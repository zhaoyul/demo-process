#!/usr/bin/env python3
# gen_beam_case.py — 依据 report.json 生成梁模型 MOOSE 动力学输入 (.i)
#
# 由 2026-08-10 PR-RG-400gal-X 算例提炼: 梁 (B31→BEAM2) + 瑞利阻尼 +
# 加速度地震边界 + MPC BEAM 刚性连杆 + 点质量/转动惯量。
#
# 用法:
#   tools/gen_beam_case.py --report outputs/<name>/report.json \
#       --mesh <mesh 文件名, 相对求解 cwd> --out inputs/<name>.i \
#       --amp-dir outputs/<name>
#
# 近似与映射约定 (重要):
#   - Abaqus I 截面: n1 ∥ 翼缘, h 沿 n2; MOOSE y_orientation = n1 (全局),
#     Iy = 绕 n1 惯性矩 (强轴), Iz = 绕 n2 (弱轴), Ix = J (圣维南扭转)
#   - *Damping beta (刚度比例) 无 MOOSE 梁对应 → HHT alpha=-0.05 近似
#   - *Damping alpha (质量比例) → InertialForceBeam/NodalInertia eta
#   - *RELEASE 端部释放未模拟 (结构略偏刚, 报告列出数量)
#   - MPC BEAM → mpc_beam_links 刚性梁块 (E 取 reactor 材料, 截面 100×)
#   - *Nonstructural Mass (MASS PER LENGTH) → 附加密度 Δρ = m'/A

import argparse
import json
import math
import os

HHT_ALPHA = 0.0                   # 不用 HHT; 刚度阻尼由 zeta 精确承担
NEWMARK_BETA = 0.25
NEWMARK_GAMMA = 0.5

# 刚性连杆截面 (相对 CIRC r141 放大 ~100× 刚度)
RIGID = {'A': 6.4e4, 'Iy': 3.1e10, 'Iz': 3.1e10, 'J': 6.2e10,
         'Ay': 0.0, 'Az': 0.0, 'mat': 'reactor', 'E_override': 2.06e7}


def circ_props(r):
    A = math.pi * r * r
    I = math.pi * r ** 4 / 4.0
    return {'A': A, 'Iy': I, 'Iz': I, 'J': 2 * I, 'Ay': 0.9 * A, 'Az': 0.9 * A}


def isect_props(dims):
    """Abaqus I 截面: l,h,b1,b2,t1,t2,t3 (l=参考轴到底边距离, 仅用于校核)"""
    l, h, b1, b2, t1, t2, t3 = dims
    hw = h - t1 - t2
    Af1, Af2, Aw = b1 * t1, b2 * t2, hw * t3
    A = Af1 + Af2 + Aw
    # 形心 (沿 n2 自底边)
    ybar = (Af1 * t1 / 2 + Aw * (t1 + hw / 2) + Af2 * (h - t2 / 2)) / A
    # I_n1 (绕 n1, 即强轴 — 翼缘 ∥ n1)
    In1 = (b1 * t1 ** 3 / 12 + Af1 * (ybar - t1 / 2) ** 2 +
           t3 * hw ** 3 / 12 + Aw * (t1 + hw / 2 - ybar) ** 2 +
           b2 * t2 ** 3 / 12 + Af2 * (h - t2 / 2 - ybar) ** 2)
    # I_n2 (弱轴)
    In2 = t1 * b1 ** 3 / 12 + t2 * b2 ** 3 / 12 + hw * t3 ** 3 / 12
    # 圣维南扭转常数 (开口薄壁近似)
    J = (b1 * t1 ** 3 + b2 * t2 ** 3 + hw * t3 ** 3) / 3.0
    return {'A': A, 'Iy': In1, 'Iz': In2, 'J': J,
            'Ay': A / 1.2, 'Az': A / 1.2, 'ybar': ybar}


def fmt(v):
    return f"{v:.6g}"


