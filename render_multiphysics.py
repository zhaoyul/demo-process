#!/usr/bin/env python3
"""红创科技 — 三场耦合动画 V2: 时间演化"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path
import subprocess

ROOT = Path(__file__).parent
RENDERS = ROOT / "renders"
d = RENDERS / "mp_frames"
for f in d.glob("*.png"): f.unlink()

L, H = 1.0, 0.2
x = np.linspace(0, L, 200)
y = np.linspace(-H/2, H/2, 40)
X, Y = np.meshgrid(x, y)

fig = plt.figure(figsize=(19.2, 7.2))
fig.patch.set_facecolor('#1A1A2E')

n = 60  # total frames

for i in range(n):
    fig.clear()
    progress = i / (n - 1)  # 0 → 1
    
    # Fields evolve with progress
    temp = 100 * (X / L) * progress
    disp_z = -5.63e-4 * (X / L)**2 * (3 - X/L) * 50 * progress
    damage = 0.5 * np.exp(-3 * X / L) * progress
    
    # --- Temperature ---
    ax1 = fig.add_subplot(1, 3, 1)
    ax1.set_facecolor('#1A1A2E')
    c1 = ax1.contourf(X, Y, temp, levels=40, cmap='hot', vmin=0, vmax=100)
    ax1.set_xlim(-0.05, L+0.05); ax1.set_ylim(-0.25, 0.25); ax1.axis('off')
    ax1.set_title('Temperature (Heat Conduction)', color='#C62828', fontsize=13, pad=8)
    ax1.text(0.5, -0.2, f'{temp.max():.0f}°C', color='white', fontsize=18, ha='center', weight='bold')
    # Color bar only on first frame
    if i == 0:
        cbar1 = plt.colorbar(c1, ax=ax1, fraction=0.046)
        cbar1.set_label('°C', color='white'); cbar1.ax.tick_params(colors='white')
    
    # --- Displacement (deformed shape) ---
    ax2 = fig.add_subplot(1, 3, 2)
    ax2.set_facecolor('#1A1A2E')
    # Undeformed ghost
    ax2.fill_between(x, -H/2, H/2, alpha=0.08, color='white')
    # Deformed beam
    ax2.fill_between(x, disp_z[0,:] - H/2, disp_z[0,:] + H/2, alpha=0.9, color='#D4AF37')
    ax2.set_xlim(-0.05, L+0.05); ax2.set_ylim(-0.06, 0.06); ax2.axis('off')
    ax2.set_title('Displacement (Mechanical Deformation)', color='#C62828', fontsize=13, pad=8)
    tip_val = abs(disp_z[0,-1])  # tip value
    ax2.text(1.0, -0.05, f'{tip_val*1000:.2f} mm', color='#D4AF37', fontsize=18, ha='right', weight='bold')
    
    # --- Damage (phase field) ---
    ax3 = fig.add_subplot(1, 3, 3)
    ax3.set_facecolor('#1A1A2E')
    c3 = ax3.contourf(X, Y, damage, levels=40, cmap='Reds', vmin=0, vmax=0.55)
    ax3.set_xlim(-0.05, L+0.05); ax3.set_ylim(-0.15, 0.15); ax3.axis('off')
    ax3.set_title('Damage (Phase Field)', color='#C62828', fontsize=13, pad=8)
    ax3.text(0.1, -0.12, f'd = {damage.max():.3f}', color='white', fontsize=18, ha='left', weight='bold')
    if i == 0:
        cbar3 = plt.colorbar(c3, ax=ax3, fraction=0.046)
        cbar3.set_label('d', color='white'); cbar3.ax.tick_params(colors='white')
    
    fig.suptitle('Hongchuang: Thermal-Mechanical-Damage Direct Coupling  |  t = {:.2f}s'.format(progress),
                 color='white', fontsize=18, y=0.97)
    
    fig.savefig(str(d / f"f{i:04d}.png"), dpi=100, facecolor='#1A1A2E')
    if i % 15 == 0:
        print(f"  {i+1}/{n}  t={progress:.2f}")

plt.close()

subprocess.run([
    "ffmpeg", "-y", "-framerate", "15", "-i", str(d / "f%04d.png"),
    "-c:v", "libx264", "-pix_fmt", "yuv420p", "-vf", "scale=1920:720",
    str(RENDERS / "multiphysics_coupling.mp4")
], capture_output=True)

mp4 = RENDERS / "multiphysics_coupling.mp4"
print(f"\nDone: {mp4} ({mp4.stat().st_size/1e3:.0f} KB)")
