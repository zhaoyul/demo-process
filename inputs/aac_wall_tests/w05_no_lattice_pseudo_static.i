# AAC Wall Pseudo-Static Test — W03 Standard (3600x3600x240)
# Simplified: 2D plane stress, ideal plasticity, 3-phase cyclic loading

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

  [damage_t]
    order = CONSTANT
    family = MONOMIAL
  []
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
  [top_x]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = top
    function = cyclic_loading
  []
  [top_pressure]
    type = Pressure
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
  [damage_kernel]
    type = RankTwoScalarAux
    variable = damage_t
    rank_two_tensor = stress
    scalar_type = MaxPrincipal
    execute_on = TIMESTEP_END
  []
  [vonmises]
    type = RankTwoScalarAux
    variable = vonmises
    rank_two_tensor = stress
    scalar_type = VonMisesStress
  []
  [stress_xy]
    type = RankTwoAux
    variable = stress_xy
    rank_two_tensor = stress
    index_i = 0
    index_j = 1
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
    inelastic_models = 'plasticity'
  []
  [plasticity]
    type = IsotropicPlasticityStressUpdate
    yield_stress = 3.5e6
    hardening_constant = -1.0e6
  []
[]

[Postprocessors]
  [damage_max]
    type = ElementExtremeValue
    variable = damage_t
  []
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
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  nl_rel_tol = 1.0e-5
  nl_abs_tol = 1.0e-6
  nl_max_its = 30
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
