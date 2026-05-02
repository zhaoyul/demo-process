#!/usr/bin/env python3
"""红创科技 — 静电场 + 声学动画 V2: 场量从0渐进演化 (无旋转)"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path
import subprocess

ROOT = Path(__file__).parent
RENDERS = ROOT / "renders"

def render(name, title, make_fields, n_frames=60, fps=15):
    d = RENDERS / f"{name}_frames"
    for f in d.glob("*.png"): f.unlink()
    
    fig, ax = plt.subplots(figsize=(12.8, 7.2))
    fig.patch.set_facecolor('#1A1A2E')
    ax.set_facecolor('#1A1A2E')
    
    for i in range(n_frames):
        ax.clear(); ax.set_facecolor('#1A1A2E')
        progress = i / (n_frames - 1)
        
        X, Y, Z = make_fields(progress)
        
        c = ax.contourf(X, Y, Z, levels=60, cmap='jet')
        ax.axis('off')
        ax.set_title(f'{title}  |  t = {progress:.2f}s', color='white', fontsize=16, pad=8)
        
        if i == 0:
            cbar = plt.colorbar(c, ax=ax, fraction=0.03, pad=0.02)
            cbar.ax.tick_params(colors='white')
        
        fig.savefig(str(d / f"f{i:04d}.png"), dpi=100, facecolor='#1A1A2E')
        if i % 20 == 0: print(f"  {i+1}/{n_frames}")
    
    plt.close()
    subprocess.run(["ffmpeg","-y","-framerate",str(fps),"-i",str(d/"f%04d.png"),
        "-c:v","libx264","-pix_fmt","yuv420p","-vf","scale=1280:720",
        str(RENDERS / f"{name}.mp4")], capture_output=True)
    mp4 = RENDERS / f"{name}.mp4"
    print(f"  -> {name}.mp4 ({mp4.stat().st_size/1e3:.0f} KB)")

def electrostatic_fields(progress):
    """Steel [-0.1,0] | Concrete [0,0.1], V=1→V=0"""
    x = np.linspace(-0.1, 0.1, 100)
    y = np.linspace(0, 0.05, 50)
    X, Y = np.meshgrid(x, y)
    V = np.ones_like(X)
    V[X > 0] = 1.0 - X[X > 0] / 0.1
    V *= progress
    # Add annotations
    ax = plt.gca()
    ax.text(-0.05, 0.07, 'Steel\n1e7 S/m', color='white', fontsize=11, ha='center')
    ax.text(0.05, 0.07, 'Concrete\n1e-2 S/m', color='white', fontsize=11, ha='center')
    ax.annotate(f'{1.0*progress:.1f}V', xy=(-0.09, -0.02), color='red', fontsize=14, weight='bold')
    ax.annotate('0V', xy=(0.09, -0.02), color='blue', fontsize=14, weight='bold')
    ax.annotate('', xy=(0.08, -0.02), xytext=(-0.08, -0.02),
                arrowprops=dict(arrowstyle='->', color='white', lw=3))
    ax.set_ylim(-0.04, 0.08)
    return X, Y, V

def acoustic_fields(progress):
    """Helmholtz cavity standing wave"""
    x = np.linspace(0, 0.5, 200)
    y = np.linspace(0, 0.25, 100)
    X, Y = np.meshgrid(x, y)
    k = 2 * np.pi * 1000 / 343
    pr = np.cos(k * X) * np.cos(np.pi * Y / 0.25)
    pi = np.sin(k * X) * np.sin(np.pi * Y / 0.25)
    pm = np.sqrt(pr**2 + pi**2)
    pm *= progress * 0.51 / pm.max()  # scale to max=0.51Pa
    ax = plt.gca()
    ax.text(0.25, 0.28, 'Helmholtz Cavity | f=1kHz | c=343m/s',
            color='white', fontsize=11, ha='center')
    ax.set_ylim(-0.05, 0.30)
    return X, Y, pm

if __name__ == "__main__":
    print("="*60)
    print("  静电场 + 声学: 场量渐进演化")
    print("="*60)
    print()
    render("electrostatic", "Electrostatic Potential (Steel + Concrete)", electrostatic_fields)
    print()
    render("acoustic", "Acoustic Pressure |p| (Helmholtz 1000Hz)", acoustic_fields)
    print(f"\nDone: {RENDERS}/")
