# AAC Wall Pseudo-Static Test — W04 Thin Wall (3600x3600x200)
# Smeared cracking model, 3-phase cyclic loading, AD formulation

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 24
  ny = 24
  xmin = 0
  xmax = 3.6
  ymin = 0
  ymax = 3.6
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Variables]
  [disp_x]
  []
  [disp_y]
  []
[]

[AuxVariables]
  [vonmises]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_xy]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Kernels]
  [TensorMechanics]
    use_automatic_differentiation = true
  []
[]

[BCs]
  [bottom_x]
    type = ADDirichletBC
    variable = disp_x
    boundary = bottom
    value = 0.0
  []
  [bottom_y]
    type = ADDirichletBC
    variable = disp_y
    boundary = bottom
    value = 0.0
  []
  [top_x]
    type = ADFunctionDirichletBC
    variable = disp_x
    boundary = top
    function = cyclic_loading
  []
  [top_pressure]
    type = ADPressure
    variable = disp_y
    boundary = top
    factor = -0.5e6
  []
[]

[Functions]
  [cyclic_loading]
    type = ParsedFunction
    expression = 'if(t<40, 0.00655*sin(2*pi*t/40-pi/2), if(t<80, 0.0090*sin(2*pi*(t-40)/40-pi/2), if(t<160, 0.0144*sin(2*pi*(t-80)/80-pi/2), 0.0240*sin(2*pi*(t-160)/40-pi/2))))'
  []
[]

[AuxKernels]
  [vonmises]
    type = ADRankTwoScalarAux
    variable = vonmises
    rank_two_tensor = stress
    scalar_type = VonMisesStress
  []
  [stress_xy]
    type = ADRankTwoAux
    variable = stress_xy
    rank_two_tensor = stress
    index_i = 0
    index_j = 1
  []
[]

[Materials]
  [elasticity]
    type = ADComputeIsotropicElasticityTensor
    youngs_modulus = 1.75e9
    poissons_ratio = 0.20
  []
  [strain]
    type = ADComputeIncrementalStrain
  []
  [stress]
    type = ADComputeSmearedCrackingStress
    cracking_stress = 5.0e6
    cracking_neg_fraction = 0.0
    shear_retention_factor = 0.1
    cracked_elasticity_type = FULL
    softening_models = 'exponential_softening'
  []
  [exponential_softening]
    type = ADExponentialSoftening
    residual_stress = 0.01
    alpha = -0.5
  []
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
  [vonmises_max]
    type = ElementExtremeValue
    variable = vonmises
  []
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'
  nl_rel_tol = 1.0e-5
  nl_abs_tol = 1.0e-6
  nl_max_its = 50
  line_search = bt

  start_time = 0.0
  end_time = 280.0
  dt = 4.0
  dtmin = 0.1

  [TimeIntegrator]
    type = ImplicitEuler
  []
[]

[Outputs]
  csv = true
  exodus = true
  perf_graph = true
[]
