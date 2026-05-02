#!/usr/bin/env python3
"""红创科技 — 仿真动画渲染 (pvpython)
生成变形过程 MP4 视频, 展示仿真场景的时间演化"""

import sys, os
from pathlib import Path

ROOT = Path(__file__).parent
OUTPUTS = ROOT / "outputs"
RENDERS = ROOT / "renders"
RENDERS.mkdir(exist_ok=True)

from paraview.simple import *

def render_frames(render_setup, name, n_frames, fps=15, rotate=False):
    """手动逐帧渲染"""
    d = RENDERS / name
    d.mkdir(exist_ok=True)
    
    anim = GetAnimationScene()
    anim.PlayMode = 'Sequence'
    
    for frame in range(n_frames):
        anim.AnimationTime = frame
        
        if rotate:
            # Rotate camera around model
            angle = frame * 360.0 / n_frames
            import math
            rad = math.radians(angle)
            r = 1.5
            GetActiveView().CameraPosition = [0.5 + r*math.sin(rad), -r*math.cos(rad), 0.4]
        
        render_setup(frame, n_frames)
        Render()
        SaveScreenshot(str(d / f"f{frame:04d}.png"), GetActiveView(),
            ImageResolution=[1280, 720])
        if frame % max(1, n_frames//5) == 0:
            print(f"  [{name}] {frame+1}/{n_frames}")
    
    print(f"  ✓ {name}/ ({n_frames} frames)")
    
    # Generate MP4 with ffmpeg
    mp4 = RENDERS / f"{name}.mp4"
    os.system(f'ffmpeg -y -framerate {fps} -i "{d}/f%04d.png" '
              f'-c:v libx264 -pix_fmt yuv420p "{mp4}" 2>/dev/null')
    if mp4.exists():
        size_mb = mp4.stat().st_size / 1e6
        print(f"  ✓ {name}.mp4 ({size_mb:.1f} MB)")


# ─── 场景 1: 悬臂梁渐变加载 ────────────────────────
def setup_beam_transient(frame, total):
    if frame == 0:
        r = ExodusIIReader(FileName=[str(OUTPUTS / "cantilever_beam_transient.e")])
        r.PointVariables = ['disp_x','disp_y','disp_z']
        w = WarpByVector(Input=r)
        w.Vectors = ['POINTS', 'disp_z']
        w.ScaleFactor = 50.0
        d = Show(w); d.Representation = 'Surface With Edges'
        ColorBy(d, ('POINTS', 'disp_z'))
        GetColorTransferFunction('disp_z').ApplyPreset('Cool to Warm (Extended)', True)
        v = GetActiveView(); v.Background = [0.12,0.12,0.15]
        v.CameraPosition = [0.3,-1.2,0.4]; v.CameraFocalPoint = [0.5,0.05,0.1]; v.CameraViewUp = [0,0,1]
        ResetCamera()
        setup_beam_transient._data = (r, w)

# ─── 场景 2: 悬臂梁循环载荷 ────────────────────────
def setup_beam_cyclic(frame, total):
    if frame == 0:
        r = ExodusIIReader(FileName=[str(OUTPUTS / "cantilever_beam_cyclic.e")])
        r.PointVariables = ['disp_x','disp_y','disp_z']
        w = WarpByVector(Input=r)
        w.Vectors = ['POINTS', 'disp_z']
        w.ScaleFactor = 60.0
        d = Show(w); d.Representation = 'Surface With Edges'
        ColorBy(d, ('POINTS', 'disp_z'))
        GetColorTransferFunction('disp_z').ApplyPreset('Cool to Warm (Extended)', True)
        v = GetActiveView(); v.Background = [0.12,0.12,0.15]
        v.CameraPosition = [0.3,-1.2,0.4]; v.CameraFocalPoint = [0.5,0.05,0.1]; v.CameraViewUp = [0,0,1]
        ResetCamera()
        setup_beam_cyclic._data = (r, w)

# ─── 场景 3: 接触力学 ──────────────────────────────
def setup_contact(frame, total):
    if frame == 0:
        r = ExodusIIReader(FileName=[str(OUTPUTS / "contact_2d.e")])
        w = WarpByVector(Input=r)
        w.Vectors = ['POINTS', 'disp_x']
        w.ScaleFactor = 1.0
        d = Show(w); d.Representation = 'Surface With Edges'
        try:
            ColorBy(d, ('POINTS', 'disp_x'))
            GetColorTransferFunction('disp_x').ApplyPreset('Cool to Warm (Extended)', True)
        except: pass
        v = GetActiveView(); v.Background = [0.12,0.12,0.15]
        v.CameraPosition = [0.5,-1,2]; v.CameraFocalPoint = [0.5,0.5,0]; v.CameraViewUp = [0,1,0]
        ResetCamera()
        setup_contact._data = (r, w)

# ─── 场景 4: 静电电位场 (旋转相机) ─────────────────
def setup_em(frame, total):
    if frame == 0:
        r = ExodusIIReader(FileName=[str(OUTPUTS / "electrostatic_steel_concrete.e")])
        r.PointVariables = ['potential']
        d = Show(r); d.Representation = 'Surface With Edges'
        ColorBy(d, ('POINTS', 'potential'))
        GetColorTransferFunction('potential').ApplyPreset('Blue to Red Rainbow', True)
        v = GetActiveView(); v.Background = [0.12,0.12,0.15]
        v.CameraViewUp = [0,0,1]
        ResetCamera()
        setup_em._data = (r,)
    # Rotate camera
    import math
    angle = frame * 360.0 / total
    rad = math.radians(angle)
    r = 0.2
    GetActiveView().CameraPosition = [r*math.sin(rad), -r*math.cos(rad), 0.15]
    GetActiveView().CameraFocalPoint = [0, 0.025, 0]

# ─── 场景 5: 声学压力场 (旋转) ─────────────────────
def setup_acoustic(frame, total):
    if frame == 0:
        r = ExodusIIReader(FileName=[str(OUTPUTS / "acoustic_cavity.e")])
        r.PointVariables = ['pressure_real', 'pressure_imag']
        c = Calculator(Input=r)
        c.AttributeType = 'Point Data'; c.ResultArrayName = 'pmag'
        c.Function = '(pressure_real^2 + pressure_imag^2)^0.5'
        d = Show(c)
        ColorBy(d, ('POINTS', 'pmag'))
        GetColorTransferFunction('pmag').ApplyPreset('erdc_rainbow_bright', True)
        v = GetActiveView(); v.Background = [0.12,0.12,0.15]
        v.CameraViewUp = [0,1,0]
        ResetCamera()
        setup_acoustic._data = (r, c)
    # Rotate camera
    import math
    angle = frame * 360.0 / total
    rad = math.radians(angle)
    r = 0.6
    GetActiveView().CameraPosition = [0.25 + r*math.sin(rad), -r*math.cos(rad), 0.4]
    GetActiveView().CameraFocalPoint = [0.25, 0.125, 0]


if __name__ == "__main__":
    print("=" * 60)
    print("  红创科技多物理场仿真平台 — 动画渲染")
    print("=" * 60)
    print()
    
    scenes = [
        ("beam_loading",  "悬臂梁渐变加载 [0→10kPa]",  setup_beam_transient, 60, 15),
        ("beam_cyclic",   "悬臂梁循环载荷 [正弦]",      setup_beam_cyclic,   60, 15),
        ("contact",       "接触力学演化 [10步]",        setup_contact,       30, 10),
        ("electrostatic", "静电电位场 [360°旋转]",      setup_em,            90, 15),
        ("acoustic",      "声学压力场 [360°旋转]",      setup_acoustic,      90, 15),
    ]
    
    for name, title, setup_fn, n_frames, fps in scenes:
        # Check file exists
        if name.startswith("beam"):
            base = "cantilever_beam_transient.e" if "loading" in name else "cantilever_beam_cyclic.e"
        elif name == "contact":
            base = "contact_2d.e"
        elif name == "electrostatic":
            base = "electrostatic_steel_concrete.e"
        elif name == "acoustic":
            base = "acoustic_cavity.e"
        
        if not (OUTPUTS / base).exists():
            print(f"  [跳过] {base} 不存在")
            continue
        
        print(f"[{title}]")
        render_frames(setup_fn, name, n_frames, fps, rotate=False)
        print()
    
    print(f"\n✓ 全部完成 → {RENDERS}/")
    for f in sorted(RENDERS.glob("*.mp4")):
        size_mb = f.stat().st_size / 1e6
        print(f"  {f.name}  ({size_mb:.1f} MB)")
