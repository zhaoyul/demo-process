#!/usr/bin/env python3
"""红创科技 — 三场耦合动画 V3: 混凝土塑性损伤模型 (CDP)"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path
import subprocess

ROOT = Path(__file__).parent
RENDERS = ROOT / "renders"
d = RENDERS / "cdp_frames"
for f in d.glob("*.png"): f.unlink()
d.mkdir(exist_ok=True)

L, H = 1.0, 0.2
x = np.linspace(0, L, 200)
y = np.linspace(-H/2, H/2, 40)
X, Y = np.meshgrid(x, y)

fig = plt.figure(figsize=(19.2, 10.8))
fig.patch.set_facecolor('#1A1A2E')

n = 80  # total frames

# C30 concrete parameters for display
E_c30 = 30e9
f_t = 2.0e6
f_c = 20.0e6

for i in range(n):
    fig.clear()
    progress = i / (n - 1)  # 0 → 1

    # Fields evolve with progress (analytical approximations based on C30 concrete beam)
    temp = 100 * (X / L) * progress
    
    # Thermal stress field: σ_thermal ≈ E·α·ΔT
    sigma_xx = E_c30 * 1e-5 * temp  # axial thermal stress
    sigma_xx_max = sigma_xx.max()
    
    # Equivalent tensile stress (max principal ≈ sigma_xx for beam bending+thermal)
    eq_stress_t = np.maximum(sigma_xx, 0)
    eq_stress_c = np.maximum(-sigma_xx, 0)
    
    # Tension damage evolution: d_t = 1 - (f_t/σ_eq)·exp(α_t·(f_t-σ_eq))
    alpha_t = 2000.0
    d_t = np.where(
        eq_stress_t > f_t,
        np.maximum(0, 1.0 - (f_t / eq_stress_t) * np.exp(alpha_t * (f_t - eq_stress_t))),
        0.0
    )
    
    # Compression damage evolution
    alpha_c = 1000.0
    d_c = np.where(
        eq_stress_c > f_c,
        np.maximum(0, 1.0 - (f_c / eq_stress_c) * np.exp(alpha_c * (f_c - eq_stress_c))),
        0.0
    )
    
    # Total damage
    d_total = np.maximum(d_t, d_c)
    
    # Effective displacement with damage softening
    disp_z = -5.63e-4 * (X / L)**2 * (3 - X/L) * 50 * progress
    # Damage softening: larger displacement due to reduced stiffness
    disp_z *= (1.0 + 0.3 * d_total[0, :])[np.newaxis, :]
    
    # ── Row 1: Temperature + Displacement ──
    # --- Temperature ---
    ax1 = fig.add_subplot(2, 3, 1)
    ax1.set_facecolor('#1A1A2E')
    c1 = ax1.contourf(X, Y, temp, levels=40, cmap='hot', vmin=0, vmax=100)
    ax1.set_xlim(-0.05, L+0.05); ax1.set_ylim(-0.15, 0.15); ax1.axis('off')
    ax1.set_title('Temperature (C30 Concrete)', color='#C62828', fontsize=12, pad=8)
    ax1.text(0.5, -0.08, f'{temp.max():.0f}°C', color='white', fontsize=16, ha='center', weight='bold')

    # --- Displacement ---
    ax2 = fig.add_subplot(2, 3, 2)
    ax2.set_facecolor('#1A1A2E')
    ax2.fill_between(x, -H/2, H/2, alpha=0.08, color='white')
    ax2.fill_between(x, disp_z[0,:] - H/2, disp_z[0,:] + H/2, alpha=0.9, color='#D4AF37')
    ax2.set_xlim(-0.05, L+0.05); ax2.set_ylim(-0.04, 0.04); ax2.axis('off')
    ax2.set_title('Displacement (Mechanical + Thermal)', color='#C62828', fontsize=12, pad=8)
    tip_val = abs(disp_z[0,-1])
    ax2.text(1.0, -0.03, f'{tip_val*1000:.3f} mm', color='#D4AF37', fontsize=16, ha='right', weight='bold')

    # --- Stress (von Mises proxy: abs(sigma_xx)) ---
    ax3 = fig.add_subplot(2, 3, 3)
    ax3.set_facecolor('#1A1A2E')
    stress_mag = np.abs(sigma_xx) / 1e6  # MPa
    c3 = ax3.contourf(X, Y, stress_mag, levels=40, cmap='coolwarm', vmin=0, vmax=stress_mag.max()*1.1)
    ax3.set_xlim(-0.05, L+0.05); ax3.set_ylim(-0.15, 0.15); ax3.axis('off')
    ax3.set_title('|Stress| (Thermal + Flexural)', color='#C62828', fontsize=12, pad=8)
    ax3.text(0.5, -0.08, f'{stress_mag.max():.1f} MPa', color='white', fontsize=16, ha='center', weight='bold')

    # ── Row 2: DamageT + DamageC + Total Damage ──
    # --- Damage T (tension) ---
    ax4 = fig.add_subplot(2, 3, 4)
    ax4.set_facecolor('#1A1A2E')
    c4 = ax4.contourf(X, Y, d_t, levels=40, cmap='Reds', vmin=0, vmax=1.0)
    ax4.set_xlim(-0.05, L+0.05); ax4.set_ylim(-0.15, 0.15); ax4.axis('off')
    ax4.set_title('DamageT (Tension Damage)', color='#C62828', fontsize=12, pad=8)
    ax4.text(0.5, -0.08, f'd_t max = {d_t.max():.3f}', color='white', fontsize=16, ha='center', weight='bold')
    # f_t line
    if eq_stress_t.max() > f_t:
        ax4.axhline(y=0.10, color='yellow', linestyle='--', alpha=0.4, linewidth=1)
        ax4.text(0.5, 0.11, f'f_t = {f_t/1e6:.1f} MPa (threshold)', color='yellow', fontsize=8, ha='center', alpha=0.7)

    # --- Damage C (compression) ---
    ax5 = fig.add_subplot(2, 3, 5)
    ax5.set_facecolor('#1A1A2E')
    c5 = ax5.contourf(X, Y, d_c, levels=40, cmap='Blues', vmin=0, vmax=1.0)
    ax5.set_xlim(-0.05, L+0.05); ax5.set_ylim(-0.15, 0.15); ax5.axis('off')
    ax5.set_title('DamageC (Compression Damage)', color='#C62828', fontsize=12, pad=8)
    ax5.text(0.5, -0.08, f'd_c max = {d_c.max():.3f}', color='white', fontsize=16, ha='center', weight='bold')
    if eq_stress_c.max() > f_c:
        ax5.axhline(y=0.10, color='cyan', linestyle='--', alpha=0.4, linewidth=1)
        ax5.text(0.5, 0.11, f'f_c = {f_c/1e6:.1f} MPa (threshold)', color='cyan', fontsize=8, ha='center', alpha=0.7)

    # --- Total Damage ---
    ax6 = fig.add_subplot(2, 3, 6)
    ax6.set_facecolor('#1A1A2E')
    c6 = ax6.contourf(X, Y, d_total, levels=40, cmap='plasma', vmin=0, vmax=1.0)
    ax6.set_xlim(-0.05, L+0.05); ax6.set_ylim(-0.15, 0.15); ax6.axis('off')
    ax6.set_title('Total Damage d = max(d_t, d_c)', color='#C62828', fontsize=12, pad=8)
    ax6.text(0.5, -0.08, f'd max = {d_total.max():.3f}', color='white', fontsize=16, ha='center', weight='bold')

    fig.suptitle(
        'Hongchuang: Thermal-Mechanical-Damage CDP (C30 Concrete)  |  t = {:.2f}s\n'
        'E=30GPa | ν=0.20 | f_t=2.0MPa | f_c=20.0MPa'.format(progress),
        color='white', fontsize=16, y=0.99
    )

    fig.savefig(str(d / f"f{i:04d}.png"), dpi=100, facecolor='#1A1A2E')
    if i % 20 == 0:
        print(f"  CDP frame {i+1}/{n}  t={progress:.2f}")

plt.close()

subprocess.run([
    "ffmpeg", "-y", "-framerate", "20", "-i", str(d / "f%04d.png"),
    "-c:v", "libx264", "-pix_fmt", "yuv420p", "-vf", "scale=1920:1080",
    str(RENDERS / "multiphysics_cdp.mp4")
], capture_output=True)

mp4 = RENDERS / "multiphysics_cdp.mp4"
print(f"\nCDP Done: {mp4} ({mp4.stat().st_size/1e3:.0f} KB)")
