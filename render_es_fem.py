#!/usr/bin/env python3
"""红创科技 — 静电 3D 渲染 (参照 beam_loading 风格)"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
import numpy as np
import netCDF4
from pathlib import Path
import subprocess

ROOT = Path(__file__).parent
RENDERS = ROOT / "renders"
d = RENDERS / "es_fem"
d.mkdir(exist_ok=True)
for f in d.glob("*.png"): f.unlink()

# Load FEM data
nc = netCDF4.Dataset(str(ROOT / "outputs/electrostatic_steel_concrete.e"))
coordx = nc.variables['coordx'][:].data
coordy = nc.variables['coordy'][:].data
potential = nc.variables['vals_nod_var1'][-1].data  # steady state
conn1 = nc.variables['connect1'][:].data - 1
conn2 = nc.variables['connect2'][:].data - 1
nc.close()

# Create 3D slab by extruding 2D mesh
THICKNESS = 0.008  # z-extrusion for 3D effect
coords_2d = np.column_stack([coordx, coordy])
coords_top = np.column_stack([coordx, coordy, np.full(len(coordx), THICKNESS)])
coords_bot = np.column_stack([coordx, coordy, np.zeros(len(coordx))])

# Build 3D faces: top faces + side faces
all_faces = []

def add_quad_face(p1, p2, p3, p4, val):
    """Add a quadrilateral face with potential value"""
    all_faces.append(([p1, p2, p3, p4], val))

# Top surface faces (from both blocks)
for conn in [conn1, conn2]:
    for quad in conn:
        pts_top = [coords_top[q] for q in quad]
        val = potential[quad].mean()
        # Split quad into 2 triangles for poly3d
        add_quad_face(pts_top[0], pts_top[1], pts_top[2], pts_top[3], val)

# Side faces (extrude boundaries)
# Find boundary edges (appear only once across all quads)
from collections import Counter
edge_counts = Counter()
for conn in [conn1, conn2]:
    for quad in conn:
        for i in range(4):
            e = tuple(sorted([quad[i], quad[(i+1)%4]]))
            edge_counts[e] += 1

boundary_edges = [e for e, c in edge_counts.items() if c == 1]

for e in boundary_edges:
    p1t = coords_top[e[0]]; p2t = coords_top[e[1]]
    p1b = coords_bot[e[0]]; p2b = coords_bot[e[1]]
    val = (potential[e[0]] + potential[e[1]]) / 2
    all_faces.append(([p1t, p2t, p2b, p1b], val))

n_faces = len(all_faces)
print(f"Faces: {n_faces}")

# Render animation (60 frames, gentle camera rotation)
fig = plt.figure(figsize=(12.8, 7.2))
fig.patch.set_facecolor('#1A1A2E')
ax = fig.add_subplot(111, projection='3d')
ax.set_facecolor('#1A1A2E')
for pane in [ax.xaxis.pane, ax.yaxis.pane, ax.zaxis.pane]:
    pane.fill = False
ax.grid(False)

for i in range(60):
    ax.clear()
    ax.set_facecolor('#1A1A2E')
    
    # Camera orbit
    angle = i * 0.33 / 60 * 360  # 0.33 rotations
    elev = 35 + 10 * np.sin(i * np.pi / 30)
    azim = angle % 360
    
    # Animate field build-up: 0 → final over 40 frames
    progress = min(i / 40, 1.0)
    
    for face_pts, val_raw in all_faces:
        color = plt.cm.jet(val_raw * progress)
        tri = Poly3DCollection([face_pts], alpha=0.85, facecolor=color,
                               edgecolor='#333333', linewidth=0.15)
        ax.add_collection3d(tri)
    
    ax.set_xlim(-0.11, 0.11); ax.set_ylim(0, 0.05); ax.set_zlim(-0.005, THICKNESS*1.5)
    ax.set_xlabel('X (m)', color='#888'); ax.set_ylabel('Y (m)', color='#888')
    ax.tick_params(colors='#888')
    ax.view_init(elev=elev, azim=azim)
    ax.set_title(f'Electrostatic Potential: Steel (1e7 S/m) + Concrete (1e-2 S/m)',
                 color='white', fontsize=14, pad=10)
    
    ax.text2D(0.02, 0.95, 'Steel: V ≈ 1.0V (conductor)', transform=ax.transAxes,
              color='#FF4444', fontsize=16, weight='bold')
    ax.text2D(0.02, 0.88, 'Concrete: V: 1.0V → 0V (gradient)', transform=ax.transAxes,
              color='#4488FF', fontsize=16, weight='bold')
    ax.text2D(0.02, 0.81, f'V_max = {potential.max()*progress:.2f} V  |  Progress: {progress*100:.0f}%', transform=ax.transAxes,
              color='white', fontsize=12, weight='bold')
    
    fig.savefig(str(d / f"f{i:04d}.png"), dpi=100, facecolor='#1A1A2E')
    if i % 20 == 0:
        print(f"  {i+1}/60  angle={azim:.0f}°")

plt.close()

mp4 = RENDERS / "electrostatic.mp4"
subprocess.run(["ffmpeg","-y","-framerate","12","-i",str(d/"f%04d.png"),
    "-c:v","libx264","-pix_fmt","yuv420p","-vf","scale=1280:720",str(mp4)], capture_output=True)
print(f"\nDone: {mp4} ({mp4.stat().st_size/1e3:.0f} KB)")
