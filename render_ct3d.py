#!/usr/bin/env python3
"""红创科技 — 接触力学 3D动画 (参照 beam_loading 风格)"""
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
d = RENDERS / "ct3d_fem"
d.mkdir(exist_ok=True)
for f in d.glob("*.png"): f.unlink()

# Load contact data
nc = netCDF4.Dataset(str(ROOT / "outputs/contact_2d.e"))
ts = nc.variables['time_whole'][:].data
coordx = nc.variables['coordx'][:].data
coordy = nc.variables['coordy'][:].data
n_ts = len(ts)

# Get displacement and coordinates
disp_x = nc.variables['vals_nod_var2'][:].data  # disp_x (compression direction)
conn1 = nc.variables['connect1'][:].data - 1
conn2 = nc.variables['connect2'][:].data - 1
all_conn = list(conn1) + list(conn2)
nc.close()

# 3D extrusion
THICKNESS = 0.05
coords_2d = np.column_stack([coordx, coordy])

# Animation
n_cycles, total = 4, n_ts * 4
fig = plt.figure(figsize=(12.8, 7.2))
fig.patch.set_facecolor('#1A1A2E')
ax = fig.add_subplot(111, projection='3d')
ax.set_facecolor('#1A1A2E')

for i in range(total):
    ax.clear(); ax.set_facecolor('#1A1A2E')
    for p in [ax.xaxis.pane, ax.yaxis.pane, ax.zaxis.pane]:
        p.fill = False
    ax.grid(False)
    
    t_idx = i % n_ts
    t = ts[t_idx]
    dx = disp_x[t_idx]
    
    # Warped coords
    coords_top = np.column_stack([coordx + dx, coordy, np.full(len(coordx), THICKNESS)])
    coords_bot = np.column_stack([coordx + dx, coordy, np.zeros(len(coordx))])
    
    # Build top faces
    vrange = max(abs(dx.max()), abs(dx.min()), 0.18)
    
    for conn in [conn1, conn2]:
        for quad in conn:
            pts = [coords_top[q] for q in quad]
            val = dx[quad].mean()
            color = plt.cm.coolwarm((val + vrange) / (2 * vrange))
            tri = Poly3DCollection([pts], alpha=0.85, facecolor=color,
                                   edgecolor='#333333', linewidth=0.2)
            ax.add_collection3d(tri)
    
    # Side faces for external edges
    edge_counts = Counter()
    for conn in [conn1, conn2]:
        for quad in conn:
            for j in range(4):
                e = tuple(sorted([quad[j], quad[(j+1)%4]]))
                edge_counts[e] += 1
    boundary = [e for e, c in edge_counts.items() if c == 1]
    
    for e in boundary:
        p1t, p2t = coords_top[e[0]], coords_top[e[1]]
        p1b, p2b = coords_bot[e[0]], coords_bot[e[1]]
        val = (dx[e[0]] + dx[e[1]]) / 2
        color = plt.cm.coolwarm((val + vrange) / (2 * vrange))
        tri = Poly3DCollection([[p1t, p2t, p2b, p1b]], alpha=0.6, facecolor=color,
                               edgecolor='#222222', linewidth=0.1)
        ax.add_collection3d(tri)
    
    # Camera
    angle = i * 1.0 / total * 360
    ax.view_init(elev=50, azim=-30 + angle)
    ax.set_xlim(-0.2, 1.05); ax.set_ylim(-0.05, 1.05); ax.set_zlim(-0.05, THICKNESS*1.2)
    ax.set_xlabel('X (m)', color='#888'); ax.set_ylabel('Y (m)', color='#888')
    ax.tick_params(colors='#888')
    ax.set_title(f'Contact Mechanics  |  t={t:.2f}s  |  disp_x=[{dx.min():.3f}, {dx.max():.3f}]m',
                 color='white', fontsize=14, pad=10)
    
    fig.savefig(str(d / f"f{i:04d}.png"), dpi=100, facecolor='#1A1A2E')
    if i % max(1, total//5) == 0:
        print(f"  {i+1}/{total}  t={t:.2f}")

plt.close()

mp4 = RENDERS / "contact.mp4"
subprocess.run(["ffmpeg","-y","-framerate","10","-i",str(d/"f%04d.png"),
    "-c:v","libx264","-pix_fmt","yuv420p","-vf","scale=1280:720",str(mp4)], capture_output=True)
print(f"\nDone: {mp4} ({mp4.stat().st_size/1e3:.0f} KB)")
