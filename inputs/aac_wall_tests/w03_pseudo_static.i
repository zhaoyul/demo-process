# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: AAC墙体拟静力试验 — W-03 标准格构                    ║
# ║  规范: JGJ/T 101-2015 (低周反复加载)                       ║
# ║  构造: 格构 3600×3600×240mm, 无构造柱, 分布式芯柱          ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 加载制度:
#   竖向: 恒定 0.5 MPa (轴压比 0.1)
#   水平: 位移控制循环
#     位移角 ±1/550(6.55mm) → ±1/400(9.0mm) → ±1/250(14.4mm)
#           → ±1/150(24.0mm) → ±1/120(30.0mm)...
#     屈服前每级1循环, 屈服后每级3循环

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
  [acc_plastic_strain]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Physics/SolidMechanics/QuasiStatic]
  [all]
    generate_output = 'stress_xy'
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
  # 顶部竖向恒压 0.5 MPa
  [top_pressure]
    type = Pressure
    variable = disp_y
    boundary = top
    factor = -0.5e6
  []
  # 顶部水平循环位移
  [top_disp_x]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = top
    function = cyclic_loading
  []
[]

[Functions]
  # 拟静力循环加载函数 (JGJ/T 101-2015)
  # 各阶段: [时间范围, 位移幅值mm, 循环数]
  #   Phase1: t=0~40s,  Δ=±6.55mm,  1 cycles
  #   Phase2: t=40~80s,  Δ=±9.0mm,   1 cycles
  #   Phase3: t=80~160s, Δ=±14.4mm,  1 cycles
  #   Phase4: t=160~280s,Δ=±24.0mm,  3 cycles
  #   Phase5: t=280~400s,Δ=±30.0mm,  3 cycles
  # 每个 phase 使用三角波 (ramp up → ramp down)
  [cyclic_loading]
    type = ParsedFunction
    expression = 'cyclic_amp(t) * tri_wave(t, period(t))'
    symbol_names = 'cyclic_amp tri_wave period'
    symbol_values = 'cyclic_amplitude triangular_wave phase_period'
  []
  [cyclic_amplitude]
    type = ParsedFunction
    # 分阶段增加位移幅值 (单位: m)
    expression = 'if(t<40, 0.00655, if(t<80, 0.0090, if(t<160, 0.0144, if(t<280, 0.0240, 0.0300))))'
  []
  [triangular_wave]
    type = ParsedFunction
    # 三角波: -1 到 +1, cycle_seconds 为周期参数
    expression = '2 * abs(2 * (t / cycle_period - floor(t / cycle_period + 0.5))) - 1'
    symbol_names = 'cycle_period'
    symbol_values = 'phase_period'
  []
  [phase_period]
    type = ParsedFunction
    # 各阶段周期长度 (每循环秒数)
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
  [acc_plastic_kernel]
    type = MaterialRealAux
    variable = acc_plastic_strain
    property = effective_plastic_strain
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
  dtmin = 0.1

  [TimeIntegrator]
    type = ImplicitEuler
  []
[]

[Outputs]
  file_base = outputs/w03_pseudo_static
  exodus = true
  csv = true
  interval = 10
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
  [mid_vonmises]
    type = PointValue
    variable = vonmises
    point = '1.8 1.8 0.0'
  []
[]
