# 红创 — 接触力学: 3D瞬态5s (位移控制, GeneratedMesh)

[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 4
    ny = 2
    nz = 10
    xmin = 0
    xmax = 0.1
    ymin = 0
    ymax = 0.05
    zmin = 0
    zmax = 0.1
  []
  [bottom]
    type = SubdomainBoundingBoxGenerator
    input = gen
    block_id = 1
    bottom_left = '0 0 0'
    top_right = '0.1 0.05 0.05'
  []
  [top]
    type = SubdomainBoundingBoxGenerator
    input = bottom
    block_id = 2
    bottom_left = '0 0 0.05'
    top_right = '0.1 0.05 0.1'
  []
  [interface]
    type = SideSetsBetweenSubdomainsGenerator
    input = top
    primary_block = 1
    paired_block = 2
    new_boundary = 'contact_bottom'
  []
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  block = '1 2'
[]

[Variables]
  [disp_x] []
  [disp_y] []
  [disp_z] []
[]

[Kernels]
  [TensorMechanics]
    displacements = 'disp_x disp_y disp_z'
    use_displaced_mesh = true
  []
[]

[BCs]
  [bottom_fixed]
    type = DirichletBC
    variable = disp_z boundary = bottom value = 0.0
  []
  [bottom_fixed_x]
    type = DirichletBC
    variable = disp_x boundary = bottom value = 0.0
  []
  [bottom_fixed_y]
    type = DirichletBC
    variable = disp_y boundary = bottom value = 0.0
  []
  [top_disp]
    type = FunctionDirichletBC
    variable = disp_z boundary = top
    function = ramped_disp
  []
[]

[Functions]
  [ramped_disp]
    type = ParsedFunction
    expression = 'if(t<5.0, -sin(t/5.0*pi/2)*0.0005, -0.0005)'
  []
[]

[Contact]
  [block_contact]
    primary = contact_bottom
    secondary = top
    model = frictionless
    penalty = 1e10
  []
[]

[Materials]
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 2.0e11 poissons_ratio = 0.30
  []
  [strain]
    type = ComputeSmallStrain
  []
  [stress]
    type = ComputeLinearElasticStress
  []
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_type'
  petsc_options_value = 'lu mumps'
  nl_rel_tol = 1.0e-6
  nl_abs_tol = 1.0e-8
  nl_max_its = 30
  dt = 0.5
  end_time = 5.0
[]

[Outputs]
  file_base = outputs/contact_blocks_out
  exodus = true csv = true
[]

[Postprocessors]
  [top_disp_z]
    type = PointValue variable = disp_z point = '0.05 0.025 0.1'
  []
  [contact_pressure_max]
    type = ElementExtremeValue variable = contact_pressure block = '1 2'
  []
[]
