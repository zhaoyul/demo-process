#!/usr/bin/env python3
"""红创科技 — 三场耦合 3D动画: 温度 / 位移 / 损伤"""
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
d = RENDERS / "mp3d_fem"
d.mkdir(exist_ok=True)
for f in d.glob("*.png"): f.unlink()

# Load
nc = netCDF4.Dataset(str(ROOT / "outputs/cantilever_multiphysics.e"))
coordx = nc.variables['coordx'][:].data
coordy = nc.variables['coordy'][:].data
coordz = nc.variables['coordz'][:].data
coords = np.column_stack([coordx, coordy, coordz])
temp   = nc.variables['vals_nod_var4'][1].data  # t=1
disp_z = nc.variables['vals_nod_var3'][1].data
damage = nc.variables['vals_nod_var1'][1].data
conn   = nc.variables['connect1'][:].data - 1
nc.close()

# External faces
face_triplets = [(0,1,2),(0,1,3),(0,2,3),(1,2,3)]
fc = Counter()
for e in conn:
    for f in face_triplets:
        fc[tuple(sorted([e[f[0]],e[f[1]],e[f[2]]]))] += 1
ext_faces = [f for f,c in fc.items() if c == 1]
print(f"External faces: {len(ext_faces)}")

WARP_SCALE = 1000

# Three fields to cycle through
fields = [
    ("Temperature", temp, plt.cm.hot, "°C", None),
    ("Displacement z", disp_z, plt.cm.coolwarm, "m", WARP_SCALE),
    ("Damage (Phase Field)", damage, plt.cm.Reds, "d", None),
]

n = 90  # 30 frames per field
fig = plt.figure(figsize=(12.8, 7.2))
fig.patch.set_facecolor('#1A1A2E')
ax = fig.add_subplot(111, projection='3d')
ax.set_facecolor('#1A1A2E')

for i in range(n):
    ax.clear(); ax.set_facecolor('#1A1A2E')
    for p in [ax.xaxis.pane, ax.yaxis.pane, ax.zaxis.pane]:
        p.fill = False
    ax.grid(False)
    
    field_idx = i // 30
    label, values, cmap, unit, warp_scale = fields[field_idx]
    
    # Warp if needed
    wc = coords.copy()
    if warp_scale:
        wc[:, 2] += values * warp_scale
    
    # Scale values for colormap (avoid division by zero)
    vrange = values.max() - values.min()
    vnorm = vrange if vrange > 1e-10 else 1.0
    
    for face in ext_faces:
        nidx = list(face)
        v = values[nidx].mean()
        color = cmap((v - values.min()) / vnorm)
        poly = [wc[n] for n in nidx]
        tri = Poly3DCollection([poly], alpha=0.85, facecolor=color,
                               edgecolor='#333333', linewidth=0.15)
        ax.add_collection3d(tri)
    
    # Slow camera orbit
    angle = i * 1.2 / n * 360
    ax.view_init(elev=30 + 5*np.sin(i*np.pi/45), azim=-60+angle)
    ax.set_xlim(-0.05, 1.05); ax.set_ylim(-0.05, 0.15); ax.set_zlim(-0.02, 0.25)
    ax.tick_params(colors='#888')
    ax.set_title(f'Multiphysics Coupling: {label}  |  range=[{values.min():.3f}, {values.max():.3f}] {unit}',
                 color='white', fontsize=14, pad=10)
    
    fig.savefig(str(d / f"f{i:04d}.png"), dpi=100, facecolor='#1A1A2E')
    if i % 15 == 0:
        print(f"  [{label}] {i+1}/{n}")

plt.close()

mp4 = RENDERS / "multiphysics_coupling.mp4"
subprocess.run(["ffmpeg","-y","-framerate","12","-i",str(d/"f%04d.png"),
    "-c:v","libx264","-pix_fmt","yuv420p","-vf","scale=1280:720",str(mp4)], capture_output=True)
print(f"\nDone: {mp4} ({mp4.stat().st_size/1e3:.0f} KB)")
