#!/usr/bin/env python3
"""render_abaqus_6_15.py — Abaqus 6-15 转换算例渲染 (pvpython)

红创科技多物理场仿真平台 / 后处理

从 MOOSE 求解结果 (abaqus_6_15_out.e) 生成拟静力试验分析视频:
  场景 1: von Mises 应力云图 + 变形动画 (x15 放大)
  场景 2: 损伤指数云图 + 变形动画 (砌块灰缝开裂演化)
钢筋骨架 (原始网格 TRUSS 块) 叠加显示。

用法:
  pvpython tools/render_abaqus_6_15.py [result.e]
输出:
  renders/abaqus_6_15_vonmises.mp4
  renders/abaqus_6_15_damage.mp4
"""

import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent  # 本脚本位于 tools/, ROOT 为 repo 根
OUTDIR = ROOT / "outputs" / "abaqus_6_15"
RENDERS = ROOT / "renders"
RENDERS.mkdir(exist_ok=True)

RESULT = sys.argv[1] if len(sys.argv) > 1 else str(OUTDIR / "abaqus_6_15_out.e")
MESH = str(OUTDIR / "6-15_mesh.e")   # 钢筋骨架来源

from paraview.simple import *

# 墙中心 (mm): x∈[390,5490] y∈[-3395,205] z∈[13530,13930]
CX, CY, CZ = 2940.0, -1595.0, 13730.0
WARP_SCALE = 15.0
FPS = 10
RES = [1600, 900]


def make_scene(field, preset, rng, name, rebar=True):
    """构建场景: 变形体着色 + 钢筋骨架叠加, 返回更新函数"""
    r = ExodusIIReader(FileName=[RESULT])
    r.PointVariables = ['disp_']
    r.ElementVariables = [field]

    # MOOSE 输出 disp_x/y/z, ExodusIIReader 自动合成为向量 'disp_'
    warp = WarpByVector(Input=r)
    warp.Vectors = ['POINTS', 'disp_']
    warp.ScaleFactor = WARP_SCALE

    d = Show(warp)
    d.Representation = 'Surface With Edges'
    d.EdgeColor = [0.2, 0.2, 0.2]
    d.Opacity = 0.88  # 半透明, 让内部钢筋骨架可见
    ColorBy(d, ('CELLS', field))
    lut = GetColorTransferFunction(field)
    lut.ApplyPreset(preset, True)
    lut.RescaleTransferFunction(rng[0], rng[1])

    # 钢筋骨架: 从原始网格读 TRUSS 块, 同样施加变形场没有意义
    # (钢筋未参与求解, 无位移) — 以半透明线框静态显示轮廓
    if rebar:
        rm = ExodusIIReader(FileName=[MESH])
        # 只显示钢筋块
        rm.ElementBlocks = [
            'AA_dinglaing_gujin__gangjin', 'AA_zongjin_D12__gangjin',
            'AA_zongjin_D16__gangjin', 'CC_diliang_gujin__gangjin',
            'CC_zongjin_D12__gangjin', 'CC_zongjin_D16__gangjin',
            'EE_lianjiegangjin__HPB400', 'Part_23__gangjin',
            'gjwl_1__gangjin', 'zgjl__gangjin']
        dm = Show(rm)
        dm.Representation = 'Wireframe'
        dm.AmbientColor = [0.85, 0.25, 0.15]
        dm.DiffuseColor = [0.85, 0.25, 0.15]
        dm.LineWidth = 2.0
        dm.Opacity = 0.9

    v = GetActiveView()
    v.Background = [0.10, 0.10, 0.13]
    v.CameraPosition = [CX, CY, CZ - 13500.0]
    v.CameraFocalPoint = [CX, CY, CZ]
    v.CameraViewUp = [0, 1, 0]
    v.OrientationAxesVisibility = 0

    # 色标
    sb = GetScalarBar(lut, v)
    sb.Title = field
    sb.ComponentTitle = ''
    sb.Visibility = 1

    # 标题
    txt = Text()
    txt.Text = 'Abaqus 6-15 -> MOOSE | AAC masonry wall pseudo-static test'
    td = Show(txt, v)
    td.FontSize = 18
    td.Color = [0.9, 0.9, 0.9]
    td.WindowLocation = 'Upper Center'

    anim = GetAnimationScene()
    anim.PlayMode = 'Sequence'
    ts = r.TimestepValues
    n = len(ts)
    anim.NumberOfFrames = n

    return n, ts


def render(name, field, preset, rng):
    print(f"[render] {name}: field={field}")
    n, ts = make_scene(field, preset, rng, name)
    d = RENDERS / name
    d.mkdir(exist_ok=True)
    anim = GetAnimationScene()
    for i in range(n):
        anim.AnimationTime = float(ts[i])
        Render()
        SaveScreenshot(str(d / f"f{i:04d}.png"), GetActiveView(),
                       ImageResolution=RES)
        if i % max(1, n // 5) == 0:
            print(f"  {name}: {i + 1}/{n}")
    mp4 = RENDERS / f"{name}.mp4"
    os.system(f'ffmpeg -y -framerate {FPS} -i "{d}/f%04d.png" '
              f'-c:v libx264 -pix_fmt yuv420p "{mp4}" 2>/dev/null')
    if mp4.exists():
        print(f"  ✓ {mp4.name} ({mp4.stat().st_size / 1e6:.1f} MB)")
    # 清理场景, 准备下一场景
    for src in GetSources().values():
        Delete(src)
    ResetSession()


if __name__ == '__main__':
    render('abaqus_6_15_vonmises', 'vonmises', 'Cool to Warm (Extended)',
           (0.0, 15.0), )
    render('abaqus_6_15_damage', 'damage_index', 'Cool to Warm (Extended)',
           (0.0, 0.65), )
    print("全部完成 ✓")
