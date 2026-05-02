#!/usr/bin/env python3
"""红创科技 — 仿真动画渲染 V2 (固定问题: 分辨率 + 帧更新)"""
from pathlib import Path
from paraview.simple import *
import os
import subprocess

ROOT = Path(__file__).parent
OUTPUTS = ROOT / "outputs"
RENDERS = ROOT / "renders"
RENDERS.mkdir(exist_ok=True)

W, H = 1280, 720

def new_view(pos, focal, up=(0,0,1)):
    """Create a clean view with proper size"""
    layout = CreateLayout("Layout")
    v = CreateView("RenderView")
    v.ViewSize = [W, H]
    v.Background = [0.12, 0.12, 0.15]
    v.OrientationAxesVisibility = 0
    v.CameraPosition = pos
    v.CameraFocalPoint = focal
    v.CameraViewUp = up
    return v

def render_exodus(exodus_file, name, vars_list, warp_var, scale,
                  pos, focal, up=(0,0,1), n_cycles=4, fps=15, color_var=None, warp_scale=None):
    d = RENDERS / name
    d.mkdir(exist_ok=True)
    
    r = ExodusIIReader(FileName=[str(exodus_file)])
    r.PointVariables = vars_list
    r.UpdatePipeline()
    ts = r.TimestepValues
    n_ts = len(ts)
    print(f"  [{name}] timesteps={n_ts} range=[{ts[0]:.2f}, {ts[-1]:.2f}]")
    
    # Create pipeline for each frame fresh to ensure update
    v = new_view(pos, focal, up)
    
    # Warp + color
    w = WarpByVector(Input=r)
    w.Vectors = ['POINTS', warp_var]
    w.ScaleFactor = warp_scale or scale
    dsp = Show(w, v)
    dsp.Representation = 'Surface With Edges'
    
    cv = color_var or warp_var
    ColorBy(dsp, ('POINTS', cv))
    try:
        GetColorTransferFunction(cv).ApplyPreset('Cool to Warm (Extended)', True)
    except:
        pass
    
    Render(v)
    ResetCamera(v)
    
    # Render frames by seeking to each timestep
    anim = GetAnimationScene()
    total = n_ts * n_cycles
    
    for i in range(total):
        t = ts[i % n_ts]
        anim.AnimationTime = t
        
        # Force pipeline update
        r.UpdatePipeline()
        w.UpdatePipeline()
        
        Render(v)
        fpath = str(d / f"f{i:04d}.png")
        SaveScreenshot(fpath, v, ImageResolution=[W, H])
        
        if i == 0 or i == total-1 or i % max(1, total//5) == 0:
            print(f"    {i+1}/{total} t={t:.2f}")
    
    print(f"  → {total} frames")
    
    # Verify frames differ
    import subprocess
    sizes = sorted([os.stat(str(p)).st_size for p in d.glob("*.png")])
    unique = len(set(sizes))
    print(f"  → {unique} unique frame sizes (of {total})")
    
    # MP4
    mp4 = RENDERS / f"{name}.mp4"
    subprocess.run([
        "ffmpeg", "-y", "-framerate", str(fps),
        "-i", str(d / "f%04d.png"),
        "-c:v", "libx264", "-pix_fmt", "yuv420p",
        str(mp4)
    ], capture_output=True)
    
    if mp4.exists():
        print(f"  → {name}.mp4 ({mp4.stat().st_size/1e6:.1f} MB)")
    else:
        print(f"  ✗ MP4 failed")

    # Cleanup
    Delete(r)
    Delete(v)
    for x in GetSources().values():
        Delete(x)


if __name__ == "__main__":
    import sys
    scene = sys.argv[1] if len(sys.argv) > 1 else "all"
    
    print("=" * 60)
    print("  红创科技仿真动画渲染 V2")
    print("=" * 60)
    
    base = OUTPUTS
    
    if scene in ("all", "beam"):
        print("\n[悬臂梁渐变加载]")
        render_exodus(
            base / "cantilever_beam_transient.e", "beam_loading",
            ['disp_x','disp_y','disp_z'], 'disp_z', 50,
            [0.3, -1.2, 0.4], [0.5, 0.05, 0.1],
            n_cycles=5, fps=15, warp_scale=500,
        )
    
    if scene in ("all", "cyclic"):
        print("\n[悬臂梁循环载荷]")
        render_exodus(
            base / "cantilever_beam_cyclic.e", "beam_cyclic",
            ['disp_x','disp_y','disp_z'], 'disp_z', 60,
            [0.3, -1.2, 0.4], [0.5, 0.05, 0.1],
            n_cycles=3, fps=15, warp_scale=600,
        )
    
    if scene in ("all", "contact"):
        print("\n[接触力学]")
        render_exodus(
            base / "contact_2d.e", "contact",
            ['disp_x','disp_y'], 'disp_x', 1.0,
            [0.5, -1.0, 2.0], [0.5, 0.5, 0], up=[0,1,0],
            n_cycles=5, fps=10,
        )
    
    if scene in ("all", "em"):
        print("\n[静电电位场 — 旋转相机]")
        d = RENDERS / "electrostatic"
        d.mkdir(exist_ok=True)
        
        r = ExodusIIReader(FileName=[str(base / "electrostatic_steel_concrete.e")])
        r.PointVariables = ['potential']
        r.UpdatePipeline()
        
        v = new_view([0, -0.15, 0.2], [0, 0.025, 0])
        dsp = Show(r, v)
        ColorBy(dsp, ('POINTS', 'potential'))
        GetColorTransferFunction('potential').ApplyPreset('Blue to Red Rainbow', True)
        Render(v); ResetCamera(v)
        
        import math
        n = 90
        for i in range(n):
            angle = i * 360.0 / n
            rad = math.radians(angle)
            rr = 0.2
            v.CameraPosition = [rr*math.sin(rad), -rr*math.cos(rad), 0.15]
            v.CameraFocalPoint = [0, 0.025, 0]
            Render(v)
            SaveScreenshot(str(d / f"f{i:04d}.png"), v, ImageResolution=[W, H])
            if i % 20 == 0:
                print(f"    {i+1}/{n}")
        
        subprocess.run([
            "ffmpeg", "-y", "-framerate", "15",
            "-i", str(d / "f%04d.png"),
            "-c:v", "libx264", "-pix_fmt", "yuv420p",
            str(RENDERS / "electrostatic.mp4")
        ], capture_output=True)
        print(f"  → {n} frames → electrostatic.mp4")
        Delete(r); Delete(v)
    
    if scene in ("all", "acoustic"):
        print("\n[声学压力场 — 旋转相机]")
        d = RENDERS / "acoustic"
        d.mkdir(exist_ok=True)
        
        r = ExodusIIReader(FileName=[str(base / "acoustic_cavity.e")])
        r.PointVariables = ['pressure_real', 'pressure_imag']
        r.UpdatePipeline()
        
        c = Calculator(Input=r)
        c.AttributeType = 'Point Data'
        c.ResultArrayName = 'pmag'
        c.Function = '(pressure_real^2 + pressure_imag^2)^0.5'
        c.UpdatePipeline()
        
        v = new_view([0.25, -0.6, 0.5], [0.25, 0.125, 0], up=[0,1,0])
        dsp = Show(c, v)
        ColorBy(dsp, ('POINTS', 'pmag'))
        GetColorTransferFunction('pmag').ApplyPreset('erdc_rainbow_bright', True)
        Render(v); ResetCamera(v)
        
        import math
        n = 90
        for i in range(n):
            angle = i * 360.0 / n
            rad = math.radians(angle)
            rr = 0.6
            v.CameraPosition = [0.25 + rr*math.sin(rad), -rr*math.cos(rad), 0.4]
            v.CameraFocalPoint = [0.25, 0.125, 0]
            Render(v)
            SaveScreenshot(str(d / f"f{i:04d}.png"), v, ImageResolution=[W, H])
            if i % 20 == 0:
                print(f"    {i+1}/{n}")
        
        subprocess.run([
            "ffmpeg", "-y", "-framerate", "15",
            "-i", str(d / "f%04d.png"),
            "-c:v", "libx264", "-pix_fmt", "yuv420p",
            str(RENDERS / "acoustic.mp4")
        ], capture_output=True)
        print(f"  → {n} frames → acoustic.mp4")
        Delete(r); Delete(v)
    
    print(f"\n✓ 完成: {RENDERS}/")
    for f in sorted(RENDERS.glob("*.mp4")):
        print(f"  {f.name} ({f.stat().st_size/1e6:.1f} MB)")