def main():
    ap = argparse.ArgumentParser(description='report.json → MOOSE 梁动力学 .i')
    ap.add_argument('--report', required=True)
    ap.add_argument('--mesh', required=True,
                    help='网格文件名 (相对求解工作目录)')
    ap.add_argument('--out', required=True, help='输出 .i 路径')
    ap.add_argument('--amp-dir', required=True,
                    help='幅值 CSV 输出目录 (相对求解工作目录引用)')
    ap.add_argument('--dt', type=float, default=None)
    ap.add_argument('--end-time', type=float, default=None)
    ap.add_argument('--output-interval', type=int, default=5)
    ap.add_argument('--file-base', default=None,
                    help='输出文件基名 (默认 <算例名>_out)')
    args = ap.parse_args()

    r = json.load(open(args.report))
    mats = r['materials']
    step = r['steps'][0]
    dyn = step.get('dynamic') or [0.01, 1.0]
    dt = args.dt or dyn[0]
    end_time = args.end_time or (dyn[1] if len(dyn) > 1 else 1.0)
    case = os.path.splitext(os.path.basename(args.out))[0]
    file_base = args.file_base or f"{case}_out"
    # MOOSE 按输入文件所在目录解析相对路径: 计算 amp_dir 相对 .i 的前缀
    amp_prefix = os.path.relpath(os.path.abspath(args.amp_dir),
                                 os.path.dirname(os.path.abspath(args.out)))

    # ---- 幅值导出 (加速度边界的时程) ----
    amp_files = {}
    for amp_name in {b['amplitude'] for b in step['boundaries']
                     if b.get('amplitude')}:
        pairs = r['amplitudes'].get(amp_name, [])
        csv_name = f"{amp_name.lower().replace('-', '_')}.csv"
        path = os.path.join(args.amp_dir, csv_name)
        with open(path, 'w') as f:
            for t, v in pairs:
                f.write(f"{t} {v}\n")
        amp_files[amp_name] = f"{amp_prefix}/{csv_name}"

    # ---- 非结构质量 → 附加密度 ----
    extra_rho = {}   # block -> Δρ
    for ns in r.get('nonstructural_mass', []):
        for blk in ns['per_block']:
            bs = r['beam_sections'].get(blk)
            if not bs:
                continue
            p = circ_props(bs['dims'][0]) if bs['section'] == 'CIRC' \
                else isect_props(bs['dims'])
            extra_rho[blk] = extra_rho.get(blk, 0.0) + ns['value'] / p['A']

    # ---- 块属性表 ----
    blocks = {}      # block -> dict(props...)
    for blk, bs in r['beam_sections'].items():
        if bs['section'] == 'RIGID':
            mat = mats[RIGID['mat']]
            blocks[blk] = {
                **RIGID, 'E': RIGID.get('E_override', mat['elastic'][0][0]),
                'nu': mat['elastic'][0][1],
                'rho': mat['density'][0][0], 'y_orient': bs['n1']}
            continue
        p = circ_props(bs['dims'][0]) if bs['section'] == 'CIRC' \
            else isect_props(bs['dims'])
        mat = mats[bs['material']]
        E, nu = mat['elastic'][0][0], mat['elastic'][0][1]
        rho = mat['density'][0][0] + extra_rho.get(blk, 0.0)
        blocks[blk] = {**p, 'E': E, 'nu': nu, 'rho': rho,
                       'y_orient': bs['n1']}

    beam_blks = [b for b in blocks if b != 'mpc_beam_links']
    all_blks = list(blocks)
    blk_str = " ".join(all_blks)

    eta = 0.0
    zeta = 0.0
    for mt in mats.values():
        if mt.get('damping'):
            eta = mt['damping'].get('alpha', eta)
            zeta = mt['damping'].get('beta', zeta)
            break

    # ---- 边界分组 ----
    fixed = {}       # nset -> [dofs]
    accel_bc = []    # (nset, dof, value, amplitude)
    for b in step['boundaries']:
        if b.get('amplitude'):
            accel_bc.append((b['set'], b['dof1'], b['value'], b['amplitude']))
        else:
            fixed.setdefault(b['set'], []).append(b['dof1'])
    # nset 名 → exodus 名 (instance 限定)
    def exo_set(name):
        for cand in r['nodesets']:
            if cand == name or cand.startswith(f"{name}__"):
                return cand
        return name

    DOF_VAR = {1: 'disp_x', 2: 'disp_y', 3: 'disp_z',
               4: 'rot_x', 5: 'rot_y', 6: 'rot_z'}
    VAR_COMP = {'disp_x': 0, 'disp_y': 1, 'disp_z': 2,
                'rot_x': 3, 'rot_y': 4, 'rot_z': 5}

    L = []
    A = L.append
    A(f"# {case}: Abaqus→MOOSE 梁模型地震时程分析 (自动生成)")
    A(f"# 源: {r['source']}")
    A("# 单位制: mm-t-N-s (应力 MPa, 加速度 mm/s²)")
    A("# 近似: *RELEASE 端部释放未模拟; 刚度比例阻尼以 "
      f"HHT alpha={HHT_ALPHA} 近似; MPC BEAM → 刚性连杆")
    A("")
    A("[Mesh]")
    A("  [file]")
    A("    type = FileMeshGenerator")
    A(f"    file = {args.mesh}")
    A("  []")
    A("  displacements = 'disp_x disp_y disp_z'")
    A("[]\n")

    A("[Variables]")
    for v in DOF_VAR.values():
        A(f"  [{v}]\n  []")
    A("[]\n")

    A("[AuxVariables]")
    for base in ('disp', 'rot'):
        for d in 'xyz':
            A(f"  [{'vel' if base == 'disp' else 'rot_vel'}_{d}]\n    "
              f"family = LAGRANGE\n    order = FIRST\n  []")
            A(f"  [{'accel' if base == 'disp' else 'rot_accel'}_{d}]\n    "
              f"family = LAGRANGE\n    order = FIRST\n  []")
    A("[]\n")

    A("[AuxKernels]")
    for d in 'xyz':
        A(f"  [accel_{d}]")
        A("    type = NewmarkAccelAux")
        A(f"    variable = accel_{d}")
        A(f"    displacement = disp_{d}")
        A(f"    velocity = vel_{d}")
        A(f"    beta = {fmt(NEWMARK_BETA)}")
        A("    execute_on = 'TIMESTEP_END'")
        A("  []")
        A(f"  [vel_{d}]")
        A("    type = NewmarkVelAux")
        A(f"    variable = vel_{d}")
        A(f"    acceleration = accel_{d}")
        A(f"    gamma = {fmt(NEWMARK_GAMMA)}")
        A("    execute_on = 'TIMESTEP_END'")
        A("  []")
        A(f"  [rot_accel_{d}]")
        A("    type = NewmarkAccelAux")
        A(f"    variable = rot_accel_{d}")
        A(f"    displacement = rot_{d}")
        A(f"    velocity = rot_vel_{d}")
        A(f"    beta = {fmt(NEWMARK_BETA)}")
        A("    execute_on = 'TIMESTEP_END'")
        A("  []")
        A(f"  [rot_vel_{d}]")
        A("    type = NewmarkVelAux")
        A(f"    variable = rot_vel_{d}")
        A(f"    acceleration = rot_accel_{d}")
        A(f"    gamma = {fmt(NEWMARK_GAMMA)}")
        A("    execute_on = 'TIMESTEP_END'")
        A("  []")
    A("[]\n")

    A("[Functions]")
    A("  [zero]")
    A("    type = ConstantFunction")
    A("    value = 0.0")
    A("  []")
    for amp_name, csv in amp_files.items():
        A(f"  [{amp_name.lower().replace('-', '_')}]")
        A("    type = PiecewiseLinear")
        A(f"    data_file = {csv}")
        A("    format = columns")
        A("  []")
    A("[]\n")

    # ---- Kernels ----
    A("[Kernels]")
    for var, comp in VAR_COMP.items():
        A(f"  [sd_{var}]")
        A("    type = StressDivergenceBeam")
        A(f"    block = '{blk_str}'")
        A("    displacements = 'disp_x disp_y disp_z'")
        A("    rotations = 'rot_x rot_y rot_z'")
        A(f"    component = {comp}")
        A(f"    variable = {var}")
        A(f"    zeta = {fmt(zeta)}")
        A(f"    alpha = {HHT_ALPHA}")
        A("  []")
    for blk in all_blks:
        bp = blocks[blk]
        for var, comp in VAR_COMP.items():
            A(f"  [if_{var}_{blk[-12:]}]" if len(all_blks) > 1
              else f"  [if_{var}]")
            A("    type = InertialForceBeam")
            A(f"    block = '{blk}'")
            A("    displacements = 'disp_x disp_y disp_z'")
            A("    rotations = 'rot_x rot_y rot_z'")
            A("    velocities = 'vel_x vel_y vel_z'")
            A("    accelerations = 'accel_x accel_y accel_z'")
            A("    rotational_accelerations = "
              "'rot_accel_x rot_accel_y rot_accel_z'")
            A("    rotational_velocities = "
              "'rot_vel_x rot_vel_y rot_vel_z'")
            A(f"    beta = {fmt(NEWMARK_BETA)}")
            A(f"    gamma = {fmt(NEWMARK_GAMMA)}")
            A(f"    eta = {fmt(eta)}")
            A(f"    alpha = {HHT_ALPHA}")
            A(f"    area = {fmt(bp['A'])}")
            A(f"    Iy = {fmt(bp['Iy'])}")
            A(f"    Iz = {fmt(bp['Iz'])}")
            A("    density = density")
            A(f"    component = {comp}")
            A(f"    variable = {var}")
            A("  []")
    A("[]\n")

    # ---- NodalKernels: 点质量 + 转动惯量 ----
    A("[NodalKernels]")
    pset172 = exo_set('_PickedSet172')
    for pm in r.get('point_mass', []):
        if pm['kind'] == 'mass':
            for d in 'xyz':
                A(f"  [mass_{d}]")
                A("    type = NodalTranslationalInertia")
                A(f"    variable = disp_{d}")
                A(f"    boundary = '{pset172}'")
                A(f"    mass = {fmt(pm['mass'])}")
                A(f"    velocity = vel_{d}")
                A(f"    acceleration = accel_{d}")
                A(f"    beta = {fmt(NEWMARK_BETA)}")
                A(f"    gamma = {fmt(NEWMARK_GAMMA)}")
                A(f"    eta = {fmt(eta)}")
                A(f"    alpha = {HHT_ALPHA}")
                A("  []")
        elif pm['kind'] == 'rotary':
            I = pm['inertia']
            for ci, d in enumerate('xyz'):
                A(f"  [rotin_{d}]")
                A("    type = NodalRotationalInertia")
                A(f"    variable = rot_{d}")
                A(f"    boundary = '{pset172}'")
                A("    rotations = 'rot_x rot_y rot_z'")
                A("    rotational_velocities = "
                  "'rot_vel_x rot_vel_y rot_vel_z'")
                A("    rotational_accelerations = "
                  "'rot_accel_x rot_accel_y rot_accel_z'")
                A(f"    Ixx = {fmt(I[0])}")
                A(f"    Iyy = {fmt(I[1])}")
                A(f"    Izz = {fmt(I[2])}")
                A(f"    Ixy = {fmt(I[3])}")
                A(f"    Ixz = {fmt(I[4])}")
                A(f"    Iyz = {fmt(I[5])}")
                A(f"    component = {ci}")
                A(f"    beta = {fmt(NEWMARK_BETA)}")
                A(f"    gamma = {fmt(NEWMARK_GAMMA)}")
                A(f"    eta = {fmt(eta)}")
                A(f"    alpha = {HHT_ALPHA}")
                A("  []")
    A("[]\n")

    # ---- BCs ----
    A("[BCs]")
    for nset, dofs in fixed.items():
        for dof in sorted(set(dofs)):
            var = DOF_VAR[dof]
            d = var[-1]
            is_rot = var.startswith('rot')
            A(f"  [fix_{var}]")
            A("    type = PresetDisplacement")
            A(f"    variable = {var}")
            A(f"    boundary = '{exo_set(nset)}'")
            A("    function = zero")
            A(f"    velocity = {'rot_vel' if is_rot else 'vel'}_{d}")
            A(f"    acceleration = {'rot_accel' if is_rot else 'accel'}_{d}")
            A(f"    beta = {fmt(NEWMARK_BETA)}")
            A("  []")
    for nset, dof, val, amp in accel_bc:
        var = DOF_VAR[dof]
        fn = amp.lower().replace('-', '_')
        A(f"  [accel_bc_{var}]")
        A("    type = PresetAcceleration")
        A(f"    variable = {var}")
        A(f"    boundary = '{exo_set(nset)}'")
        A(f"    function = {fn}")
        A(f"    scale_factor = {fmt(val)}")
        A(f"    velocity = vel_{var[-1]}")
        A(f"    acceleration = accel_{var[-1]}")
        A(f"    beta = {fmt(NEWMARK_BETA)}")
        A("  []")
    A("[]\n")

    # ---- Materials ----
    A("[Materials]")
    for blk in all_blks:
        bp = blocks[blk]
        A(f"  [elasticity_{blk[-12:]}]")
        A("    type = ComputeElasticityBeam")
        A(f"    block = '{blk}'")
        A(f"    youngs_modulus = {fmt(bp['E'])}")
        A(f"    poissons_ratio = {fmt(bp['nu'])}")
        A("    shear_coefficient = 1.0")
        A("  []")
        A(f"  [resultants_{blk[-12:]}]")
        A("    type = ComputeBeamResultants")
        A(f"    block = '{blk}'")
        A("  []")
        A(f"  [strain_{blk[-12:]}]")
        A("    type = ComputeIncrementalBeamStrain")
        A(f"    block = '{blk}'")
        A("    displacements = 'disp_x disp_y disp_z'")
        A("    rotations = 'rot_x rot_y rot_z'")
        A(f"    area = {fmt(bp['A'])}")
        A(f"    Ay = {fmt(bp['Ay'])}")
        A(f"    Az = {fmt(bp['Az'])}")
        A(f"    Ix = {fmt(bp['J'])}")
        A(f"    Iy = {fmt(bp['Iy'])}")
        A(f"    Iz = {fmt(bp['Iz'])}")
        yo = bp['y_orient']
        A(f"    y_orientation = '{fmt(yo[0])} {fmt(yo[1])} {fmt(yo[2])}'")
        A("  []")
        A(f"  [density_{blk[-12:]}]")
        A("    type = GenericConstantMaterial")
        A(f"    block = '{blk}'")
        A("    prop_names = 'density'")
        A(f"    prop_values = '{fmt(bp['rho'])}'")
        A("  []")
    A("[]\n")

    A("[Executioner]")
    A("  type = Transient")
    A("  # NEWTON: 残差~1e-6 N 触底即收 (rel 1e-3); 个别步不收时接受当前解")
    A("  # (LINEAR 对本模型积分不稳定 — 某 kernel Jacobian 非精确, 勿用)")
    A("  solve_type = NEWTON")
    A(f"  dt = {fmt(dt)}")
    A(f"  end_time = {fmt(end_time)}")
    A("  [TimeIntegrator]")
    A("    type = NewmarkBeta")
    A(f"    beta = {fmt(NEWMARK_BETA)}")
    A(f"    gamma = {fmt(NEWMARK_GAMMA)}")
    A("  []")
    A("  petsc_options_iname = '-pc_type -ksp_type -snes_linesearch_type'")
    A("    petsc_options_value = 'lu      preonly   basic'")
    A("  nl_rel_tol = 1e-3")
    A("  nl_abs_tol = 1e-4")
    A("  l_tol = 1e-8")
    A("  nl_max_its = 8")
    A("  abort_on_solve_fail = false")
    A("  dtmin = 1e-6")
    A("[]\n")

    # 顶点 (主节点) 位移时程 — 结果校核用
    pm_xyz = None
    for pm in r.get('point_mass', []):
        pm_xyz = pm['xyz']
        break
    if pm_xyz:
        A("[Postprocessors]")
        A("  [top_disp_x]")
        A("    type = PointValue")
        A("    variable = disp_x")
        A(f"    point = '{fmt(pm_xyz[0])} {fmt(pm_xyz[1])} {fmt(pm_xyz[2])}'")
        A("  []")
        A("[]\n")

    A("[Outputs]")
    A(f"  file_base = {file_base}")
    A("  exodus = true")
    A("  csv = true")
    A("  print_linear_residuals = false")
    A("[]")

    with open(args.out, 'w') as f:
        f.write("\n".join(L) + "\n")

    # 摘要
    print(f"✓ 生成 {args.out}")
    print(f"  时间: dt={dt}, T={end_time} ({int(end_time / dt)} 步), "
          f"Newmark β={NEWMARK_BETA:.6f} γ={NEWMARK_GAMMA} + HHT α={HHT_ALPHA}")
    print(f"  质量比例阻尼 eta={eta}")
    print(f"  幅值: {', '.join(f'{k}→{v}' for k, v in amp_files.items())}")
    print(f"  块截面/材料/密度:")
    for blk in all_blks:
        bp = blocks[blk]
        print(f"    {blk}: A={bp['A']:.4g} Iy={bp['Iy']:.4g} "
              f"Iz={bp['Iz']:.4g} J={bp['J']:.4g} E={bp['E']:.4g} "
              f"ρ={bp['rho']:.4g} y_orient={bp['y_orient']}")
    n_rel = sum(len(v) for v in r.get('releases', {}).values())
    if n_rel:
        print(f"  ⚠ 未模拟: {n_rel} 处 *RELEASE 端部释放 (结构略偏刚)")


if __name__ == '__main__':
    main()
