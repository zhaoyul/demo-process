#!/usr/bin/env python3
"""stitch_interface.py — 界面节点缝合 (等效 Abaqus *Tie adjust=yes, 防翻转)

把 slave nodeset 的节点并入最近的宿主块节点 (改写连接表, slave 变孤儿节点),
带 det(J) 防翻转回滚: 任一相关 hex 角点 det(J) 由正变非正则撤销该合并。

适用: 接触/绑定界面两侧网格非匹配且共面/近距 (tol 内), 如 8elc 的
槽身底面 z=2570 ↔ 排架盖梁顶面, 钢梁底面 z=3945 ↔ 槽身顶面。

与约束法对比: 网格层面绑定, 求解纯线性无阻尼 Newton 1 步收敛 (~6s/步);
TiedValueConstraint 实测定点迭代收敛慢且失收, LinearNodalConstraint 本版
MOOSE 雅可比装配有问题 (Newton 方向不降低残差)。

用法:
  ~/miniforge3/envs/moose/bin/python tools/stitch_interface.py \
      outputs/abaqus_8elc/abaqus_8elc_mesh.e \
      --stitch 'SURF__PickedSurf2150 SURF__PickedSurf2151 : paijia__con' \
      --stitch 'GL_BOTTOM : caoshen_dangkuai__con' \
      --tol 30
"""

import argparse
import sys
from pathlib import Path

import netCDF4
import numpy as np
from scipy.spatial import cKDTree

sys.path.insert(0, str(Path(__file__).resolve().parent))
from abaqus2exodus import _HEX_CORNERS, _HEX_SIGNS  # noqa: E402


def det_j_corners(pts):
    """hex8 8 角点 det(J), 与 abaqus2exodus.find_inverted_hexes 一致"""
    p = np.array(pts)
    dets = []
    for xi, eta, zeta in _HEX_CORNERS:
        ds = np.array([a * (1 + b * eta) * (1 + c * zeta)
                       for a, b, c in _HEX_SIGNS]) / 8.0
        dt = np.array([(1 + a * xi) * b * (1 + c * zeta)
                       for a, b, c in _HEX_SIGNS]) / 8.0
        du = np.array([(1 + a * xi) * (1 + b * eta) * c
                       for a, b, c in _HEX_SIGNS]) / 8.0
        J = np.array([ds @ p, dt @ p, du @ p])
        dets.append(float(np.linalg.det(J)))
    return dets


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('mesh')
    ap.add_argument('--stitch', action='append', required=True,
                    metavar='SLAVE_NSETS : HOST_BLOCK')
    ap.add_argument('--tol', type=float, default=30.0)
    args = ap.parse_args()

    nc = netCDF4.Dataset(args.mesh, 'a')
    C = np.column_stack([nc.variables['coordx'][:].data,
                         nc.variables['coordy'][:].data,
                         nc.variables['coordz'][:].data])
    ebnames = [''.join(c for c in row.astype('U1') if c).strip()
               for row in nc.variables['eb_names'][:]]
    nsnames = [''.join(c for c in row.astype('U1') if c).strip()
               for row in nc.variables['ns_names'][:]]
    # 全部 hex 块连接表 (内存副本 + 文件变量)
    hex_blocks = {}
    for bi, name in enumerate(ebnames, 1):
        v = nc.variables[f'connect{bi}']
        if v.getncattr('elem_type') == 'HEX8':
            hex_blocks[name] = (v, v[:].data.copy())

    # 节点 → 相关 hex 列表 [(block, elem_idx)]
    node_elems = {}
    for bname, (v, conn) in hex_blocks.items():
        for ei, row in enumerate(conn):
            for n in row:
                node_elems.setdefault(int(n), []).append((bname, ei))

    def corner_dets(bname, ei, conn_override=None):
        conn = conn_override if conn_override is not None else hex_blocks[bname][1][ei]
        pts = [tuple(C[n - 1]) for n in conn]
        return det_j_corners(pts)

    total_m = total_s = 0
    for spec in args.stitch:
        slave_part, host_block = [s.strip() for s in spec.split(':')]
        slaves = set()
        for ns in slave_part.split():
            ni = nsnames.index(ns) + 1
            slaves.update(nc.variables[f'node_ns{ni}'][:].data.tolist())
        _, host_conn = hex_blocks[host_block]
        host_nodes = sorted(set(host_conn.ravel().tolist()))
        host_tree = cKDTree(C[np.array(host_nodes) - 1])

        n_merge = n_skip = n_flip = 0
        for g in sorted(slaves):
            if g in host_nodes:
                continue  # 已是共享节点
            d, ii = host_tree.query(C[g - 1])
            if d > args.tol:
                n_skip += 1
                continue
            h = int(host_nodes[ii])
            # 试合并: 相关 hex 连接表 g→h
            affected = node_elems.get(g, [])
            old = {}
            flip = False
            for bname, ei in affected:
                row = hex_blocks[bname][1][ei]
                old[(bname, ei)] = row.copy()
                trial = row.copy()
                trial[trial == g] = h
                if len(set(trial.tolist())) < 8 or \
                   min(corner_dets(bname, ei, trial)) <= 0:
                    flip = True
                    break
                hex_blocks[bname][1][ei] = trial
            if flip:
                for (bname, ei), row in old.items():
                    hex_blocks[bname][1][ei] = row
                n_flip += 1
                continue
            # 接受: 更新 node_elems 索引
            for bname, ei in affected:
                node_elems.setdefault(h, []).append((bname, ei))
            n_merge += 1
        print(f'  {slave_part} → {host_block}: 合并 {n_merge}, '
              f'超距跳过 {n_skip} (tol={args.tol}), 防翻转回滚 {n_flip}')
        total_m += n_merge
        total_s += n_skip

    # 写回连接表
    for bname, (v, conn) in hex_blocks.items():
        v[:] = conn
    nc.close()
    print(f'✓ 共合并 {total_m} 对, 跳过 {total_s} → {args.mesh} (就地)')


if __name__ == '__main__':
    main()
