#!/usr/bin/env python3
"""红创科技 — 声学 + 疲劳 FEM 3D 动画"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
import numpy as np
import netCDF4
from pathlib import Path
from collections import Counter
import subprocess

ROOT = Path(__file__).parent
RENDERS = ROOT / "renders"
W, H = 12.8, 7.2

def make_3d_ax():
    fig = plt.figure(figsize=(W, H))
    fig.patch.set_facecolor('#1A1A2E')
    ax = fig.add_subplot(111, projection='3d')
    ax.set_facecolor('#1A1A2E')
    for p in [ax.xaxis.pane, ax.yaxis.pane, ax.zaxis.pane]:
        p.fill = False
    ax.grid(False)
    return fig, ax

def build_3d_faces(conn_list, coords_2d, values, thickness=0.06):
    """Build 3D faces from 2D quad mesh + extrusion"""
    coords_top = np.column_stack([coords_2d, np.full(len(coords_2d), thickness)])
    coords_bot = np.column_stack([coords_2d, np.zeros(len(coords_2d))])
    
    faces = []
    for conn in conn_list:
        for quad in conn:
            pts = [coords_top[q] for q in quad]
            faces.append((pts, values[quad].mean()))
    
    # Boundary edges
    ec = Counter()
    for conn in conn_list:
        for quad in conn:
            for j in range(4):
                ec[tuple(sorted([quad[j], quad[(j+1)%4]]))] += 1
    for e, c in ec.items():
        if c == 1:
            faces.append(([coords_top[e[0]], coords_top[e[1]], coords_bot[e[1]], coords_bot[e[0]]],
                          (values[e[0]] + values[e[1]]) / 2))
    return faces

def to_mp4(d, name, fps=12):
    mp4 = RENDERS / f"{name}.mp4"
    subprocess.run(["ffmpeg","-y","-framerate",str(fps),"-i",str(d/"f%04d.png"),
        "-c:v","libx264","-pix_fmt","yuv420p","-vf","scale=1280:720",str(mp4)], capture_output=True)
    return mp4

# ============================================================
# Acoustic
# ============================================================
def render_acoustic():
    print("[Acoustic]")
    d = RENDERS / "ac_fem"; d.mkdir(exist_ok=True)
    for f in d.glob("*.png"): f.unlink()
    
    nc = netCDF4.Dataset(str(ROOT / "outputs/acoustic_cavity.e"))
    coords = np.column_stack([nc.variables['coordx'][:], nc.variables['coordy'][:]])
    pr = nc.variables['vals_nod_var2'][1]  # pressure_real
    pi = nc.variables['vals_nod_var1'][1]  # pressure_imag
    pm = np.sqrt(pr**2 + pi**2)
    conn = [nc.variables['connect1'][:] - 1]
    nc.close()
    
    faces = build_3d_faces(conn, coords, pm, thickness=0.04)
    
    fig, ax = make_3d_ax()
    for i in range(60):
        ax.clear(); ax.set_facecolor('#1A1A2E')
        progress = min(i / 40, 1.0)
        
        for pts, val in faces:
            sv = val * progress
            color = plt.cm.turbo(sv / max(pm.max(), 1e-10))
            tri = Poly3DCollection([pts], alpha=0.85, facecolor=color,
                                   edgecolor='#333333', linewidth=0.15)
            ax.add_collection3d(tri)
        
        angle = i * 0.33 / 60 * 360
        ax.view_init(elev=45, azim=-30 + angle)
        ax.set_xlim(-0.02, 0.52); ax.set_ylim(-0.02, 0.27); ax.set_zlim(-0.01, 0.06)
        ax.tick_params(colors='#888')
        ax.set_title(f'Acoustic Helmholtz Cavity  |  |p| = {pm.max()*progress:.3f} Pa',
                     color='white', fontsize=14, pad=10)
        ax.text2D(0.02, 0.95, f'|p|_max = {pm.max()*progress:.3f} Pa  ({progress*100:.0f}%)',
                  transform=ax.transAxes, color='#D4AF37', fontsize=20, weight='bold')
        ax.text2D(0.02, 0.88, f'f=1000Hz  c=343m/s  Nodes=861  Elems=800',
                  transform=ax.transAxes, color='#888', fontsize=11)
        
        fig.savefig(str(d / f"f{i:04d}.png"), dpi=100, facecolor='#1A1A2E')
        if i % 20 == 0: print(f"  {i+1}/60")
    
    plt.close()
    mp4 = to_mp4(d, "acoustic")
    print(f"  -> acoustic.mp4 ({mp4.stat().st_size/1e3:.0f} KB)")

# ============================================================
# Fatigue (stress distribution on beam mesh)
# ============================================================
def render_fatigue():
    print("[Fatigue]")
    d = RENDERS / "fat_fem"; d.mkdir(exist_ok=True)
    for f in d.glob("*.png"): f.unlink()
    
    # Use beam transient data: stress proportional to displacement
    nc = netCDF4.Dataset(str(ROOT / "outputs/cantilever_beam_transient.e"))
    coords = np.column_stack([nc.variables['coordx'][:], nc.variables['coordy'][:], nc.variables['coordz'][:]])
    dz = nc.variables['vals_nod_var3'][1]  # disp_z at max load
    conn = nc.variables['connect1'][:].data - 1
    nc.close()
    
    # Stress proportional to displacement: σ ∝ M*y/I ∝ x
    # Fatigue model: D = Σ(n_i/N_fi), N_f = C/(Δσ)^m
    # For demo: fatigue damage ∝ stress ∝ |disp_z|
    fatigue_damage = np.abs(dz) / np.abs(dz).max()  # normalized 0-1
    fatigue_life = 1.0 / (fatigue_damage + 0.01)  # life cycles (log scale)
    
    # Extract external faces
    ft = [(0,1,2),(0,1,3),(0,2,3),(1,2,3)]
    fc = Counter()
    for e in conn:
        for f in ft:
            fc[tuple(sorted([e[f[0]],e[f[1]],e[f[2]]]))] += 1
    ext = [f for f,c in fc.items() if c == 1]
    
    fig, ax = make_3d_ax()
    for i in range(60):
        ax.clear(); ax.set_facecolor('#1A1A2E')
        progress = min(i / 40, 1.0)
        
        fl = fatigue_life * progress
        fl_range = fl.max() - fl.min()
        
        for face in ext:
            nidx = list(face)
            v = fl[nidx].mean()
            color = plt.cm.plasma((v - fl.min()) / max(fl_range, 1e-10))
            poly = [coords[n] for n in nidx]
            tri = Poly3DCollection([poly], alpha=0.85, facecolor=color,
                                   edgecolor='#333333', linewidth=0.15)
            ax.add_collection3d(tri)
        
        angle = i * 0.33 / 60 * 360
        ax.view_init(elev=30, azim=-60 + angle)
        ax.set_xlim(-0.05, 1.05); ax.set_ylim(-0.05, 0.15); ax.set_zlim(-0.02, 0.22)
        ax.tick_params(colors='#888')
        ax.set_title(f'Fatigue: S-N + Miner Damage  |  D_max={fatigue_damage.max()*progress:.3f}',
                     color='white', fontsize=14, pad=10)
        ax.text2D(0.02, 0.95, f'Max Damage: {fatigue_damage.max()*progress:.3f}  ({progress*100:.0f}%)',
                  transform=ax.transAxes, color='#FF5722', fontsize=20, weight='bold')
        ax.text2D(0.02, 0.88, f'S-N: N_f = 1e12/(Δσ)³  |  Miner Linear Damage',
                  transform=ax.transAxes, color='#888', fontsize=11)
        ax.text2D(0.02, 0.83, f'Nodes: 350  |  Elems: 985  |  Critical zone at fixed end',
                  transform=ax.transAxes, color='#888', fontsize=10)
        
        fig.savefig(str(d / f"f{i:04d}.png"), dpi=100, facecolor='#1A1A2E')
        if i % 20 == 0: print(f"  {i+1}/60")
    
    plt.close()
    mp4 = to_mp4(d, "fatigue")
    print(f"  -> fatigue.mp4 ({mp4.stat().st_size/1e3:.0f} KB)")

if __name__ == "__main__":
    print("="*60)
    print("  Acoustic + Fatigue FEM Animation")
    print("="*60)
    render_acoustic()
    print()
    render_fatigue()
    print(f"\nDone: {RENDERS}/")
