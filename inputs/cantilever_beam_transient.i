# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  动画算例: 悬臂梁瞬态加载 — 渐变载荷                      ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 载荷从 0 线性增加至 10kPa, 捕捉全过程变形演化

[Mesh]
  type = FileMesh
  file = ../outputs/cantilever_beam.msh
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
  [fixed_x]
    type = DirichletBC
    variable = disp_x
    boundary = fixed_end
    value = 0.0
  []
  [fixed_y]
    type = DirichletBC
    variable = disp_y
    boundary = fixed_end
    value = 0.0
  []
  [fixed_z]
    type = DirichletBC
    variable = disp_z
    boundary = fixed_end
    value = 0.0
  []
  [load]
    type = FunctionNeumannBC
    variable = disp_z
    boundary = load_surface
    function = load_func
  []
[]

[Functions]
  [load_func]
    type = ParsedFunction
    expression = '-1.0e4 * t / 1.0'
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
  num_steps = 10
[]

[Outputs]
  file_base = outputs/cantilever_beam_transient
  exodus = true
  csv = true
[]

[Postprocessors]
  [tip_disp_z]
    type = PointValue
    variable = disp_z
    point = '1.0 0.05 0.2'
  []
  [load_magnitude]
    type = FunctionValuePostprocessor
    function = load_func
  []
[]
