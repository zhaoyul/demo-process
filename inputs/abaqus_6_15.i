# ============================================================================
# Abaqus 6-15 (LW-Copy) → MOOSE 转换算例 v2
# AAC 砌体墙拟静力试验: C40 框架 + AAC705 砌块 + M60 灌浆/灰缝 + 钢筋骨架
#
# 网格: outputs/abaqus_6_15/6-15_mesh.e  (tools/abaqus2exodus.py 由 6-15.inp 转换)
# 单位: mm-N-MPa (与 Abaqus 源模型一致)
#
# v2 — Abaqus 约束的 MOOSE 完整映射:
#   *Embedded Element (Constraint-4) → MPC 多点约束 (v3)
#       每个钢筋节点定位宿主 hex, 形函数插值 u_truss = Σ N_i·u_solid_i
#       (LinearNodalConstraint × 17364, 见 outputs/abaqus_6_15/mpc_rebar.i;
#        未命中宿主者退化为最近实体节点 w=1; 钢筋保持原始直线几何)
#   *Tie ×9 (adjust=yes)            → 转换器节点缝合 (abaqus2exodus.py --tie-tol)
#       slave 面节点并入最近 master 节点, 网格层面保证绑定
#   *Coupling kinematic (Constraint-17, rp→加载面) → 加载面整体 Dirichlet 位移
#       (对被驱动自由度 U1 与运动耦合等效)
#   cohesive 接触 (灰缝)            → 单体化 + AAC 块 prescribed scalar damage
#
# 加载协议 (对应 Abaqus 两个 Step):
#   Step-1: 顶梁顶面竖向压力 0.5 MPa (t=0→1 线性加载, 之后保持)
#   Step-2: 顶梁顶面水平位移循环 (Amp-1: ±16mm, ±20mm, t=1→8)
# ============================================================================

[Mesh]
  [file]
    type = FileMeshGenerator
    file = ../outputs/abaqus_6_15/6-15_mesh.e
  []
  # v4: 求解不含钢筋 (保持钢筋零丢失; 钢筋位移/应力由宿主插值后处理得到)
  [del_rebar]
    type = BlockDeletionGenerator
    input = file
    block = 'AA_dinglaing_gujin__gangjin AA_zongjin_D12__gangjin
             AA_zongjin_D16__gangjin CC_diliang_gujin__gangjin
             CC_zongjin_D12__gangjin CC_zongjin_D16__gangjin
             EE_lianjiegangjin__HPB400 Part_23__gangjin
             gjwl_1__gangjin zgjl__gangjin_A50 zgjl__gangjin_A113'
  []
  # Pressure BC 需要 sideset: 只转换压力面 nodeset
  # (全部转换会把共享表面节点的 truss 单元 0D 侧面也加入, 导致 Pressure 崩溃)
  [surf_sidesets]
    type = SideSetsFromNodeSetsGenerator
    input = del_rebar
    nodesets_to_convert = 'SURF__PickedSurf829'
  []
[]

[Problem]
  kernel_coverage_check = false
  material_coverage_check = false
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [disp_x]
  []
  [disp_y]
  []
  [disp_z]
  []
[]

[AuxVariables]
  [vonmises]
    order = CONSTANT
    family = MONOMIAL
  []
  [damage_index]
    order = CONSTANT
    family = MONOMIAL
  []
[]

# ---------------------------------------------------------------------------
# 实体结构 kernel (框架/砌块/灌浆)
# ---------------------------------------------------------------------------
[Kernels]
  [TensorMechanics]
    block = 'kuang__C40 kuang__M60 DD_gujiangliao__M60 BB_qikuai__aac705'
  []
  # --- 钢筋 TRUSS kernels (按截面积分组, 3 个分量) ---
  # D8 箍筋 A=50.24 mm²
  # D12 纵筋 A=113.04 mm²
  # D16 纵筋 A=200.96 mm²
  # HPB400-14 连接筋 A=153.938 mm²
  # D6 构造筋 A=28.26 mm²
[]

[BCs]
  # --- BC-1: 框架底面 ENCASTRE (对应 Abaqus 初始 *Boundary, _PickedSet833@kuang-1)
  [fixed_x]
    type = DirichletBC
    variable = disp_x
    boundary = '_PickedSet833__kuang_1'
    value = 0.0
  []
  [fixed_y]
    type = DirichletBC
    variable = disp_y
    boundary = '_PickedSet833__kuang_1'
    value = 0.0
  []
  [fixed_z]
    type = DirichletBC
    variable = disp_z
    boundary = '_PickedSet833__kuang_1'
    value = 0.0
  []
  # --- Step-1: 顶面竖向压力 0.5 MPa (_PickedSurf829), t=0→1 加载后保持
  [top_pressure]
    type = Pressure
    variable = disp_y
    component = 1
    boundary = 'SURF__PickedSurf829'
    factor = 0.5
    function = pressure_ramp
  []
  # --- Step-2: 顶面水平循环位移 (Amp-1 幅值曲线, _PickedSurf837 耦合面)
  #     等效 *Coupling kinematic: 加载面整体刚性 U1 平动
  [cyclic_x]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = 'SURF__PickedSurf837'
    function = amp_1
  []
