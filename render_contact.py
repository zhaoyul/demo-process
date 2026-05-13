#!/usr/bin/env python3
"""红创科技 — 接触力学 FEM 动画: 11步真实FEM数据插值, HEX8面渲染, 100×"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
import numpy as np
import netCDF4
from pathlib import Path
from collections import Counter
import subprocess, sys

ROOT = Path(__file__).parent
RENDERS = ROOT / "renders"
OUTPUT = ROOT / "outputs"

exo_path = OUTPUT / "contact_blocks_out.e"
nc = netCDF4.Dataset(str(exo_path))
ts = nc.variables['time_whole'][:].data
n_ts = len(ts)

coordx = nc.variables['coordx'][:].data
coordy = nc.variables['coordy'][:].data
coordz = nc.variables['coordz'][:].data
coords = np.column_stack([coordx, coordy, coordz])

disp_x = nc.variables['vals_nod_var2'][:].data
disp_y = nc.variables['vals_nod_var3'][:].data
disp_z = nc.variables['vals_nod_var4'][:].data
contact_pressure = nc.variables['vals_nod_var1'][:].data

conn_b = nc.variables['connect1'][:].data - 1
conn_t = nc.variables['connect2'][:].data - 1
nc.close()

# ── HEX8 external quad faces ──
def extract_hex_faces(conn):
    quad_faces = [(0,1,2,3),(0,1,5,4),(1,2,6,5),(2,3,7,6),(3,0,4,7),(4,5,6,7)]
    fc = Counter()
    for e in conn:
        for q in quad_faces:
            fc[tuple(sorted([e[q[0]],e[q[1]],e[q[2]],e[q[3]]]))] += 1
    return [f for f,c in fc.items() if c == 1]

all_faces = [(f,'b') for f in extract_hex_faces(conn_b)] + [(f,'t') for f in extract_hex_faces(conn_t)]

# ── Setup ──
FPS = 15
TOTAL_SECS = 6.0  # slightly more than 5s for context
n_frames = int(TOTAL_SECS * FPS)
WARP_SCALE = 100.0

d = RENDERS / "contact_frames"
d.mkdir(parents=True, exist_ok=True)
for f in d.glob("*.png"): f.unlink()

fig = plt.figure(figsize=(12.8, 7.2))
fig.patch.set_facecolor('#1A1A2E')
ax = fig.add_subplot(111, projection='3d')

# Pre-compute global bounds
z_margin = abs(disp_z).max() * WARP_SCALE * 2

for i in range(n_frames):
    ax.clear()
    ax.set_facecolor('#1A1A2E')
    for p in [ax.xaxis.pane, ax.yaxis.pane, ax.zaxis.pane]: p.fill = False
    ax.grid(False)

    # Map frame to FEM timestep with smooth interpolation
    sim_time = (i / (n_frames - 1)) * 5.0  # 0→5s
    sim_time = min(sim_time, 5.0)

    # Find enclosing FEM timesteps
    idx_after = np.searchsorted(ts, sim_time)
    idx_after = min(idx_after, n_ts - 1)
    idx_after = max(idx_after, 1)
    idx_before = idx_after - 1

    t0, t1 = ts[idx_before], ts[idx_after]
    frac = (sim_time - t0) / (t1 - t0 + 1e-12)

    # Interpolate displacement between real FEM steps
    dz = (1-frac) * disp_z[idx_before] + frac * disp_z[idx_after]
    dx = (1-frac) * disp_x[idx_before] + frac * disp_x[idx_after]
    dy = (1-frac) * disp_y[idx_before] + frac * disp_y[idx_after]
    cp_val = (1-frac) * contact_pressure[idx_before] + frac * contact_pressure[idx_after]

    # Warp coordinates
    warped = coords.copy()
    warped[:,0] += dx * WARP_SCALE
    warped[:,1] += dy * WARP_SCALE
    warped[:,2] += dz * WARP_SCALE

    # Displacement magnitude for color
    disp_mag = np.sqrt(dx**2 + dy**2 + dz**2)
    dm_max = disp_mag.max() if disp_mag.max() > 0 else 1.0

    # Draw faces color-coded by displacement: blue(fixed)→red(compressed)
    for face, block in all_faces:
        fd = np.clip(disp_mag[list(face)].mean() / (dm_max + 1e-12), 0, 1)
        color = [0.15 + fd*0.85, 0.12, 1.0 - fd*0.95]  # blue→red
        poly = [warped[f] for f in face]
        ax.add_collection3d(Poly3DCollection([poly], alpha=0.92, facecolor=color,
                              edgecolor='#111133', linewidth=0.2))

    # ── HUD ──
    dz_mm = abs(dz).max() * 1000
    cp_mpa = abs(cp_val).max() / 1e6

    ax.set_xlim(coordx.min()-0.02, coordx.max()+0.02)
    ax.set_ylim(coordy.min()-0.02, coordy.max()+0.02)
    ax.set_zlim(coordz.min()-z_margin, coordz.max()+0.02)
    for a, lbl in [(ax.set_xlabel,'X'),(ax.set_ylabel,'Y'),(ax.set_zlabel,'Z')]:
        a(f'{lbl} (m)', color='#888888')
    ax.tick_params(colors='#888888', labelsize=7)
    ax.view_init(elev=28, azim=-52)

    ax.set_title(f'Hongchuang Contact Mechanics — Transient FEM  |  t = {sim_time:.1f}s / 5.0s',
                 color='white', fontsize=14, pad=10)

    # Large HUD numbers
    ax.text2D(0.02, 0.95, f'δ_z = {dz_mm:.3f} mm', transform=ax.transAxes,
              color='#FF6B35', fontsize=26, weight='bold')
    ax.text2D(0.02, 0.86, f'P_contact = {cp_mpa:.1f} MPa', transform=ax.transAxes,
              color='#D4AF37', fontsize=18)
    ax.text2D(0.02, 0.78, f'{WARP_SCALE:.0f}× deformation  |  80 HEX8  |  495 DOF',
              transform=ax.transAxes, color='#888888', fontsize=10)

    # Color legend
    ax.text2D(0.86, 0.03, '● Compressed', transform=ax.transAxes, color='#FF3333', fontsize=9)
    ax.text2D(0.86, 0.08, '● Undeformed', transform=ax.transAxes, color='#3388FF', fontsize=9)

    # Block labels
    cb = warped[list(set(conn_b.flatten()))].mean(axis=0)
    ct = warped[list(set(conn_t.flatten()))].mean(axis=0)
    ax.text(cb[0], cb[1], cb[2]-0.012, 'Bottom (Fixed)', color='#3388FF', fontsize=10, ha='center')
    ax.text(ct[0], ct[1], cb[2]+0.012, 'Top (Compressed)', color='#FF3333', fontsize=10, ha='center')

    fig.savefig(str(d / f"f{i:04d}.png"), dpi=120, facecolor='#1A1A2E')
    if i % max(1,n_frames//6) == 0:
        print(f"  {i+1}/{n_frames} t={sim_time:.2f}s  δz={dz_mm:.3f}mm")

plt.close()

mp4 = RENDERS / "contact.mp4"
subprocess.run([
    "ffmpeg","-y","-framerate",str(FPS),
    "-i",str(d/"f%04d.png"),
    "-c:v","libx264","-pix_fmt","yuv420p","-vf","scale=1280:720",
    str(mp4)
], capture_output=True)

if mp4.exists():
    print(f"\n✓ Done: {mp4} ({mp4.stat().st_size/1e3:.0f} KB)")
    print(f"  FEM steps: {n_ts}, Frames: {n_frames}, Duration: {TOTAL_SECS}s")
else:
    print("\n✗ ffmpeg failed")
