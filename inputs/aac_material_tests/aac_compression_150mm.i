# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: AAC 立方体抗压强度试验 (150×150×150mm)              ║
# ║  规范: GB/T 11969-2020                                     ║
# ║  试件编号: A2 (3块)                                        ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 试验描述: AAC 非标准立方体(150mm)抗压强度试验
# 注: 150mm立方体结果需乘以0.95换算为标准强度
# 材料: AAC, E = 1.75 GPa, ν = 0.20, f_c ≈ 3.5 MPa

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 15
  ny = 15
  nz = 15
  xmin = 0
  xmax = 0.15
  ymin = 0
  ymax = 0.15
  zmin = 0
  zmax = 0.15
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [disp_x] []
  [disp_y] []
  [disp_z] []
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
[]

[Physics/SolidMechanics/QuasiStatic]
  [all]
    generate_output = 'stress_zz'
  []
[]

[BCs]
  [bottom_z]
    type = DirichletBC
    variable = disp_z
    boundary = bottom
    value = 0.0
  []
  [bottom_center_x]
    type = DirichletBC
    variable = disp_x
    boundary = bottom
    value = 0.0
  []
  [bottom_center_y]
    type = DirichletBC
    variable = disp_y
    boundary = bottom
    value = 0.0
  []
  [top_disp_z]
    type = FunctionDirichletBC
    variable = disp_z
    boundary = top
    function = '-3.0e-3 * t'
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
    hardening_constant = 0.0
  []
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  nl_rel_tol = 1.0e-6
  nl_abs_tol = 1.0e-8
  nl_max_its = 30
  start_time = 0.0
  end_time = 1.0
  dt = 0.05
  [TimeIntegrator]
    type = ImplicitEuler
  []
[]

[Outputs]
  file_base = outputs/aac_compression_150mm
  exodus = true
  csv = true
  interval = 5
[]

[Postprocessors]
  [reaction_force_z]
    type = SideAverageValue
    variable = stress_zz
    boundary = top
  []
  [top_disp_z]
    type = SideAverageValue
    variable = disp_z
    boundary = top
  []
  [vonmises_max]
    type = ElementExtremeValue
    variable = vonmises
  []
[]
