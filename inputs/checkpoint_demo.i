# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: 检查点/恢复验证                                    ║
# ║  招标条款: §2.8 检查点与恢复                            ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 场景: 悬臂梁瞬态加载, 中途写入检查点, 从检查点恢复续算
# 验证: 恢复后结果与不间断计算范数误差 < 1e-10

[Mesh]
  type = FileMesh
  file = ../outputs/cantilever_beam_fine.msh
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
    expression = '-1.0e4 * sin(pi * t / 2.0)'
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
  dt = 0.25
  num_steps = 4
[]

[Outputs]
  file_base = outputs/checkpoint_restore
  exodus = true
  csv = true
  [checkpoint]
    type = Checkpoint
    num_files = 2
    time_step_interval = 2
  []
[]

[Postprocessors]
  [tip_disp_z]
    type = PointValue
    variable = disp_z
    point = '1.0 0.05 0.2'
  []
  [load_level]
    type = FunctionValuePostprocessor
    function = load_func
  []
[]
