# ============================================================================
# Abaqus 8elc → MOOSE 转换算例 v1
# 排架结构 (paijia, 混凝土 con CDP→线弹性简化) + 槽身 (caoshen_dangkuai, con)
#   + 钢梁 (gangliang, 钢 solid) + 钢筋 T3D2 ×10 块 (不进求解, 宿主插值后处理)
#
# 网格: outputs/abaqus_8elc/abaqus_8elc_mesh.e
#   (tools/abaqus2exodus.py 由 8elc.inp 转换; GBK→UTF-8 预转码)
# 单位: mm-t-N-MPa-s (与 Abaqus 源模型一致)
#
# Abaqus → MOOSE 映射 (沿用 6-15 v4 决策, 见 docs/ABAQUUS_PIPELINE.md):
#   *Tie ×10 (adjust=yes)        → 转换器节点缝合 (--tie-tol 20)
#   *Embedded Element            → 纯实体求解 + 宿主插值后处理
#   接触对 Int-1/2 (槽身↔排架)   → tools/stitch_interface.py 界面缝合
#     (259 对, tol=30mm, 防翻转回滚 0; 跨空段 346 节点正确跳过)
#   *Tie GL-1..5 (钢梁↔槽身)     → 转换器缝合 20 对 + stitch_interface 20 对
#   接触对 Int-3..6 (侧向)        → 简化: 忽略 (侧壁约束次要)
#   约束路线备忘: TiedValueConstraint 定点迭代收敛慢且失收 (~50s/步);
#     LinearNodalConstraint 本版 MOOSE 雅可比装配问题 (Newton 方向不降残差);
#     最终回归 6-15 验证过的网格缝合路线 (纯线性, Newton 1 步收敛)
#   con CDP                      → 简化: 线弹性 E=30000 ν=0.2 (CDP 曲线在
#                                  report.json, 后续可换 ScalarMaterialDamage)
#   steel *Plastic 400→696       → 线弹性 E=200000 ν=0.3 (gangliang 实体);
#                                  钢筋应力后处理按 *Plastic 弹塑性截断
#
# 分析步合并 (Abaqus Step-1 静力 + ELC 动力 → 单动力步):
#   重力: BodyForce 0→0.5s 线性爬坡后保持 (ρ·9800 mm/s², -z)
#   基底地震动: PrescribedAcceleration on bottom 节点集 ×3 分量
#     幅值 = amp_{X,Y,Z}.csv (Abaqus *Amplitude, dt=0.00125s) × 7840 mm/s²
#     峰值: X 0.80g@2.87s, Y 0.68g@0.54s, Z 0.52g@0.25s
#   Newmark β=0.25 γ=0.5 无阻尼, dt=0.005s, 强震段 0→4s (800 步)
# ============================================================================

[Mesh]
  [file]
    type = FileMeshGenerator
    file = ../outputs/abaqus_8elc/abaqus_8elc_mesh.e
  []
  # v4 决策: 求解不含钢筋 (零丢失; 位移/应力由宿主插值后处理)
  [del_rebar]
    type = BlockDeletionGenerator
    input = file
    block = 'caoshen_jin_all__steel_A154 caoshen_jin_all__steel_A50
             dangkuai_jin__steel_A3 dangkuai_jin__steel_A50
             gailiang_jin__steel_A3 gailiang_jin__steel_A50
             lianxiliang_jin__steel_A3 lianxiliang_jin__steel_A50
             zhu_jin__steel_A3 zhu_jin__steel_A50'
  []
  # TiedValueConstraint 主面需要 sideset: 只转换 3 个界面 nodeset
  # (nodesets_to_convert 限定, 避免 0D 侧面混入 — 6-15 经验)
  #   SURF__PickedSurf2123/2121: paijia 盖梁顶面 z=2570 (接触 Int-1/2 主面)
  #   CAOSHEN_TOP: 槽身顶面 z=3945 (tools/add_interface_sets.py 追加)
  [interface_sidesets]
    type = SideSetsFromNodeSetsGenerator
    input = del_rebar
    nodesets_to_convert = 'SURF__PickedSurf2123 SURF__PickedSurf2121 CAOSHEN_TOP'
  []
