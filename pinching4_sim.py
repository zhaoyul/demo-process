#!/usr/bin/env python3
"""Pinching4 Hysteretic Model for AAC Wall — comparison with MOOSE plasticity"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path

ROOT = Path(__file__).parent
RENDERS = ROOT / "renders"
RENDERS.mkdir(exist_ok=True)

# ─── Load MOOSE plasticity data (backbone reference) ───
pdata = np.loadtxt(ROOT / 'outputs/w03_pseudo_static.csv', delimiter=',', skiprows=1)
p_disp = pdata[:, 3] * 1000  # mm
p_shear = pdata[:, 1] / 1000  # kN

# ─── Extract backbone envelope ───
def extract_backbone(disp, shear):
    """Extract positive envelope from cyclic data"""
    points = []
    for i in range(1, len(disp)-1):
        if disp[i] > 0:
            # Detect local maxima (peaks)
            if disp[i] > disp[i-1] and disp[i] >= disp[i+1]:
                # Only take the first peak at each amplitude level
                amp = round(disp[i], 1)
                if not points or amp > points[-1][0] + 0.5:
                    points.append((disp[i], shear[i]))
    return np.array(sorted(points))

bb_pts = extract_backbone(p_disp, p_shear)
if len(bb_pts) < 3:
    bb_pts = np.array([[0,0], [6.5, 480], [9.0, 660], [14.4, 960], [24.0, 1113]])

print(f"Backbone points: {len(bb_pts)}")
for pt in bb_pts:
    print(f"  d={pt[0]:.1f}mm, F={pt[1]:.0f}kN")

# ─── Pinching4 Material Model ───
class Pinching4:
    """
    Pinching4 hysteretic model (Lowes & Altoontash, 2003)
    
    Parameters:
      ePf1, ePf2, ePf3, ePf4 : positive backbone deformations
      ePf1, ePf2, ePf3, ePf4 : ... (forces at those points)
      Same for negative side
      rDispP, rForceP, uForceP : pinching parameters (positive side)
      rDispN, rForceN, uForceN : pinching parameters (negative side)
      gK1..gK6, gD1..gD6, gF1..gF6 : damage parameters
    """
    def __init__(self, e_pos, f_pos, e_neg=None, f_neg=None,
                 rDispP=0.4, rForceP=0.15, uForceP=0.01,
                 rDispN=0.4, rForceN=0.15, uForceN=0.01,
                 gKlim=0.0, gDlim=0.0, gFlim=0.0,
                 damage='none'):
        self.e_pos = np.asarray(e_pos, dtype=float)  # positive backbone deformations
        self.f_pos = np.asarray(f_pos, dtype=float)  # positive backbone forces
        
        if e_neg is None:
            self.e_neg = -self.e_pos
            self.f_neg = -self.f_pos
        else:
            self.e_neg = np.asarray(e_neg)
            self.f_neg = np.asarray(f_neg)
        
        # Pinching parameters
        self.rDispP = rDispP    # reloading deformation pinching factor
        self.rForceP = rForceP  # reloading force pinching factor
        self.uForceP = uForceP  # unloading force factor
        self.rDispN = rDispN
        self.rForceN = rForceN
        self.uForceN = uForceN
        
        # Damage limits
        self.gKlim = gKlim
        self.gDlim = gDlim
        self.gFlim = gFlim
        self.damage = damage
        
        # State
        self.reset()
    
    def reset(self):
        self.e = 0.0          # current deformation
        self.f = 0.0          # current force
        self.e_max = 0.0      # historical max positive deformation
        self.f_max = 0.0      # force at e_max
        self.e_min = 0.0      # historical min negative deformation
        self.f_min = 0.0      # force at e_min
        self.e_unload = 0.0   # last unloading point deformation
        self.f_unload = 0.0   # last unloading point force
        self.e_reload = 0.0   # last reloading point
        self.f_reload = 0.0
        self.state = 'elastic'  # elastic, positive_env, negative_env, unload_pos, unload_neg, reload_pos, reload_neg
        self.energy = 0.0     # cumulative hysteretic energy
        self.E0_pos = None    # initial positive stiffness
        self.E0_neg = None
    
    def _backbone_force(self, e):
        """Evaluate positive backbone at deformation e"""
        if e <= self.e_pos[0]:
            return (self.f_pos[0] / self.e_pos[0]) * e if self.e_pos[0] > 0 else 0
        for i in range(len(self.e_pos) - 1):
            if self.e_pos[i] <= e <= self.e_pos[i+1]:
                ratio = (e - self.e_pos[i]) / (self.e_pos[i+1] - self.e_pos[i])
                return self.f_pos[i] + ratio * (self.f_pos[i+1] - self.f_pos[i])
        # Beyond last point: flat or softening
        if len(self.f_pos) >= 2:
            last_slope = (self.f_pos[-1] - self.f_pos[-2]) / (self.e_pos[-1] - self.e_pos[-2])
            return self.f_pos[-1] + last_slope * (e - self.e_pos[-1])
        return self.f_pos[-1]
    
    def _neg_backbone_force(self, e):
        """Evaluate negative backbone at deformation e (e is negative)"""
        if e >= self.e_neg[0]:
            return (self.f_neg[0] / self.e_neg[0]) * e if self.e_neg[0] < 0 else 0
        for i in range(len(self.e_neg) - 1):
            if self.e_neg[i] >= e >= self.e_neg[i+1]:
                ratio = (e - self.e_neg[i]) / (self.e_neg[i+1] - self.e_neg[i])
                return self.f_neg[i] + ratio * (self.f_neg[i+1] - self.f_neg[i])
        if len(self.f_neg) >= 2:
            last_slope = (self.f_neg[-1] - self.f_neg[-2]) / (self.e_neg[-1] - self.e_neg[-2])
            return self.f_neg[-1] + last_slope * (e - self.e_neg[-1])
        return self.f_neg[-1]
    
    def setTrialStrain(self, e_new):
        """Update state for new deformation"""
        de = e_new - self.e
        old_f = self.f
        old_e = self.e
        
        # Detect loading direction
        if de > 0:  # moving positive
            if self.e >= self.e_max:  # on or beyond positive envelope
                self.f = self._backbone_force(e_new)
                if e_new > self.e_max:
                    self.e_max = e_new
                    self.f_max = self.f
                    self.e_unload = e_new
                    self.f_unload = self.f
                
                # Apply damage degradation
                if self.damage == 'strength':
                    d_ratio = min(1.0, self.energy / 200.0)
                    self.f *= (1.0 - d_ratio * 0.4)
                
            elif self.e > 0:  # reloading in positive direction
                self._reload_positive(e_new)
            elif self.e <= 0:  # crossing from negative to positive
                self._reload_positive(e_new)
                
        elif de < 0:  # moving negative
            if self.e <= self.e_min:  # on or beyond negative envelope
                self.f = self._neg_backbone_force(e_new)
                if e_new < self.e_min:
                    self.e_min = e_new
                    self.f_min = self.f
                    self.e_unload = e_new
                    self.f_unload = self.f
                
                if self.damage == 'strength':
                    d_ratio = min(1.0, self.energy / 200.0)
                    self.f *= (1.0 - d_ratio * 0.4)
                    
            elif self.e < 0:  # reloading in negative direction
                self._reload_negative(e_new)
            elif self.e >= 0:  # crossing from positive to negative
                self._reload_negative(e_new)
        else:
            # de == 0
            pass
        
        self.energy += 0.5 * abs(old_f + self.f) * abs(de)
        self.e = e_new
        return self.f
    
    def _reload_positive(self, e):
        """Implement pinching reload in positive direction"""
        # Pinching point
        e_pinch = self.rDispP * self.e_max
        f_pinch = self.rForceP * self.f_max + (1 - self.rForceP) * self.uForceP * self.f_max
        
        # Current reload stiffness
        if self.e_max > 0:
            K_reload = (self.f_max - f_pinch) / (self.e_max - e_pinch)
        else:
            K_reload = self.f_pos[1] / self.e_pos[1] if len(self.e_pos) > 1 else 1.0
        
        if e <= e_pinch:
            # In pinching region: reduced stiffness
            if e_pinch > 0:
                self.f = f_pinch * (e / e_pinch)
            else:
                self.f = 0
        else:
            # Beyond pinching: approach envelope
            self.f = f_pinch + K_reload * (e - e_pinch)
            # Cap at backbone
            f_env = self._backbone_force(e)
            if self.f > f_env:
                self.f = f_env
    
    def _reload_negative(self, e):
        """Implement pinching reload in negative direction"""
        e_pinch = self.rDispN * self.e_min  # e_min is negative
        f_pinch = self.rForceN * self.f_min + (1 - self.rForceN) * self.uForceN * self.f_min  # f_min negative
        
        if self.e_min < 0:
            K_reload = (self.f_min - f_pinch) / (self.e_min - e_pinch)
        else:
            K_reload = self.f_neg[1] / self.e_neg[1] if len(self.e_neg) > 1 else 1.0
        
        if e >= e_pinch:
            if e_pinch < 0:
                self.f = f_pinch * (e / e_pinch)
            else:
                self.f = 0
        else:
            self.f = f_pinch + K_reload * (e - e_pinch)
            f_env = self._neg_backbone_force(e)
            if self.f < f_env:  # both negative, self.f is more negative
                self.f = f_env


# ─── Pinching parameter sets for AAC walls ───
PINCH_PARAMS = {
    'mild':    {'rDispP': 0.5, 'rForceP': 0.3, 'uForceP': 0.05, 'label': 'Mild Pinching'},
    'moderate':{'rDispP': 0.35,'rForceP': 0.15,'uForceP': 0.01, 'label': 'Moderate Pinching (推荐)'},
    'severe':  {'rDispP': 0.2, 'rForceP': 0.05,'uForceP': 0.0,  'label': 'Severe Pinching (AAC-like)'},
}

# ─── Build backbone from MOOSE plasticity peaks ───
print("\n=== Running Pinching4 Simulations ===")

# Build 4-point backbone from MOOSE data
# Use the positive envelope
pos_disp = [0.0, 6.55, 9.0, 24.0]   # mm
pos_force = [0.0, 483, 660, 1113]    # kN

# Run simulations
results = {}
for key, params in PINCH_PARAMS.items():
    model = Pinching4(
        e_pos=pos_disp, f_pos=pos_force,
        rDispP=params['rDispP'], rForceP=params['rForceP'], uForceP=params['uForceP'],
        rDispN=params['rDispP'], rForceN=params['rForceP'], uForceN=params['uForceP'],
        damage='none'
    )
    
    # Apply same loading protocol as MOOSE
    t_max = 280
    dt = 0.5
    history = []
    for t in np.arange(0, t_max + dt, dt):
        # Same cyclic loading function
        if t < 40:
            d = 6.55 * np.sin(2 * np.pi * t / 40 - np.pi / 2)
        elif t < 80:
            d = 9.0 * np.sin(2 * np.pi * (t - 40) / 40 - np.pi / 2)
        elif t < 160:
            d = 14.4 * np.sin(2 * np.pi * (t - 80) / 80 - np.pi / 2)
        else:
            d = 24.0 * np.sin(2 * np.pi * (t - 160) / 40 - np.pi / 2)
        
        f = model.setTrialStrain(d)
        history.append((t, d, f))
    
    history = np.array(history)
    results[key] = history
    print(f"  {params['label']}: energy={model.energy:.1f} kJ, peaks=({history[:,2].max():.0f}, {history[:,2].min():.0f})")


# ─── Plotting ───
fig, axes = plt.subplots(1, 3, figsize=(18, 5.5))

# Plot 1: MOOSE plasticity hysteresis
ax = axes[0]
ax.plot(p_disp, p_shear, 'b-', alpha=0.6, linewidth=0.8)
ax.axhline(y=0, color='gray', linewidth=0.5)
ax.axvline(x=0, color='gray', linewidth=0.5)
ax.set_xlabel('Displacement (mm)')
ax.set_ylabel('Shear Force (kN)')
ax.set_title('MOOSE: Isotropic Plasticity\n(No Pinching)')
ax.grid(True, alpha=0.3)
ax.set_xlim(-30, 30)
ax.set_ylim(-1200, 1200)

# Plot 2: Pinching4 moderate
ax = axes[1]
h = results['moderate']
ax.plot(h[:,1], h[:,2], 'r-', alpha=0.6, linewidth=0.8)
ax.axhline(y=0, color='gray', linewidth=0.5)
ax.axvline(x=0, color='gray', linewidth=0.5)
ax.set_xlabel('Displacement (mm)')
ax.set_ylabel('Shear Force (kN)')
ax.set_title('Pinching4: Moderate Pinching\n(rDisp=0.35, rForce=0.15)')
ax.grid(True, alpha=0.3)
ax.set_xlim(-30, 30)
ax.set_ylim(-1200, 1200)

# Plot 3: Pinching4 severe
ax = axes[2]
h = results['severe']
ax.plot(h[:,1], h[:,2], 'r-', alpha=0.6, linewidth=0.8)
ax.axhline(y=0, color='gray', linewidth=0.5)
ax.axvline(x=0, color='gray', linewidth=0.5)
ax.set_xlabel('Displacement (mm)')
ax.set_ylabel('Shear Force (kN)')
ax.set_title('Pinching4: Severe Pinching\n(rDisp=0.2, rForce=0.05) — AAC-like')
ax.grid(True, alpha=0.3)
ax.set_xlim(-30, 30)
ax.set_ylim(-1200, 1200)

plt.tight_layout()
plt.savefig(RENDERS / 'aac_pinching4_comparison.png', dpi=150, bbox_inches='tight')
print(f"\nSaved: renders/aac_pinching4_comparison.png")

# ─── Detailed pinching zoom ───
fig2, axes2 = plt.subplots(1, 3, figsize=(18, 5))

for i, (key, label) in enumerate([('mild', 'Mild'), ('moderate', 'Moderate'), ('severe', 'Severe')]):
    ax = axes2[i]
    h = results[key]
    ax.plot(h[:,1], h[:,2], linewidth=0.8, color='#d62728')
    ax.axhline(y=0, color='gray', linewidth=0.5)
    ax.axvline(x=0, color='gray', linewidth=0.5)
    ax.set_xlabel('Displacement (mm)')
    ax.set_ylabel('Force (kN)')
    ax.set_title(f'{label} Pinching (zoom)')
    ax.grid(True, alpha=0.3)
    ax.set_xlim(-10, 10)
    ax.set_ylim(-600, 600)
    
    # Annotate pinching parameters
    p = PINCH_PARAMS[key]
    ax.text(0.05, 0.95, 
            f'rDisp={p["rDispP"]}\nrForce={p["rForceP"]}\nuForce={p["uForceP"]}', 
            transform=ax.transAxes, fontsize=9, va='top',
            bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.5))

plt.tight_layout()
plt.savefig(RENDERS / 'aac_pinching4_detail.png', dpi=150, bbox_inches='tight')
print(f"Saved: renders/aac_pinching4_detail.png")

# ─── Energy comparison ───
print("\n=== Energy Comparison ===")
print(f"{'Model':<30} {'Energy (kJ)':<15} {'Rel. to Plasticity':<15}")
p_energy = 71.04  # from earlier report
print(f"{'MOOSE Plasticity':<30} {p_energy:<15.1f} {'1.00x':<15}")
for key, params in PINCH_PARAMS.items():
    e = results[key][:,2]
    d = results[key][:,1]
    # Compute hysteretic energy
    energy = 0.0
    for i in range(1, len(e)):
        energy += 0.5 * abs(e[i] + e[i-1]) * abs(d[i] - d[i-1])
    print(f"Pinching4 {params['label']:<22} {energy:<15.1f} {energy/p_energy:.2f}x")

print("\nDone.")
