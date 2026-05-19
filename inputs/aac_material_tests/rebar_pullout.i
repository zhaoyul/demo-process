# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: 钢筋拉拔试验 (φ5×500mm)                             ║
# ║  规范: GB/T 228.1-2010                                     ║
# ║  试件: 楼板钢筋 3根 + 墙板钢筋 3根                        ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 试验描述: 钢筋轴向拉伸试验, 测定屈服强度和极限抗拉强度
# 材料: 钢筋 φ5mm, E = 200 GPa, ν = 0.30
#       fy ≈ 400 MPa (三级带肋钢筋), fu ≈ 540 MPa

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 4
  ny = 100
  xmin = 0
  xmax = 0.005
  ymin = 0
  ymax = 0.5
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
  [plastic_strain]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_yy]
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
  # 底部固定
  [bottom_y]
    type = DirichletBC
    variable = disp_y
    boundary = bottom
    value = 0.0
  []
  [bottom_pin_x]
    type = DirichletBC
    variable = disp_x
    boundary = bottom
    value = 0.0
  []
  # 顶部施加拉伸位移 (模拟拉拔)
  [top_disp_y]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = top
    function = '2.5e-2 * t'
  []
[]

[AuxKernels]
  [vonmises_kernel]
    type = RankTwoScalarAux
    variable = vonmises
    rank_two_tensor = stress
    scalar_type = VonMisesStress
    execute_on = 'TIMESTEP_END'
  []
  [plastic_strain_kernel]
    type = RankTwoScalarAux
    variable = plastic_strain
    rank_two_tensor = plastic_strain
    scalar_type = EffectiveStrain
    execute_on = 'TIMESTEP_END'
  []
  [stress_yy_kernel]
    type = RankTwoAux
    variable = stress_yy
    rank_two_tensor = stress
    index_i = 1
    index_j = 1
    execute_on = 'TIMESTEP_END'
  []
[]

[Materials]
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 200.0e9    # 钢 E = 200 GPa
    poissons_ratio = 0.30
  []
  [strain]
    type = ComputeIncrementalStrain
  []
  [stress]
    type = ComputeMultipleInelasticStress
    inelastic_models = 'steel_plastic'
  []
  [steel_plastic]
    type = IsotropicPlasticityStressUpdate
    yield_stress = 400.0e6      # fy = 400 MPa
    hardening_constant = 2.0e9  # 硬化模量 H = 2 GPa
  []
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1.0e-10
  nl_max_its = 30
  start_time = 0.0
  end_time = 1.0
  dt = 0.02
  [TimeIntegrator]
    type = ImplicitEuler
  []
[]

[Outputs]
  file_base = outputs/rebar_pullout
  exodus = true
  csv = true
[]

[Postprocessors]
  [reaction_force]
    type = SideAverageValue
    variable = stress_yy
    boundary = top
  []
  [top_displacement]
    type = SideAverageValue
    variable = disp_y
    boundary = top
  []
  [mid_vonmises]
    type = PointValue
    variable = vonmises
    point = '0.0025 0.25 0.0'
  []
[]
