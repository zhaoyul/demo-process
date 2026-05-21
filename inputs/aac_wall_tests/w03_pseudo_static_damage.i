# AAC Wall Pseudo-Static Test — W03 Standard (3600x3600x240)
# Scalar Damage Model — ComputeDamageStress + ScalarMaterialDamage

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
  [damage_index]
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
    component = 1
    boundary = top
    factor = -0.5e6
  []
[]

[Functions]
  [cyclic_loading]
    type = ParsedFunction
    expression = 'if(t<40, 0.00655*sin(2*pi*t/40-pi/2), if(t<80, 0.0090*sin(2*pi*(t-40)/40-pi/2), if(t<160, 0.0144*sin(2*pi*(t-80)/80-pi/2), 0.0240*sin(2*pi*(t-160)/40-pi/2))))'
  []
  [damage_evolution]
    type = PiecewiseLinear
    xy_data = '0.0   0.0
               20.0  0.0
               40.0  0.02
               80.0  0.10
               160.0 0.35
               200.0 0.55
               240.0 0.70
               280.0 0.85'
  []
[]

[AuxKernels]
  [vonmises]
    type = RankTwoScalarAux
    variable = vonmises
    rank_two_tensor = stress
    scalar_type = VonMisesStress
    execute_on = TIMESTEP_END
  []
  [stress_xy]
    type = RankTwoAux
    variable = stress_xy
    rank_two_tensor = stress
    index_i = 0
    index_j = 1
    execute_on = TIMESTEP_END
  []
  [damage_index_aux]
    type = MaterialRealAux
    variable = damage_index
    property = damage_index
    execute_on = TIMESTEP_END
  []
[]

[Materials]
  [damage_index_mat]
    type = GenericFunctionMaterial
    prop_names = damage_index_prop
    prop_values = damage_evolution
  []
  [damage]
    type = ScalarMaterialDamage
    damage_index = damage_index_prop
    damage_index_name = damage_index
    maximum_damage_increment = 0.05
  []
  [stress]
    type = ComputeDamageStress
    damage_model = damage
  []
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1.75e9
    poissons_ratio = 0.20
  []
  [strain]
    type = ComputeFiniteStrain
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
  [damage_max]
    type = ElementExtremeValue
    variable = damage_index
  []
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  nl_rel_tol = 1.0e-5
  nl_abs_tol = 1.0e-6
  nl_max_its = 50

  start_time = 0.0
  end_time = 280.0
  dt = 4.0
  dtmin = 0.05

  [TimeIntegrator]
    type = ImplicitEuler
  []
[]

[Outputs]
  csv = true
  exodus = true
  perf_graph = true
[]
