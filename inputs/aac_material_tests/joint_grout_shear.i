# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: 接缝灌浆剪切试验 (600×480×240mm, φ80预留孔)        ║
# ║  试验编号: J (3块)                                        ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 试验描述: 灌浆与AAC板界面剪切粘结强度试验
# 试件: 600×480×240mm, 中心 φ80mm 灌浆孔
# 加载: 垂直加载, 匀速连续加荷, 1~3min 破坏
# 材料: AAC + M60 灌浆, 界面接触模型
# fv = N / A (公式1.3)

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 30
  ny = 24
  nz = 12
  xmin = 0
  xmax = 0.6
  ymin = 0
  ymax = 0.48
  zmin = 0
  zmax = 0.24
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [disp_x] []
  [disp_y] []
  [disp_z] []
[]

[AuxVariables]
  [vonmises]
    order = CONSTANT
    family = MONOMIAL
  []
  [max_princ]
    order = CONSTANT
    family = MONOMIAL
  []
  [shear_stress_xy]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Kernels]
  [TensorMechanics]
    displacements = 'disp_x disp_y disp_z'
  []
[]

[BCs]
  # 底面约束
  [bottom_z]
    type = DirichletBC
    variable = disp_z
    boundary = bottom
    value = 0.0
  []
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
  # 顶面施加剪切位移 (沿x方向)
  [top_shear_x]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = top
    function = '5.0e-4 * t'
  []
[]

[AuxKernels]
  [vonmises_kernel]
    type = RankTwoScalarAux
    variable = vonmises
    rank_two_tensor = stress
    scalar_type = VonMisesStress
    execute_on = 'TIMESTEP_END'
  []
  [max_princ_kernel]
    type = RankTwoScalarAux
    variable = max_princ
    rank_two_tensor = stress
    scalar_type = MaxPrincipal
    execute_on = 'TIMESTEP_END'
  []
  [shear_stress_xy_kernel]
    type = RankTwoAux
    variable = shear_stress_xy
    rank_two_tensor = stress
    index_i = 0
    index_j = 1
    execute_on = 'TIMESTEP_END'
  []
[]

[Materials]
  # AAC 基体
  [aac_elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1.75e9
    poissons_ratio = 0.20
  []
  [aac_strain]
    type = ComputeIncrementalStrain
  []
  [aac_stress]
    type = ComputeFiniteStrainElasticStress
  []
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  nl_rel_tol = 1.0e-6
  nl_abs_tol = 1.0e-8
  nl_max_its = 30
  start_time = 0.0
  end_time = 1.0
  dt = 0.05
  [TimeIntegrator]
    type = ImplicitEuler
  []
[]

[Outputs]
  file_base = outputs/joint_grout_shear
  exodus = true
  csv = true
[]

[Postprocessors]
  [top_reaction_x]
    type = SideAverageValue
    variable = stress_xy
    boundary = top
  []
  [top_disp_x]
    type = SideAverageValue
    variable = disp_x
    boundary = top
  []
  [shear_max]
    type = ElementExtremeValue
    variable = shear_stress_xy
  []
[]
  [stress_xy]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_xy_kernel]
    type = RankTwoAux
    variable = stress_xy
    rank_two_tensor = stress
    index_i = 0
    index_j = 1
    execute_on = 'TIMESTEP_END'
  []
