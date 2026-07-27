#!/usr/bin/env python3
"""build_rebar_result.py — 钢筋结果重构 v2 (宿主单元插值)

物理模型 (与 Abaqus *Embedded Element 运动学一致):
  每个钢筋节点的位移 = 其宿主实体单元在该点处的形函数插值
      u_rebar(x) = Σ N_i(x) · u_solid_i
  天然保证:
  - 钢筋位移被实体节点位移凸包约束, 不会探出墙体轮廓
  - 位移场平滑, 钢筋保持平直随墙体变形 (不会折成折线)
  钢筋轴向应力按原始几何重算: σ = E · (u2 - u1)·t̂ / L

输入:
  outputs/abaqus_6_15/6-15_mesh.e           转换后网格 (实体宿主)
  outputs/abaqus_6_15/abaqus_6_15_out.e     MOOSE 求解结果 (位移场)
  outputs/abaqus_6_15/rebar_render_map.json 原始钢筋几何 (--render-map)
  outputs/abaqus_6_15/report.json           材料表 (E 值)
输出:
  outputs/abaqus_6_15/rebar_result.e        原始几何 + 插值位移 + 重算应力

用法 (6-15 默认路径, 全部参数可覆盖以复用于其他算例):
  ~/miniforge3/envs/moose/bin/python tools/build_rebar_result.py \
      [--mesh MESH.e] [--result OUT.e] [--render-map MAP.json] \
      [--report REPORT.json] [--out REBAR_RESULT.e]
"""

import argparse
import json
import sys
from pathlib import Path

import netCDF4
import numpy as np

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "outputs" / "abaqus_6_15"
sys.path.insert(0, str(ROOT / "tools"))
from abaqus2exodus import point_in_hex, _hex_shape, _hex_map  # noqa: E402

# 材料弹性模量 (MPa), 与 Abaqus *Elastic 一致
E_OF_MATERIAL = {'gangjin': 206000.0, 'HPB400': 200000.0}


def load_solid(mesh_path):
    """读实体 hex 块: 坐标 + 连接表"""
    nc = netCDF4.Dataset(str(mesh_path))
    C = np.column_stack([nc.variables['coordx'][:].data,
                         nc.variables['coordy'][:].data,
                         nc.variables['coordz'][:].data])
    names = [''.join(c for c in row.astype('U1') if c).strip()
             for row in nc.variables['eb_names'][:]]
    hexes = []
    for i, v in enumerate(sorted(v for v in nc.variables if v.startswith('connect'))):
        pass  # sorted 顺序与 eb_names 不对应, 下面按序号处理
    for bi in range(1, len(names) + 1):
        v = f'connect{bi}'
        conn = nc.variables[v][:].data
        if nc.variables[v].getncattr('elem_type') == 'HEX8':
            hexes.append(conn)
    nc.close()
    return C, np.vstack(hexes)


def compute_weights(pt, C, conn, cent_tree, cents, radii, solid_tree, solid_ids):
    """宿主单元形函数权重; 失败时最近单元投影; 再失败最近节点"""
    cand = cent_tree.query_ball_point(pt, r=250.0)
    cand.sort(key=lambda i: np.linalg.norm(cents[i] - pt) - radii[i])
    for i in cand[:32]:
        nodes = conn[i]
        pts = [tuple(C[n - 1]) for n in nodes]
        res = point_in_hex(pt, pts, tol=0.02)
        if res is not None:
            xi, eta, zeta = (max(-1.0, min(1.0, c)) for c in res)
            return list(zip(nodes.tolist(), _hex_shape(xi, eta, zeta)))
    # 最近单元投影 (允许 |ξ|>1 后截断, 仍被实体节点凸包约束)
    if cand:
        i = cand[0]
        nodes = conn[i]
        pts = [tuple(C[n - 1]) for n in nodes]
        res = point_in_hex(pt, pts, tol=2.0)
        if res is not None:
            xi, eta, zeta = (max(-1.0, min(1.0, c)) for c in res)
            return list(zip(nodes.tolist(), _hex_shape(xi, eta, zeta)))
    # 最近节点
    d, ii = solid_tree.query(pt)
    return [(int(solid_ids[ii]), 1.0)]


