#!/usr/bin/env python3
"""AAC Wall FEM Render v2 — von Mises stress coloring + damage + slow playback"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.tri as tri
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
    "W-07": "w07_thin_column_pseudo_static",
    "W-08": "w08_window_opening_pseudo_static",
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
    
    # Connectivity
    conn = nc.variables['connect1'][:].data - 1
    if conn.min() < 0:
        conn = conn + 1
    tris = []
    for q in conn:
        tris.append([q[0], q[1], q[2]])
        tris.append([q[0], q[2], q[3]])
    triangles = np.array(tris)
    
    # Displacements
    disp_x = nc.variables['vals_nod_var1'][:].data
    disp_y = nc.variables['vals_nod_var2'][:].data
    
    # Element variables (von Mises, damage)
    elem_vars = {}
    for name in nc.variables:
        if name.startswith('vals_elem_var'):
            parts = name.split('eb')
            var_idx = int(parts[0].split('var')[1])
            data = nc.variables[name][:].data
            # Average per-element across time
            elem_vars[var_idx] = data
    
    nc.close()
    
    n_steps = len(ts)
    n_nodes = len(cx)
    
    # Identify variables
    # var1=vonmises, var2=damage_t (or similar)
    vm_data = None
    dm_data = None
    for idx, data in sorted(elem_vars.items()):
        if vm_data is None:
            vm_data = data
        elif dm_data is None:
            dm_data = data
    
    print(f"  {n_steps} timesteps, {n_nodes} nodes, {len(triangles)} tris")
    
    # Scale
    max_disp = max(np.max(np.abs(disp_x)), np.max(np.abs(disp_y)))
    scale = min(np.ptp(cx), np.ptp(cy)) / max_disp * 0.5 if max_disp > 0 else 1
    
    # Stress range for colorbar
    if vm_data is not None:
        vm_all = vm_data / 1e6  # MPa
        vm_max = np.percentile(np.abs(vm_all), 99)
    else:
        vm_max = 3.5
    
    frames_dir = RENDERS / f"aac_fem_{prefix}"
    # Clear old frames
    import shutil
    if frames_dir.exists():
        shutil.rmtree(frames_dir)
    frames_dir.mkdir()
    
    # Generate ALL frames (1 per timestep), slow playback
    n_frames = n_steps
    
    for i in range(n_frames):
        frame = i
        
        fig, (ax_stress, ax_damage) = plt.subplots(1, 2, figsize=(19.2, 7.2))
        fig.patch.set_facecolor('#0D0D1A')
        for ax in [ax_stress, ax_damage]:
            ax.set_facecolor('#0D0D1A')
        
        # Deformed coords
        dx = disp_x[i] * scale
        dy = disp_y[i] * scale
        deformed = coords.copy()
        deformed[:, 0] += dx
        deformed[:, 1] += dy
        
        xlim = [np.min(cx) - max_disp*scale*0.3, np.max(cx) + max_disp*scale*0.3]
        ylim = [np.min(cy) - max_disp*scale*0.3, np.max(cy) + max_disp*scale*0.3]
        
        # --- LEFT: von Mises stress colored mesh ---
        if vm_data is not None:
            elem_vm = np.abs(vm_data[i]) / 1e6  # MPa per element
            # Map element values to triangles
            tri_vm = np.zeros(len(triangles))
            for t_idx, tri_verts in enumerate(triangles):
                elem_idx = t_idx // 2  # 2 tris per quad
                if elem_idx < len(elem_vm) and tri_verts.max() < len(deformed):
                    tri_vm[t_idx] = elem_vm[elem_idx]
            
            triang = tri.Triangulation(deformed[:, 0], deformed[:, 1], triangles)
            tpc = ax_stress.tripcolor(triang, tri_vm, cmap='inferno', shading='flat',
                                       vmin=0, vmax=vm_max)
            cbar = plt.colorbar(tpc, ax=ax_stress, fraction=0.04, pad=0.02)
            cbar.set_label('von Mises (MPa)', color='white', fontsize=9)
            cbar.ax.tick_params(colors='white', labelsize=7)
        else:
            for tri_idx in triangles:
                pts = deformed[tri_idx]
                ax_stress.fill(pts[:,0], pts[:,1], facecolor='#3A4A6A', edgecolor='#5A6A8A', 
                             linewidth=0.2, alpha=0.8)
        
        ax_stress.set_title(f'{name} — von Mises Stress  t={ts[i]:.0f}s  Δmax={max_disp*1000:.1f}mm', 
                           color='white', fontsize=10)
        ax_stress.set_xlim(xlim); ax_stress.set_ylim(ylim)
        ax_stress.set_aspect('equal')
        ax_stress.tick_params(colors='#555555', labelsize=7)
        for spine in ax_stress.spines.values():
            spine.set_color('#333333')
        
        # --- RIGHT: Damage/deformation indicator ---
        if dm_data is not None:
            elem_dm = np.abs(dm_data[i]) / 1e6
            tri_dm = np.zeros(len(triangles))
            for t_idx, tri_verts in enumerate(triangles):
                elem_idx = t_idx // 2
                if elem_idx < len(elem_dm) and tri_verts.max() < len(deformed):
                    tri_dm[t_idx] = elem_dm[elem_idx]
            
            triang = tri.Triangulation(deformed[:,0], deformed[:,1], triangles)
            tpc2 = ax_damage.tripcolor(triang, tri_dm, cmap='plasma', shading='flat',
                                        vmin=0, vmax=vm_max)
            cbar2 = plt.colorbar(tpc2, ax=ax_damage, fraction=0.04, pad=0.02)
            cbar2.set_label('Stress intensity (MPa)', color='white', fontsize=9)
            cbar2.ax.tick_params(colors='white', labelsize=7)
        else:
            # Show displacement vectors as arrows
            step = max(1, n_nodes // 200)
            ax_damage.quiver(cx[::step], cy[::step], dx[::step], dy[::step],
                           scale=1, scale_units='xy', color='#FF6B35', alpha=0.6, width=0.003)
            for tri_idx in triangles[::10]:
                pts = deformed[tri_idx]
                ax_damage.fill(pts[:,0], pts[:,1], facecolor='#2A2A4A', edgecolor='#4A4A6A',
                             linewidth=0.15, alpha=0.5)
        
        ax_damage.set_title(f'{name} — Deformation (×{scale:.0f})  t={ts[i]:.0f}s', 
                           color='white', fontsize=10)
        ax_damage.set_xlim(xlim); ax_damage.set_ylim(ylim)
        ax_damage.set_aspect('equal')
        ax_damage.tick_params(colors='#555555', labelsize=7)
        for spine in ax_damage.spines.values():
            spine.set_color('#333333')
        
        fig.savefig(frames_dir / f"frame_{frame:04d}.png", dpi=100, facecolor='#0D0D1A')
        plt.close(fig)
        
        if frame % 15 == 0:
            print(f"    frame {frame}/{n_frames}")
    
    # Encode at 5 fps (slow, 200ms per frame) — 70 frames = 14 seconds
    out_mp4 = RENDERS / f"aac_wall_fem_{prefix}.mp4"
    subprocess.run([
        'ffmpeg', '-y', '-framerate', '5',
        '-i', str(frames_dir / 'frame_%04d.png'),
        '-c:v', 'libx264', '-pix_fmt', 'yuv420p',
        '-vf', 'scale=1920:720',
        str(out_mp4)
    ], capture_output=True)
    
    size_kb = out_mp4.stat().st_size // 1024 if out_mp4.exists() else 0
    print(f"  → {out_mp4.name} ({size_kb} KB, {n_frames} frames @5fps = {n_frames/5:.0f}s)")
    return True

if __name__ == "__main__":
    print("AAC Wall FEM Render v2 — Stress colored + slow")
    for name, prefix in WALLS.items():
        print(f"\n{name}:")
        render_wall(name, prefix)
    print("\nDone.")
