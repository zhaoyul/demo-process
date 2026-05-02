#!/usr/bin/env python3
"""Fixed beam animation using Exodus timesteps"""
from pathlib import Path
from paraview.simple import *

ROOT = Path(__file__).parent
OUTPUTS = ROOT / "outputs"
RENDERS = ROOT / "renders"

def render_exodus_anim(exodus_file, name, warp_var='disp_z', scale=50.0,
                       pos=[0.3,-1.2,0.4], focal=[0.5,0.05,0.1], up=[0,0,1],
                       fps=15, n_cycles=5, point_vars=None):
    d = RENDERS / name
    d.mkdir(exist_ok=True)
    
    r = ExodusIIReader(FileName=[exodus_file])
    if point_vars:
        r.PointVariables = point_vars
    else:
        r.PointVariables = ['disp_x','disp_y','disp_z']
    r.UpdatePipeline()
    ts = r.TimestepValues
    n_ts = len(ts)
    print(f"  Time steps: {n_ts}, range: [{ts[0]:.1f}, {ts[-1]:.1f}]")
    
    w = WarpByVector(Input=r)
    w.Vectors = ['POINTS', warp_var]
    w.ScaleFactor = scale
    dsp = Show(w)
    dsp.Representation = 'Surface With Edges'
    ColorBy(dsp, ('POINTS', warp_var))
    GetColorTransferFunction(warp_var).ApplyPreset('Cool to Warm (Extended)', True)
    
    v = GetActiveView()
    v.Background = [0.12,0.12,0.15]
    v.CameraPosition = pos; v.CameraFocalPoint = focal; v.CameraViewUp = up
    Render(); ResetCamera()
    
    total_frames = n_ts * n_cycles
    for i in range(total_frames):
        t = ts[i % n_ts]
        anim = GetAnimationScene()
        anim.AnimationTime = t
        anim.UpdateAnimationUsingDataTimeSteps()
        Render()
        SaveScreenshot(str(d / f"f{i:04d}.png"), v, ImageResolution=[1280, 720])
        if i % max(1, total_frames//10) == 0:
            print(f"    Frame {i+1}/{total_frames} (t={t:.2f})")
    
    print(f"  -> {name}/ ({total_frames} frames)")
    
    import os
    mp4 = RENDERS / f"{name}.mp4"
    os.system(f'ffmpeg -y -framerate {fps} -i "{d}/f%04d.png" -c:v libx264 -pix_fmt yuv420p "{mp4}" 2>/dev/null')
    if mp4.exists():
        print(f"  -> {name}.mp4 ({mp4.stat().st_size/1e6:.1f} MB)")

if __name__ == "__main__":
    print("=" * 60)
    print("  仿真变形动画渲染")
    print("=" * 60)
    base = str(OUTPUTS)
    render_exodus_anim(f"{base}/cantilever_beam_transient.e", "beam_loading", scale=50, n_cycles=5)
    print()
    render_exodus_anim(f"{base}/cantilever_beam_cyclic.e", "beam_cyclic", scale=60, n_cycles=3)
    print()
    render_exodus_anim(f"{base}/contact_2d.e", "contact", warp_var='disp_x', scale=1.0,
                       n_cycles=5, fps=10, pos=[0.5,-1,2], focal=[0.5,0.5,0], up=[0,1,0])
    print(f"\nDone: {RENDERS}/")
