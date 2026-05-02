# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: 声学 — 空腔 Helmholtz 谐响应                       ║
# ║  招标条款: 第6章 声学仿真 (亥姆霍兹域)                    ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 场景: 2D 矩形空腔, 左侧壁面振动激励 (正弦波)
# 频率 f=1000Hz, 声速 c=343m/s (空气), k=2πf/c=18.3 rad/m
# 求解 Helmholtz 方程: ∇²p + k²p = 0

[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 40
    ny = 20
    xmin = 0
    xmax = 0.5
    ymin = 0
    ymax = 0.25
  []
[]

[Variables]
  [pressure_real]
  []
  [pressure_imag]
  []
[]

[Kernels]
  [diff_real]
    type = MatDiffusion
    variable = pressure_real
    diffusivity = 1.0
  []
  [diff_imag]
    type = MatDiffusion
    variable = pressure_imag
    diffusivity = 1.0
  []
  [helmholtz_real]
    type = CoupledForce
    variable = pressure_real
    v = pressure_imag
    coef = 18.3
  []
  [helmholtz_imag]
    type = CoupledForce
    variable = pressure_imag
    v = pressure_real
    coef = -18.3
  []
[]

[BCs]
  [left_real]
    type = DirichletBC
    variable = pressure_real
    boundary = left
    value = 1.0
  []
  [left_imag]
    type = DirichletBC
    variable = pressure_imag
    boundary = left
    value = 0.0
  []
  [walls_real]
    type = NeumannBC
    variable = pressure_real
    boundary = 'top bottom right'
    value = 0.0
  []
  [walls_imag]
    type = NeumannBC
    variable = pressure_imag
    boundary = 'top bottom right'
    value = 0.0
  []
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_type'
  petsc_options_value = 'lu mumps'
  nl_rel_tol = 1.0e-10
  nl_abs_tol = 1.0e-10
[]

[Outputs]
  file_base = outputs/acoustic_cavity
  exodus = true
  csv = true
[]

[Postprocessors]
  [p_real_center]
    type = PointValue
    variable = pressure_real
    point = '0.25 0.125 0'
  []
  [p_imag_center]
    type = PointValue
    variable = pressure_imag
    point = '0.25 0.125 0'
  []
[]
