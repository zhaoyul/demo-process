# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: AAC墙体拟静力试验 — W-08 格构带窗洞+构造柱          ║
# ║  规范: JGJ/T 101-2015                                      ║
# ║  构造: 格构 3600×3600×240mm, 加构造柱, 带窗洞              ║
# ╚═══════════════════════════════════════════════════════════╝
#
# W-08 带窗洞: 墙体中部开设窗洞 1200×1500mm
# - 构造柱位于两侧 + 窗洞过梁
# - 窗洞削弱墙体截面, 引起应力集中
# - 预期: 承载力略低于 W-07, 窗角应力集中明显

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
  # 窗洞区域标识 (1=窗洞, 0=墙体)
  [is_opening]
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
  # 标记窗洞区域: x∈[1.2,2.4], y∈[1.05,2.55]
  [opening_marker]
    type = ParsedAux
    variable = is_opening
    coupled_variables = 'vonmises'
    constant_names = 'x1 x2 y1 y2'
    constant_expressions = '1.2 2.4 1.05 2.55'
    expression = 'if(x > x1 & x < x2 & y > y1 & y < y2, 1.0, 0.0)'
    execute_on = 'INITIAL'
  []
[]

[Materials]
  # 窗洞区域弹性模量降为接近零 (模拟开洞)
  # 构造柱区域 (x<0.2 或 x>3.4): E_col = 32.5 GPa
  # 窗洞区域: E_opening ≈ 0 (极小值模拟刚度丧失)
  # 墙区域: E_wall = 1.75 GPa
  [elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1.75e9     # 基础值 (墙)
    poissons_ratio = 0.20
  []
  [strain]
    type = ComputeIncrementalStrain
  []
  [stress]
    type = ComputeMultipleInelasticStress
    inelastic_models = 'opening_soft'
  []
  # 窗洞区软化: 屈服强度极低 (模拟空洞)
  [opening_soft]
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
  file_base = outputs/aac_wall_tests/w08_window_opening_pseudo_static
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
  [window_corner_stress]
    type = PointValue
    variable = vonmises
    point = '1.2 2.55 0.0'
  []
]
