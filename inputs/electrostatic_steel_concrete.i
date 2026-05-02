# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: 低频电磁 — 双材料静电分析                          ║
# ║  招标条款: 第6章 低频电磁场仿真                           ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 场景: 钢筋 (导体, 左) + 混凝土 (介质, 右) 双材料界面
# 左侧施加 1V 电位, 右侧接地 0V
# 模拟钢筋-混凝土介质中低频电场分布

[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 40
    ny = 10
    xmin = -0.1
    xmax = 0.1
    ymin = 0
    ymax = 0.05
  []
  [steel]
    type = SubdomainBoundingBoxGenerator
    input = gen
    block_id = 1
    block_name = 'steel'
    bottom_left = '-0.1 0 0'
    top_right = '0 0.05 0'
  []
  [concrete]
    type = SubdomainBoundingBoxGenerator
    input = steel
    block_id = 2
    block_name = 'concrete'
    bottom_left = '0 0 0'
    top_right = '0.1 0.05 0'
  []
  [interface]
    type = SideSetsBetweenSubdomainsGenerator
    input = concrete
    primary_block = 1
    paired_block = 2
    new_boundary = 'steel_concrete_interface'
  []
[]

[Variables]
  [potential]
  []
[]

[Kernels]
  [diffusion_steel]
    type = MatDiffusion
    variable = potential
    diffusivity = electrical_conductivity
    block = 'steel'
  []
  [diffusion_concrete]
    type = MatDiffusion
    variable = potential
    diffusivity = electrical_conductivity
    block = 'concrete'
  []
[]

[BCs]
  [left]
    type = DirichletBC
    variable = potential
    boundary = left
    value = 1.0
  []
  [right]
    type = DirichletBC
    variable = potential
    boundary = right
    value = 0.0
  []
[]

[Materials]
  [steel_conductivity]
    type = GenericConstantMaterial
    prop_names = 'electrical_conductivity'
    prop_values = 1.0e7
    block = 'steel'
  []
  [concrete_conductivity]
    type = GenericConstantMaterial
    prop_names = 'electrical_conductivity'
    prop_values = 1.0e-2
    block = 'concrete'
  []
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  nl_rel_tol = 1.0e-10
[]

[Outputs]
  file_base = outputs/electrostatic_steel_concrete
  exodus = true
  csv = true
[]

[Postprocessors]
  [potential_interface]
    type = PointValue
    variable = potential
    point = '0 0.025 0'
  []
  [potential_center_steel]
    type = PointValue
    variable = potential
    point = '-0.05 0.025 0'
  []
[]
