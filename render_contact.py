#!/usr/bin/env python3
"""红创科技 — 接触力学动画: 右块逐步压入"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path
import subprocess

ROOT = Path(__file__).parent
RENDERS = ROOT / "renders"
d = RENDERS / "contact_frames"
for f in d.glob("*.png"): f.unlink()

n = 60

# Two blocks: left [0, 0.5], right [0.5, 1.0], unit height
fig, ax = plt.subplots(figsize=(12.8, 7.2))
fig.patch.set_facecolor('#1A1A2E')
ax.set_facecolor('#1A1A2E')

for i in range(n):
    ax.clear(); ax.set_facecolor('#1A1A2E')
    progress = i / (n - 1)
    
    # Right block moves left by displacement
    dx = progress * 0.17  # 0 → 0.17m (from FEM result)
    
    # Left block: fixed at [0, 0.5]
    left = plt.Rectangle((0, 0), 0.5, 1.0, facecolor='#E53935', edgecolor='white', linewidth=2, alpha=0.85)
    ax.add_patch(left)
    
    # Right block: starts at x=0.5, moves left by dx
    right_x = 0.5 - dx
    right = plt.Rectangle((right_x, 0), 0.5, 1.0, facecolor='#1E88E5', edgecolor='white', linewidth=2, alpha=0.85)
    ax.add_patch(right)
    
    # Contact force indicator
    force = dx * 0.954 / 0.17  # scaled from FEM: force=0.954 at dx=0.17
    # Force arrows at interface
    for fy in [0.2, 0.5, 0.8]:
        ax.annotate('', xy=(0.5 - dx + 0.02, fy), xytext=(0.48 - dx, fy),
                    arrowprops=dict(arrowstyle='->', color='#D4AF37', lw=2))
    
    # Labels
    ax.text(0.25, 1.12, 'Fixed Block', color='#E53935', fontsize=14, ha='center', weight='bold')
    ax.text(0.75 - dx, 1.12, 'Moving Block', color='#1E88E5', fontsize=14, ha='center', weight='bold')
    ax.text(0.5 - dx/2, -0.12, f'Contact interface', color='#D4AF37', fontsize=11, ha='center')
    
    # Stats
    ax.text(0.95, 0.95, f'Disp: {dx*1000:.1f} mm', transform=ax.transAxes,
            color='white', fontsize=14, ha='right', weight='bold')
    ax.text(0.95, 0.88, f'Force: {force:.3f} N', transform=ax.transAxes,
            color='#D4AF37', fontsize=14, ha='right', weight='bold')
    
    ax.set_xlim(-0.1, 1.1); ax.set_ylim(-0.2, 1.3); ax.axis('off')
    ax.set_title('Contact Mechanics: Two-Body Coulomb Friction  |  t = {:.2f}s'.format(progress),
                 color='white', fontsize=16, pad=10)
    
    fig.savefig(str(d / f"f{i:04d}.png"), dpi=100, facecolor='#1A1A2E')
    if i % 15 == 0: print(f"  {i+1}/{n}")

plt.close()

subprocess.run(["ffmpeg","-y","-framerate","15","-i",str(d/"f%04d.png"),
    "-c:v","libx264","-pix_fmt","yuv420p","-vf","scale=1280:720",
    str(RENDERS/"contact.mp4")], capture_output=True)

mp4 = RENDERS / "contact.mp4"
print(f"\nDone: {mp4} ({mp4.stat().st_size/1e3:.0f} KB)")
