#!/usr/bin/env python3
"""emit_interface_mpc.py — 界面绑定 MPC 约束生成 (LinearNodalConstraint, 宿主插值)

用途: 接触/绑定界面两侧网格非匹配时, 把 slave 面节点按宿主实体单元形函数
插值绑定到 master 块 (u_slave = Σ N_i·u_master_i), 等效 Abaqus *Tie/绑定接触。

与 TiedValueConstraint 对比: 纯线性罚约束, 线性问题 Newton 1 步收敛
(TiedValueConstraint 实测为定点迭代式收敛, 每步 10-20 次 Newton 且会失收)。

用法:
  ~/miniforge3/envs/moose/bin/python tools/emit_interface_mpc.py \
      --mesh outputs/abaqus_8elc/abaqus_8elc_mesh.e \
      --tie 'SURF__PickedSurf2150 SURF__PickedSurf2151 : paijia__con' \
      --tie 'GL_BOTTOM : caoshen_dangkuai__con' \
      --penalty 1e7 \
      --out outputs/abaqus_8elc/mpc_interface.i

产物: [Constraints] 片段 (可 cat 进主 .i 或经 abaqus_pipeline.sh 拼接)
"""

import argparse
import sys
from pathlib import Path

import netCDF4
import numpy as np
from scipy.spatial import cKDTree

sys.path.insert(0, str(Path(__file__).resolve().parent))
from abaqus2exodus import point_in_hex, _hex_shape  # noqa: E402


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--mesh', required=True)
    ap.add_argument('--tie', action='append', required=True,
                    metavar='SLAVE_NSETS : HOST_BLOCK',
                    help="slave nodeset(空格分隔多个) : 宿主块名; 可重复")
    ap.add_argument('--penalty', type=float, default=1e7)
    ap.add_argument('--max-degen-dist', type=float, default=50.0,
                    help='最近点退化仅接受此距离内 (mm), 超出则跳过 (跨空段不应绑定)')
    ap.add_argument('--out', required=True)
    args = ap.parse_args()

    nc = netCDF4.Dataset(args.mesh)
    C = np.column_stack([nc.variables['coordx'][:].data,
                         nc.variables['coordy'][:].data,
                         nc.variables['coordz'][:].data])
    ebnames = [''.join(c for c in row.astype('U1') if c).strip()
               for row in nc.variables['eb_names'][:]]
    nsnames = [''.join(c for c in row.astype('U1') if c).strip()
               for row in nc.variables['ns_names'][:]]
    blocks = {}
    for bi, name in enumerate(ebnames, 1):
        conn = nc.variables[f'connect{bi}'][:].data
        if nc.variables[f'connect{bi}'].getncattr('elem_type') == 'HEX8':
            blocks[name] = conn

    lines = ['[Constraints]\n']
    total = n_interp = n_degen = n_skip = 0
    for spec in args.tie:
        slave_part, host_block = [s.strip() for s in spec.split(':')]
        slave_nodes = set()
        for ns in slave_part.split():
            if ns not in nsnames:
                sys.exit(f'✗ nodeset 不存在: {ns}')
            ni = nsnames.index(ns) + 1
            slave_nodes.update(nc.variables[f'node_ns{ni}'][:].data.tolist())
        if host_block not in blocks:
            sys.exit(f'✗ 宿主块不存在: {host_block} (可选: {sorted(blocks)})')

        conn_all = blocks[host_block]
        cents = np.array([C[c - 1].mean(axis=0) for c in conn_all])
        sizes = np.array([C[c - 1].max(axis=0) - C[c - 1].min(axis=0)
                          for c in conn_all])
        radii = np.linalg.norm(sizes, axis=1) / 2.0
        tree = cKDTree(cents)
        host_nodes = sorted(set(conn_all.ravel().tolist()))
        host_tree = cKDTree(C[np.array(host_nodes) - 1])

        for g in sorted(slave_nodes):
            pt = C[g - 1]
            # 大单元可能使质心距离 > 固定球半径: 用最近 k 个质心
            k = min(48, len(cents))
            dd, cand = tree.query(pt, k=k)
            cand = list(cand)
            cand.sort(key=lambda i: np.linalg.norm(cents[i] - pt) - radii[i])
            weights = None
            for i in cand[:24]:
                nodes = conn_all[i]
                pts = [tuple(C[n - 1]) for n in nodes]
                res = point_in_hex(pt, pts, tol=0.02)
                if res is not None:
                    # 截断 [-1,1]: 外插负形函数 → 不定矩阵 → MUMPS PC_FAILED
                    xi, eta, zeta = (max(-1.0, min(1.0, c)) for c in res)
                    weights = list(zip(nodes.tolist(),
                                       _hex_shape(xi, eta, zeta)))
                    n_interp += 1
                    break
            if weights is None:
                d, ii = host_tree.query(pt)
                if d > args.max_degen_dist:
                    n_skip += 1
                    continue
                weights = [(int(host_nodes[ii]), 1.0)]
                n_degen += 1
            prim = ' '.join(str(n) for n, _ in weights)
            wts = ' '.join(f'{w:.8g}' for _, w in weights)
            for v in ('disp_x', 'disp_y', 'disp_z'):
                lines.append(
                    f"  [mpc_n{g}_{v[-1]}]\n"
                    f"    type = LinearNodalConstraint\n"
                    f"    variable = {v}\n"
                    f"    primary = '{prim}'\n"
                    f"    secondary_node_ids = '{g}'\n"
                    f"    weights = '{wts}'\n"
                    f"    penalty = {args.penalty:g}\n"
                    f"  []\n")
            total += 1
        print(f'  {slave_part} → {host_block}: {len(slave_nodes)} 节点')
    lines.append('[]\n')
    with open(args.out, 'w') as f:
        f.writelines(lines)
    print(f'✓ {total} 个 slave 节点 (插值 {n_interp}, 最近点退化 {n_degen}, '
          f'跨空跳过 {n_skip}) → {args.out}')


if __name__ == '__main__':
    main()