[]

[Problem]
  kernel_coverage_check = false
  material_coverage_check = false
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [disp_x][]
  [disp_y][]
  [disp_z][]
[]

[AuxVariables]
  [vel_x][]
  [vel_y][]
  [vel_z][]
  [accel_x][]
  [accel_y][]
  [accel_z][]
  [vonmises]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Kernels]
  [TensorMechanics]
    block = 'paijia__con caoshen_dangkuai__con gangliang__steel'
  []
  [inertial_x]
    type = InertialForce
    variable = disp_x
    velocity = vel_x
    acceleration = accel_x
    beta = 0.25
    gamma = 0.5
    block = 'paijia__con caoshen_dangkuai__con gangliang__steel'
  []
  [inertial_y]
    type = InertialForce
    variable = disp_y
    velocity = vel_y
    acceleration = accel_y
    beta = 0.25
    gamma = 0.5
    block = 'paijia__con caoshen_dangkuai__con gangliang__steel'
  []
  [inertial_z]
    type = InertialForce
    variable = disp_z
    velocity = vel_z
    acceleration = accel_z
    beta = 0.25
    gamma = 0.5
    block = 'paijia__con caoshen_dangkuai__con gangliang__steel'
  []
  # 重力 (Abaqus Step-1 GRAV 9800 -z): 0→0.5s 爬坡, ρg 按块
  # 注: 钢梁 (gangliang) 不施加重力 — 其与槽身仅部分节点缝合 (40 对),
  # 重力会使梁跨中铰接下垂 (伪影); 钢梁质量小, 地震响应由锚点驱动
  # 重力 (Abaqus Step-1 GRAV 9800 -z): 0→0.5s 爬坡, ρg 按块
  [gravity_con]
    type = BodyForce
    variable = disp_z
    value = -2.5872e-5   # 2.64e-9 t/mm³ × 9800 mm/s²
    function = gravity_ramp
    block = 'paijia__con caoshen_dangkuai__con'
  []
[]

[BCs]
  # ELC step: bottom 节点集三向基底加速度 (×7840 mm/s²)
  [seismic_x]
    type = PresetAcceleration
    variable = disp_x
    velocity = vel_x
    acceleration = accel_x
    beta = 0.25
    boundary = 'bottom__paijia_1 bottom__paijia_1_lin_2_1'
    function = amp_x
  []
  [seismic_y]
    type = PresetAcceleration
    variable = disp_y
    velocity = vel_y
    acceleration = accel_y
    beta = 0.25
    boundary = 'bottom__paijia_1 bottom__paijia_1_lin_2_1'
    function = amp_y
  []
  [seismic_z]
    type = PresetAcceleration
    variable = disp_z
    velocity = vel_z
    acceleration = accel_z
    beta = 0.25
    boundary = 'bottom__paijia_1 bottom__paijia_1_lin_2_1'
    function = amp_z
  []
[]


[Functions]
  [gravity_ramp]
    type = ParsedFunction
    expression = 'if(t<0.5, t/0.5, 1)'
  []
  # Abaqus *Amplitude X/Y/Z (原始采样 dt=0.00125s, 截取 0→4.2s)
  [amp_x]
    type = PiecewiseLinear
    data_file = ../outputs/abaqus_8elc/amp_X.csv
    format = columns
    scale_factor = 7840
  []
  [amp_y]
    type = PiecewiseLinear
    data_file = ../outputs/abaqus_8elc/amp_Y.csv
    format = columns
    scale_factor = 7840
  []
  [amp_z]
    type = PiecewiseLinear
    data_file = ../outputs/abaqus_8elc/amp_Z.csv
    format = columns
    scale_factor = 7840
  []
[]

