# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: AAC墙体拟静力试验 — W-02 偏压试验                   ║
# ║  规范: JGJ/T 101-2015                                      ║
# ║  构造: 格构 3600×3600×240mm, 无构造柱                      ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 试验描述: W-02 格构墙体偏心受压试验
# 竖向荷载: 0.5 MPa, 偏心距 e = 0.2m (距墙中心线)
# 目标: 测定墙体偏压承载力和弯曲破坏模式

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
[]

[Physics/SolidMechanics/QuasiStatic]
  [all]
  []
[]

[BCs]
  # 底部固定
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
  # 顶部偏心压力 (中心偏右 0.2m 施加, 等效为压力 + 弯矩)
  # 压力 0.5 MPa × 宽度 = 线上荷载
  [top_pressure]
    type = Pressure
    variable = disp_y
    boundary = top
    factor = -0.5e6
    function = eccentric_distribution
  []
  [top_x_free]
    type = DirichletBC
    variable = disp_x
    boundary = top
    value = 0.0
  []
[]

[Functions]
  # 偏心分布: 右侧50%区域施加更多压力 (模拟偏心)
  [eccentric_distribution]
    type = ParsedFunction
    expression = 'if(x > 2.3, 1.5, 0.5)'
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
[]

[Materials]
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1.75e9
    poissons_ratio = 0.20
  []
  [strain]
    type = ComputeIncrementalSmallStrain
  []
  [stress]
    type = ComputeMultipleInelasticStress
    inelastic_models = 'aac_crush'
  []
  [aac_crush]
    type = IsotropicPlasticityStressUpdate
    yield_stress = 3.5e6
    hardening_constant = -1.0e7
  []
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  nl_rel_tol = 1.0e-6
  nl_abs_tol = 1.0e-8
  nl_max_its = 30
[]

[Outputs]
  file_base = outputs/w02_eccentric_compression
  exodus = true
  csv = true
[]

[Postprocessors]
  [top_disp_y_left]
    type = PointValue
    variable = disp_y
    point = '0.6 3.6 0.0'
  []
  [top_disp_y_right]
    type = PointValue
    variable = disp_y
    point = '3.0 3.6 0.0'
  []
  [mid_max_princ]
    type = PointValue
    variable = max_princ
    point = '1.8 1.8 0.0'
  []
  [damage_t_max]
    type = ElementExtremeValue
    variable = damage_t
  []
  [damage_c_max]
    type = ElementExtremeValue
    variable = damage_c
  []
[]
