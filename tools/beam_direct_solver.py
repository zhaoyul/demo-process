#!/usr/bin/env python3
# beam_direct_solver.py — 梁模型地震时程直接求解器 (numpy/scipy Newmark)
#
# 由 2026-08-10 PR-RG-400gal-X 算例创建。动机: hongchuang-opt (MOOSE) 在
# i5-1038NG7 上每残差评估 ~2s, 6500 步不可行; 且发现 PresetAcceleration
# scale_factor 不被使用 (MOOSE bug)。本求解器对线性体系精确组装 K/M/C,
# MPC 用约束变换精确消元, Newmark 常加速度, 一次性稀疏 LU 分解后逐步回代
# — 全 65s (6500 步) 分钟级完成。
#
# 模型语义与 tools/gen_beam_case.py 一致 (同一 report.json):
#   - 3D Timoshenko 梁 (φ 剪切因子), 截面特性来自 Abaqus I/CIRC 公式
#   - y_orientation = report n1 (已按 Abaqus 投影语义处理)
#   - *Damping → C = α·M + β·K
#   - *Mass / *Rotary Inertia → 主节点集中质量/惯量
#   - *Nonstructural Mass → 附加密度 Δρ = m'/A
#   - *MPC BEAM → 从节点 6 自由度刚体约束消元 (u_s = u_m + θ_m × r)
#   - *RELEASE s1/s2 allm → 端部铰接静力凝聚 (精确)
#   - 基底: dofs 2-6 固定, x 向 prescribed 加速度 = scale × amplitude(t)
#
# 用法:
#   tools/beam_direct_solver.py --report outputs/<name>/report.json \
#       --mesh outputs/<name>/<name>_mesh.e --out outputs/<name>/<name>_out.e \
#       [--csv top.csv] [--dt 0.01] [--end-time 65]

import argparse
import json
import time

import numpy as np
import netCDF4
from scipy.sparse import lil_matrix, csr_matrix, hstack
from scipy.sparse.linalg import splu, eigsh

NEWMARK_BETA = 0.25
NEWMARK_GAMMA = 0.5


# ---------------------------------------------------------------- 截面特性
def circ_props(r):
    A = np.pi * r * r
    I = np.pi * r ** 4 / 4.0
    return A, I, I, 2 * I          # A, Iy, Iz, J


def isect_props(dims):
    l, h, b1, b2, t1, t2, t3 = dims
    hw = h - t1 - t2
    Af1, Af2, Aw = b1 * t1, b2 * t2, hw * t3
    A = Af1 + Af2 + Aw
    ybar = (Af1 * t1 / 2 + Aw * (t1 + hw / 2) + Af2 * (h - t2 / 2)) / A
    In1 = (b1 * t1 ** 3 / 12 + Af1 * (ybar - t1 / 2) ** 2 +
           t3 * hw ** 3 / 12 + Aw * (t1 + hw / 2 - ybar) ** 2 +
           b2 * t2 ** 3 / 12 + Af2 * (h - t2 / 2 - ybar) ** 2)
    In2 = t1 * b1 ** 3 / 12 + t2 * b2 ** 3 / 12 + hw * t3 ** 3 / 12
    J = (b1 * t1 ** 3 + b2 * t2 ** 3 + hw * t3 ** 3) / 3.0
    return A, In1, In2, J


