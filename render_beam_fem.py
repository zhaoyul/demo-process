#!/usr/bin/env python3
"""红创科技 — 悬臂梁 3D 变形动画 (从 .e 提取真实 FEM)"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.collections import PolyCollection
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
import numpy as np
import netCDF4
from pathlib import Path
import subprocess

ROOT = Path(__file__).parent
RENDERS = ROOT / "renders"
d = RENDERS / "beam_fem"
d.mkdir(exist_ok=True)
for f in d.glob("*.png"): f.unlink()

# Load data
nc = netCDF4.Dataset(str(ROOT / "outputs/cantilever_beam_transient.e"))
ts = nc.variables['time_whole'][:].data
coordx = nc.variables['coordx'][:].data
coordy = nc.variables['coordy'][:].data
coordz = nc.variables['coordz'][:].data
coords = np.column_stack([coordx, coordy, coordz])
disp_z = nc.variables['vals_nod_var3'][:].data  # disp_z
conn = nc.variables['connect1'][:].data - 1  # 0-indexed
nc.close()

n_ts = len(ts); n_elems = len(conn)
WARP_SCALE = 3000

# Extract external faces of tetrahedral mesh
# Each tet has 4 faces: (0,1,2), (0,1,3), (0,2,3), (1,2,3)
face_triplets = [(0,1,2), (0,1,3), (0,2,3), (1,2,3)]
from collections import Counter
face_counts = Counter()
for elem in conn:
    for f in face_triplets:
        face = tuple(sorted([elem[f[0]], elem[f[1]], elem[f[2]]]))
        face_counts[face] += 1

# External faces appear exactly once (internal faces appear twice)
ext_faces = [face for face, count in face_counts.items() if count == 1]
print(f"External faces: {len(ext_faces)}")

# Render animation
fig = plt.figure(figsize=(12.8, 7.2))
fig.patch.set_facecolor('#1A1A2E')
ax = fig.add_subplot(111, projection='3d')
ax.set_facecolor('#1A1A2E')
ax.xaxis.pane.fill = False; ax.yaxis.pane.fill = False; ax.zaxis.pane.fill = False
ax.grid(False)

n_cycles = 5
total = n_ts * n_cycles

for i in range(total):
    ax.clear()
    t_idx = i % n_ts
    t = ts[t_idx]
    dz = disp_z[t_idx]
    
    # Warp z coordinates
    warped = coords.copy()
    warped[:, 2] += dz * WARP_SCALE
    
    # Color each face by average displacement
    face_colors = []
    for face in ext_faces:
        avg_dz = abs(dz[list(face)].mean())
        color = plt.cm.coolwarm(min(avg_dz / 5e-6, 1.0))
        poly = [warped[f] for f in face]
        tri = Poly3DCollection([poly], alpha=0.85, facecolor=color, edgecolor='#333333', linewidth=0.15)
        ax.add_collection3d(tri)
    
    ax.set_xlim(-0.05, 1.05); ax.set_ylim(-0.05, 0.15); ax.set_zlim(-0.02, 0.22)
    ax.set_xlabel('X (m)', color='#888'); ax.set_ylabel('Y (m)', color='#888'); ax.set_zlabel('Z (m)', color='#888')
    ax.tick_params(colors='#888')
    ax.view_init(elev=25, azim=-60 + (i % 20) * 1.5)
    ax.set_title(f'Cantilever Beam Loading  |  t={t:.2f}s  |  max defl={abs(dz.min())*1e6:.2f}µm',
                 color='white', fontsize=14, pad=10)
    
    fig.savefig(str(d / f"f{i:04d}.png"), dpi=100, facecolor='#1A1A2E')
    if i % max(1, total//5) == 0:
        print(f"  {i+1}/{total}  t={t:.2f}  dz_max={abs(dz.min())*1e6:.1f}µm")

plt.close()

mp4 = RENDERS / "beam_loading.mp4"
subprocess.run(["ffmpeg","-y","-framerate","12","-i",str(d/"f%04d.png"),
    "-c:v","libx264","-pix_fmt","yuv420p","-vf","scale=1280:720",str(mp4)], capture_output=True)
print(f"\nDone: {mp4} ({mp4.stat().st_size/1e3:.0f} KB)")
