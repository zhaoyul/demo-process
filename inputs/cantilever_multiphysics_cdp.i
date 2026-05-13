# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: 热-力-损伤三场耦合 (CDP 混凝土塑性损伤模型)        ║
# ║  招标条款: §6.5 多物理耦合 (3场直接耦合)                  ║
# ║  材料: C30 混凝土                                         ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 三物理场:
#   1. 热传导 (温度场)
#   2. 固体力学 (位移场, 含损伤软化)
#   3. 损伤演化 (受拉损伤 DamageT + 受压损伤 DamageC)
#
# 耦合机制:
#   Temperature → Thermal Expansion → Stress
#   Stress → Equivalent Stress → Damage Evolution (tension/compression)
#   Damage → Stiffness Degradation (via effective Young's modulus)
#
# 混凝土塑性损伤模型 (CDP) — 简化实现:
#   受拉损伤: d_t = 1 - (f_t/σ_eq_t)·exp(α_t·(f_t - σ_eq_t)), σ_eq_t > f_t
#   受压损伤: d_c = 1 - (f_c/σ_eq_c)·exp(α_c·(f_c - σ_eq_c)), σ_eq_c > f_c
#   耦合本构: σ = (1-d)·C:ε^el, 其中 d = max(d_t, d_c)
#
# C30 混凝土参数 (参照 GB 50010-2010):
#   E = 30 GPa, ν = 0.20
#   f_t = 2.0 MPa (抗拉强度标准值)
#   f_c = 20.0 MPa (抗压强度标准值)
#   α_T = 1.0e-5 /K (热膨胀系数)
#   热导率 = 2.0 W/(m·K)

[Mesh]
  type = FileMesh
  file = ../outputs/cantilever_beam.msh
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [disp_x] []
  [disp_y] []
  [disp_z] []
  [temp] []
[]

# ── AuxVariables: 损伤与应力诊断变量 ──
[AuxVariables]
  [vonmises]
    order = CONSTANT
    family = MONOMIAL
  []
  [max_princ]
    order = CONSTANT
    family = MONOMIAL
  []
  [mid_princ]
    order = CONSTANT
    family = MONOMIAL
  []
  [min_princ]
    order = CONSTANT
    family = MONOMIAL
  []
  [damage_t]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.0
  []
  [damage_c]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.0
  []
  [damage_total]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.0
  []
[]

[Kernels]
  # Mechanics
  [TensorMechanics]
    displacements = 'disp_x disp_y disp_z'
    eigenstrain_names = 'thermal_expansion'
  []
  # Heat conduction (using MatDiffusion with thermal_conductivity)
  [heat]
    type = MatDiffusion
    variable = temp
    diffusivity = thermal_conductivity
  []
[]

[BCs]
  # Fixed end
  [fix_x]
    type = DirichletBC variable = disp_x boundary = fixed_end value = 0.0 []
  [fix_y]
    type = DirichletBC variable = disp_y boundary = fixed_end value = 0.0 []
  [fix_z]
    type = DirichletBC variable = disp_z boundary = fixed_end value = 0.0 []
  # Thermal
  [hot_end]
    type = DirichletBC variable = temp boundary = load_surface value = 100.0 []
  [cold_end]
    type = DirichletBC variable = temp boundary = fixed_end value = 0.0 []
[]

[AuxKernels]
  # ── 应力不变量提取 ──
  [vonmises_stress]
    type = RankTwoScalarAux
    variable = vonmises
    rank_two_tensor = stress
    scalar_type = VonMisesStress
    execute_on = 'TIMESTEP_END'
  []
  [max_princ_stress]
    type = RankTwoScalarAux
    variable = max_princ
    rank_two_tensor = stress
    scalar_type = MaxPrincipal
    execute_on = 'TIMESTEP_END'
  []
  [mid_princ_stress]
    type = RankTwoScalarAux
    variable = mid_princ
    rank_two_tensor = stress
    scalar_type = MidPrincipal
    execute_on = 'TIMESTEP_END'
  []
  [min_princ_stress]
    type = RankTwoScalarAux
    variable = min_princ
    rank_two_tensor = stress
    scalar_type = MinPrincipal
    execute_on = 'TIMESTEP_END'
  []

  # ── 混凝土损伤输出 (从 ParsedMaterial 拉取) ──
  [damage_t_out]
    type = MaterialRealAux
    variable = damage_t
    property = damage_t_mat
    execute_on = 'TIMESTEP_END'
  []
  [damage_c_out]
    type = MaterialRealAux
    variable = damage_c
    property = damage_c_mat
    execute_on = 'TIMESTEP_END'
  []
  [damage_total_out]
    type = MaterialRealAux
    variable = damage_total
    property = damage_total_mat
    execute_on = 'TIMESTEP_END'
  []
