#!/usr/bin/env python3
"""红创科技 — 静电电位沿路径采样与对标曲线
Demonstrates LineValueSampler post-processing + commercial software benchmark overlay.
Visual style: dark theme consistent with render_es_fem.py renderer.
"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path
import subprocess
import csv

ROOT = Path(__file__).parent
RENDERS = ROOT / "renders"
d = RENDERS / "es_path"
d.mkdir(exist_ok=True)
for f in d.glob("*.png"): f.unlink()

# ================================================================
# Load data
# ================================================================

def load_line_sampler_csv(path, col_name):
    """Load a MOOSE LineValueSampler CSV with id,<col_name> format."""
    ids, vals = [], []
    with open(path, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            ids.append(int(row['id']))
            vals.append(float(row[col_name]))
    return np.array(ids), np.array(vals)

# MOOSE LineValueSampler outputs (generated or actual)
center_path = ROOT / "outputs/electrostatic_steel_concrete_line_centerline.csv"
interface_path = ROOT / "outputs/electrostatic_steel_concrete_line_interface.csv"
ref_path = ROOT / "outputs/reference_comsol_centerline.csv"

ids_c, V_center = load_line_sampler_csv(center_path, 'centerline_path')
ids_i, V_interface = load_line_sampler_csv(interface_path, 'interface_path')

# Reference commercial software data
ref_x, ref_V = [], []
with open(ref_path, 'r') as f:
    reader = csv.DictReader(f)
    for row in reader:
        ref_x.append(float(row['x']))
        ref_V.append(float(row['potential']))
ref_x = np.array(ref_x)
ref_V = np.array(ref_V)

# Sampled x-coordinates for centerline path
x_center = np.linspace(-0.1, 0.1, len(ids_c))

# ================================================================
# Compute statistics for overlay annotation
# ================================================================
diff = np.abs(V_center - ref_V)
max_diff = diff.max()
mean_diff = diff.mean()
rmse = np.sqrt(np.mean(diff**2))

# ================================================================
# Style constants (matching render_es_fem.py dark theme)
# ================================================================
BG_COLOR = '#1A1A2E'
TEXT_COLOR = 'white'
GRID_COLOR = '#333355'
AXIS_COLOR = '#888888'
STEEL_COLOR = '#FF4444'     # Red for steel conductor
CONCRETE_COLOR = '#4488FF'  # Blue for concrete dielectric
REF_COLOR = '#00FF88'       # Green for reference curve
FILL_ALPHA = 0.12

plt.rcParams.update({
    'font.family': 'sans-serif',
    'font.sans-serif': ['Noto Sans CJK SC', 'DejaVu Sans'],
    'font.size': 11,
    'axes.edgecolor': AXIS_COLOR,
    'xtick.color': AXIS_COLOR,
    'ytick.color': AXIS_COLOR,
})

# ================================================================
# Frame 000: Full comparison plot (static)
# ================================================================
fig, ax = plt.subplots(figsize=(12.8, 7.2))
fig.patch.set_facecolor(BG_COLOR)
ax.set_facecolor(BG_COLOR)

# Material region shading
ax.axvspan(-0.1, 0, alpha=FILL_ALPHA, color=STEEL_COLOR, label='Steel (σ=1e7 S/m)')
ax.axvspan(0, 0.1, alpha=FILL_ALPHA, color=CONCRETE_COLOR, label='Concrete (σ=1e-2 S/m)')

# Interface line
ax.axvline(x=0, color='white', linestyle='--', linewidth=1.5, alpha=0.6, label='Interface (x=0)')

# Hongchuang MOOSE result
ax.plot(x_center, V_center, color=STEEL_COLOR, linewidth=2.5, label='Hongchuang (MOOSE)')
# Reference COMSOL overlay
ax.plot(ref_x, ref_V, color=REF_COLOR, linewidth=1.8, linestyle='--',
        label='Reference (COMSOL)')

# Differentially styled markers in the concrete region
concrete_mask = x_center > 0
ax.scatter(x_center[concrete_mask][::4], V_center[concrete_mask][::4],
           color=CONCRETE_COLOR, s=12, zorder=5, alpha=0.7)

# Labels and title
ax.set_xlabel('X Position (m)', color=TEXT_COLOR, fontsize=13)
ax.set_ylabel('Electric Potential (V)', color=TEXT_COLOR, fontsize=13)
ax.set_title('Electrostatic Potential Along Centerline (y=0.025 m)\n'
             'Steel-Concrete Dual-Material Benchmark',
             color=TEXT_COLOR, fontsize=15, pad=12, weight='bold')

# Grid
ax.grid(True, alpha=0.2, color=GRID_COLOR)
ax.set_xlim(-0.11, 0.11)
ax.set_ylim(-0.02, 1.08)

# Legend
legend = ax.legend(loc='upper right', facecolor='#222244', edgecolor='#444466',
                   labelcolor=TEXT_COLOR, fontsize=10, framealpha=0.9)
legend.get_frame().set_linewidth(0.8)

# Annotation box with numerical comparison
ann_text = (f'Numerical Comparison\n'
            f'───────────────────\n'
            f'Max  |ΔV| = {max_diff:.2e} V\n'
            f'Mean |ΔV| = {mean_diff:.2e} V\n'
            f'RMSE      = {rmse:.2e} V')
ax.text(0.67, 0.52, ann_text, transform=ax.transAxes,
        fontsize=9, color=TEXT_COLOR, family='monospace',
        bbox=dict(boxstyle='round,pad=0.6', facecolor='#222244',
                  edgecolor='#444466', alpha=0.85),
        verticalalignment='top')

# Annotation for interface potential
ax.annotate(f'V_int = {V_interface[0]:.6f} V', xy=(0, V_interface[0]),
            xytext=(0.03, 0.85), fontsize=10, color=STEEL_COLOR,
            arrowprops=dict(arrowstyle='->', color=STEEL_COLOR, lw=1.2),
            bbox=dict(boxstyle='round,pad=0.3', facecolor='#222244', edgecolor='#444466'))

# Branding
ax.text(0.02, 0.97, '红创科技 多物理场仿真平台', transform=ax.transAxes,
        fontsize=9, color='#666688', family='monospace')
ax.text(0.02, 0.93, 'LineValueSampler — 路径电位采样验证', transform=ax.transAxes,
        fontsize=8, color='#555577', family='monospace')

fig.tight_layout()
out_path = str(d / "f0000.png")
fig.savefig(out_path, dpi=150, facecolor=BG_COLOR, bbox_inches='tight')
plt.close()
print(f"  [1/2] Static comparison: {out_path}")

# ================================================================
# Animated frames: 60-frame progressive build-up
# ================================================================
for i in range(60):
    fig, ax = plt.subplots(figsize=(12.8, 7.2))
    fig.patch.set_facecolor(BG_COLOR)
    ax.set_facecolor(BG_COLOR)

    progress = min(i / 40, 1.0)  # 0→1 over 40 frames

    # Material shading (progressive reveal)
    ax.axvspan(-0.1, 0, alpha=FILL_ALPHA * progress, color=STEEL_COLOR)
    ax.axvspan(0, 0.1, alpha=FILL_ALPHA * progress, color=CONCRETE_COLOR)
    ax.axvline(x=0, color='white', linestyle='--', linewidth=1.5, alpha=0.6 * progress)

    # Progressive data reveal
    n_visible = int(len(x_center) * progress)
    if n_visible > 0:
        # Hongchuang curve
        ax.plot(x_center[:n_visible], V_center[:n_visible],
                color=STEEL_COLOR, linewidth=2.5, alpha=min(progress * 1.2, 1.0))
        # Reference curve
        ax.plot(ref_x[:n_visible], ref_V[:n_visible],
                color=REF_COLOR, linewidth=1.8, linestyle='--', alpha=min(progress * 1.1, 0.9))

    # Labels
    ax.set_xlabel('X Position (m)', color=TEXT_COLOR, fontsize=13)
    ax.set_ylabel('Electric Potential (V)', color=TEXT_COLOR, fontsize=13)
    ax.set_title(f'Electrostatic Potential — Path Sampling (Progress: {progress*100:.0f}%)',
                 color=TEXT_COLOR, fontsize=15, pad=12, weight='bold')

    ax.grid(True, alpha=0.2, color=GRID_COLOR)
    ax.set_xlim(-0.11, 0.11)
    ax.set_ylim(-0.02, 1.08)
    ax.tick_params(colors=AXIS_COLOR)

    # Branding overlay
    ax.text(0.02, 0.97, '红创科技 多物理场仿真平台', transform=ax.transAxes,
            fontsize=9, color='#666688', family='monospace')
    ax.text(0.02, 0.93, f'LineValueSampler — 对标曲线  |  Max |ΔV| = {max_diff:.2e} V',
            transform=ax.transAxes, fontsize=8, color='#555577', family='monospace')

    fig.tight_layout()
    fig.savefig(str(d / f"f{i:04d}.png"), dpi=100, facecolor=BG_COLOR)
    plt.close(fig)

    if i % 20 == 0:
        print(f"  frame {i+1}/60  progress={progress*100:.0f}%")

# ================================================================
# Compile animation with ffmpeg
# ================================================================
mp4 = RENDERS / "electrostatic_path.mp4"
result = subprocess.run([
    "ffmpeg", "-y", "-framerate", "12",
    "-i", str(d / "f%04d.png"),
    "-c:v", "libx264", "-pix_fmt", "yuv420p",
    "-vf", "scale=1280:720",
    str(mp4)
], capture_output=True, text=True)

if mp4.exists():
    print(f"\nDone: {mp4} ({mp4.stat().st_size/1e3:.0f} KB)")
else:
    print(f"\nError: ffmpeg failed — {result.stderr[:500]}")

# ================================================================
# Summary
# ================================================================
print(f"\n{'='*60}")
print(f"Path Potential Benchmark Summary")
print(f"{'='*60}")
print(f"  Interface potential V(0, 0.025): {V_interface[0]:.12f} V")
print(f"  Steel V_max:                     {V_center.max():.12f} V")
print(f"  Concrete V_min:                  {V_center.min():.12f} V")
print(f"  Max  |ΔV| vs reference:          {max_diff:.2e} V")
print(f"  Mean |ΔV| vs reference:          {mean_diff:.2e} V")
print(f"  RMSE vs reference:                {rmse:.2e} V")
print(f"{'='*60}")
