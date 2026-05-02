[Mesh]
  type = FileMesh
  file = ../outputs/beam_demo.msh
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [disp_x] []
  [disp_y] []
  [disp_z] []
[]

[Kernels]
  [TensorMechanics]
    displacements = 'disp_x disp_y disp_z'
  []
[]

[BCs]
  [fix_x]
    type = DirichletBC
    variable = disp_x
    boundary = fixed
    value = 0.0
  []
  [fix_y]
    type = DirichletBC
    variable = disp_y
    boundary = fixed
    value = 0.0
  []
  [fix_z]
    type = DirichletBC
    variable = disp_z
    boundary = fixed
    value = 0.0
  []
  [load]
    type = FunctionNeumannBC
    variable = disp_z
    boundary = load
    function = load_fn
  []
[]

[Functions]
  [load_fn]
    type = ParsedFunction
    expression = '-2.0e4 * t / 1.0'
  []
[]

[Materials]
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 2.0e11
    poissons_ratio = 0.30
    block = beam
  []
  [strain]
    type = ComputeSmallStrain
    block = beam
  []
  [stress]
    type = ComputeLinearElasticStress
    block = beam
  []
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1.0e-8
  start_time = 0.0
  end_time = 1.0
  dt = 0.1
[]

[Outputs]
  file_base = outputs/beam_demo_transient
  exodus = true
  csv = true
[]

[Postprocessors]
  [tip]
    type = PointValue
    variable = disp_z
    point = '0.2 0.01 0.01'
  []
[]
