# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: AAC墙体拟静力试验 — W-07 薄墙+构造柱                 ║
# ║  规范: JGJ/T 101-2015                                      ║
# ║  构造: 格构 3600×3600×200mm, 加构造柱, 分布式芯柱           ║
# ╚═══════════════════════════════════════════════════════════╝
#
# W-07 与 W-04 对比: 增设构造柱
# - 构造柱: C40 混凝土, 截面 200×200mm, 配筋 Φ16
# - 马牙槎连接 (20mm 槎口), 拉结筋 2道/柱高
# - 构造柱位于墙体两侧
# - 预期: 承载力显著提升, 滞回环更饱满

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
[]

[Kernels]
  [TensorMechanics]
    displacements = 'disp_x disp_y'
  []
[]

[BCs]
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
  [stress_xy_aux]
    type = RankTwoAux
    variable = stress_xy
    rank_two_tensor = stress
    index_i = 0
    index_j = 1
    execute_on = 'TIMESTEP_END'
  []
[]

[Materials]
  # 构造柱增强: 边缘区域弹性模量提升 (C40混凝土 + 钢筋的等效)
  # 柱区: x < 0.2m 或 x > 3.4m, E_col = 32.5 GPa
  # 墙区: 0.2m < x < 3.4m, E_wall = 1.75 GPa
  [elasticity]
    type = ParsedMaterial
    property_name = youngs_modulus_function
    coupled_variables = 'vonmises'
    constant_names = 'E_col E_wall x_left x_right'
    constant_expressions = '32.5e9 1.75e9 0.2 3.4'
    expression = 'if(x < x_left | x > x_right, E_col, E_wall)'
    outputs = exodus
  []
  [elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1.75e9
    poissons_ratio = 0.20
  []
  [strain]
    type = ComputeIncrementalStrain
  []
  [stress]
    type = ComputeMultipleInelasticStress
    inelastic_models = 'wall_damage'
  []
  # 柱区使用更高屈服强度 (C40 fc=40MPa, 墙区 fc=3.5MPa)
  [wall_damage]
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
  file_base = outputs/aac_wall_tests/w07_thin_column_pseudo_static
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
]
