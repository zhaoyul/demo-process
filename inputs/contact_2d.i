# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: 两体接触压缩 (Coulomb 摩擦)                        ║
# ║  招标条款: 第6章 非线性结构 (接触力学)                    ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 两个矩形块并排, 左侧固定, 右侧向左压入, 界面摩擦接触

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    nx = 10
    ny = 10
    dim = 2
  []
  [block1]
    type = SubdomainBoundingBoxGenerator
    block_id = 1
    bottom_left = '0 0 0'
    top_right = '0.5 1 0'
    input = gen
  []
  [block2]
    type = SubdomainBoundingBoxGenerator
    block_id = 2
    bottom_left = '0.5 0 0'
    top_right = '1 1 0'
    input = block1
  []
  [breakmesh]
    input = block2
    type = BreakMeshByBlockGenerator
    block_pairs = '1 2'
  []
[]

[Physics/SolidMechanics/QuasiStatic]
  generate_output = 'stress_xx stress_yy vonmises_stress'
  add_variables = true
  strain = SMALL
  [block1]
    block = 1
  []
  [block2]
    block = 2
  []
[]

[Contact]
  [mechanical]
    primary = Block1_Block2
    secondary = Block2_Block1
    penalty = 1000
    model = coulomb
    friction_coefficient = 0.3
    formulation = tangential_penalty
    tangential_tolerance = 0.1
  []
[]

[BCs]
  [left_x]
    type = DirichletBC
    variable = disp_x
    boundary = left
    value = 0.0
  []
  [left_y]
    type = DirichletBC
    variable = disp_y
    boundary = left
    value = 0.0
  []
  [right_x]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = right
    function = '-0.05 * t'
  []
  [right_y]
    type = DirichletBC
    variable = disp_y
    boundary = right
    value = 0.0
  []
[]

[Materials]
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 100.0
    poissons_ratio = 0.30
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
  line_search = 'none'
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-8
  nl_max_its = 20
  start_time = 0.0
  num_steps = 10
  dt = 0.5
[]

[Outputs]
  file_base = outputs/contact_2d
  exodus = true
  csv = true
[]

[Postprocessors]
  [right_disp]
    type = PointValue
    variable = disp_x
    point = '1.0 0.5 0'
  []
  [contact_force_x]
    type = NodalSum
    variable = disp_x
    boundary = Block1_Block2
  []
[]
