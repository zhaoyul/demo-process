# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: AAC 立方体抗压强度试验 (100×100×100mm)              ║
# ║  规范: GB/T 11969-2020                                     ║
# ║  试件编号: A1 (3块)                                        ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 试验描述: AAC 标准立方体(100mm)抗压强度试验
# 加载: 单调压缩, 加载速率 2 kN/s, 位移控制终止
# 材料: AAC - 蒸压加气混凝土, 密度 600 kg/m³
#       E = 1.75 GPa, ν = 0.20, f_c ≈ 3.5 MPa
#
# 网格: 10×10×10 六面体网格, 模拟 100mm 立方体
# 边界: 底面固定法向, 顶面施加均布位移压缩

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 10
  ny = 10
  nz = 10
  xmin = 0
  xmax = 0.1
  ymin = 0
  ymax = 0.1
  zmin = 0
  zmax = 0.1
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
  [min_princ]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Physics/SolidMechanics/QuasiStatic]
  [all]
    generate_output = 'stress_zz'
  []
[]

[BCs]
  # 底面约束法向位移
  [bottom_z]
    type = DirichletBC
    variable = disp_z
    boundary = bottom
    value = 0.0
  []
  # 底面中心点约束横向位移防止刚体位移
  [bottom_center_x]
    type = DirichletBC
    variable = disp_x
    boundary = bottom
    value = 0.0
  []
  [bottom_center_y]
    type = DirichletBC
    variable = disp_y
    boundary = bottom
    value = 0.0
  []
  # 顶面施加压缩位移 (0.05mm/s, 模拟准静态加载)
  # 总共压缩 2mm → 2% 应变
  [top_disp_z]
    type = FunctionDirichletBC
    variable = disp_z
    boundary = top
    function = '-2.0e-3 * t'
  []
[]

[AuxKernels]
  [vonmises_stress]
    type = RankTwoScalarAux
    variable = vonmises
    rank_two_tensor = stress
    scalar_type = VonMisesStress
    execute_on = 'TIMESTEP_END'
  []
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
[]

[Materials]
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1.75e9     # AAC E = 1.75 GPa
    poissons_ratio = 0.20
  []
  [strain]
    type = ComputeIncrementalSmallStrain
  []
  [stress]
    type = ComputeMultipleInelasticStress
    inelastic_models = 'aac_crush'
  []
  [aac_crush]
    type = IsotropicPlasticityStressUpdate
    yield_stress = 3.5e6        # AAC 抗压强度 ≈ 3.5 MPa
    hardening_constant = 0.0    # 理想塑性 (脆性材料近似)
  []
[]

[Functions]
  [load_rate]
    type = ParsedFunction
    expression = 't'
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

  # 加载时间: 2mm / 0.002mm = 1000 steps, dt = 0.01 → 10s 总时间
  start_time = 0.0
  end_time = 1.0
  dt = 0.05
  dtmin = 0.001

  [TimeIntegrator]
    type = ImplicitEuler
  []
[]

[Outputs]
  file_base = outputs/aac_compression_100mm
  exodus = true
  csv = true
  interval = 5
[]

[Postprocessors]
  [reaction_force_z]
    type = SideAverageValue
    variable = stress_zz
    boundary = top
  []
  [top_disp_z]
    type = SideAverageValue
    variable = disp_z
    boundary = top
  []
  [vonmises_max]
    type = ElementExtremeValue
    variable = vonmises
  []
  [compressive_strength]
    type = PointValue
    variable = min_princ
    point = '0.05 0.05 0.05'
  []
[]