# ---------------------------------------------------------------- 梁单元
def beam_ke_local(E, G, A, Iy, Iz, J, L, Ay, Az):
    """3D Timoshenko 梁局部刚度 (12×12), 局部 x=轴向, y=n1"""
    k = np.zeros((12, 12))

    def put(idofs, mat):
        for a in range(len(idofs)):
            for b in range(len(idofs)):
                k[idofs[a], idofs[b]] += mat[a][b]

    put([0, 6], (E * A / L) * np.array([[1, -1], [-1, 1]]))
    put([3, 9], (G * J / L) * np.array([[1, -1], [-1, 1]]))
    phi_z = 12.0 * E * Iz / (G * Ay * L * L) if Ay > 0 else 0.0
    c = E * Iz / (L ** 3 * (1 + phi_z))
    put([1, 5, 7, 11], c * np.array([
        [12, 6 * L, -12, 6 * L],
        [6 * L, (4 + phi_z) * L * L, -6 * L, (2 - phi_z) * L * L],
        [-12, -6 * L, 12, -6 * L],
        [6 * L, (2 - phi_z) * L * L, -6 * L, (4 + phi_z) * L * L]]))
    phi_y = 12.0 * E * Iy / (G * Az * L * L) if Az > 0 else 0.0
    c = E * Iy / (L ** 3 * (1 + phi_y))
    put([2, 4, 8, 10], c * np.array([
        [12, -6 * L, -12, -6 * L],
        [-6 * L, (4 + phi_y) * L * L, 6 * L, (2 - phi_y) * L * L],
        [-12, 6 * L, 12, 6 * L],
        [-6 * L, (2 - phi_y) * L * L, 6 * L, (4 + phi_y) * L * L]]))
    return k


def beam_me_local(rho, A, Iy, Iz, L):
    """一致质量 (局部坐标, MOOSE InertialForceBeam 同约定):
    平动 ρAL (1/3,1/6); 转动 ρL·diag(Iy+Iz, Iz, Iy) (1/3,1/6)"""
    m = np.zeros((12, 12))
    mt = rho * A * L
    for d in range(3):
        m[d, d] += mt / 3
        m[d + 6, d + 6] += mt / 3
        m[d, d + 6] += mt / 6
        m[d + 6, d] += mt / 6
    for a, Ia in enumerate([Iy + Iz, Iz, Iy]):
        w = rho * L * Ia
        m[a + 3, a + 3] += w / 3
        m[a + 9, a + 9] += w / 3
        m[a + 3, a + 9] += w / 6
        m[a + 9, a + 3] += w / 6
    return m