def main():
    ap = argparse.ArgumentParser(description='钢筋结果重构 (宿主单元插值)')
    ap.add_argument('--mesh', default=str(OUT / "6-15_mesh.e"),
                    help='转换后网格 .e (实体宿主)')
    ap.add_argument('--result', default=str(OUT / "abaqus_6_15_out.e"),
                    help='MOOSE 求解结果 .e (位移场)')
    ap.add_argument('--render-map', default=str(OUT / "rebar_render_map.json"),
                    help='abaqus2exodus.py --render-map 产物 (原始钢筋几何)')
    ap.add_argument('--report', default=str(OUT / "report.json"),
                    help='abaqus2exodus.py --report 产物 (材料表)')
    ap.add_argument('--out', default=str(OUT / "rebar_result.e"),
                    help='输出: 原始几何 + 插值位移 + 重算应力')
    args = ap.parse_args()

    mesh_path = Path(args.mesh)
    res_path = Path(args.result)
    map_path = Path(args.render_map)
    report_path = Path(args.report)
    dst_path = Path(args.out)

    print("[1/4] 加载实体网格与渲染映射 ...")
    C, conn = load_solid(mesh_path)
    cents = np.array([C[c - 1].mean(axis=0) for c in conn])
    sizes = np.array([C[c - 1].max(axis=0) - C[c - 1].min(axis=0)
                      for c in conn])
    radii = np.linalg.norm(sizes, axis=1) / 2.0
    from scipy.spatial import cKDTree
    cent_tree = cKDTree(cents)
    solid_ids = np.unique(conn.ravel())
    solid_tree = cKDTree(C[solid_ids - 1])

    rmap = json.load(open(map_path))

    nc = netCDF4.Dataset(str(res_path))
    times = nc.variables['time_whole'][:].data
    nt = len(times)
    nod_names = [''.join(c for c in row.astype('U1') if c).strip()
                 for row in nc.variables['name_nod_var'][:]]
    idx = {n: i + 1 for i, n in enumerate(nod_names)}
    disp = {comp: nc.variables[f"vals_nod_var{idx[comp]}"][:].data
            for comp in ('disp_x', 'disp_y', 'disp_z')}
    print(f"      结果时间步: {nt}")

    # MOOSE 会重排节点编号, 且 v4 求解网格不含 truss 块:
    # 结果 .e 只有实体节点。只需为实体节点建立 网格id -> 结果行号 映射
    Cr = np.column_stack([nc.variables['coordx'][:].data,
                          nc.variables['coordy'][:].data,
                          nc.variables['coordz'][:].data])
    res_tree = cKDTree(Cr)
    mesh2res = np.zeros(len(C), dtype=int)  # 默认 0 (truss 节点不会被引用)
    dd, ii = res_tree.query(C[solid_ids - 1])
    assert dd.max() < 1e-3, f'实体节点匹配失败: max dist {dd.max()}'
    mesh2res[solid_ids - 1] = ii
    print(f'      实体节点映射: max dist {dd.max():.2e} '
          f'({len(solid_ids)}/{len(C)} 节点)')

    # 位移按网格节点 id 重排 (result_row = mesh2res[mesh_gid-1])
    for comp in disp:
        disp[comp] = disp[comp][:, mesh2res]

    print("[2/4] 计算钢筋节点插值权重 (宿主单元形函数) ...")
    # 收集全部原始钢筋节点
    node_pos = {}   # key -> (x,y,z)
    elems = []      # (bname, key1, key2, p0, p1)
    for blk in rmap['blocks']:
        for el in blk['elements']:
            k0 = tuple(np.round(el['p0'], 3))
            k1 = tuple(np.round(el['p1'], 3))
            node_pos[k0] = el['p0']
            node_pos[k1] = el['p1']
            elems.append((blk['name'], k0, k1,
                          np.array(el['p0']), np.array(el['p1'])))
    keys = sorted(node_pos)
    weights = {}
    n_interp = n_proj = n_near = 0
    for k in keys:
        pt = np.array(node_pos[k])
        cand = cent_tree.query_ball_point(pt, r=250.0)
        cand.sort(key=lambda i: np.linalg.norm(cents[i] - pt) - radii[i])
        w = None
        for i in cand[:32]:
            nodes = conn[i]
            pts = [tuple(C[n - 1]) for n in nodes]
            res = point_in_hex(pt, pts, tol=0.02)
            if res is not None:
                xi, eta, zeta = (max(-1.0, min(1.0, c)) for c in res)
                w = list(zip(nodes.tolist(), _hex_shape(xi, eta, zeta)))
                n_interp += 1
                break
        if w is None and cand:
            # 体外点: 在邻近候选单元上 best-effort 投影,
            # 按真实投影残差选最近单元 (防止附到界面另一侧的大单元)
            best = None
            for i in cand[:8]:
                nodes = conn[i]
                pts = [tuple(C[n - 1]) for n in nodes]
                res = point_in_hex(pt, pts, best_effort=True)
                if res is None:
                    continue
                pm, _ = _hex_map(pts, *res)
                r = float(np.linalg.norm(np.array(pm) - pt))
                if best is None or r < best[0]:
                    best = (r, i, res)
            if best is not None:
                _, i, res = best
                w = list(zip(conn[i].tolist(), _hex_shape(*res)))
                n_proj += 1
        if w is None:
            d, ii = solid_tree.query(pt)
            w = [(int(solid_ids[ii]), 1.0)]
            n_near += 1
        weights[k] = w
    print(f"      插值 {n_interp}, 投影 {n_proj}, 最近点 {n_near}")

    print("[3/4] 插值位移场 + 重算轴向应力 ...")
    key_of_new = {}     # key -> 新节点 id
    new_nodes = []
    new_elems = []      # (bname, n1, n2, t̂, L)
    for bname, k0, k1, p0, p1 in elems:
        if k0 not in key_of_new:
            key_of_new[k0] = len(new_nodes) + 1
            new_nodes.append(node_pos[k0])
        if k1 not in key_of_new:
            key_of_new[k1] = len(new_nodes) + 1
            new_nodes.append(node_pos[k1])
        L = float(np.linalg.norm(p1 - p0))
        if L < 1e-9:
            continue
        t = (p1 - p0) / L
        new_elems.append((bname, key_of_new[k0], key_of_new[k1], t, L))

    nn = len(new_nodes)
    # 位移插值矩阵: 每节点 ~8 个 (nid, w)
    wlists = [weights[k] for k in
              sorted(key_of_new, key=lambda k: key_of_new[k])]
    disp_i = {}  # comp -> (nt, nn)
    for comp in ('disp_x', 'disp_y', 'disp_z'):
        U = disp[comp]  # (nt, n_nodes_result)
        out = np.zeros((nt, nn))
        for j, wl in enumerate(wlists):
            ids = np.array([n for n, _ in wl])
            w = np.array([x for _, x in wl])
            out[:, j] = U[:, ids - 1] @ w
        disp_i[comp] = out

    # --- 应力: 弹塑性模型 (按 Abaqus inp *Plastic 数据, 屈服截断) ---
    # σ = E·ε (弹性段), |σ| ≤ σ_y + H·ε_p (塑性段), 数据来自 report.json
    report = json.load(open(report_path))
    mats = report.get('materials', {})

    def plastic_curve(mat):
        """返回 (E, [(ε_total, σ) 递增折线])"""
        v = mats.get(mat, {})
        E = v.get('elastic', [[206000.0, 0.3]])[0][0]
        pl = v.get('plastic') or []
        pts = [(p[1] + p[0] / E, p[0]) for p in pl]  # 总应变, 应力
        return E, pts

    def elpl(esp, E, pts):
        """弹塑性应力 (signed)"""
        out = np.empty_like(esp)
        for k, e in np.ndenumerate(esp):
            s = 1.0 if e >= 0 else -1.0
            ae = abs(e)
            sig = E * ae
            if pts:
                if ae <= pts[0][0]:
                    sig = E * ae
                else:
                    sig = pts[-1][1] + (ae - pts[-1][0]) * (
                        (pts[-1][1] - pts[-2][1]) / (pts[-1][0] - pts[-2][0])
                        if len(pts) > 1 else 0.0)
                    for j in range(len(pts) - 1):
                        if pts[j][0] <= ae <= pts[j + 1][0]:
                            sig = pts[j][1] + (ae - pts[j][0]) * (
                                pts[j + 1][1] - pts[j][1]) / (
                                pts[j + 1][0] - pts[j][0])
                            break
            out[k] = s * sig
        return out

    mat_of_block = {b['name']: b['name'].split('__')[-1].split('_A')[0]
                    for b in rmap['blocks']}
    stress = np.zeros((nt, len(new_elems)))
    for ei, (bname, n1, n2, t, L) in enumerate(new_elems):
        E, pts = plastic_curve(mat_of_block[bname])
        du = np.column_stack([disp_i['disp_x'][:, n2 - 1] - disp_i['disp_x'][:, n1 - 1],
                              disp_i['disp_y'][:, n2 - 1] - disp_i['disp_y'][:, n1 - 1],
                              disp_i['disp_z'][:, n2 - 1] - disp_i['disp_z'][:, n1 - 1]])
        esp = (du @ t) / L
        stress[:, ei] = elpl(esp, E, pts)
    elem_names = [''.join(c for c in row.astype('U1') if c).strip()
                  for row in nc.variables['name_elem_var'][:]]
    stress_var = elem_names.index('truss_stress') + 1 \
        if 'truss_stress' in elem_names else None
    eb_names_out = [''.join(c for c in row.astype('U1') if c).strip()
                    for row in nc.variables['eb_names'][:]]


    print(f"      重构: {nn} 节点, {len(new_elems)} 单元")
    print(f"      应力范围: [{stress.min():.0f}, {stress.max():.0f}] MPa")

    print("[4/4] 写出 rebar_result.e ...")
    write_exodus(dst_path, times, new_nodes, new_elems, disp_i, stress)
    nc.close()
    print(f"✓ 完成: {dst_path}")


