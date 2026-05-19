# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: C60 早强混凝土抗压强度试验 (100×100×100mm)          ║
# ║  规范: GB/T 50081-2019                                     ║
# ║  试件编号: A1 (3块)                                        ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 试验描述: C60 早强混凝土标准立方体抗压强度试验
# 材料: C60 混凝土, E = 36 GPa, ν = 0.20, f_cu = 60 MPa

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 10
  ny = 10
  nz = 10
  xmin = 0
  xmax = 0.1
  ymin = 0
  ymax = 0.1
  zmin = 0
  zmax = 0.1
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
    youngs_modulus = 36.0e9        # C60 E = 36 GPa
    poissons_ratio = 0.20
  []
  [strain]
    type = ComputeIncrementalStrain
  []
  [stress]
    type = ComputeMultipleInelasticStress
    inelastic_models = 'c60_crush'
  []
  [c60_crush]
    type = IsotropicPlasticityStressUpdate
    yield_stress = 60.0e6          # f_cu = 60 MPa
    hardening_constant = -1.0e8    # 应变软化
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
  file_base = outputs/aac_material_tests/c60_compression
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
  [vonmises_max]
    type = ElementExtremeValue
    variable = vonmises
  []
  [compressive_strength]
    type = PointValue
    variable = min_princ
    point = '0.05 0.05 0.05'
  []
[]