def condense_release(k, m, end):
    """端部弯矩释放 (allm): 释放端转动 DOF 静力凝聚。
    返回 (kc, mc, keep) — 凝聚后矩阵 + 保留的局部 DOF"""
    rel = [9, 10, 11] if end == 's2' else [3, 4, 5]
    keep = [i for i in range(12) if i not in rel]
    k_aa = k[np.ix_(keep, keep)]
    k_ab = k[np.ix_(keep, rel)]
    k_bb = k[np.ix_(rel, rel)]
    kc = k_aa - k_ab @ np.linalg.solve(k_bb, k_ab.T)
    mc = m[np.ix_(keep, keep)]
    # 被释放端转动惯量并入该端平动对角 (保持总转动惯量量级, 防零质量 DOF)
    for r in rel:
        tnode = [i for i in keep if (i // 6) == (r // 6) and i % 6 < 3]
        for t in tnode:
            mc[t, t] += m[r, r] / max(1, len(tnode))
    return kc, mc, keep


# ---------------------------------------------------------------- Exodus 写出
def write_exodus_result(mesh_path, out_path, U6, times):
    """克隆网格文件, 追加 nodal 变量 disp/rot (MOOSE 输出同构)"""
    import shutil
    shutil.copy(mesh_path, out_path)
    nc = netCDF4.Dataset(out_path, 'r+')
    vnames = ['disp_x', 'disp_y', 'disp_z', 'rot_x', 'rot_y', 'rot_z']
    nc.createDimension('num_nod_var', 6)
    v = nc.createVariable('name_nod_var', 'S1', ('num_nod_var', 'len_name'))
    for i, nm in enumerate(vnames):
        b = nm.encode()
        v[i, :len(b)] = list(np.frombuffer(b, dtype='S1'))
    for j, nm in enumerate(vnames, start=1):
        nc.createVariable(f'vals_nod_var{j}', 'f8', ('time_step', 'num_nodes'))
    vt = nc.variables['time_whole']
    vt[0] = 0.0
    for j in range(1, 7):
        nc.variables[f'vals_nod_var{j}'][0, :] = 0.0
    # 一次性整块写入 (逐帧写在 HDF5 unlimited dim 上极慢)
    vt[1:len(times) + 1] = np.array(times)
    for j in range(1, 7):
        nc.variables[f'vals_nod_var{j}'][1:len(times) + 1, :] = U6[:, :, j - 1]
    nc.close()


# ---------------------------------------------------------------- 主流程
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--report', required=True)
    ap.add_argument('--mesh', required=True)
    ap.add_argument('--out', required=True)
    ap.add_argument('--csv', help='顶点 (主节点) disp_x 时程 CSV')
    ap.add_argument('--dt', type=float, default=None)
    ap.add_argument('--end-time', type=float, default=None)
    ap.add_argument('--output-interval', type=int, default=5)
    ap.add_argument('--save-matrices', help='导出 Kf/Mf/Cf npz (验证用)')
    ap.add_argument('--no-releases', action='store_true',
                    help='忽略 *RELEASE 端部释放 (与 MOOSE 模型对照用)')
    args = ap.parse_args()

    t_start = time.time()
    r = json.load(open(args.report))

    # ---- 读网格 ----
    nc = netCDF4.Dataset(args.mesh)
    coords = np.column_stack([nc.variables['coordx'][:],
                              nc.variables['coordy'][:],
                              nc.variables['coordz'][:]])
    nnode = coords.shape[0]
    nblk = nc.dimensions['num_el_blk'].size
    eb_raw = nc.variables['eb_names']
    eb_names = [eb_raw[i].tobytes().decode('ascii', 'replace').strip('\x00 ')
                for i in range(eb_raw.shape[0])]
    blocks = {}
    for bi, nm in enumerate(eb_names, start=1):
        blocks[nm] = nc.variables[f'connect{bi}'][:] - 1
    nsets = {}
    if 'ns_names' in nc.variables:
        ns_raw = nc.variables['ns_names']
        ns_names = [ns_raw[i].tobytes().decode('ascii', 'replace').strip('\x00 ')
                    for i in range(ns_raw.shape[0])]
        for ni, nm in enumerate(ns_names, start=1):
            nsets[nm] = nc.variables[f'node_ns{ni}'][:]
    nc.close()
    print(f"[load] 节点={nnode} 块={len(blocks)} "
          f"单元={sum(len(v) for v in blocks.values())}")

    ndof = nnode * 6
    step = r['steps'][0]
    dyn = step.get('dynamic') or [0.01, 1.0]
    dt = args.dt or dyn[0]
    T = args.end_time or (dyn[1] if len(dyn) > 1 else 1.0)
    nsteps = int(round(T / dt))

    mats = r['materials']
    eta = zeta = 0.0
    for mt in mats.values():
        if mt.get('damping'):
            eta = mt['damping'].get('alpha', 0.0)
            zeta = mt['damping'].get('beta', 0.0)
            break
    print(f"[mat] Rayleigh: α={eta} β={zeta}")

    extra_rho = {}
    for ns in r.get('nonstructural_mass', []):
        for blk in ns['per_block']:
            bs = r['beam_sections'].get(blk)
            if not bs:
                continue
            A = circ_props(bs['dims'][0])[0] if bs['section'] == 'CIRC' \
                else isect_props(bs['dims'])[0]
            extra_rho[blk] = extra_rho.get(blk, 0.0) + ns['value'] / A

    # ---- 单元组装 (全局 K, M; MPC 连杆跳过) ----
    K = lil_matrix((ndof, ndof))
    M = lil_matrix((ndof, ndof))
    release_map = {rel['geid']: rel['end']
                   for rel in r.get('releases_global', [])}
    if args.no_releases:
        release_map = {}
    geid = 0
    n_hinge = 0
    for bname, conn in sorted(blocks.items()):
        if bname.startswith('mpc_beam_links'):
            geid += len(conn)
            continue
        bs = r['beam_sections'][bname]
        mat = mats[bs['material']]
        E, nu = mat['elastic'][0][0], mat['elastic'][0][1]
        G = E / (2 * (1 + nu))
        rho = mat['density'][0][0] + extra_rho.get(bname, 0.0)
        if bs['section'] == 'CIRC':
            A, Iy, Iz, J = circ_props(bs['dims'][0])
            Ay = Az = 0.9 * A
        else:
            A, Iy, Iz, J = isect_props(bs['dims'])
            Ay = Az = A / 1.2
        n1 = np.array(bs['n1'], dtype=float)
        for e in conn:
            geid += 1
            p0, p1 = coords[e[0]], coords[e[1]]
            t = p1 - p0
            L = np.linalg.norm(t)
            t = t / L
            y = n1 - np.dot(n1, t) * t
            ny = np.linalg.norm(y)
            if ny < 1e-8:
                y = np.array([-t[1], t[0], 0.0])
                ny = np.linalg.norm(y)
                if ny < 1e-8:
                    y = np.array([0.0, -t[2], t[1]])
                    ny = np.linalg.norm(y)
            y = y / ny
            z = np.cross(t, y)
            R = np.vstack([t, y, z])
            T12 = np.zeros((12, 12))
            for i in range(4):
                T12[3 * i:3 * i + 3, 3 * i:3 * i + 3] = R
            ke = beam_ke_local(E, G, A, Iy, Iz, J, L, Ay, Az)
            me = beam_me_local(rho, A, Iy, Iz, L)
            end = release_map.get(geid)
            if end:
                ke, me, keep = condense_release(ke, me, end)
                n_hinge += 1
            else:
                keep = list(range(12))
            Tk = T12[np.ix_(keep, keep)]
            kg = Tk.T @ ke @ Tk
            mg = Tk.T @ me @ Tk
            gd = [(e[0] if i < 6 else e[1]) * 6 + i % 6 for i in keep]
            for a in range(len(gd)):
                K[gd[a], gd[a]] += kg[a, a]
                M[gd[a], gd[a]] += mg[a, a]
                for b in range(a + 1, len(gd)):
                    K[gd[a], gd[b]] += kg[a, b]
                    K[gd[b], gd[a]] += kg[a, b]
                    M[gd[a], gd[b]] += mg[a, b]
                    M[gd[b], gd[a]] += mg[a, b]
    print(f"[assemble] 单元组装完成 (铰接凝聚 {n_hinge}), "
          f"{time.time() - t_start:.1f}s")

    # ---- 点质量/转动惯量 ----
    for pm in r.get('point_mass', []):
        n0 = (pm['gid'] - 1) * 6
        if pm['kind'] == 'mass':
            for d in range(3):
                M[n0 + d, n0 + d] += pm['mass']
            print(f"[mass] 节点 {pm['gid']}: m={pm['mass']} t")
        else:
            for d in range(3):
                M[n0 + 3 + d, n0 + 3 + d] += pm['inertia'][d]
            print(f"[mass] 节点 {pm['gid']}: I={pm['inertia'][:3]}")

    K = K.tocsr()
    M = M.tocsr()

    # ---- MPC BEAM 约束变换矩阵 G (ndof × nfree) ----
    master_of = {}
    for link in r.get('mpc_links', []):
        master_of[link['slave']] = link['master']

    def exo_set(name):
        for cand in nsets:
            if cand == name or cand.startswith(f"{name}__"):
                return cand
        return name

    fixed_dofs = []
    accel_dofs = []
    amp_name = scale = None
    for b in step['boundaries']:
        nodes = nsets[exo_set(b['set'])]
        if b.get('amplitude'):
            amp_name, scale = b['amplitude'], b['value']
            for nid in nodes:
                accel_dofs.append((nid - 1) * 6 + b['dof1'] - 1)
        else:
            for nid in nodes:
                for dof in range(b['dof1'], b['dof2'] + 1):
                    fixed_dofs.append((nid - 1) * 6 + dof - 1)
    accel_dofs = sorted(set(accel_dofs))
    fixed_dofs = sorted(set(fixed_dofs))
    constrained = set(fixed_dofs) | set(accel_dofs)
    elim_dofs = set()
    elim_map = {}                        # elim dof -> [(free dof, w)]
    for s, m0 in master_of.items():
        rvec = coords[s - 1] - coords[m0 - 1]
        sd, md = (s - 1) * 6, (m0 - 1) * 6
        # u_s = u_m + θ_m × rvec;  θ×r = [θy rz−θz ry, θz rx−θx rz, θx ry−θy rx]
        W = np.array([[0, rvec[2], -rvec[1]],
                      [-rvec[2], 0, rvec[0]],
                      [rvec[1], -rvec[0], 0]])    # W @ θ = θ × r
        for d in range(3):
            elim_map[sd + d] = [(md + d, 1.0)] + [(md + 3 + k, W[d, k])
                                                  for k in range(3)]
            elim_map[sd + 3 + d] = [(md + 3 + d, 1.0)]
    elim_dofs = set(elim_map)

    free = [d for d in range(ndof)
            if d not in constrained and d not in elim_dofs]
    Kd = K.diagonal()
    Md = M.diagonal()
    dangling = [d for d in free if abs(Kd[d]) < 1e-12 and abs(Md[d]) < 1e-12]
    if dangling:
        print(f"[bc] {len(dangling)} 个悬空 dof → 固定")
        constrained.update(dangling)
        free = [d for d in free if d not in constrained]
    fidx = {d: i for i, d in enumerate(free)}
    nfree = len(free)
    print(f"[dof] 总={ndof} 自由={nfree} MPC消元={len(elim_dofs)} "
          f"约束={len(constrained)} (其中加速度 {len(accel_dofs)})")

    # G 的行: free→单位; elim→master 组合; constrained→空
    rows, cols, vals = [], [], []
    for d in free:
        rows.append(d)
        cols.append(fidx[d])
        vals.append(1.0)
    for d, combo in elim_map.items():
        for md, w in combo:
            if md in fidx:
                rows.append(d)
                cols.append(fidx[md])
                vals.append(w)
    G = csr_matrix((vals, (rows, cols)), shape=(ndof, nfree))

    Kf = (G.T @ K @ G).tocsr()
    Mf = (G.T @ M @ G).tocsr()
    acol = np.array(accel_dofs)
    Kfc = (G.T @ K[:, acol]).tocsr()
    Mfc = (G.T @ M[:, acol]).tocsr()
    print(f"[reduce] {time.time() - t_start:.1f}s")

    # ---- 阻尼 & Newmark ----
    Cf = eta * Mf + zeta * Kf
    Cfc = eta * Mfc + zeta * Kfc
    a0 = 1.0 / (NEWMARK_BETA * dt * dt)
    a1 = NEWMARK_GAMMA / (NEWMARK_BETA * dt)
    a2 = 1.0 / (NEWMARK_BETA * dt)
    a3 = 1.0 / (2 * NEWMARK_BETA) - 1.0
    a4 = NEWMARK_GAMMA / NEWMARK_BETA - 1.0
    a5 = dt * (NEWMARK_GAMMA / (2 * NEWMARK_BETA) - 1.0)
    A = a0 * Mf + a1 * Cf + Kf
    print("[factor] 稀疏 LU ...")
    lu = splu(A.tocsc())
    print(f"[factor] 完成 {time.time() - t_start:.1f}s")

    # ---- 特征频率校核 ----
    try:
        w2 = eigsh(Kf, k=6, M=Mf, sigma=0.01, which='LM', maxiter=5000,
                   return_eigenvectors=False)
        freqs = np.sqrt(np.maximum(w2, 0)) / (2 * np.pi)
        print(f"[eig] 前 6 阶频率 (Hz): {np.sort(freqs).round(3)}")
    except Exception as ex:
        print(f"[eig] 跳过: {ex}")
    if args.save_matrices:
        from scipy.sparse import save_npz
        save_npz(args.save_matrices.replace('.npz', '_K.npz'), Kf)
        save_npz(args.save_matrices.replace('.npz', '_M.npz'), Mf)
        print(f"[save] 矩阵已导出 {args.save_matrices}_{{K,M}}.npz")

    # ---- 地面加速度插值 ----
    amp = np.array(r['amplitudes'][amp_name])
    at, av = amp[:, 0], amp[:, 1]

    def ground_accel(t):
        return scale * float(np.interp(t, at, av))

    # ---- 时程积分 ----
    u = np.zeros(nfree)
    v = np.zeros(nfree)
    acc = np.zeros(nfree)
    ug = vg = 0.0
    out_every = args.output_interval
    frames = []
    times = []
    ug_frames = []
    top_dof = None
    for pm in r.get('point_mass', []):
        top_dof = (pm['gid'] - 1) * 6
        break
    top_hist = []
    print(f"[solve] {nsteps} 步 dt={dt} T={T} ...")
    ts0 = time.time()
    for n in range(nsteps):
        t_new = (n + 1) * dt
        ag0 = ground_accel(n * dt)
        ag1 = ground_accel(t_new)
        ug1 = ug + dt * vg + dt * dt * ((0.5 - NEWMARK_BETA) * ag0
                                        + NEWMARK_BETA * ag1)
        vg1 = vg + dt * ((1 - NEWMARK_GAMMA) * ag0 + NEWMARK_GAMMA * ag1)
        b = (Mf @ (a0 * u + a2 * v + a3 * acc) +
             Cf @ (a1 * u + a4 * v + a5 * acc) -
             Kfc @ (np.full(len(accel_dofs), ug1)) -
             Cfc @ (np.full(len(accel_dofs), vg1)) -
             Mfc @ (np.full(len(accel_dofs), ag1)))
        u1 = lu.solve(b)
        acc1 = a0 * (u1 - u) - a2 * v - a3 * acc
        v1 = v + dt * ((1 - NEWMARK_GAMMA) * acc + NEWMARK_GAMMA * acc1)
        u, v, acc = u1, v1, acc1
        ug, vg = ug1, vg1
        top_hist.append(u[fidx[top_dof]] if top_dof in fidx else np.nan)
        if (n + 1) % out_every == 0 or n == nsteps - 1:
            frames.append(u.copy())
            ug_frames.append(ug)
            times.append(t_new)
        if (n + 1) % 500 == 0:
            print(f"  {n + 1}/{nsteps} t={t_new:.1f}s "
                  f"({time.time() - ts0:.0f}s) max|u|={np.abs(u).max():.3g}")

    peak = np.nanmax(np.abs(top_hist))
    print(f"[solve] 完成 {time.time() - ts0:.0f}s, "
          f"顶点 |disp_x| 峰值 = {peak:.4g} mm")

    if args.csv:
        with open(args.csv, 'w') as f:
            f.write('time,top_disp_x\n')
            for n, val in enumerate(top_hist):
                f.write(f"{(n + 1) * dt},{val}\n")

    # ---- 重构全自由度并写 Exodus ----
    print("[write] Exodus ...")
    nfr = len(frames)
    U6 = np.zeros((nfr, nnode, 6))
    Fr = np.array(frames)                # (nfr, nfree)
    for d in free:
        U6[:, d // 6, d % 6] = Fr[:, fidx[d]]
    for d in accel_dofs:
        U6[:, d // 6, d % 6] = np.array(ug_frames)
    for d, combo in elim_map.items():
        acc_vec = np.zeros(nfr)
        for md, w in combo:
            if md in fidx:
                acc_vec += w * Fr[:, fidx[md]]
            elif md in accel_dofs:
                acc_vec += w * np.array(ug_frames)
        U6[:, d // 6, d % 6] = acc_vec
    write_exodus_result(args.mesh, args.out, U6, times)
    print(f"完成 ✓ 总耗时 {time.time() - t_start:.0f}s")


if __name__ == '__main__':
    main()
