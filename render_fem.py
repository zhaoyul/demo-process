#!/usr/bin/env python3
"""红创科技 — 真实 FEM 动画 (matplotlib + netCDF4 读 .e)"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.tri as tri
import numpy as np
import netCDF4
from pathlib import Path
import subprocess, os

ROOT = Path(__file__).parent
OUTPUTS = ROOT / "outputs"
RENDERS = ROOT / "renders"

def make_fig():
    fig, ax = plt.subplots(figsize=(12.8, 7.2))
    fig.patch.set_facecolor('#1A1A2E')
    ax.set_facecolor('#1A1A2E')
    return fig, ax

def load_exodus(path):
    """Load ExodusII: returns (timesteps, coords, nodal_vars, connectivity)"""
    nc = netCDF4.Dataset(str(path))
    ts = nc.variables['time_whole'][:].data
    coordx = nc.variables['coordx'][:].data
    coordy = nc.variables['coordy'][:].data
    coords = np.column_stack([coordx, coordy])
    n_ts = len(ts)
    
    # Auto-detect nodal displacement variables
    nodal_vars = {}
    for i in range(1, 10):
        vname = f'vals_nod_var{i}'
        if vname in nc.variables:
            name = nc.variables[f'name_nod_var'][i-1].tobytes().decode().strip('\x00')
            nodal_vars[name] = nc.variables[vname][:].data
    
    # Get element connectivity
    conn = {}
    for i in range(1, 10):
        cname = f'connect{i}'
        if cname in nc.variables:
            conn[i] = nc.variables[cname][:].data - 1  # 1-indexed → 0-indexed
    
    nc.close()
    return ts, coords, nodal_vars, conn

def to_mp4(frame_dir, name, fps=15):
    mp4_path = RENDERS / f"{name}.mp4"
    subprocess.run(["ffmpeg","-y","-framerate",str(fps),"-i",
        str(frame_dir/"f%04d.png"),"-c:v","libx264","-pix_fmt","yuv420p",
        "-vf","scale=1280:720",str(mp4_path)], capture_output=True)
    sz = mp4_path.stat().st_size/1e3 if mp4_path.exists() else 0
    print(f"  -> {name}.mp4 ({sz:.0f} KB)")
    return mp4_path

# ============================================================
def render_contact():
    print("[Contact Mechanics — real FEM mesh + deformation]")
    path = OUTPUTS / "contact_2d.e"
    ts, coords, vars, conn = load_exodus(path)
    
    d = RENDERS / "contact_fem"; d.mkdir(exist_ok=True)
    for f in d.glob("*.png"): f.unlink()
    
    disp_x = vars.get('disp_x', vars.get('stress_xx', None))
    if disp_x is None:
        print("  No displacement found!"); return
    
    n_ts = len(ts)
    n_cycles = 5
    total = n_ts * n_cycles
    
    fig, ax = make_fig()
    
    for i in range(total):
        ax.clear(); ax.set_facecolor('#1A1A2E')
        t_idx = i % n_ts
        t = ts[t_idx]
        
        # Warp coordinates by actual displacement
        dxy = disp_x[t_idx]
        warped_coords = coords.copy()
        warped_coords[:, 0] += dxy
        
        # Draw mesh triangles
        for blk_id, elem_conn in conn.items():
            triangles = elem_conn
            for tri_idx in range(len(triangles)):
                pts = warped_coords[triangles[tri_idx]]
                color_val = abs(dxy[triangles[tri_idx]].mean())
                color = plt.cm.coolwarm(color_val / max(0.18, abs(disp_x).max()))
                ax.fill(pts[:, 0], pts[:, 1], facecolor=color, edgecolor='#333333', linewidth=0.3, alpha=0.85)
        
        ax.set_xlim(-0.05, 1.05); ax.set_ylim(-0.05, 1.05)
        ax.set_aspect('equal'); ax.axis('off')
        ax.set_title(f'Contact Mechanics  |  t={t:.2f}s  |  disp_x=[{dxy.min():.3f}, {dxy.max():.3f}]m',
                     color='white', fontsize=14, pad=8)
        
        fig.savefig(str(d / f"f{i:04d}.png"), dpi=100, facecolor='#1A1A2E')
        if i % max(1, total//5) == 0:
            print(f"  {i+1}/{total}  t={t:.2f}")
    
    plt.close()
    to_mp4(d, "contact", fps=10)

# ============================================================
def render_electrostatic():
    print("[Electrostatic — real FEM mesh + potential gradient]")
    path = OUTPUTS / "electrostatic_steel_concrete.e"
    ts, coords, vars, conn = load_exodus(path)
    
    d = RENDERS / "electrostatic_fem"; d.mkdir(exist_ok=True)
    for f in d.glob("*.png"): f.unlink()
    
    potential = vars.get('potential')
    if potential is None:
        print("  No potential found!"); return
    
    pot = potential[-1]  # steady state (last timestep)
    
    fig, ax = make_fig()
    
    # 60 frames: camera pans slightly to show 3D structure
    for i in range(60):
        ax.clear(); ax.set_facecolor('#1A1A2E')
        
        for blk_id, elem_conn in conn.items():
            for tri_idx in range(len(elem_conn)):
                pts = coords[elem_conn[tri_idx]]
                val = pot[elem_conn[tri_idx]].mean()
                color = plt.cm.jet(val)
                ax.fill(pts[:, 0], pts[:, 1], facecolor=color, edgecolor='#555555', linewidth=0.3, alpha=0.9)
        
        ax.set_xlim(-0.11, 0.11); ax.set_ylim(0, 0.05)
        ax.set_aspect('equal'); ax.axis('off')
        ax.set_title(f'Electrostatic Potential  |  V=[{pot.min():.2f}, {pot.max():.2f}]V',
                     color='white', fontsize=14, pad=8)
        # Annotations
        ax.text(-0.05, 0.06, 'Steel\n1e7 S/m', color='white', fontsize=10, ha='center')
        ax.text(0.05, 0.06, 'Concrete\n1e-2 S/m', color='white', fontsize=10, ha='center')
        
        fig.savefig(str(d / f"f{i:04d}.png"), dpi=100, facecolor='#1A1A2E')
        if i % 20 == 0:
            print(f"  {i+1}/60")
    
    plt.close()
    to_mp4(d, "electrostatic")

# ============================================================
def render_multiphysics():
    print("[Multiphysics — temperature field from .e]")
    path = OUTPUTS / "cantilever_multiphysics.e"
    ts, coords, vars, conn = load_exodus(path)
    
    d = RENDERS / "multiphysics_fem"; d.mkdir(exist_ok=True)
    for f in d.glob("*.png"): f.unlink()
    
    temp = vars.get('temp')
    if temp is None:
        print("  No temperature found!"); return
    
    T = temp[-1]
    
    fig, ax = make_fig()
    
    for i in range(60):
        ax.clear(); ax.set_facecolor('#1A1A2E')
        
        for blk_id, elem_conn in conn.items():
            for tri_idx in range(len(elem_conn)):
                pts = coords[elem_conn[tri_idx]]
                val = T[elem_conn[tri_idx]].mean()
                color = plt.cm.hot(val / T.max())
                ax.fill(pts[:, 0], pts[:, 1], facecolor=color, edgecolor='#555555', linewidth=0.2, alpha=0.9)
        
        ax.set_aspect('equal'); ax.axis('off')
        ax.set_title(f'Multiphysics: Temperature Field  |  T=[{T.min():.1f}, {T.max():.1f}]°C',
                     color='white', fontsize=14, pad=8)
        
        fig.savefig(str(d / f"f{i:04d}.png"), dpi=100, facecolor='#1A1A2E')
        if i % 20 == 0:
            print(f"  {i+1}/60")
    
    plt.close()
    to_mp4(d, "multiphysics_coupling")

if __name__ == "__main__":
    print("=" * 60)
    print("  Real FEM Animation (netCDF4 read ExodusII)")
    print("=" * 60)
    render_contact()
    print()
    render_electrostatic()
    print()
    render_multiphysics()
    print(f"\nDone: {RENDERS}/")
