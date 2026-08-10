#!/usr/bin/env python3
"""render_pr_rg_400gal_x.py — PR-RG-400gal-X 梁模型地震响应渲染 (pvpython)

红创科技多物理场仿真平台 / 后处理

从 MOOSE 求解结果 (pr_rg_400gal_x_out.e) 生成地震时程分析视频:
  梁结构变形动画 (WarpByVector, 自动放大倍数) + 位移幅值云图

用法:
  pvpython tools/render_pr_rg_400gal_x.py [result.e] [warp_scale]
输出:
  renders/pr_rg_400gal_x_rel.mp4
"""

import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUTDIR = ROOT / "outputs" / "pr_rg_400gal_x"
RENDERS = ROOT / "renders"
RENDERS.mkdir(exist_ok=True)

RESULT = sys.argv[1] if len(sys.argv) > 1 else str(OUTDIR / "pr_rg_400gal_x_out.e")

FPS = 25
SUBSAMPLE = 33          # 抽帧 (系统高负载, 减帧)
RES = [1280, 720]
HEIGHT = 17360.0        # 结构高度 (mm)

# 自动估算变形放大倍数: 峰值位移 → 结构高度的 ~8%
import netCDF4  # noqa: E402
import numpy as np  # noqa: E402

_nc = netCDF4.Dataset(RESULT)
_nn = _nc.variables['name_nod_var']
_names = [_nn[i].tobytes().decode().strip('\x00 ') for i in range(_nn.shape[0])]
_i = {n: k + 1 for k, n in enumerate(_names)}
_dx = _nc.variables[f"vals_nod_var{_i['disp_x']}"][:]
_dy = _nc.variables[f"vals_nod_var{_i['disp_y']}"][:]
_dz = _nc.variables[f"vals_nod_var{_i['disp_z']}"][:]
_mag = np.sqrt(_dx ** 2 + _dy ** 2 + _dz ** 2)
MAX_DISP = float(_mag[::SUBSAMPLE].max())
_nc.close()
WARP = float(sys.argv[2]) if len(sys.argv) > 2 else 0.08 * HEIGHT / max(MAX_DISP, 1e-12)
CLR_MAX = float(sys.argv[3]) if len(sys.argv) > 3 else MAX_DISP
print(f"[info] max|disp| = {MAX_DISP:.3f} mm, warp scale = {WARP:.1f}")

from paraview.simple import *  # noqa: E402

CX, CY, CZ = 0.0, 0.0, HEIGHT / 2


def main():
    r = ExodusIIReader(FileName=[RESULT])
    r.PointVariables = ['disp_']
    r.ElementBlocks = list(r.ElementBlocks.Available)

    warp = WarpByVector(Input=r)
    warp.Vectors = ['POINTS', 'disp_']
    warp.ScaleFactor = WARP

    d = Show(warp)                 # Tube 过滤器在此环境崩溃 → 线框加粗
    d.Representation = 'Wireframe'
    d.LineWidth = 3.0
    ColorBy(d, ('POINTS', 'disp_'))
    lut = GetColorTransferFunction('disp_')
    lut.ApplyPreset('Cool to Warm (Extended)', True)
    lut.RescaleTransferFunction(0.0, CLR_MAX)

    v = GetActiveView()
    v.Background = [0.10, 0.10, 0.13]
    v.CameraPosition = [14000.0, -19000.0, 11000.0]
    v.CameraFocalPoint = [CX, CY, CZ]
    v.CameraViewUp = [0, 0, 1]
    v.OrientationAxesVisibility = 0

    sb = GetScalarBar(lut, v)
    sb.Title = '|disp| (mm)'
    sb.ComponentTitle = ''
    sb.Visibility = 1

    txt = Text()
    txt.Text = 'PR-RG-400gal-X | reactor-insulator beam model | 400gal RG spectrum X-dir'
    td = Show(txt, v)
    td.FontSize = 18
    td.Color = [0.9, 0.9, 0.9]
    td.WindowLocation = 'Upper Center'

    ttxt = Text()
    ttxt.Text = 't = 0.00 s'
    ttd = Show(ttxt, v)
    ttd.FontSize = 16
    ttd.Color = [0.8, 0.8, 0.8]
    ttd.WindowLocation = 'Upper Left Corner'

    ts = list(r.TimestepValues)[::SUBSAMPLE]
    n = len(ts)
    print(f"[render] {n} frames")

    outdir = RENDERS / 'pr_rg_400gal_x_rel'
    outdir.mkdir(exist_ok=True)
    anim = GetAnimationScene()
    anim.PlayMode = 'Sequence'
    for i, t in enumerate(ts):
        anim.AnimationTime = float(t)
        ttxt.Text = f't = {t:.2f} s'
        Render()
        SaveScreenshot(str(outdir / f"f{i:04d}.png"), v, ImageResolution=RES)
        if i % max(1, n // 5) == 0:
            print(f"  {i + 1}/{n}")
    mp4 = RENDERS / 'pr_rg_400gal_x_rel.mp4'
    os.system(f'ffmpeg -y -framerate {FPS} -i "{outdir}/f%04d.png" '
              f'-c:v libx264 -pix_fmt yuv420p "{mp4}" 2>/dev/null')
    if mp4.exists():
        print(f"  ✓ {mp4.name} ({mp4.stat().st_size / 1e6:.1f} MB)")


if __name__ == '__main__':
    main()
    print("完成 ✓")
