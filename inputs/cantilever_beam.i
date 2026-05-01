# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: 悬臂梁静力学分析                                    ║
# ║  求解器: MOOSE Solid Mechanics (solid_mechanics-opt)      ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 理论解: δ_max = PL³/(3EI)
#   P = 10 kPa × 0.1×0.2 = 200 N, E = 200 GPa
#   I = bh³/12 = 0.1×0.2³/12 = 6.667e-5 m⁴
#   δ_max = 200 × 1³ / (3 × 2e11 × 6.667e-5) = 5.0e-6 m

[Mesh]
  type = FileMesh
  file = ../outputs/cantilever_beam.msh
[]

[Variables]
  [disp_x]
    order = FIRST
    family = LAGRANGE
  []
  [disp_y]
    order = FIRST
    family = LAGRANGE
  []
  [disp_z]
    order = FIRST
    family = LAGRANGE
  []
[]

[Kernels]
  [TensorMechanics]
    displacements = 'disp_x disp_y disp_z'
    use_displaced_mesh = false
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
    type = NeumannBC
    variable = disp_z
    boundary = load_surface
    value = -1.0e4
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
    displacements = 'disp_x disp_y disp_z'
  []
  [stress]
    type = ComputeLinearElasticStress
    block = beam
  []
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1.0e-6
  nl_max_its = 20
[]

[Outputs]
  file_base = ../outputs/cantilever_beam
  exodus = true
  csv = true
  console = true
[]

[Postprocessors]
  [tip_disp_z]
    type = PointValue
    variable = disp_z
    point = '1.0 0.05 0.2'
  []
[]
