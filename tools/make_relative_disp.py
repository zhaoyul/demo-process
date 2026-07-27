#!/usr/bin/env python3
"""make_relative_disp.py — 地震结果相对位移化 (去刚体地面运动)

基底加速度激励的结果中, 绝对位移包含地面运动时程 (8elc 基底 x 向达 -440mm),
变形放大渲染时结构飞出画面。本工具生成相对位移版结果:
  disp_rel(x,t) = disp(x,t) - mean(disp(基底节点,t))
基底节点按坐标识别 (z < --base-z)。结构原地振动, 任意 warp 倍数不出画。

用法:
  ~/miniforge3/envs/moose/bin/python tools/make_relative_disp.py \
      outputs/abaqus_8elc/abaqus_8elc_out.e [--base-z 1.0]
  # 生成 *_rel.e; 钢筋结果用 --ref 复用实体结果的基底均值序列:
  ~/miniforge3/envs/moose/bin/python tools/make_relative_disp.py \
      outputs/abaqus_8elc/rebar_result.e --ref outputs/abaqus_8elc/abaqus_8elc_out.e
"""

import argparse
import shutil
import sys

import netCDF4
import numpy as np


def names_of(nc, var):
    return [''.join(c for c in row.astype('U1') if c).strip()
            for row in nc.variables[var][:]]

def base_mean_series(path, base_z):
    nc = netCDF4.Dataset(path)
    z = nc.variables['coordz'][:].data
    mask = z < base_z
    names = names_of(nc, 'name_nod_var')
    idx = {n: i + 1 for i, n in enumerate(names)}
    series = {}
    for comp in ('disp_x', 'disp_y', 'disp_z'):
        v = nc.variables[f'vals_nod_var{idx[comp]}'][:].data
        series[comp] = v[:, mask].mean(axis=1)
    nc.close()
    return series


def make_relative(src, series, dst):
    shutil.copy(src, dst)
    nc = netCDF4.Dataset(dst, 'a')
    names = names_of(nc, 'name_nod_var')
    idx = {n: i + 1 for i, n in enumerate(names)}
    for comp in ('disp_x', 'disp_y', 'disp_z'):
        if comp not in idx:
            continue
        v = nc.variables[f'vals_nod_var{idx[comp]}']
        v[:] = v[:].data - series[comp][:, None]
    nc.close()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('result')
    ap.add_argument('--base-z', type=float, default=1.0)
    ap.add_argument('--ref', help='实体结果 .e (基底均值序列来源, 用于钢筋等无基底节点的文件)')
    ap.add_argument('--out', help='输出路径 (默认 <name>_rel.e)')
    args = ap.parse_args()

    ref = args.ref or args.result
    series = base_mean_series(ref, args.base_z)
    dst = args.out or args.result.replace('.e', '_rel.e')
    make_relative(args.result, series, dst)
    print(f'✓ {dst} (基底均值来自 {ref}, '
          f'x 范围 [{series["disp_x"].min():.1f},{series["disp_x"].max():.1f}] mm)')


if __name__ == '__main__':
    main()
