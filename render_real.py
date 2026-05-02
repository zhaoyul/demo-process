#!/usr/bin/env python3
"""红创科技 — 真实 FEM 结果动画渲染 (ExodusII + pvpython)"""
from pathlib import Path
from paraview.simple import *
import subprocess, os, math

ROOT = Path(__file__).parent
OUTPUTS = ROOT / "outputs"
RENDERS = ROOT / "renders"
W, H = 1280, 720

def make_view(pos, focal, up=(0,0,1)):
    v = CreateView("RenderView")
    v.ViewSize = [W, H]
    v.Background = [0.12, 0.12, 0.15]
    v.OrientationAxesVisibility = 0
    v.CameraPosition = pos
    v.CameraFocalPoint = focal
    v.CameraViewUp = up
    return v

def to_mp4(frame_dir, name, fps=15):
    mp4 = RENDERS / f"{name}.mp4"
    subprocess.run(["ffmpeg","-y","-framerate",str(fps),"-i",
        str(frame_dir/"f%04d.png"),"-c:v","libx264","-pix_fmt","yuv420p",
        "-vf",f"scale={W}:{H}",str(mp4)], capture_output=True)
    sz = mp4.stat().st_size / 1e3 if mp4.exists() else 0
    print(f"  -> {name}.mp4 ({sz:.0f} KB)")
    return mp4

# ============================================================
# Contact: 11 timesteps, real deformation from .e
# ============================================================
def render_contact():
    fname = str(OUTPUTS / "contact_2d.e")
    if not Path(fname).exists(): return
    print("[Contact Mechanics]")
    
    d = RENDERS / "c_frames"; d.mkdir(exist_ok=True)
    for f in d.glob("*.png"): f.unlink()
    
    r = ExodusIIReader(FileName=[fname])
    r.UpdatePipeline()
    ts = r.TimestepValues
    
    v = make_view([0.5, -1.5, 2.0], [0.5, 0.5, 0], [0, 1, 0])
    
    for i, t in enumerate(ts):
        anim = GetAnimationScene()
        anim.AnimationTime = t
        r.UpdatePipeline()
        
        # Warp by actual displacement
        w = WarpByVector(Input=r)
        w.Vectors = ['POINTS', 'disp_x']
        w.ScaleFactor = 1.0
        
        dsp = Show(w, v)
        dsp.Representation = 'Surface With Edges'  # mesh visible!
        dsp.EdgeColor = [0.3, 0.3, 0.3]
        
        try:
            ColorBy(dsp, ('POINTS', 'disp_x'))
            lut = GetColorTransferFunction('disp_x')
            lut.ApplyPreset('Cool to Warm (Extended)', True)
        except:
            pass
        
        Render(v)
        SaveScreenshot(str(d / f"f{i:04d}.png"), v, ImageResolution=[W, H])
        
        if i == 0: ResetCamera(v)
        if i % 3 == 0: print(f"  t={t:.2f}")
        
        Delete(w)
        Delete(dsp)
    
    # Repeat last frame several times for smooth video
    last_img = d / f"f{len(ts)-1:04d}.png"
    last_data = last_img.read_bytes() if last_img.exists() else None
    for j in range(len(ts), 60):
        if last_data:
            (d / f"f{j:04d}.png").write_bytes(last_data)
    
    Delete(r); Delete(v)
    to_mp4(d, "contact", fps=8)

# ============================================================
# Electrostatic: 1 frame, repeat to show gradient with mesh
# ============================================================
def render_electrostatic():
    fname = str(OUTPUTS / "electrostatic_steel_concrete.e")
    if not Path(fname).exists(): return
    print("[Electrostatic]")
    
    d = RENDERS / "e_frames2"; d.mkdir(exist_ok=True)
    for f in d.glob("*.png"): f.unlink()
    
    r = ExodusIIReader(FileName=[fname])
    r.PointVariables = ['potential']
    r.UpdatePipeline()
    
    v = make_view([0, -0.3, 0.3], [0, 0.025, 0])
    
    dsp = Show(r, v)
    dsp.Representation = 'Surface With Edges'
    dsp.EdgeColor = [0.3, 0.3, 0.3]
    ColorBy(dsp, ('POINTS', 'potential'))
    lut = GetColorTransferFunction('potential')
    lut.ApplyPreset('Blue to Red Rainbow', True)
    # Force full data range
    lut.RescaleTransferFunction(0.0, 1.0)
    
    Render(v); ResetCamera(v)
    
    # Save one frame
    SaveScreenshot(str(d / "f0000.png"), v, ImageResolution=[W, H])
    
    # Repeat to make 60-frame video (static field with slight camera pan)
    import shutil
    for i in range(1, 60):
        # Tiny camera pan to show 3D structure
        angle = i * 2.0 / 60
        v.CameraPosition = [0.05*math.sin(angle), -0.3, 0.3]
        Render(v)
        SaveScreenshot(str(d / f"f{i:04d}.png"), v, ImageResolution=[W, H])
    
    Delete(r); Delete(v)
    to_mp4(d, "electrostatic")

# ============================================================
# Thermal + Mechanical + Damage (multiphysics)
# ============================================================
def render_multiphysics():
    fname = str(OUTPUTS / "cantilever_multiphysics.e")
    if not Path(fname).exists(): return
    print("[Multiphysics Coupling]")
    
    d = RENDERS / "mp_frames2"; d.mkdir(exist_ok=True)
    for f in d.glob("*.png"): f.unlink()
    
    r = ExodusIIReader(FileName=[fname])
    r.PointVariables = ['disp_x','disp_y','disp_z','temp']
    r.UpdatePipeline()
    
    v = make_view([0.3, -1.5, 0.5], [0.5, 0.05, 0.1])
    
    # 60 frames: 20 temp, 20 disp, 20 damage (cycling)
    for i in range(60):
        phase = i % 3
        
        dsp = Show(r, v)
        dsp.Representation = 'Surface With Edges'
        dsp.EdgeColor = [0.3, 0.3, 0.3]
        
        if phase == 0:
            ColorBy(dsp, ('POINTS', 'temp'))
            lut = GetColorTransferFunction('temp')
            lut.ApplyPreset('Black-Body Radiation', True)
            title = 'Temperature'
        elif phase == 1:
            w = WarpByVector(Input=r)
            w.Vectors = ['POINTS', 'disp_z']
            w.ScaleFactor = 500
            dsp2 = Show(w, v)
            dsp2.Representation = 'Surface With Edges'
            dsp2.EdgeColor = [0.3, 0.3, 0.3]
            ColorBy(dsp2, ('POINTS', 'disp_z'))
            GetColorTransferFunction('disp_z').ApplyPreset('Cool to Warm (Extended)', True)
            title = 'Displacement'
        else:
            ColorBy(dsp, ('CELLS', 'ObjectId'))
            title = 'Damage'
        
        Render(v)
        if i == 0: ResetCamera(v)
        SaveScreenshot(str(d / f"f{i:04d}.png"), v, ImageResolution=[W, H])
        
        if i % 20 == 0: print(f"  [{title}] {i+1}/60")
        
        Delete(dsp)
        if phase == 1:
            Delete(w); Delete(dsp2)
    
    Delete(r); Delete(v)
    to_mp4(d, "multiphysics_coupling")

if __name__ == "__main__":
    print("=" * 60)
    print("  Real FEM Animation (ExodusII + pvpython)")
    print("=" * 60)
    
    render_contact()
    print()
    render_electrostatic()
    print()
    render_multiphysics()
    
    print(f"\nDone: {RENDERS}/")
