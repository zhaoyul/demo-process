#!/usr/bin/env python3
"""render_abaqus_8elc.py — Abaqus 8elc 转换算例渲染 (pvpython)

红创科技多物理场仿真平台 / 后处理

从 MOOSE 求解结果 (abaqus_8elc_out.e) 生成地震响应分析视频:
  场景 1: von Mises 应力云图 + 变形动画
  场景 2: 加速度幅值云图 + 变形动画 (基底三向 El Centro 激励)
钢筋骨架 (rebar_result.e: 原始直线几何 + 宿主插值位移 + 弹塑性应力) 叠加显示。

用法:
  pvpython tools/render_abaqus_8elc.py [result.e]
输出:
  renders/abaqus_8elc_vonmises.mp4
  renders/abaqus_8elc_accel.mp4
"""

import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent  # 本脚本位于 tools/, ROOT 为 repo 根
OUTDIR = ROOT / "outputs" / "abaqus_8elc"
RENDERS = ROOT / "renders"
RENDERS.mkdir(exist_ok=True)

RESULT = sys.argv[1] if len(sys.argv) > 1 else str(OUTDIR / "abaqus_8elc_out_rel.e")
# 相对位移版 (tools/make_relative_disp.py): 去刚体地面运动, 结构原地不振出画面
REBAR_RESULT = str(OUTDIR / "rebar_result_rel.e")

from paraview.simple import *

# 结构 bbox (mm): x∈[-220,2380] y∈[-220,3780] z∈[0,4145] (report.json)
CX, CY, CZ = 1080.0, 1780.0, 2072.0
WARP_SCALE = 50.0   # 地震位移小, 放大 50 倍
FPS = 20
RES = [1600, 900]
FRAME_STRIDE = 4    # 801 步 → 201 帧/视频

SOLID_BLOCKS = ['paijia__con', 'caoshen_dangkuai__con', 'gangliang__steel']

# rebar_result.e 中的 10 个钢筋块 (文档用; 读取时不过滤)
TRUSS_BLOCKS = [
    'caoshen_jin_all__steel_A154', 'caoshen_jin_all__steel_A50',
    'dangkuai_jin__steel_A3', 'dangkuai_jin__steel_A50',
    'gailiang_jin__steel_A3', 'gailiang_jin__steel_A50',
    'lianxiliang_jin__steel_A3', 'lianxiliang_jin__steel_A50',
    'zhu_jin__steel_A3', 'zhu_jin__steel_A50',
]


def make_scene(field, preset, rng, name, rebar=True, kind='CELLS'):
    """构建场景: 变形体着色 + 钢筋骨架叠加, 返回 (帧数, 时间序列)"""
    r = ExodusIIReader(FileName=[RESULT])
    r.PointVariables = ['disp_', 'vel_', 'accel_']
    r.ElementVariables = ['vonmises']
    r.ElementBlocks = SOLID_BLOCKS

    warp = WarpByVector(Input=r)
    warp.Vectors = ['POINTS', 'disp_']
    warp.ScaleFactor = WARP_SCALE

    d = Show(warp)
    d.Representation = 'Surface With Edges'
    d.EdgeColor = [0.2, 0.2, 0.2]
    d.Opacity = 0.55  # 让内部钢筋应力云清晰可见
    ColorBy(d, (kind, field))
    lut = GetColorTransferFunction(field)
    lut.ApplyPreset(preset, True)
    lut.RescaleTransferFunction(rng[0], rng[1])

    # 钢筋骨架: rebar_result.e, 按 truss_stress 着色 (弹塑性, 0-450 MPa)
    if rebar:
        rt = ExodusIIReader(FileName=[REBAR_RESULT])
        rt.PointVariables = ['disp_']
        rt.ElementVariables = ['truss_stress']
        wt = WarpByVector(Input=rt)
        wt.Vectors = ['POINTS', 'disp_']
        wt.ScaleFactor = WARP_SCALE
        dm = Show(wt)
        dm.Representation = 'Wireframe'
        dm.LineWidth = 4.0
        ColorBy(dm, ('CELLS', 'truss_stress'))
        rlut = GetColorTransferFunction('truss_stress')
        rlut.ApplyPreset('Cool to Warm (Extended)', True)
        rlut.RescaleTransferFunction(0.0, 450.0)

    v = GetActiveView()
    v.Background = [0.10, 0.10, 0.13]
    # 3/4 视角: 结构竖向为 z
    v.CameraPosition = [CX + 5200.0, CY - 7200.0, CZ + 2600.0]
    v.CameraFocalPoint = [CX, CY, CZ]
    v.CameraViewUp = [0, 0, 1]
    v.OrientationAxesVisibility = 0

    sb = GetScalarBar(lut, v)
    sb.Title = field
    sb.ComponentTitle = ''
    sb.Visibility = 1

    txt = Text()
    txt.Text = 'Abaqus 8elc -> MOOSE | bent frame seismic response (El Centro 3-comp)'
    td = Show(txt, v)
    td.FontSize = 18
    td.Color = [0.9, 0.9, 0.9]
    td.WindowLocation = 'Upper Center'

    anim = GetAnimationScene()
    anim.PlayMode = 'Sequence'
    ts = r.TimestepValues
    anim.NumberOfFrames = len(ts)
    return ts


def render(name, field, preset, rng, kind='CELLS'):
    print(f"[render] {name}: field={field}")
    ts = make_scene(field, preset, rng, name, kind=kind)
    d = RENDERS / name
    d.mkdir(exist_ok=True)
    anim = GetAnimationScene()
    frames = list(range(0, len(ts), FRAME_STRIDE))
    for j, i in enumerate(frames):
        anim.AnimationTime = float(ts[i])
        Render()
        SaveScreenshot(str(d / f"f{j:04d}.png"), GetActiveView(),
                       ImageResolution=RES)
        if j % max(1, len(frames) // 5) == 0:
            print(f"  {name}: {j + 1}/{len(frames)}")
    mp4 = RENDERS / f"{name}.mp4"
    os.system(f'ffmpeg -y -framerate {FPS} -i "{d}/f%04d.png" '
              f'-c:v libx264 -pix_fmt yuv420p "{mp4}" 2>/dev/null')
    if mp4.exists():
        print(f"  ✓ {mp4.name} ({mp4.stat().st_size / 1e6:.1f} MB)")
    for src in GetSources().values():
        Delete(src)
    ResetSession()


if __name__ == '__main__':
    render('abaqus_8elc_vonmises', 'vonmises', 'Cool to Warm (Extended)',
           (0.0, 10.0))
    render('abaqus_8elc_accel', 'accel_', 'Cool to Warm (Extended)',
           (0.0, 8000.0), kind='POINTS')
    print("全部完成 ✓")
