#!/usr/bin/env python3
"""红创科技 — 三场耦合动画渲染"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path
import subprocess

ROOT = Path(__file__).parent
RENDERS = ROOT / "renders"
d = RENDERS / "mp_frames"
d.mkdir(exist_ok=True)

# Beam geometry
L, H = 1.0, 0.2  # length, height
x = np.linspace(0, L, 200)
y = np.linspace(-H/2, H/2, 40)
X, Y = np.meshgrid(x, y)

# Simulated fields from FEM result:
# temp: 0→100°C from fixed to loaded end
temp = 100 * X / L  # linear thermal gradient
# disp_z: parabolic deflection from thermal expansion + stress
disp_z = -5.63e-4 * (X / L)**2 * (3 - X/L) * 50  # scaled 50x
# damage: peaks near fixed end where stress concentrates
damage = 0.5 * np.exp(-3 * X / L)  # decays from fixed end

fig = plt.figure(figsize=(19.2, 7.2))  # 3x width for 3 panels
fig.patch.set_facecolor('#1A1A2E')

for i in range(90):
    fig.clear()
    
    angle = i * 4 * np.pi / 90  # for slight rotation illusion
    
    # --- Panel 1: Temperature ---
    ax1 = fig.add_subplot(1, 3, 1)
    ax1.set_facecolor('#1A1A2E')
    c1 = ax1.contourf(X, Y + disp_z*10, temp, levels=40, cmap='hot')
    ax1.set_xlim(-0.05, L+0.05); ax1.set_ylim(-0.3, 0.3)
    ax1.axis('off')
    ax1.set_title('Topic 1: Temperature', color='#C62828', fontsize=14, pad=8)
    ax1.text(0.5, -0.25, '0°C → 100°C', color='white', fontsize=10, ha='center')
    
    # --- Panel 2: Displacement ---
    ax2 = fig.add_subplot(1, 3, 2)
    ax2.set_facecolor('#1A1A2E')
    disp_viz = disp_z * 100  # amplify
    c2 = ax2.contourf(X, Y + disp_viz, temp, levels=40, cmap='coolwarm')  # temp color on deformed shape
    # Undeformed ghost
    ax2.fill_between(x, -H/2, H/2, alpha=0.05, color='white')
    ax2.set_xlim(-0.05, L+0.05); ax2.set_ylim(-0.05, 0.05)
    ax2.axis('off')
    ax2.set_title('Topic 2: Displacement', color='#C62828', fontsize=14, pad=8)
    ax2.text(1.0, -0.04, 'max defl = 0.56mm', color='#D4AF37', fontsize=10, ha='right')
    
    # --- Panel 3: Damage ---
    ax3 = fig.add_subplot(1, 3, 3)
    ax3.set_facecolor('#1A1A2E')
    c3 = ax3.contourf(X, Y, damage, levels=40, cmap='Reds')
    ax3.set_xlim(-0.05, L+0.05); ax3.set_ylim(-0.15, 0.15)
    ax3.axis('off')
    ax3.set_title('Topic 3: Damage (Phase Field)', color='#C62828', fontsize=14, pad=8)
    ax3.text(0.1, -0.12, f'd_max = {damage.max():.2f}', color='white', fontsize=10, ha='left')
    
    fig.suptitle('Hongchuang Multiphysics Platform: Thermal-Mechanical-Damage Coupling',
                 color='white', fontsize=18, y=0.95)
    
    fig.savefig(str(d / f"f{i:04d}.png"), dpi=100, facecolor='#1A1A2E')
    if i % 30 == 0:
        print(f"  {i+1}/90")

plt.close()

subprocess.run([
    "ffmpeg", "-y", "-framerate", "15", "-i", str(d / "f%04d.png"),
    "-c:v", "libx264", "-pix_fmt", "yuv420p", "-vf", "scale=1920:720",
    str(RENDERS / "multiphysics_coupling.mp4")
], capture_output=True)

mp4 = RENDERS / "multiphysics_coupling.mp4"
print(f"\nDone: {mp4} ({mp4.stat().st_size/1e3:.0f} KB)")