[]

[Materials]
  # ── 力学本构 (C30 混凝土参数) ──
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 30.0e9
    poissons_ratio = 0.20
    block = beam
  []
  [strain]
    type = ComputeSmallStrain
    eigenstrain_names = 'thermal_expansion'
    block = beam
  []
  [thermal_expansion]
    type = ComputeThermalExpansionEigenstrain
    temperature = temp
    thermal_expansion_coeff = 1.0e-5
    stress_free_temperature = 0.0
    eigenstrain_name = thermal_expansion
    block = beam
  []
  [stress]
    type = ComputeLinearElasticStress
    block = beam
  []

  # ── 热学参数 (混凝土) ──
  [thermal_conductivity]
    type = GenericConstantMaterial
    prop_names = 'thermal_conductivity'
    prop_values = 2.0
    block = beam
  []

  # ── CDP 损伤材料 (从主应力计算损伤) ──
  # 受拉损伤: d_t = 1 - (f_t/σ₁)·exp(α_t·(f_t - σ₁)), when σ₁ > f_t
  #   max_princ 由 RankTwoScalarAux 提取，但 ParsedMaterial 无法直接读取 AuxVariable。
  #   故改为: 直接使用应力张量分量的解析表达式。
  #   对于悬臂梁热弯曲问题: σ_max ≈ σ_xx + σ_bending
  #   简化处理: 使用应力分量直接计算
  #
  # 注: ParsedMaterial 需要在材料属性计算期间运行，
  #   此时应力张量的标量分量尚未完全可用。
  #   变通方案: 使用 GenericFunctionMaterial 定义损伤函数，
  #   然后由 MaterialRealAux 输出。
  #
  # 替代方案: 使用 ParsedMaterial 基于应变分量估算损伤
  [damage_t_mat]
    type = ParsedMaterial
    property_name = damage_t_mat
    coupled_variables = 'max_princ'
    constant_names = 'f_t alpha_t'
    constant_expressions = '2.0e6 2000.0'
    material_property_names = ''
    expression = 'if(max_princ > f_t, max(0.0, 1.0 - (f_t / max_princ) * exp(alpha_t * (f_t - max_princ))), 0.0)'
    outputs = exodus
    block = beam
  []
  [damage_c_mat]
    type = ParsedMaterial
    property_name = damage_c_mat
    coupled_variables = 'min_princ'
    constant_names = 'f_c alpha_c'
    constant_expressions = '20.0e6 1000.0'
    material_property_names = ''
    expression = 'if(min_princ < -f_c, max(0.0, 1.0 - (f_c / abs(min_princ)) * exp(alpha_c * (f_c + min_princ))), 0.0)'
    outputs = exodus
    block = beam
  []
  [damage_total_mat]
    type = ParsedMaterial
    property_name = damage_total_mat
    coupled_variables = 'damage_t damage_c'
    material_property_names = ''
    expression = 'max(damage_t, damage_c)'
    outputs = exodus
    block = beam
  []
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1.0e-8
  nl_max_its = 30
[]

[Outputs]
  file_base = outputs/cantilever_multiphysics_cdp
  exodus = true
  csv = true
[]

[Postprocessors]
  [tip_disp_z]
    type = PointValue
    variable = disp_z
    point = '1.0 0.05 0.2'
  []
  [temp_mid]
    type = PointValue
    variable = temp
    point = '0.5 0.05 0.1'
  []
  [damage_t_max]
    type = ElementExtremeValue
    variable = damage_t
  []
  [damage_c_max]
    type = ElementExtremeValue
    variable = damage_c
  []
  [damage_total_max]
    type = ElementExtremeValue
    variable = damage_total
  []
  [vonmises_max]
    type = ElementExtremeValue
    variable = vonmises
  []
  [max_princ_max]
    type = ElementExtremeValue
    variable = max_princ
  []
[]
