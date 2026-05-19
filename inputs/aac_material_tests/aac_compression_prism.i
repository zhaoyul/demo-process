# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: AAC 棱柱体轴心抗压强度试验 (100×100×300mm)         ║
# ║  规范: GB/T 11969-2020                                     ║
# ║  试件编号: A3 (3块)                                        ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 试验描述: AAC 棱柱体(100×100×300mm)轴心抗压强度 fc
# 材料: AAC, E = 1.75 GPa, ν = 0.20, f_c_prism ≈ 2.8 MPa

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 10
  ny = 10
  nz = 30
  xmin = 0
  xmax = 0.1
  ymin = 0
  ymax = 0.1
  zmin = 0
  zmax = 0.3
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
  [stress_zz]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Kernels]
  [TensorMechanics]
    displacements = 'disp_x disp_y disp_z'
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
  [stress_zz_aux]
    type = RankTwoAux
    variable = stress_zz
    rank_two_tensor = stress
    index_i = 2
    index_j = 2
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
    type = ComputeIncrementalStrain
  []
  [stress]
    type = ComputeMultipleInelasticStress
    inelastic_models = 'aac_crush'
  []
  [aac_crush]
    type = IsotropicPlasticityStressUpdate
    yield_stress = 2.8e6        # 棱柱体抗压 ≈ 0.8 × f_cube
    hardening_constant = -5.0e7 # 应变软化模拟脆性破坏
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
  file_base = outputs/aac_material_tests/aac_compression_prism
  exodus = true
  csv = true
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
  [mid_stress]
    type = PointValue
    variable = min_princ
    point = '0.05 0.05 0.15'
  []
[]
