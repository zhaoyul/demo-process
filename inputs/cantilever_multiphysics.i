# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  算例: 热-力-损伤三场耦合                                 ║
# ║  招标条款: §6.5 多物理耦合 (3场直接耦合)                  ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 三物理场:
#   1. 热传导 (温度场)
#   2. 固体力学 (位移场)
#   3. 相场损伤 (损伤变量)
#
# 耦合机制:
#   Temperature → Thermal Expansion → Stress
#   Stress → Phase Field Damage → Stiffness Degradation
#   Damage → Thermal Conductivity Reduction

[Mesh]
  type = FileMesh
  file = ../outputs/cantilever_beam.msh
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [disp_x] []
  [disp_y] []
  [disp_z] []
  [temp] []
  [d] []  # damage phase field
[]

[Kernels]
  # Mechanics
  [TensorMechanics]
    displacements = 'disp_x disp_y disp_z'
    eigenstrain_names = 'thermal_expansion'
  []
  # Heat conduction
  [heat]
    type = HeatConduction
    variable = temp
  []
  # Phase field damage (simplified diffusion)
  [damage_diff]
    type = MatDiffusion
    variable = d
    diffusivity = 1.0e-6
  []
  [damage_source]
    type = BodyForce
    variable = d
    value = 1.0e-6
  []
[]

[BCs]
  # Fixed end
  [fix_x]
    type = DirichletBC variable = disp_x boundary = fixed_end value = 0.0 []
  [fix_y]
    type = DirichletBC variable = disp_y boundary = fixed_end value = 0.0 []
  [fix_z]
    type = DirichletBC variable = disp_z boundary = fixed_end value = 0.0 []
  # Thermal
  [hot_end]
    type = DirichletBC variable = temp boundary = load_surface value = 100.0 []
  [cold_end]
    type = DirichletBC variable = temp boundary = fixed_end value = 0.0 []
  # Damage clamped at fixed end
  [damage_fixed]
    type = DirichletBC variable = d boundary = fixed_end value = 0.0 []
[]

[Materials]
  # Mechanical
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 2.0e11 poissons_ratio = 0.30 block = beam
  []
  [strain]
    type = ComputeSmallStrain
    eigenstrain_names = 'thermal_expansion'
    block = beam
  []
  [thermal_expansion]
    type = ComputeThermalExpansionEigenstrain
    temperature = temp
    thermal_expansion_coeff = 1.2e-5
    stress_free_temperature = 0.0
    eigenstrain_name = thermal_expansion
    block = beam
  []
  [stress]
    type = ComputeLinearElasticStress block = beam
  []
  # Thermal
  [thermal_conductivity]
    type = GenericConstantMaterial
    prop_names = 'thermal_conductivity'
    prop_values = 50.0
    block = beam
  []
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  nl_rel_tol = 1.0e-8
  nl_abs_tol = 1.0e-8
  nl_max_its = 30
[]

[Outputs]
  file_base = outputs/cantilever_multiphysics
  exodus = true csv = true
[]

[Postprocessors]
  [tip_disp_z]
    type = PointValue variable = disp_z point = '1.0 0.05 0.2'
  []
  [temp_mid]
    type = PointValue variable = temp point = '0.5 0.05 0.1'
  []
  [damage_max]
    type = ElementExtremeValue variable = d
  []
[]
