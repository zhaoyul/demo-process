# 红创科技 — 接触力学: FileMesh + 瞬态求解 (ramped load)

[Mesh]
  type = FileMesh
  file = ../outputs/contact_blocks.msh
  construct_side_list_from_node_list = true
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
    use_displaced_mesh = false
  []
[]

[BCs]
  [bottom_fixed]
    type = DirichletBC
    variable = disp_z
    boundary = bottom_fixed
    value = 0.0
  []
  [bottom_fixed_x]
    type = DirichletBC
    variable = disp_x
    boundary = bottom_fixed
    value = 0.0
  []
  [bottom_fixed_y]
    type = DirichletBC
    variable = disp_y
    boundary = bottom_fixed
    value = 0.0
  []
  [top_pressure]
    type = Pressure
    variable = disp_z
    boundary = top_pressure
    function = ramped_pressure
    factor = -1.0
  []
[]

[Functions]
  [ramped_pressure]
    type = ParsedFunction
    expression = 'if(t<5.0, sin(t/5.0*pi/2)*5e6, 5e6)'
  []
[]

[Contact]
  [block_contact]
    primary = contact_bottom
    secondary = contact_top
    model = frictionless
    penalty = 1e9
    normalize_penalty = true
  []
[]

[Materials]
  [elasticity_bottom]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 2.0e11
    poissons_ratio = 0.30
    block = block_bottom
  []
  [elasticity_top]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 2.0e11
    poissons_ratio = 0.30
    block = block_top
  []
  [strain_bottom]
    type = ComputeSmallStrain
    block = block_bottom
  []
  [strain_top]
    type = ComputeSmallStrain
    block = block_top
  []
  [stress_bottom]
    type = ComputeLinearElasticStress
    block = block_bottom
  []
  [stress_top]
    type = ComputeLinearElasticStress
    block = block_top
  []
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_type'
  petsc_options_value = 'lu mumps'
  line_search = 'none'
  nl_rel_tol = 1.0e-4
  nl_abs_tol = 1.0e-6
  nl_max_its = 30
  l_max_its = 100
  dt = 0.1
  end_time = 5.0
  dtmin = 0.01
[]

[Outputs]
  file_base = outputs/contact_blocks_out
  exodus = true
  csv = true
[]

[Postprocessors]
  [top_disp_z]
    type = PointValue
    variable = disp_z
    point = '0.05 0.025 0.05'
  []
  [contact_pressure]
    type = ElementExtremeValue
    variable = contact_pressure
    block = 'block_bottom block_top'
  []
[]
