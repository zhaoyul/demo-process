# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: 悬臂梁 — J2 弹塑性非线性材料                       ║
# ║  招标条款: 第6章 结构力学 + 非线性材料                     ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 验证: J2 塑性 + 各向同性硬化, 超出屈服强度后塑性变形
# 材料: 结构钢 Q235, E=200GPa, ν=0.3, σ_y=235MPa, H=2GPa

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
    value = -5.0e6
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
    type = ComputeIncrementalSmallStrain
    block = beam
  []
  [stress]
    type = ComputeMultipleInelasticStress
    inelastic_models = 'j2_plastic'
    block = beam
  []
  [j2_plastic]
    type = IsotropicPlasticityStressUpdate
    yield_stress = 235e6
    hardening_constant = 2.0e9
    block = beam
  []
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  nl_rel_tol = 1.0e-6
  nl_abs_tol = 1.0e-6
  nl_max_its = 30
[]

[Outputs]
  file_base = outputs/cantilever_beam_plastic_high
  exodus = true
  csv = true
[]

[Postprocessors]
  [tip_disp_z]
    type = PointValue
    variable = disp_z
    point = '1.0 0.05 0.2'
  []
[]
