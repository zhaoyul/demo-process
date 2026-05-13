#!/usr/bin/env python3
"""红创科技 — 接触力学 FEM 动画: 从 Exodus 读取真实 FEM 结果渲染"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
import numpy as np
import netCDF4
from pathlib import Path
from collections import Counter
import subprocess
import sys

ROOT = Path(__file__).parent
RENDERS = ROOT / "renders"
OUTPUT = ROOT / "outputs"

# ── Load FEM data from Exodus ──────────────────────────────
exo_path = OUTPUT / "contact_blocks_out.e"
if not exo_path.exists():
    print(f"ERROR: Exodus file not found: {exo_path}")
    sys.exit(1)

nc = netCDF4.Dataset(str(exo_path))

# Read time steps (steady-state → 1 step)
ts = nc.variables['time_whole'][:].data
n_ts = len(ts)

# Read mesh coordinates
coordx = nc.variables['coordx'][:].data
coordy = nc.variables['coordy'][:].data
coordz = nc.variables['coordz'][:].data
coords = np.column_stack([coordx, coordy, coordz])

# Read displacements (steps × nodes)
# Name mapping from name_nod_var:
#   var1=contact_pressure, var2=disp_x, var3=disp_y, var4=disp_z,
#   var5=nodal_area, var6=penetration
disp_x = nc.variables['vals_nod_var2'][:].data  # shape: (n_ts, n_nodes)
disp_y = nc.variables['vals_nod_var3'][:].data
disp_z = nc.variables['vals_nod_var4'][:].data
contact_pressure = nc.variables['vals_nod_var1'][:].data

# Read element connectivity (two blocks)
# connect1 = block_bottom tet4 elements
# connect2 = block_top tet4 elements
conn_bottom = nc.variables['connect1'][:].data - 1  # 0-indexed
conn_top = nc.variables['connect2'][:].data - 1

# Read global variables
gv = nc.variables['vals_glo_var'][:].data  # [contact_pressure_max, top_disp_z]
gv_names = [b''.join(nc.variables['name_glo_var'][i]).decode('utf-8', 'ignore').strip('\x00')
            for i in range(nc.variables['name_glo_var'].shape[0])]

# Get node sets for annotations
node_ns = {}
for i in range(1, 9):
    key = f'node_ns{i}'
    if key in nc.variables:
        name_bytes = b''.join(nc.variables['ns_names'][i-1])
        name = name_bytes.decode('utf-8', 'ignore').strip('\x00')
        node_ns[name] = nc.variables[key][:].data - 1  # 0-indexed

nc.close()

print(f"Loaded Exodus: {n_ts} timesteps, {len(coords)} nodes")
print(f"  Elements: bottom={len(conn_bottom)}, top={len(conn_top)}")
print(f"  Node sets: {list(node_ns.keys())}")
print(f"  Global vars: {dict(zip(gv_names, [float(gv[0][i]) for i in range(len(gv_names))]))}")
for t in range(n_ts):
    print(f"  t={ts[t]:.2f}s  disp_z: [{disp_z[t].min():.3e}, {disp_z[t].max():.3e}]  "
          f"cp: [{contact_pressure[t].min():.3e}, {contact_pressure[t].max():.3e}]")

# ── Extract external faces ─────────────────────────────────
def extract_external_faces(conn_arr):
    """Extract external faces from tet4 elements using face counting."""
    face_triplets = [(0, 1, 2), (0, 1, 3), (0, 2, 3), (1, 2, 3)]
    face_counts = Counter()
    for elem in conn_arr:
        for f in face_triplets:
            face = tuple(sorted([elem[f[0]], elem[f[1]], elem[f[2]]]))
            face_counts[face] += 1
    # External faces appear exactly once in a single block
    return [face for face, count in face_counts.items() if count == 1]

ext_faces_bottom = extract_external_faces(conn_bottom)
ext_faces_top = extract_external_faces(conn_top)

# Combined all external faces (both blocks)
all_faces = [(f, 'bottom') for f in ext_faces_bottom] + [(f, 'top') for f in ext_faces_top]

print(f"External faces: bottom={len(ext_faces_bottom)}, top={len(ext_faces_top)}")

# ── Compute deformation scale for visualization ────────────
WARP_SCALE = 1.0  # No exaggeration — show real deformation

# Check if we have real FEM results (non-zero displacements)
max_abs_disp = max(abs(disp_z).max(), abs(disp_x).max(), abs(disp_y).max())
if max_abs_disp < 1e-12:
    print("\n⚠  Warning: FEM output contains all-zero displacements.")
    print("  The animation will show the undeformed mesh in dark visual style.")
    print("  Run the solver (contact-opt) to populate real FEM results first.")
    WARP_SCALE = 1.0
else:
    print(f"\nReal FEM results detected: max|disp| = {max_abs_disp:.3e} m")
    # Auto-scale warp if displacements are very small
    extent = coordz.max() - coordz.min()
    if max_abs_disp < extent * 0.001:
        WARP_SCALE = extent / (max_abs_disp * 100)
        print(f"  Auto warp scale: {WARP_SCALE:.0f}x")

# ── Render setup ───────────────────────────────────────────
d = RENDERS / "contact_frames"
d.mkdir(parents=True, exist_ok=True)
for f in d.glob("*.png"):
    f.unlink()

fig = plt.figure(figsize=(12.8, 7.2))
fig.patch.set_facecolor('#1A1A2E')
ax = fig.add_subplot(111, projection='3d')
ax.set_facecolor('#1A1A2E')
ax.xaxis.pane.fill = False
ax.yaxis.pane.fill = False
ax.zaxis.pane.fill = False
ax.grid(False)

# ── Animation parameters ───────────────────────────────────
# For steady-state: create pseudo-transient from undeformed → deformed over 5s
ANIM_DURATION = 5.0  # seconds of animation
FPS = 15
n_frames = int(ANIM_DURATION * FPS)
# Ease-in-out for smooth loading simulation
t_anim = np.linspace(0, 1, n_frames)
alpha_values = t_anim ** 0.5  # slower start, faster finish (like real loading)

# ── Render frames ──────────────────────────────────────────
for i in range(n_frames):
    ax.clear()
    ax.set_facecolor('#1A1A2E')
    alpha = alpha_values[i]

    # Interpolate displacement: use the final (only) timestep scaled by alpha
    t_idx = min(n_ts - 1, i * n_ts // n_frames)
    dz = disp_z[t_idx] * alpha
    dx = disp_x[t_idx] * alpha
    dy = disp_y[t_idx] * alpha
    cp = contact_pressure[t_idx] * alpha

    # Warped coordinates
    warped = coords.copy()
    warped[:, 0] += dx * WARP_SCALE
    warped[:, 1] += dy * WARP_SCALE
    warped[:, 2] += dz * WARP_SCALE

    # Color by contact pressure magnitude
    cp_abs = np.abs(cp)
    cp_max = cp_abs.max() if cp_abs.max() > 0 else 1.0
    cp_norm = np.clip(cp_abs / (cp_max + 1e-10), 0, 1)

    # Draw all external faces
    for face, block_type in all_faces:
        face_cp = cp_norm[list(face)].mean()
        # Color scheme: block_bottom → red, block_top → blue, blended with contact pressure
        if block_type == 'bottom':
            base_color = np.array([0.898, 0.212, 0.212])  # #E53935
        else:
            base_color = np.array([0.118, 0.533, 0.898])  # #1E88E5
        # Overlay contact pressure as gold tint
        gold = np.array([0.831, 0.686, 0.216])  # #D4AF37
        color = base_color * (1 - face_cp * 0.6) + gold * (face_cp * 0.6)
        color = np.clip(color, 0, 1)

        poly = [warped[f] for f in face]
        tri = Poly3DCollection([poly], alpha=0.85, facecolor=color,
                               edgecolor='#444444', linewidth=0.15)
        ax.add_collection3d(tri)

    # Calculate FEM stats for the current frame
    gv_row = gv[t_idx] if t_idx < len(gv) else gv[-1]
    top_disp_z_fem = float(gv_row[1]) * alpha if len(gv_row) > 1 else dz.max()
    cp_max_fem = float(gv_row[0]) * alpha if len(gv_row) > 0 else cp.max()

    # View setup
    margin = 0.02
    x_min, x_max = coordx.min() - margin, coordx.max() + margin
    y_min, y_max = coordy.min() - margin, coordy.max() + margin
    z_min, z_max = -0.01, 0.06
    ax.set_xlim(x_min, x_max)
    ax.set_ylim(y_min, y_max)
    ax.set_zlim(z_min, z_max)
    ax.set_xlabel('X (m)', color='#888888')
    ax.set_ylabel('Y (m)', color='#888888')
    ax.set_zlabel('Z (m)', color='#888888')
    ax.tick_params(colors='#888888')
    ax.view_init(elev=25, azim=-50 + i * 0.3)  # Slow rotation

    # Loading progress bar
    progress_pct = alpha * 100
    time_label = f'{alpha * ANIM_DURATION:.1f}s'

    # Title
    ax.set_title(f'Contact Mechanics: Two-Body Compression  |  t = {time_label}  |  Load = {progress_pct:.0f}%',
                 color='white', fontsize=14, pad=10)

    # Numerical callouts — FEM values
    ax.text2D(0.02, 0.95, f'δ_z = {top_disp_z_fem*1e6:.2f} µm', transform=ax.transAxes,
              color='#D4AF37', fontsize=20, weight='bold')
    ax.text2D(0.02, 0.88, f'P_contact = {cp_max_fem/1e6:.3f} MPa', transform=ax.transAxes,
              color='#D4AF37', fontsize=14)
    ax.text2D(0.02, 0.83, f'Nodes: {len(coords)}  |  Elems: {len(conn_bottom)+len(conn_top)}  |  DOF: {len(coords)*3}',
              transform=ax.transAxes, color='#888888', fontsize=10)
    ax.text2D(0.02, 0.79, f'FEM: Elastic (E=200 GPa, ν=0.30)  |  Contact: frictionless penalty',
              transform=ax.transAxes, color='#666666', fontsize=9)
    ax.text2D(0.02, 0.75, f'Disp. scale: {WARP_SCALE:.0f}×', transform=ax.transAxes,
              color='#FF6B35', fontsize=10, weight='bold')

    # Block labels
    center_bottom = warped[list(set(conn_bottom.flatten()))].mean(axis=0)
    center_top = warped[list(set(conn_top.flatten()))].mean(axis=0)
    ax.text(center_bottom[0], center_bottom[1], center_bottom[2] + 0.008,
            'Fixed Block', color='#E53935', fontsize=12, ha='center', weight='bold')
    ax.text(center_top[0], center_top[1], center_top[2] + 0.008,
            'Compressed Block', color='#1E88E5', fontsize=12, ha='center', weight='bold')

    # Contact interface indicator
    interface_z = warped[list(set(conn_bottom.flatten()))][:, 2].max()
    ax.text(x_max, coordy.max() / 2, interface_z,
            '← contact interface →', color='#D4AF37', fontsize=9, ha='center')

    fig.savefig(str(d / f"f{i:04d}.png"), dpi=100, facecolor='#1A1A2E')
    if i % max(1, n_frames // 5) == 0:
        print(f"  {i+1}/{n_frames}  α={alpha:.2f}  "
              f"disp_z_max={abs(dz).max()*1e6:.1f}µm  "
              f"cp_max={abs(cp).max()/1e6:.3f}MPa")

plt.close()

# ── Encode video ───────────────────────────────────────────
mp4 = RENDERS / "contact.mp4"
subprocess.run([
    "ffmpeg", "-y", "-framerate", str(FPS),
    "-i", str(d / "f%04d.png"),
    "-c:v", "libx264", "-pix_fmt", "yuv420p",
    "-vf", "scale=1280:720",
    str(mp4)
], capture_output=True)

if mp4.exists():
    print(f"\n✓ Done: {mp4} ({mp4.stat().st_size/1e3:.0f} KB)")
    print(f"  Duration: {ANIM_DURATION}s, Frames: {n_frames}, FPS: {FPS}")
else:
    print("\n✗ ffmpeg failed to create video")
