#!/usr/bin/env python3
"""红创科技 — 动画 V3: matplotlib, 1280x720, 保证颜色梯度"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path
import subprocess

ROOT = Path(__file__).parent
RENDERS = ROOT / "renders"

def make_fig():
    fig = plt.figure(figsize=(12.8, 7.2))
    fig.patch.set_facecolor('#1A1A2E')
    ax = fig.add_axes([0, 0, 1, 1])
    ax.set_facecolor('#1A1A2E')
    return fig, ax

def render_electrostatic():
    print("[Electrostatic Potential]")
    d = RENDERS / "e_frames"; d.mkdir(exist_ok=True)
    
    nx, ny = 100, 50
    x = np.linspace(-0.1, 0.1, nx)
    y = np.linspace(0, 0.05, ny)
    X, Y = np.meshgrid(x, y)
    V = np.ones_like(X)
    V[X > 0] = 1.0 - X[X > 0] / 0.1
    
    fig, ax = make_fig()
    
    for i in range(90):
        ax.clear(); ax.set_facecolor('#1A1A2E')
        angle = i * 4 * np.pi / 90
        Xr = X * np.cos(angle) - Y * np.sin(angle)
        Yr = X * np.sin(angle) + Y * np.cos(angle)
        
        ax.contourf(Xr, Yr, V, levels=60, cmap='jet')
        ax.set_xlim(-0.15, 0.15); ax.set_ylim(-0.08, 0.12)
        ax.axis('off')
        # Add label for material regions
        ax.text(-0.07, 0.10, 'Steel\n1e7 S/m', color='white', fontsize=10, ha='center')
        ax.text(0.07, 0.10, 'Concrete\n1e-2 S/m', color='white', fontsize=10, ha='center')
        # Arrow showing potential drop
        ax.annotate('V=1V', xy=(-0.08, -0.03), color='red', fontsize=12)
        ax.annotate('V=0V', xy=(0.08, -0.03), color='blue', fontsize=12)
        ax.annotate('', xy=(0.07, -0.03), xytext=(-0.07, -0.03),
                    arrowprops=dict(arrowstyle='->', color='white', lw=2))
        
        fig.savefig(str(d / f"f{i:04d}.png"), dpi=100, facecolor='#1A1A2E')
        if i % 30 == 0: print(f"  {i+1}/90")
    
    plt.close()
    subprocess.run(["ffmpeg","-y","-framerate","15","-i",str(d/"f%04d.png"),
        "-c:v","libx264","-pix_fmt","yuv420p","-vf","scale=1280:720",
        str(RENDERS/"electrostatic.mp4")], capture_output=True)
    print(f"  -> electrostatic.mp4 {RENDERS/'electrostatic.mp4'} {Path(str(RENDERS/'electrostatic.mp4')).stat().st_size/1e3:.0f}KB")

def render_acoustic():
    print("[Acoustic Pressure Field]")
    d = RENDERS / "a_frames"; d.mkdir(exist_ok=True)
    
    nx, ny = 200, 100
    x = np.linspace(0, 0.5, nx)
    y = np.linspace(0, 0.25, ny)
    X, Y = np.meshgrid(x, y)
    
    k = 2 * np.pi * 1000 / 343
    # Multi-mode standing wave
    p_real = np.cos(k * X) * np.cos(np.pi * Y / 0.25) * 0.5
    p_imag = np.sin(k * X) * np.sin(np.pi * Y / 0.25) * 0.3
    p_mag = np.sqrt(p_real**2 + p_imag**2)
    
    fig, ax = make_fig()
    
    for i in range(90):
        ax.clear(); ax.set_facecolor('#1A1A2E')
        angle = i * 4 * np.pi / 90
        Xr = X * np.cos(angle) - Y * np.sin(angle)
        Yr = X * np.sin(angle) + Y * np.cos(angle)
        
        ax.contourf(Xr, Yr, p_mag, levels=60, cmap='turbo')
        ax.set_xlim(-0.08, 0.58); ax.set_ylim(-0.15, 0.4)
        ax.axis('off')
        ax.text(0.25, 0.32, 'Helmholtz Cavity\nf=1000Hz, c=343m/s', color='white', fontsize=10, ha='center')
        
        fig.savefig(str(d / f"f{i:04d}.png"), dpi=100, facecolor='#1A1A2E')
        if i % 30 == 0: print(f"  {i+1}/90")
    
    plt.close()
    subprocess.run(["ffmpeg","-y","-framerate","15","-i",str(d/"f%04d.png"),
        "-c:v","libx264","-pix_fmt","yuv420p","-vf","scale=1280:720",
        str(RENDERS/"acoustic.mp4")], capture_output=True)
    print(f"  -> acoustic.mp4 {Path(str(RENDERS/'acoustic.mp4')).stat().st_size/1e3:.0f}KB")

def render_beam():
    print("[Cantilever Beam Loading]")
    d = RENDERS / "b_frames"; d.mkdir(exist_ok=True)
    
    L, H = 0.2, 0.01
    E, I = 200e9, 0.02 * H**3 / 12
    x = np.linspace(0, L, 100)
    
    fig, ax = make_fig()
    
    for i in range(60):
        ax.clear(); ax.set_facecolor('#1A1A2E')
        t = i / 59.0
        P = t * 100000 * 0.02 * L  # N
        deflection = -P * x**2 * (3*L - x) / (6 * E * I) * 80
        
        # Undeformed ghost
        ax.fill_between(x, -H/2, H/2, alpha=0.08, color='gray')
        # Deformed beam with colormap gradient along length
        colors = plt.cm.coolwarm(np.linspace(0, 1, len(x)-1))
        for j in range(len(x)-1):
            ax.fill_between(x[j:j+2], deflection[j:j+2]-H/2, deflection[j:j+2]+H/2,
                           color=colors[j], alpha=0.9)
        
        # Fixed end wall
        ax.add_patch(plt.Rectangle((-0.015, -0.025), 0.02, 0.05, color='#555555', zorder=10))
        
        ax.set_xlim(-0.02, L * 1.35)
        ax.set_ylim(-0.06, 0.06)
        ax.axis('off')
        ax.set_title(f'Cantilever Beam Loading  |  t = {t:.2f}s  |  max deflection = {abs(deflection[-1])*1000:.1f}mm',
                     color='white', fontsize=14, pad=8)
        
        fig.savefig(str(d / f"f{i:04d}.png"), dpi=100, facecolor='#1A1A2E')
        if i % 15 == 0: print(f"  {i+1}/60")
    
    plt.close()
    subprocess.run(["ffmpeg","-y","-framerate","15","-i",str(d/"f%04d.png"),
        "-c:v","libx264","-pix_fmt","yuv420p","-vf","scale=1280:720",
        str(RENDERS/"beam_loading.mp4")], capture_output=True)
    print(f"  -> beam_loading.mp4 {Path(str(RENDERS/'beam_loading.mp4')).stat().st_size/1e3:.0f}KB")

if __name__ == "__main__":
    print("=" * 60)
    print("  Hongchuang Animation Render V3")
    print("=" * 60)
    render_electrostatic()
    print()
    render_acoustic()
    print()
    render_beam()
    print(f"\nDone: {RENDERS}/")
