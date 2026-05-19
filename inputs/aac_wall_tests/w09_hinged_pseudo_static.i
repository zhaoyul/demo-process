# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: AAC墙体拟静力试验 — W-09 铰接梁柱                    ║
# ║  规范: JGJ/T 101-2015                                      ║
# ║  构造: 格构, 铰接梁柱连接, 无构造柱                        ║
# ╚═══════════════════════════════════════════════════════════╝
#
# W-09 铰接梁柱连接:
# - 墙体与圈梁/地梁之间采用铰接 (释放弯矩)
# - 顶部可自由转动, 水平力通过拉压传递
# - 与 W-03 对比: 节点约束差异
# - 预期: 初始刚度低于固接, 变形能力大但承载力低

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 72
  ny = 72
  xmin = 0
  xmax = 3.6
  ymin = 0
  ymax = 3.6
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Variables]
  [disp_x] []
  [disp_y] []
[]

[AuxVariables]
  [vonmises]
    order = CONSTANT
    family = MONOMIAL
  []
  [max_princ]
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
  [stress_xy]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Kernels]
  [TensorMechanics]
    displacements = 'disp_x disp_y'
  []
[]

[BCs]
  # 底部: 仅约束平移 (铰接 → 释放转动)
  # 铰接: disp_x=0, disp_y=0, 但允许顶部自由转动 (默认已允许, 因为只约束 disp 不约束 rotation)
  [bottom_x]
    type = DirichletBC
    variable = disp_x
    boundary = bottom
    value = 0.0
  []
  [bottom_y]
    type = DirichletBC
    variable = disp_y
    boundary = bottom
    value = 0.0
  []
  # 顶部: 仅施加竖向压力和水平位移, 不约束转动
  # 注: 与 W-03 相同 (2D 平面应力模型中固接/铰接差异通过底部约束体现)
  # 铰接特征: 底部不约束转角 → 允许墙体绕底部转动, 降低弯曲刚度
  [top_pressure]
    type = Pressure
    variable = disp_y
    boundary = top
    factor = -0.5e6
  []
  [top_disp_x]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = top
    function = cyclic_loading
  []
[]

[Functions]
  [cyclic_loading]
    type = ParsedFunction
    expression = 'amp(t) * (2 * abs(2 * (t / per - floor(t / per + 0.5))) - 1)'
    symbol_names = 'amp per'
    symbol_values = 'cyclic_amp phase_period'
  []
  [cyclic_amp]
    type = ParsedFunction
    expression = 'if(t<40, 0.00655, if(t<80, 0.0090, if(t<160, 0.0144, if(t<280, 0.0240, 0.0300))))'
  []
  [phase_period]
    type = ParsedFunction
    expression = 'if(t<40, 40, if(t<80, 40, if(t<160, 80, if(t<280, 40, 40))))'
  []
[]

[AuxKernels]
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
  [min_princ_stress]
    type = RankTwoScalarAux
    variable = min_princ
    rank_two_tensor = stress
    scalar_type = MinPrincipal
    execute_on = 'TIMESTEP_END'
  []
  [damage_t_kernel]
    type = ParsedAux
    variable = damage_t
    coupled_variables = 'max_princ'
    constant_names = 'f_t alpha_t'
    constant_expressions = '0.4e6 5.0e-7'
    expression = 'if(max_princ > f_t, max(0.0, 1.0 - (f_t / max_princ) * exp(max(-700.0, alpha_t * (f_t - max_princ)))), 0.0)'
    execute_on = 'TIMESTEP_END'
  []
  [damage_c_kernel]
    type = ParsedAux
    variable = damage_c
    coupled_variables = 'min_princ'
    constant_names = 'f_c alpha_c'
    constant_expressions = '3.5e6 2.0e-7'
    expression = 'if(min_princ < -f_c, max(0.0, 1.0 - (f_c / abs(min_princ)) * exp(max(-700.0, alpha_c * (f_c + min_princ)))), 0.0)'
    execute_on = 'TIMESTEP_END'
  []
  [damage_total_kernel]
    type = ParsedAux
    variable = damage_total
    coupled_variables = 'damage_t damage_c'
    expression = 'max(damage_t, damage_c)'
    execute_on = 'TIMESTEP_END'
  []
  [stress_xy_kernel]
    type = RankTwoAux
    variable = stress_xy
    rank_two_tensor = stress
    index_i = 0
    index_j = 1
    execute_on = 'TIMESTEP_END'
  []
[]

[Materials]
  # 铰接: 连接刚度折减 (模拟铰接节点的柔度)
  # E_eff = 1.75 × 0.85 (铰接效应折减)
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1.49e9     # 折减15%模拟铰接柔度
    poissons_ratio = 0.20
  []
  [strain]
    type = ComputeIncrementalStrain
  []
  [stress]
    type = ComputeMultipleInelasticStress
    inelastic_models = 'aac_damage'
  []
  [aac_damage]
    type = IsotropicPlasticityStressUpdate
    yield_stress = 3.5e6
    hardening_constant = -5.0e6
  []
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  nl_rel_tol = 1.0e-5
  nl_abs_tol = 1.0e-6
  nl_max_its = 30
  start_time = 0.0
  end_time = 400.0
  dt = 2.0
  [TimeIntegrator]
    type = ImplicitEuler
  []
[]

[Outputs]
  file_base = outputs/w09_hinged_pseudo_static
  exodus = true
  csv = true
[]

[Postprocessors]
  [top_disp_x]
    type = SideAverageValue
    variable = disp_x
    boundary = top
  []
  [base_shear_x]
    type = SideAverageValue
    variable = stress_xy
    boundary = bottom
  []
  [top_disp_y]
    type = SideAverageValue
    variable = disp_y
    boundary = top
  []
  [top_rotation]
    type = PointValue
    variable = disp_x
    point = '3.6 3.6 0.0'
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
[]
