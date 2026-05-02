# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例3: 两体接触 — 线弹性压缩                             ║
# ║  招标条款: 第6章 非线性 (接触力学)                        ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 2D 两体接触: 底块固定, 顶块受压下沉

[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 10
    ny = 20
    xmin = 0
    xmax = 0.1
    ymin = 0
    ymax = 0.2
  []
  [bottom]
    type = SubdomainBoundingBoxGenerator
    input = gen
    block_id = 1
    bottom_left = '0 0 0'
    top_right = '0.1 0.1 0'
  []
  [top]
    type = SubdomainBoundingBoxGenerator
    input = bottom
    block_id = 2
    bottom_left = '0 0.1 0'
    top_right = '0.1 0.2 0'
  []
  [interface]
    type = SideSetsBetweenSubdomainsGenerator
    input = top
    primary_block = 1
    paired_block = 2
    new_boundary = 'interface_bottom'
  []
  [interface_top]
    type = SideSetsBetweenSubdomainsGenerator
    input = interface
    primary_block = 2
    paired_block = 1
    new_boundary = 'interface_top'
  []
  [breakmesh]
    type = BreakMeshByBlockGenerator
    input = interface_top
  []
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Variables]
  [disp_x] []
  [disp_y] []
[]

[Kernels]
  [TensorMechanics]
    displacements = 'disp_x disp_y'
  []
[]

[BCs]
  [bottom_fixed]
    type = DirichletBC
    variable = disp_y
    boundary = bottom
    value = 0.0
  []
  [top_pressure]
    type = NeumannBC
    variable = disp_y
    boundary = top
    value = -1.0e6
  []
  [fix_x_bottom]
    type = DirichletBC
    variable = disp_x
    boundary = left
    value = 0.0
  []
[]

[Contact]
  [contact]
    primary = interface_bottom
    secondary = interface_top
    model = frictionless
    formulation = mortar
  []
[]

[Materials]
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 2.0e11
    poissons_ratio = 0.30
    block = '1 2'
  []
  [strain]
    type = ComputeSmallStrain
    block = '1 2'
  []
  [stress]
    type = ComputeLinearElasticStress
    block = '1 2'
  []
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  nl_rel_tol = 1.0e-5
  nl_abs_tol = 1.0e-5
  nl_max_its = 30
[]

[Outputs]
  file_base = outputs/contact_out
  exodus = true
  csv = true
[]

[Postprocessors]
  [top_disp]
    type = PointValue
    variable = disp_y
    point = '0.05 0.2 0'
  []
[]
