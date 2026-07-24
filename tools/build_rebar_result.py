#!/usr/bin/env python3
"""build_rebar_result.py — 钢筋结果重构 (v3)

将 MOOSE 结果中的钢筋数据“回弹”到原始直线几何:
  v2 求解把钢筋节点缝合到最近实体节点 (获得正确位移耦合与应力),
  但网格里钢筋位置被拉弯。本工具按 rebar_render_map.json 把每个钢筋
  单元画回原始直线位置, 位移/应力取缝合对应节点的求解结果。

输入:
  outputs/abaqus_6_15/abaqus_6_15_out.e     MOOSE 结果 (含 truss_stress)
  outputs/abaqus_6_15/rebar_render_map.json 转换器导出的渲染映射
输出:
  outputs/abaqus_6_15/rebar_result.e        原始几何 + 位移/应力场

用法: ~/miniforge3/envs/moose/bin/python tools/build_rebar_result.py
"""

import json
import sys
from pathlib import Path

import netCDF4
import numpy as np

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "outputs" / "abaqus_6_15"


def main():
    res_path = OUT / "abaqus_6_15_out.e"
    map_path = OUT / "rebar_render_map.json"
    dst_path = OUT / "rebar_result.e"

    rmap = json.load(open(map_path))
    nc = netCDF4.Dataset(str(res_path))

    times = nc.variables['time_whole'][:].data
    nt = len(times)
    print(f"结果时间步: {nt}")

    # --- nodal 位移 (MOOSE 输出 disp_x/y/z 为前三个 nodal var) ---
    nod_names = [''.join(c for c in row.astype('U1') if c).strip()
                 for row in nc.variables['name_nod_var'][:]]
    idx = {n: i + 1 for i, n in enumerate(nod_names)}
    print("nodal vars:", nod_names)
    disp = {}
    for comp in ('disp_x', 'disp_y', 'disp_z'):
        disp[comp] = nc.variables[f"vals_nod_var{idx[comp]}"][:].data  # (nt, nn)

    # --- 元素块信息: 输出 .e 的块顺序与输入网格一致 ---
    eb_names = [''.join(c for c in row.astype('U1') if c).strip()
                for row in nc.variables['eb_names'][:]]
    elem_names = [''.join(c for c in row.astype('U1') if c).strip()
                  for row in nc.variables['name_elem_var'][:]]
    print("elem vars:", elem_names)
    stress_var = elem_names.index('truss_stress') + 1 if 'truss_stress' in elem_names else None

    # --- 重构节点表: 渲染映射中的最终节点 (缝合后网格节点) ---
    # 新网格: 每个原始钢筋单元的两端点 (原始坐标); 位移取最终节点
    new_nodes = []       # (x, y, z) 原始坐标
    node_disp_ids = []   # 对应结果 .e 的节点 id (1-based)
    new_node_index = {}  # (orig rounded xyz, final id) -> new id
    new_elems = []       # (block_name, [n1, n2])
    block_of = {}

    def add_node(orig_pt, final_id):
        key = (round(orig_pt[0], 3), round(orig_pt[1], 3),
               round(orig_pt[2], 3), final_id)
        if key in new_node_index:
            return new_node_index[key]
        new_nodes.append(orig_pt)
        node_disp_ids.append(final_id)
        new_node_index[key] = len(new_nodes)
        return len(new_nodes)

    # 实体包围盒 (+10mm 余量), 裁剪伸出混凝土的钢筋端头
    solid_blocks = {'kuang__C40', 'kuang__M60', 'DD_gujiangliao__M60',
                    'BB_qikuai__aac705'}
    sc = []
    for v in nc.variables:
        if v.startswith('connect'):
            bi_ = int(v.replace('connect', ''))
            if eb_names[bi_ - 1] in solid_blocks:
                sc.append(nc.variables[v][:].data.ravel())
    sn = np.unique(np.concatenate(sc))
    cx = nc.variables['coordx'][:].data
    cy = nc.variables['coordy'][:].data
    cz = nc.variables['coordz'][:].data
    bb_min = np.array([cx[sn - 1].min(), cy[sn - 1].min(), cz[sn - 1].min()]) - 10
    bb_max = np.array([cx[sn - 1].max(), cy[sn - 1].max(), cz[sn - 1].max()]) + 10

    def inside(pt):
        p = np.array(pt)
        return bool(((p >= bb_min) & (p <= bb_max)).all())

    for blk in rmap['blocks']:
        bname = blk['name']
        for eidx, el in enumerate(blk['elements']):
            if not (inside(el['p0']) and inside(el['p1'])):
                continue  # 伸出混凝土的钢筋段不显示
            n1 = add_node(el['p0'], el['n'][0])
            n2 = add_node(el['p1'], el['n'][1])
            new_elems.append((bname, [n1, n2], eidx))  # eidx = 块内序号(应力对齐)
            block_of[bname] = True

    print(f"重构: {len(new_nodes)} 节点, {len(new_elems)} 单元, "
          f"{len(block_of)} 块")

    # --- 每块应力数据 (结果 .e 中 truss 块的 truss_stress) ---
    # 输出块 eb 索引 (1-based) 按名称匹配; 块内元素顺序与输入一致
    stress_by_block_eid = {}   # (bname, 输入块内序号) -> np.array (nt)
    for bname in block_of:
        eb = eb_names.index(bname) + 1
        if stress_var is None:
            break
        var = f"vals_elem_var{stress_var}eb{eb}"
        if var in nc.variables:
            stress_by_block_eid[bname] = nc.variables[var][:].data  # (nt, ne_blk)
    if stress_var is None:
        print("WARN: 结果中无 truss_stress, 应力列置零")

    # --- 写 Exodus ---
    ds = netCDF4.Dataset(str(dst_path), 'w', format='NETCDF4')
    blocks_out = {}
    for bname, _, _ in new_elems:
        blocks_out.setdefault(bname, [])
    for e in new_elems:
        blocks_out[e[0]].append(e)
    blk_list = sorted(blocks_out)

    nn = len(new_nodes)
    ne = len(new_elems)
    ds.createDimension('len_name', 256)
    ds.createDimension('len_line', 81)
    ds.createDimension('four', 4)
    ds.createDimension('time_step', None)
    ds.createDimension('num_dim', 3)
    ds.createDimension('num_nodes', nn)
    ds.createDimension('num_elem', ne)
    ds.createDimension('num_el_blk', len(blk_list))
    ds.createDimension('num_node_sets', 0)
    ds.createDimension('num_side_sets', 0)
    ds.setncattr('api_version', np.float32(8.11))
    ds.setncattr('version', np.float32(8.11))
    ds.setncattr('floating_point_word_size', np.int32(8))
    ds.setncattr('file_size', np.int32(1))
    ds.setncattr('maximum_name_length', np.int32(32))
    ds.setncattr('int64_status', np.int32(0))
    ds.setncattr('title', 'rebar_result (original geometry)')

    vt = ds.createVariable('time_whole', 'f8', ('time_step',))
    vt[:] = times

    coords = np.array(new_nodes, dtype='f8')
    for d, vn in enumerate(('coordx', 'coordy', 'coordz')):
        v = ds.createVariable(vn, 'f8', ('num_nodes',))
        v[:] = coords[:, d]
    v = ds.createVariable('coor_names', 'S1', ('num_dim', 'len_name'))
    for d, nm in enumerate(('x', 'y', 'z')):
        v[d, 0] = np.frombuffer(nm.encode(), dtype='S1')[0]

    ds.createVariable('node_num_map', 'i4', ('num_nodes',))[:] = \
        np.arange(1, nn + 1)
    ds.createVariable('elem_num_map', 'i4', ('num_elem',))[:] = \
        np.arange(1, ne + 1)

    ds.createVariable('eb_status', 'i4', ('num_el_blk',))[:] = 1
    vebp = ds.createVariable('eb_prop1', 'i4', ('num_el_blk',))
    vebp.setncattr('name', 'ID')
    vebp[:] = np.arange(1, len(blk_list) + 1)

    vbn = ds.createVariable('eb_names', 'S1', ('num_el_blk', 'len_name'))
    for i, nm in enumerate(blk_list):
        b = nm.encode()[:255]
        vbn[i, :len(b)] = list(np.frombuffer(b, dtype='S1'))

    for bi, bname in enumerate(blk_list, start=1):
        elems = blocks_out[bname]
        ds.createDimension(f'num_el_in_blk{bi}', len(elems))
        ds.createDimension(f'num_nod_per_el{bi}', 2)
        vc = ds.createVariable(f'connect{bi}', 'i4',
                               (f'num_el_in_blk{bi}', f'num_nod_per_el{bi}'))
        vc.setncattr('elem_type', 'TRUSS')
        vc[:] = np.array([e[1] for e in elems], dtype='i4')

    # nodal 位移变量 (3)
    ds.createDimension('num_nod_var', 3)
    vnv = ds.createVariable('name_nod_var', 'S1', ('num_nod_var', 'len_name'))
    for i, nm in enumerate(('disp_x', 'disp_y', 'disp_z')):
        b = nm.encode()
        vnv[i, :len(b)] = list(np.frombuffer(b, dtype='S1'))
    disp_ids = np.array(node_disp_ids)
    for i, comp in enumerate(('disp_x', 'disp_y', 'disp_z'), start=1):
        v = ds.createVariable(f'vals_nod_var{i}', 'f8',
                              ('time_step', 'num_nodes'))
        v[:] = disp[comp][:, disp_ids - 1]

    # elemental 应力变量 (1): truss_stress
    ds.createDimension('num_elem_var', 1)
    vev = ds.createVariable('name_elem_var', 'S1', ('num_elem_var', 'len_name'))
    b = b'truss_stress'
    vev[0, :len(b)] = list(np.frombuffer(b, dtype='S1'))
    for bi, bname in enumerate(blk_list, start=1):
        elems = blocks_out[bname]
        v = ds.createVariable(f'vals_elem_var1eb{bi}', 'f8',
                              ('time_step', f'num_el_in_blk{bi}'))
        src = stress_by_block_eid.get(bname)
        if src is None:
            v[:] = 0.0
        else:
            # 应力按渲染映射块内序号对齐 (裁剪后顺序可能不连续)
            idxs = np.array([e[2] for e in elems])
            v[:] = src[:, idxs]

    ds.close()
    nc.close()
    print(f"✓ 写出 {dst_path}")


if __name__ == '__main__':
    main()