[AuxKernels]
  [accel_x_aux]
    type = NewmarkAccelAux
    variable = accel_x
    displacement = disp_x
    velocity = vel_x
    beta = 0.25
    execute_on = 'TIMESTEP_END'
  []
  [vel_x_aux]
    type = NewmarkVelAux
    variable = vel_x
    acceleration = accel_x
    gamma = 0.5
    execute_on = 'TIMESTEP_END'
  []
  [accel_y_aux]
    type = NewmarkAccelAux
    variable = accel_y
    displacement = disp_y
    velocity = vel_y
    beta = 0.25
    execute_on = 'TIMESTEP_END'
  []
  [vel_y_aux]
    type = NewmarkVelAux
    variable = vel_y
    acceleration = accel_y
    gamma = 0.5
    execute_on = 'TIMESTEP_END'
  []
  [accel_z_aux]
    type = NewmarkAccelAux
    variable = accel_z
    displacement = disp_z
    velocity = vel_z
    beta = 0.25
    execute_on = 'TIMESTEP_END'
  []
  [vel_z_aux]
    type = NewmarkVelAux
    variable = vel_z
    acceleration = accel_z
    gamma = 0.5
    execute_on = 'TIMESTEP_END'
  []
  [vonmises]
    type = RankTwoScalarAux
    variable = vonmises
    rank_two_tensor = stress
    scalar_type = VonMisesStress
    block = 'paijia__con caoshen_dangkuai__con gangliang__steel'
    execute_on = TIMESTEP_END
  []
[]

[Materials]
  # --- con (CDP 简化为线弹性): E=30000 MPa, ν=0.2, ρ=2.64e-9 t/mm³
  [elasticity_con]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 30000.0
    poissons_ratio = 0.2
    block = 'paijia__con caoshen_dangkuai__con'
  []
  [stress_con]
    type = ComputeLinearElasticStress
    block = 'paijia__con caoshen_dangkuai__con'
  []
  [density_con]
    type = GenericConstantMaterial
    prop_names = density
    prop_values = 2.64e-9
    block = 'paijia__con caoshen_dangkuai__con'
  []
  # --- steel (gangliang 实体): E=200000 MPa, ν=0.3, ρ=7.85e-9
  [elasticity_steel]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 200000.0
    poissons_ratio = 0.3
    block = 'gangliang__steel'
  []
  [stress_steel]
    type = ComputeLinearElasticStress
    block = 'gangliang__steel'
  []
  [density_steel]
    type = GenericConstantMaterial
    prop_names = density
    prop_values = 7.85e-9
    block = 'gangliang__steel'
  []
  [strain_all]
    type = ComputeSmallStrain
    block = 'paijia__con caoshen_dangkuai__con gangliang__steel'
  []
[]

[Postprocessors]
  [vonmises_max]
    type = ElementExtremeValue
    variable = vonmises
  []
  [disp_x_max]
    type = NodalExtremeValue
    variable = disp_x
  []
  [disp_z_max]
    type = NodalExtremeValue
    variable = disp_z
  []
[]

[Executioner]
  type = Transient
  # 线弹性+Newmark 为线性问题: NEWTON 真 Jacobian 每步 1 次 Newton
  # (PJFNK 矩阵-向量积靠残差估值, 每步 ~50 次残差, 慢 4.4 倍 — 烟测实定)
  solve_type = 'NEWTON'
  [TimeIntegrator]
    type = NewmarkBeta
    beta = 0.25
    gamma = 0.5
  []
  # 多材料大刚度比 → MUMPS 直接求解 (6-15 经验)
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu mumps'
  # 罚约束提高系统刚性: 容差放宽 (1e-6 会钉在 1.7e-6 平台爬行 — 实测),
  # dtmin=dt 禁止自动切步 (实测切到 0.000625 会导致 800→6400 步)
  nl_rel_tol = 1.0e-3
  nl_abs_tol = 1.0e-4
  nl_max_its = 10
  l_max_its = 100
  dt = 0.005
  dtmin = 0.005
  end_time = 4.0
  automatic_scaling = true
[]

[Outputs]
  file_base = abaqus_8elc_out
  exodus = true
  csv = true
  perf_graph = true
[]
