# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: 悬臂梁静力学分析                                    ║
# ║  求解输入: MOOSE TensorMechanics                          ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 物理场景:
#   矩形截面钢梁 (L=1.0m, W=0.1m, H=0.2m)
#   一端固定 (x=0)，自由端顶面 (z=H) 施加向下载荷
#   线弹性各向同性材料，小变形假设
#
# 对应 .geo 文件: inputs/cantilever_beam.geo
# 网格文件:       outputs/cantilever_beam.msh

# ── 网格 ──────────────────────────────────────────────────
[Mesh]
  type = FileMesh
  file = outputs/cantilever_beam.msh
[]

# ── 变量 ──────────────────────────────────────────────────
[Variables]
  [disp_x]
    order = SECOND
    family = LAGRANGE
  []
  [disp_y]
    order = SECOND
    family = LAGRANGE
  []
  [disp_z]
    order = SECOND
    family = LAGRANGE
  []
[]

# ── 内核 (Kernels) ────────────────────────────────────────
[Kernels]
  # 应力散度项 (平衡方程)
  [TensorMechanics]
    displacements = 'disp_x disp_y disp_z'
    use_displaced_mesh = false
  []
[]

# ── 边界条件 ──────────────────────────────────────────────
[BCs]
  # 固定端 (x=0): 全约束
  [fixed_end]
    type = DirichletBC
    variable = disp_x
    boundary = fixed_end
    value = 0.0
  []
  [fixed_end_y]
    type = DirichletBC
    variable = disp_y
    boundary = fixed_end
    value = 0.0
  []
  [fixed_end_z]
    type = DirichletBC
    variable = disp_z
    boundary = fixed_end
    value = 0.0
  []

  # 集中力施加 (顶面): 沿 -z 方向
  [load]
    type = NeumannBC
    variable = disp_z
    boundary = load_surface
    value = -1.0e4    # 10 kN/m² 面压力
  []
[]

# ── 材料属性 ──────────────────────────────────────────────
[Materials]
  # 结构钢 (Q235 等效)
  [steel]
    type = ComputeIsotropicElasticityTensor
    block = beam
    youngs_modulus = 2.0e11   # 200 GPa
    poissons_ratio = 0.30
  []

  # 小应变假设
  [strain]
    type = ComputeSmallStrain
    block = beam
    displacements = 'disp_x disp_y disp_z'
  []

  # 线弹性应力
  [stress]
    type = ComputeLinearElasticStress
    block = beam
  []
[]

# ── 求解器 ────────────────────────────────────────────────
[Executioner]
  type = Steady

  solve_type = 'PJFNK'     # Preconditioned Jacobian-Free Newton-Krylov
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'

  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1.0e-6
  nl_max_its = 20
[]

# ── 输出 ──────────────────────────────────────────────────
[Outputs]
  exodus = true    # ExodusII 格式 (ParaView 可读)
  csv = true       # CSV 格式 (Python/Pandas 可读)
  console = true
  [console]
    type = Console
    perf_log = true
    max_rows = 15
  []
[]

# ── 后处理器 (可选指标) ───────────────────────────────────
[Postprocessors]
  # 自由端最大位移
  [tip_disp_z]
    type = PointValue
    variable = disp_z
    point = '1.0 0.05 0.2'
  []
  # 固定端 von Mises 应力
  [fixed_vm_stress]
    type = ElementAverageValue
    variable = vonmises_stress
    block = beam
  []
[]
