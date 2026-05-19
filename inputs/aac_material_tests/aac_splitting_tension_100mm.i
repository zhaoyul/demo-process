# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: AAC 劈裂抗拉强度试验 (100×100×100mm)               ║
# ║  规范: GB/T 11969-2020                                     ║
# ║  试件编号: B1 (3块)                                        ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 试验描述: AAC 立方体劈裂抗拉试验 (巴西劈裂法)
# ft = 0.637 × P / A (公式1.2)
# 加载: 上下对中施加线荷载, 模拟劈裂
# 材料: AAC, E = 1.75 GPa, ν = 0.20, f_t ≈ 0.4 MPa

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 40
  ny = 40
  xmin = 0
  xmax = 0.1
  ymin = 0
  ymax = 0.1
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Variables]
  [disp_x] []
  [disp_y] []
[]

[AuxVariables]
  [max_princ]
    order = CONSTANT
    family = MONOMIAL
  []
  [min_princ]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_yy]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Physics/SolidMechanics/QuasiStatic]
  [all]
    generate_output = 'stress_yy'
  []
[]

[BCs]
  # 底部中心点约束
  [bottom_pin_x]
    type = DirichletBC
    variable = disp_x
    boundary = bottom
    value = 0.0
  []
  [bottom_pin_y]
    type = DirichletBC
    variable = disp_y
    boundary = bottom
    value = 0.0
  []
  # 顶部施加下压位移 (准静态劈裂)
  [top_disp_y]
    type = FunctionDirichletBC
    variable = disp_y
    boundary = top
    function = '-1.0e-4 * t'
  []
[]

[AuxKernels]
  [max_princ_stress]
    type = RankTwoScalarAux
    variable = max_princ
    rank_two_tensor = stress
    scalar_type = MaxPrincipal
    execute_on = 'TIMESTEP_END'
  []
  [min_princ_stress]
    type = RankTwoScalarAux
    variable = min_princ
    rank_two_tensor = stress
    scalar_type = MinPrincipal
    execute_on = 'TIMESTEP_END'
  []
  [stress_yy_kernel]
    type = RankTwoAux
    variable = stress_yy
    rank_two_tensor = stress
    index_i = 1
    index_j = 1
    execute_on = 'TIMESTEP_END'
  []
[]

[Materials]
  [elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1.75e9
    poissons_ratio = 0.20
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
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1.0e-10
  nl_max_its = 30
  start_time = 0.0
  end_time = 1.0
  dt = 0.05
  [TimeIntegrator]
    type = ImplicitEuler
  []
[]

[Outputs]
  file_base = outputs/aac_splitting_tension_100mm
  exodus = true
  csv = true
  interval = 5
[]

[Postprocessors]
  [top_reaction_y]
    type = SideAverageValue
    variable = stress_yy
    boundary = top
  []
  [center_sigma_x]
    type = PointValue
    variable = max_princ
    point = '0.05 0.05 0.0'
  []
  [top_disp]
    type = SideAverageValue
    variable = disp_y
    boundary = top
  []
[]
