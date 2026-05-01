# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例4: 悬臂梁 — 热-固耦合 (温度驱动热膨胀)               ║
# ║  招标条款: 第6章 多物理耦合 (热-固耦合)                    ║
# ╚═══════════════════════════════════════════════════════════╝
#
# ΔT = +50K, α = 1.2e-5/K → ε_th = 6e-4
# 自由膨胀: δ_z = αΔT × H = 1.2e-5 × 50 × 0.2 = 1.2e-4 m

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
    eigenstrain_names = 'thermal_expansion'
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
    eigenstrain_names = 'thermal_expansion'
    block = beam
  []
  [thermal_expansion]
    type = ComputeThermalExpansionEigenstrain
    temperature = 50.0
    thermal_expansion_coeff = 1.2e-5
    stress_free_temperature = 0.0
    eigenstrain_name = thermal_expansion
    block = beam
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
[]

[Outputs]
  file_base = outputs/cantilever_beam_thermal
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
