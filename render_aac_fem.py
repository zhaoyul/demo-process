#!/usr/bin/env python3
"""AAC Wall FEM Deformation Render — simplified: deformation only"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import netCDF4
from pathlib import Path
import subprocess

ROOT = Path(__file__).parent
OUTPUTS = ROOT / "outputs"
RENDERS = ROOT / "renders"
RENDERS.mkdir(exist_ok=True)

WALLS = {
    "W-03": "w03_pseudo_static",
    "W-04": "w04_thin_pseudo_static",
    "W-05": "w05_no_lattice_pseudo_static",
    "W-06": "w06_large_plate_pseudo_static",
    "W-09": "w09_hinged_pseudo_static",
}

def render_wall(name, prefix):
    exo_path = OUTPUTS / f"{prefix}.e"
    if not exo_path.exists():
        print(f"  SKIP: {exo_path} not found")
        return False
    
    print(f"  Loading {exo_path.name}...")
    nc = netCDF4.Dataset(str(exo_path))
    ts = nc.variables['time_whole'][:].data
    cx = nc.variables['coordx'][:].data
    cy = nc.variables['coordy'][:].data
    coords = np.column_stack([cx, cy])
    
    # Connectivity (Exodus 1-indexed → 0-indexed)
    conn_raw = nc.variables['connect1'][:].data
    conn = conn_raw - 1
    if conn.min() < 0:
        conn = conn_raw
    # Quad → tri
    tris = []
    for q in conn:
        tris.append([q[0], q[1], q[2]])
        tris.append([q[0], q[2], q[3]])
    triangles = np.array(tris)
    
    # Displacements
    disp_x = nc.variables['vals_nod_var1'][:].data
    disp_y = nc.variables['vals_nod_var2'][:].data
    nc.close()
    
    n_steps = len(ts)
    n_nodes = len(cx)
    print(f"  {n_steps} timesteps, {n_nodes} nodes, {len(triangles)} tris")
    
    # Scale for visualization
    max_disp = max(np.max(np.abs(disp_x)), np.max(np.abs(disp_y)))
    scale = min(np.ptp(cx), np.ptp(cy)) / max_disp * 0.5 if max_disp > 0 else 1
    xlim = [np.min(cx) - max_disp*scale*0.2, np.max(cx) + max_disp*scale*0.2]
    ylim = [np.min(cy) - max_disp*scale*0.2, np.max(cy) + max_disp*scale*0.2]
    
    frames_dir = RENDERS / f"aac_fem_{prefix}"
    frames_dir.mkdir(exist_ok=True)
    
    frame_step = max(1, n_steps // 80)  # ~80 frames
    
    for i in range(0, n_steps, frame_step):
        frame = len(list(frames_dir.glob("*.png")))
        
        fig, ax = plt.subplots(figsize=(12.8, 7.2))
        fig.patch.set_facecolor('#1A1A2E')
        ax.set_facecolor('#1A1A2E')
        
        # Deformed mesh
        dx, dy = disp_x[i] * scale, disp_y[i] * scale
        deformed = coords.copy()
        deformed[:, 0] += dx
        deformed[:, 1] += dy
        
        for tri_idx in triangles:
            pts = deformed[tri_idx]
            ax.fill(pts[:,0], pts[:,1], facecolor='#2A3A5A', edgecolor='#4A6A9A', 
                   linewidth=0.3, alpha=0.8)
        
        ax.set_title(f'{name} — Deformation  t={ts[i]:.1f}s  disp_max={max_disp*1000:.1f}mm  ×{scale:.0f}', 
                     color='white', fontsize=12)
        ax.set_xlim(xlim); ax.set_ylim(ylim)
        ax.set_aspect('equal')
        ax.tick_params(colors='white', labelsize=8)
        for spine in ax.spines.values():
            spine.set_color('#3A3A5A')
        
        fig.savefig(frames_dir / f"frame_{frame:04d}.png", dpi=120, facecolor='#1A1A2E')
        plt.close(fig)
        
        if frame % 20 == 0:
            print(f"    frame {frame}/{n_steps//frame_step}")
    
    # Encode MP4
    out_mp4 = RENDERS / f"aac_wall_fem_{prefix}.mp4"
    subprocess.run([
        'ffmpeg', '-y', '-framerate', '12',
        '-i', str(frames_dir / 'frame_%04d.png'),
        '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
        str(out_mp4)
    ], capture_output=True)
    
    size_kb = out_mp4.stat().st_size // 1024 if out_mp4.exists() else 0
    print(f"  → {out_mp4.name} ({size_kb} KB)")
    return True

if __name__ == "__main__":
    print("AAC Wall FEM Deformation Render")
    for name, prefix in WALLS.items():
        print(f"\n{name}:")
        render_wall(name, prefix)
    print("\nDone.")
