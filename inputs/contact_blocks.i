# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例3: 接触力学 — 两体压缩接触                           ║
# ║  招标条款: 第6章 结构力学 + 非线性                         ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 两矩形块: 底块固定底面, 顶块顶面受压下沉, 界面接触

[Mesh]
  type = FileMesh
  file = ../outputs/contact_blocks.msh
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
    type = NeumannBC
    variable = disp_z
    boundary = top_pressure
    value = -5.0e6
  []
[]

[Contact]
  [block_contact]
    primary = contact_bottom
    secondary = contact_top
    model = frictionless
    penalty = 1e9
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
  type = Steady
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 101'
  line_search = 'none'
  nl_rel_tol = 1.0e-5
  nl_abs_tol = 1.0e-5
  nl_max_its = 30
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
    point = '0.05 0.025 0.1'
  []
  [contact_pressure]
    type = ElementExtremeValue
    variable = contact_pressure
    block = 'block_bottom block_top'
  []
[]