def write_exodus(path, times, nodes, elems, disp_i, stress):
    ds = netCDF4.Dataset(str(path), 'w', format='NETCDF4')
    blocks = {}
    for ei, (bname, n1, n2, t, L) in enumerate(elems):
        blocks.setdefault(bname, []).append(ei)
    blk_list = sorted(blocks)
    nn = len(nodes)
    ne = len(elems)
    nt = len(times)

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
    ds.setncattr('title', 'rebar_result (host-interpolated)')

    vt = ds.createVariable('time_whole', 'f8', ('time_step',))
    vt[:] = times
    coords = np.array(nodes, dtype='f8')
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
        eis = blocks[bname]
        ds.createDimension(f'num_el_in_blk{bi}', len(eis))
        ds.createDimension(f'num_nod_per_el{bi}', 2)
        vc = ds.createVariable(f'connect{bi}', 'i4',
                               (f'num_el_in_blk{bi}', f'num_nod_per_el{bi}'))
        vc.setncattr('elem_type', 'TRUSS')
        vc[:] = np.array([[elems[ei][1], elems[ei][2]] for ei in eis],
                         dtype='i4')

    ds.createDimension('num_nod_var', 3)
    vnv = ds.createVariable('name_nod_var', 'S1', ('num_nod_var', 'len_name'))
    for i, nm in enumerate(('disp_x', 'disp_y', 'disp_z')):
        b = nm.encode()
        vnv[i, :len(b)] = list(np.frombuffer(b, dtype='S1'))
    for i, comp in enumerate(('disp_x', 'disp_y', 'disp_z'), start=1):
        v = ds.createVariable(f'vals_nod_var{i}', 'f8',
                              ('time_step', 'num_nodes'))
        v[:] = disp_i[comp]

    ds.createDimension('num_elem_var', 1)
    vev = ds.createVariable('name_elem_var', 'S1', ('num_elem_var', 'len_name'))
    b = b'truss_stress'
    vev[0, :len(b)] = list(np.frombuffer(b, dtype='S1'))
    for bi, bname in enumerate(blk_list, start=1):
        eis = blocks[bname]
        v = ds.createVariable(f'vals_elem_var1eb{bi}', 'f8',
                              ('time_step', f'num_el_in_blk{bi}'))
        v[:] = stress[:, eis]
    ds.close()


if __name__ == '__main__':
    main()