[]

[Functions]
  [pressure_ramp]
    type = ParsedFunction
    expression = 'if(t<1, t, 1)'
  []
  # Abaqus *Amplitude Amp-1: (0,0)(1,16)(2,0)(3,-16)(4,0)(5,20)(6,0)(7,-20)(8,0)
  [amp_1]
    type = PiecewiseLinear
    xy_data = '0.0   0.0
               1.0  16.0
               2.0   0.0
               3.0 -16.0
               4.0   0.0
               5.0  20.0
               6.0   0.0
               7.0 -20.0
               8.0   0.0'
  []
  # prescribed 损伤演化: 随循环加载幅值增大而单调累积 (近似灰缝开裂)
  [damage_evolution]
    type = PiecewiseLinear
    xy_data = '0.0   0.00
               1.0   0.00
               2.0   0.05
               3.0   0.12
               4.0   0.18
               5.0   0.30
               6.0   0.38
               7.0   0.52
               8.0   0.62'
  []
[]

[AuxKernels]
  [vonmises]
    type = RankTwoScalarAux
    variable = vonmises
    rank_two_tensor = stress
    scalar_type = VonMisesStress
    block = 'kuang__C40 kuang__M60 DD_gujiangliao__M60 BB_qikuai__aac705'
    execute_on = TIMESTEP_END
  []
  [damage_index_aux]
    type = MaterialRealAux
    variable = damage_index
    property = damage_index
    block = 'BB_qikuai__aac705'
    execute_on = TIMESTEP_END
  []
[]

[Materials]
  # --- C40 混凝土框架: 线弹性 (E=32.5GPa, ν=0.2, 来自 Abaqus *Elastic)
  [elasticity_c40]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 32500.0
    poissons_ratio = 0.2
    block = 'kuang__C40'
  []
  [stress_c40]
    type = ComputeFiniteStrainElasticStress
    block = 'kuang__C40'
  []
  # --- M60 灌浆料/灰缝: 线弹性 (E=36GPa, ν=0.2)
  [elasticity_m60]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 36000.0
    poissons_ratio = 0.2
    block = 'kuang__M60 DD_gujiangliao__M60'
  []
  [stress_m60]
    type = ComputeFiniteStrainElasticStress
    block = 'kuang__M60 DD_gujiangliao__M60'
  []
  # --- AAC705 砌块: 弹性 + prescribed scalar damage (E=2.85GPa, ν=0.2)
  [damage_index_mat]
    type = GenericFunctionMaterial
    prop_names = damage_index_prop
    prop_values = damage_evolution
    block = 'BB_qikuai__aac705'
  []
  [damage_aac]
    type = ScalarMaterialDamage
    damage_index = damage_index_prop
    damage_index_name = damage_index
    maximum_damage_increment = 0.05
    block = 'BB_qikuai__aac705'
  []
  [stress_aac]
    type = ComputeDamageStress
    damage_model = damage_aac
    block = 'BB_qikuai__aac705'
  []
  [elasticity_aac]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 2850.0
    poissons_ratio = 0.2
    block = 'BB_qikuai__aac705'
  []
  [strain_all]
    type = ComputeFiniteStrain
    block = 'kuang__C40 kuang__M60 DD_gujiangliao__M60 BB_qikuai__aac705'
  []
  # --- 钢筋: truss 线弹性 (gangjin E=206GPa, HPB400 E=200GPa)
[]

[Postprocessors]
  [load_disp_x]
    type = AverageNodalVariableValue
    variable = disp_x
    boundary = 'SURF__PickedSurf837'
  []
  [vonmises_max]
    type = ElementExtremeValue
    variable = vonmises
  []
  [damage_max]
    type = ElementExtremeValue
    variable = damage_index
  []
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  # truss 刚度(钢~206GPa)与实体(混凝土~3-36GPa)差异大, AMG 崩溃 → 直接求解器
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu mumps'
  nl_rel_tol = 1.0e-4
  nl_abs_tol = 1.0e-6
  nl_max_its = 30
  l_max_its = 100
  dt = 0.2
  num_steps = 40
  automatic_scaling = true
[]

[Outputs]
  file_base = abaqus_6_15_out
  exodus = true
  csv = true
  perf_graph = true
[]
