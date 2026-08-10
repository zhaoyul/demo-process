# pr_rg_400gal_x: Abaqus→MOOSE 梁模型地震时程分析 (自动生成)
# 源: /home/kevin/Abaqus/PR-RG-400gal-X/PR-RG-400gal-X.inp
# 单位制: mm-t-N-s (应力 MPa, 加速度 mm/s²)
# 近似: *RELEASE 端部释放未模拟; 刚度比例阻尼以 HHT alpha=0.0 近似; MPC BEAM → 刚性连杆

[Mesh]
  [file]
    type = FileMeshGenerator
    file = ../outputs/pr_rg_400gal_x/pr_rg_400gal_x_mesh.e
  []
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [disp_x]
  []
  [disp_y]
  []
  [disp_z]
  []
  [rot_x]
  []
  [rot_y]
  []
  [rot_z]
  []
[]

[AuxVariables]
  [vel_x]
    family = LAGRANGE
    order = FIRST
  []
  [accel_x]
    family = LAGRANGE
    order = FIRST
  []
  [vel_y]
    family = LAGRANGE
    order = FIRST
  []
  [accel_y]
    family = LAGRANGE
    order = FIRST
  []
  [vel_z]
    family = LAGRANGE
    order = FIRST
  []
  [accel_z]
    family = LAGRANGE
    order = FIRST
  []
  [rot_vel_x]
    family = LAGRANGE
    order = FIRST
  []
  [rot_accel_x]
    family = LAGRANGE
    order = FIRST
  []
  [rot_vel_y]
    family = LAGRANGE
    order = FIRST
  []
  [rot_accel_y]
    family = LAGRANGE
    order = FIRST
  []
  [rot_vel_z]
    family = LAGRANGE
    order = FIRST
  []
  [rot_accel_z]
    family = LAGRANGE
    order = FIRST
  []
[]

[AuxKernels]
  [accel_x]
    type = NewmarkAccelAux
    variable = accel_x
    displacement = disp_x
    velocity = vel_x
    beta = 0.25
    execute_on = 'TIMESTEP_END'
  []
  [vel_x]
    type = NewmarkVelAux
    variable = vel_x
    acceleration = accel_x
    gamma = 0.5
    execute_on = 'TIMESTEP_END'
  []
  [rot_accel_x]
    type = NewmarkAccelAux
    variable = rot_accel_x
    displacement = rot_x
    velocity = rot_vel_x
    beta = 0.25
    execute_on = 'TIMESTEP_END'
  []
  [rot_vel_x]
    type = NewmarkVelAux
    variable = rot_vel_x
    acceleration = rot_accel_x
    gamma = 0.5
    execute_on = 'TIMESTEP_END'
  []
  [accel_y]
    type = NewmarkAccelAux
    variable = accel_y
    displacement = disp_y
    velocity = vel_y
    beta = 0.25
    execute_on = 'TIMESTEP_END'
  []
  [vel_y]
    type = NewmarkVelAux
    variable = vel_y
    acceleration = accel_y
    gamma = 0.5
    execute_on = 'TIMESTEP_END'
  []
  [rot_accel_y]
    type = NewmarkAccelAux
    variable = rot_accel_y
    displacement = rot_y
    velocity = rot_vel_y
    beta = 0.25
    execute_on = 'TIMESTEP_END'
  []
  [rot_vel_y]
    type = NewmarkVelAux
    variable = rot_vel_y
    acceleration = rot_accel_y
    gamma = 0.5
    execute_on = 'TIMESTEP_END'
  []
  [accel_z]
    type = NewmarkAccelAux
    variable = accel_z
    displacement = disp_z
    velocity = vel_z
    beta = 0.25
    execute_on = 'TIMESTEP_END'
  []
  [vel_z]
    type = NewmarkVelAux
    variable = vel_z
    acceleration = accel_z
    gamma = 0.5
    execute_on = 'TIMESTEP_END'
  []
  [rot_accel_z]
    type = NewmarkAccelAux
    variable = rot_accel_z
    displacement = rot_z
    velocity = rot_vel_z
    beta = 0.25
    execute_on = 'TIMESTEP_END'
  []
  [rot_vel_z]
    type = NewmarkVelAux
    variable = rot_vel_z
    acceleration = rot_accel_z
    gamma = 0.5
    execute_on = 'TIMESTEP_END'
  []
[]

[Functions]
  [zero]
    type = ConstantFunction
    value = 0.0
  []
  [rg_x]
    type = PiecewiseLinear
    data_file = ../outputs/pr_rg_400gal_x/rg_x.csv
    format = columns
  []
[]

[Kernels]
  [sd_disp_x]
    type = StressDivergenceBeam
    block = 'insulator_su__aluminium_I_g1 insulator_su__aluminium_I_g2 insulator_su__aluminium_I_g3 insulator_su__aluminium_I_g4 insulator_su__aluminium_I_g5 insulator_su__aluminium_I_g6 insulator_su__aluminium_I_g7 insulator_su__flange_CIRC_g8 insulator_su__flange_CIRC_g9 insulator_s__flange_CIRC_g10 insulato__insulator_CIRC_g11 insulator_s__flange_CIRC_g12 insulator_s__aluminium_I_g13 insulator_s__flange_CIRC_g14 insulator_s__flange_CIRC_g15 insulator_s__flange_CIRC_g16 insulato__insulator_CIRC_g17 insulator_s__flange_CIRC_g18 insulator_s__flange_CIRC_g19 insulator_s__flange_CIRC_g20 insulator_s__aluminium_I_g21 insulator_s__aluminium_I_g22 insulator_s__aluminium_I_g23 insulator_s__flange_CIRC_g24 insulator_s__flange_CIRC_g25 insulator_s__flange_CIRC_g26 insulato__insulator_CIRC_g27 insulator_s__flange_CIRC_g28 insulator_s__flange_CIRC_g29 insulator_s__flange_CIRC_g30 insulator_s__flange_CIRC_g31 insulator_s__flange_CIRC_g32 insulato__insulator_CIRC_g33 insulato__insulator_CIRC_g34 insulator_s__flange_CIRC_g35 insulator_s__aluminium_I_g36 insulator_s__flange_CIRC_g37 insulator_s__flange_CIRC_g38 insulato__insulator_CIRC_g39 insulator_s__flange_CIRC_g40 insulator_s__flange_CIRC_g41 insulator_s__aluminium_I_g42 insulator_s__aluminium_I_g43 insulator_s__aluminium_I_g44 insulator_s__flange_CIRC_g45 insulator_s__flange_CIRC_g46 insulator_s__flange_CIRC_g47 insulato__insulator_CIRC_g48 insulator_s__flange_CIRC_g49 insulator_s__flange_CIRC_g50 insulator_s__aluminium_I_g51 insulator_s__aluminium_I_g52 insulator_s__aluminium_I_g53 insulator_s__flange_CIRC_g54 insulator_s__flange_CIRC_g55 insulator_s__flange_CIRC_g56 insulator_s__flange_CIRC_g57 insulato__insulator_CIRC_g58 insulator_s__flange_CIRC_g59 insulator_s__flange_CIRC_g60 insulator_s__flange_CIRC_g61 insulator_s__flange_CIRC_g62 insulator_s__flange_CIRC_g63 insulator_s__flange_CIRC_g64 insulator_s__flange_CIRC_g65 insulator_s__flange_CIRC_g66 insulator_s__flange_CIRC_g67 insulator_s__flange_CIRC_g68 insulato__insulator_CIRC_g69 insulator_s__flange_CIRC_g70 insulator_s__aluminium_I_g71 insulator_s__aluminium_I_g72 insulator_s__flange_CIRC_g73 insulator_s__flange_CIRC_g74 insulator_s__flange_CIRC_g75 insulator_s__flange_CIRC_g76 insulator_s__flange_CIRC_g77 insulator_s__flange_CIRC_g78 insulator_s__flange_CIRC_g79 insulator_s__flange_CIRC_g80 insulator_s__aluminium_I_g81 insulator_s__flange_CIRC_g82 insulator_s__flange_CIRC_g83 insulator_s__flange_CIRC_g84 insulator_s__flange_CIRC_g85 insulator_s__flange_CIRC_g86 insulator_s__flange_CIRC_g87 insulator_s__flange_CIRC_g88 insulator_s__flange_CIRC_g89 insulator_s__flange_CIRC_g90 insulator_s__flange_CIRC_g91 insulator_s__flange_CIRC_g92 insulato__insulator_CIRC_g93 insulator_s__flange_CIRC_g94 insulato__insulator_CIRC_g95 insulator_s__flange_CIRC_g96 insulator_s__flange_CIRC_g97 insulator_s__flange_CIRC_g98 insulator_s__flange_CIRC_g99 insulator___flange_CIRC_g100 insulator___flange_CIRC_g101 insulator___flange_CIRC_g102 insulator___flange_CIRC_g103 insulator___flange_CIRC_g104 insulator___flange_CIRC_g105 insulator___flange_CIRC_g106 insulator___flange_CIRC_g107 insulator___flange_CIRC_g108 insulator___flange_CIRC_g109 insulator___aluminium_I_g110 insulator___flange_CIRC_g111 insulator___flange_CIRC_g112 insulator___flange_CIRC_g113 insulator___flange_CIRC_g114 insulat__insulator_CIRC_g115 insulat__insulator_CIRC_g116 insulator___flange_CIRC_g117 insulator___flange_CIRC_g118 insulator___flange_CIRC_g119 insulator___flange_CIRC_g120 insulator___flange_CIRC_g121 insulator___flange_CIRC_g122 insulator___flange_CIRC_g123 insulator___flange_CIRC_g124 insulator___flange_CIRC_g125 insulator___flange_CIRC_g126 insulator___flange_CIRC_g127 insulator___flange_CIRC_g128 insulator___flange_CIRC_g129 insulator___flange_CIRC_g130 insulator___flange_CIRC_g131 insulator___flange_CIRC_g132 insulator___flange_CIRC_g133 insulator___flange_CIRC_g134 insulator___flange_CIRC_g135 insulator___flange_CIRC_g136 insulat__insulator_CIRC_g137 insulator___flange_CIRC_g138 insulator___flange_CIRC_g139 insulator___flange_CIRC_g140 insulator___flange_CIRC_g141 insulator___flange_CIRC_g142 insulator___flange_CIRC_g143 insulator___flange_CIRC_g144 insulator___flange_CIRC_g145 insulat__insulator_CIRC_g146 insulator___flange_CIRC_g147 insulator___flange_CIRC_g148 insulator___flange_CIRC_g149 insulator___flange_CIRC_g150 insulator___flange_CIRC_g151 insulator___flange_CIRC_g152 insulator___flange_CIRC_g153 insulator___flange_CIRC_g154 insulator___aluminium_I_g155 insulator___flange_CIRC_g156 insulator___flange_CIRC_g157 insulat__insulator_CIRC_g158 insulator___flange_CIRC_g159 insulator___flange_CIRC_g160 insulator___flange_CIRC_g161 insulator___flange_CIRC_g162 insulator___flange_CIRC_g163 insulator___flange_CIRC_g164 insulator___flange_CIRC_g165 insulator___aluminium_I_g166 insulator___flange_CIRC_g167 insulator___flange_CIRC_g168 insulator___flange_CIRC_g169 insulator___flange_CIRC_g170 insulator___flange_CIRC_g171 insulator___flange_CIRC_g172 insulator___flange_CIRC_g173 insulator___flange_CIRC_g174 insulator___flange_CIRC_g175 insulator___flange_CIRC_g176 mpc_beam_links_g1 mpc_beam_links_g2 mpc_beam_links_g3 mpc_beam_links_g4 mpc_beam_links_g5 mpc_beam_links_g6 mpc_beam_links_g7 mpc_beam_links_g8 mpc_beam_links_g9 mpc_beam_links_g10 mpc_beam_links_g11 mpc_beam_links_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 0
    variable = disp_x
    zeta = 0.005697
    alpha = 0.0
  []
  [sd_disp_y]
    type = StressDivergenceBeam
    block = 'insulator_su__aluminium_I_g1 insulator_su__aluminium_I_g2 insulator_su__aluminium_I_g3 insulator_su__aluminium_I_g4 insulator_su__aluminium_I_g5 insulator_su__aluminium_I_g6 insulator_su__aluminium_I_g7 insulator_su__flange_CIRC_g8 insulator_su__flange_CIRC_g9 insulator_s__flange_CIRC_g10 insulato__insulator_CIRC_g11 insulator_s__flange_CIRC_g12 insulator_s__aluminium_I_g13 insulator_s__flange_CIRC_g14 insulator_s__flange_CIRC_g15 insulator_s__flange_CIRC_g16 insulato__insulator_CIRC_g17 insulator_s__flange_CIRC_g18 insulator_s__flange_CIRC_g19 insulator_s__flange_CIRC_g20 insulator_s__aluminium_I_g21 insulator_s__aluminium_I_g22 insulator_s__aluminium_I_g23 insulator_s__flange_CIRC_g24 insulator_s__flange_CIRC_g25 insulator_s__flange_CIRC_g26 insulato__insulator_CIRC_g27 insulator_s__flange_CIRC_g28 insulator_s__flange_CIRC_g29 insulator_s__flange_CIRC_g30 insulator_s__flange_CIRC_g31 insulator_s__flange_CIRC_g32 insulato__insulator_CIRC_g33 insulato__insulator_CIRC_g34 insulator_s__flange_CIRC_g35 insulator_s__aluminium_I_g36 insulator_s__flange_CIRC_g37 insulator_s__flange_CIRC_g38 insulato__insulator_CIRC_g39 insulator_s__flange_CIRC_g40 insulator_s__flange_CIRC_g41 insulator_s__aluminium_I_g42 insulator_s__aluminium_I_g43 insulator_s__aluminium_I_g44 insulator_s__flange_CIRC_g45 insulator_s__flange_CIRC_g46 insulator_s__flange_CIRC_g47 insulato__insulator_CIRC_g48 insulator_s__flange_CIRC_g49 insulator_s__flange_CIRC_g50 insulator_s__aluminium_I_g51 insulator_s__aluminium_I_g52 insulator_s__aluminium_I_g53 insulator_s__flange_CIRC_g54 insulator_s__flange_CIRC_g55 insulator_s__flange_CIRC_g56 insulator_s__flange_CIRC_g57 insulato__insulator_CIRC_g58 insulator_s__flange_CIRC_g59 insulator_s__flange_CIRC_g60 insulator_s__flange_CIRC_g61 insulator_s__flange_CIRC_g62 insulator_s__flange_CIRC_g63 insulator_s__flange_CIRC_g64 insulator_s__flange_CIRC_g65 insulator_s__flange_CIRC_g66 insulator_s__flange_CIRC_g67 insulator_s__flange_CIRC_g68 insulato__insulator_CIRC_g69 insulator_s__flange_CIRC_g70 insulator_s__aluminium_I_g71 insulator_s__aluminium_I_g72 insulator_s__flange_CIRC_g73 insulator_s__flange_CIRC_g74 insulator_s__flange_CIRC_g75 insulator_s__flange_CIRC_g76 insulator_s__flange_CIRC_g77 insulator_s__flange_CIRC_g78 insulator_s__flange_CIRC_g79 insulator_s__flange_CIRC_g80 insulator_s__aluminium_I_g81 insulator_s__flange_CIRC_g82 insulator_s__flange_CIRC_g83 insulator_s__flange_CIRC_g84 insulator_s__flange_CIRC_g85 insulator_s__flange_CIRC_g86 insulator_s__flange_CIRC_g87 insulator_s__flange_CIRC_g88 insulator_s__flange_CIRC_g89 insulator_s__flange_CIRC_g90 insulator_s__flange_CIRC_g91 insulator_s__flange_CIRC_g92 insulato__insulator_CIRC_g93 insulator_s__flange_CIRC_g94 insulato__insulator_CIRC_g95 insulator_s__flange_CIRC_g96 insulator_s__flange_CIRC_g97 insulator_s__flange_CIRC_g98 insulator_s__flange_CIRC_g99 insulator___flange_CIRC_g100 insulator___flange_CIRC_g101 insulator___flange_CIRC_g102 insulator___flange_CIRC_g103 insulator___flange_CIRC_g104 insulator___flange_CIRC_g105 insulator___flange_CIRC_g106 insulator___flange_CIRC_g107 insulator___flange_CIRC_g108 insulator___flange_CIRC_g109 insulator___aluminium_I_g110 insulator___flange_CIRC_g111 insulator___flange_CIRC_g112 insulator___flange_CIRC_g113 insulator___flange_CIRC_g114 insulat__insulator_CIRC_g115 insulat__insulator_CIRC_g116 insulator___flange_CIRC_g117 insulator___flange_CIRC_g118 insulator___flange_CIRC_g119 insulator___flange_CIRC_g120 insulator___flange_CIRC_g121 insulator___flange_CIRC_g122 insulator___flange_CIRC_g123 insulator___flange_CIRC_g124 insulator___flange_CIRC_g125 insulator___flange_CIRC_g126 insulator___flange_CIRC_g127 insulator___flange_CIRC_g128 insulator___flange_CIRC_g129 insulator___flange_CIRC_g130 insulator___flange_CIRC_g131 insulator___flange_CIRC_g132 insulator___flange_CIRC_g133 insulator___flange_CIRC_g134 insulator___flange_CIRC_g135 insulator___flange_CIRC_g136 insulat__insulator_CIRC_g137 insulator___flange_CIRC_g138 insulator___flange_CIRC_g139 insulator___flange_CIRC_g140 insulator___flange_CIRC_g141 insulator___flange_CIRC_g142 insulator___flange_CIRC_g143 insulator___flange_CIRC_g144 insulator___flange_CIRC_g145 insulat__insulator_CIRC_g146 insulator___flange_CIRC_g147 insulator___flange_CIRC_g148 insulator___flange_CIRC_g149 insulator___flange_CIRC_g150 insulator___flange_CIRC_g151 insulator___flange_CIRC_g152 insulator___flange_CIRC_g153 insulator___flange_CIRC_g154 insulator___aluminium_I_g155 insulator___flange_CIRC_g156 insulator___flange_CIRC_g157 insulat__insulator_CIRC_g158 insulator___flange_CIRC_g159 insulator___flange_CIRC_g160 insulator___flange_CIRC_g161 insulator___flange_CIRC_g162 insulator___flange_CIRC_g163 insulator___flange_CIRC_g164 insulator___flange_CIRC_g165 insulator___aluminium_I_g166 insulator___flange_CIRC_g167 insulator___flange_CIRC_g168 insulator___flange_CIRC_g169 insulator___flange_CIRC_g170 insulator___flange_CIRC_g171 insulator___flange_CIRC_g172 insulator___flange_CIRC_g173 insulator___flange_CIRC_g174 insulator___flange_CIRC_g175 insulator___flange_CIRC_g176 mpc_beam_links_g1 mpc_beam_links_g2 mpc_beam_links_g3 mpc_beam_links_g4 mpc_beam_links_g5 mpc_beam_links_g6 mpc_beam_links_g7 mpc_beam_links_g8 mpc_beam_links_g9 mpc_beam_links_g10 mpc_beam_links_g11 mpc_beam_links_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 1
    variable = disp_y
    zeta = 0.005697
    alpha = 0.0
  []
  [sd_disp_z]
    type = StressDivergenceBeam
    block = 'insulator_su__aluminium_I_g1 insulator_su__aluminium_I_g2 insulator_su__aluminium_I_g3 insulator_su__aluminium_I_g4 insulator_su__aluminium_I_g5 insulator_su__aluminium_I_g6 insulator_su__aluminium_I_g7 insulator_su__flange_CIRC_g8 insulator_su__flange_CIRC_g9 insulator_s__flange_CIRC_g10 insulato__insulator_CIRC_g11 insulator_s__flange_CIRC_g12 insulator_s__aluminium_I_g13 insulator_s__flange_CIRC_g14 insulator_s__flange_CIRC_g15 insulator_s__flange_CIRC_g16 insulato__insulator_CIRC_g17 insulator_s__flange_CIRC_g18 insulator_s__flange_CIRC_g19 insulator_s__flange_CIRC_g20 insulator_s__aluminium_I_g21 insulator_s__aluminium_I_g22 insulator_s__aluminium_I_g23 insulator_s__flange_CIRC_g24 insulator_s__flange_CIRC_g25 insulator_s__flange_CIRC_g26 insulato__insulator_CIRC_g27 insulator_s__flange_CIRC_g28 insulator_s__flange_CIRC_g29 insulator_s__flange_CIRC_g30 insulator_s__flange_CIRC_g31 insulator_s__flange_CIRC_g32 insulato__insulator_CIRC_g33 insulato__insulator_CIRC_g34 insulator_s__flange_CIRC_g35 insulator_s__aluminium_I_g36 insulator_s__flange_CIRC_g37 insulator_s__flange_CIRC_g38 insulato__insulator_CIRC_g39 insulator_s__flange_CIRC_g40 insulator_s__flange_CIRC_g41 insulator_s__aluminium_I_g42 insulator_s__aluminium_I_g43 insulator_s__aluminium_I_g44 insulator_s__flange_CIRC_g45 insulator_s__flange_CIRC_g46 insulator_s__flange_CIRC_g47 insulato__insulator_CIRC_g48 insulator_s__flange_CIRC_g49 insulator_s__flange_CIRC_g50 insulator_s__aluminium_I_g51 insulator_s__aluminium_I_g52 insulator_s__aluminium_I_g53 insulator_s__flange_CIRC_g54 insulator_s__flange_CIRC_g55 insulator_s__flange_CIRC_g56 insulator_s__flange_CIRC_g57 insulato__insulator_CIRC_g58 insulator_s__flange_CIRC_g59 insulator_s__flange_CIRC_g60 insulator_s__flange_CIRC_g61 insulator_s__flange_CIRC_g62 insulator_s__flange_CIRC_g63 insulator_s__flange_CIRC_g64 insulator_s__flange_CIRC_g65 insulator_s__flange_CIRC_g66 insulator_s__flange_CIRC_g67 insulator_s__flange_CIRC_g68 insulato__insulator_CIRC_g69 insulator_s__flange_CIRC_g70 insulator_s__aluminium_I_g71 insulator_s__aluminium_I_g72 insulator_s__flange_CIRC_g73 insulator_s__flange_CIRC_g74 insulator_s__flange_CIRC_g75 insulator_s__flange_CIRC_g76 insulator_s__flange_CIRC_g77 insulator_s__flange_CIRC_g78 insulator_s__flange_CIRC_g79 insulator_s__flange_CIRC_g80 insulator_s__aluminium_I_g81 insulator_s__flange_CIRC_g82 insulator_s__flange_CIRC_g83 insulator_s__flange_CIRC_g84 insulator_s__flange_CIRC_g85 insulator_s__flange_CIRC_g86 insulator_s__flange_CIRC_g87 insulator_s__flange_CIRC_g88 insulator_s__flange_CIRC_g89 insulator_s__flange_CIRC_g90 insulator_s__flange_CIRC_g91 insulator_s__flange_CIRC_g92 insulato__insulator_CIRC_g93 insulator_s__flange_CIRC_g94 insulato__insulator_CIRC_g95 insulator_s__flange_CIRC_g96 insulator_s__flange_CIRC_g97 insulator_s__flange_CIRC_g98 insulator_s__flange_CIRC_g99 insulator___flange_CIRC_g100 insulator___flange_CIRC_g101 insulator___flange_CIRC_g102 insulator___flange_CIRC_g103 insulator___flange_CIRC_g104 insulator___flange_CIRC_g105 insulator___flange_CIRC_g106 insulator___flange_CIRC_g107 insulator___flange_CIRC_g108 insulator___flange_CIRC_g109 insulator___aluminium_I_g110 insulator___flange_CIRC_g111 insulator___flange_CIRC_g112 insulator___flange_CIRC_g113 insulator___flange_CIRC_g114 insulat__insulator_CIRC_g115 insulat__insulator_CIRC_g116 insulator___flange_CIRC_g117 insulator___flange_CIRC_g118 insulator___flange_CIRC_g119 insulator___flange_CIRC_g120 insulator___flange_CIRC_g121 insulator___flange_CIRC_g122 insulator___flange_CIRC_g123 insulator___flange_CIRC_g124 insulator___flange_CIRC_g125 insulator___flange_CIRC_g126 insulator___flange_CIRC_g127 insulator___flange_CIRC_g128 insulator___flange_CIRC_g129 insulator___flange_CIRC_g130 insulator___flange_CIRC_g131 insulator___flange_CIRC_g132 insulator___flange_CIRC_g133 insulator___flange_CIRC_g134 insulator___flange_CIRC_g135 insulator___flange_CIRC_g136 insulat__insulator_CIRC_g137 insulator___flange_CIRC_g138 insulator___flange_CIRC_g139 insulator___flange_CIRC_g140 insulator___flange_CIRC_g141 insulator___flange_CIRC_g142 insulator___flange_CIRC_g143 insulator___flange_CIRC_g144 insulator___flange_CIRC_g145 insulat__insulator_CIRC_g146 insulator___flange_CIRC_g147 insulator___flange_CIRC_g148 insulator___flange_CIRC_g149 insulator___flange_CIRC_g150 insulator___flange_CIRC_g151 insulator___flange_CIRC_g152 insulator___flange_CIRC_g153 insulator___flange_CIRC_g154 insulator___aluminium_I_g155 insulator___flange_CIRC_g156 insulator___flange_CIRC_g157 insulat__insulator_CIRC_g158 insulator___flange_CIRC_g159 insulator___flange_CIRC_g160 insulator___flange_CIRC_g161 insulator___flange_CIRC_g162 insulator___flange_CIRC_g163 insulator___flange_CIRC_g164 insulator___flange_CIRC_g165 insulator___aluminium_I_g166 insulator___flange_CIRC_g167 insulator___flange_CIRC_g168 insulator___flange_CIRC_g169 insulator___flange_CIRC_g170 insulator___flange_CIRC_g171 insulator___flange_CIRC_g172 insulator___flange_CIRC_g173 insulator___flange_CIRC_g174 insulator___flange_CIRC_g175 insulator___flange_CIRC_g176 mpc_beam_links_g1 mpc_beam_links_g2 mpc_beam_links_g3 mpc_beam_links_g4 mpc_beam_links_g5 mpc_beam_links_g6 mpc_beam_links_g7 mpc_beam_links_g8 mpc_beam_links_g9 mpc_beam_links_g10 mpc_beam_links_g11 mpc_beam_links_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 2
    variable = disp_z
    zeta = 0.005697
    alpha = 0.0
  []
  [sd_rot_x]
    type = StressDivergenceBeam
    block = 'insulator_su__aluminium_I_g1 insulator_su__aluminium_I_g2 insulator_su__aluminium_I_g3 insulator_su__aluminium_I_g4 insulator_su__aluminium_I_g5 insulator_su__aluminium_I_g6 insulator_su__aluminium_I_g7 insulator_su__flange_CIRC_g8 insulator_su__flange_CIRC_g9 insulator_s__flange_CIRC_g10 insulato__insulator_CIRC_g11 insulator_s__flange_CIRC_g12 insulator_s__aluminium_I_g13 insulator_s__flange_CIRC_g14 insulator_s__flange_CIRC_g15 insulator_s__flange_CIRC_g16 insulato__insulator_CIRC_g17 insulator_s__flange_CIRC_g18 insulator_s__flange_CIRC_g19 insulator_s__flange_CIRC_g20 insulator_s__aluminium_I_g21 insulator_s__aluminium_I_g22 insulator_s__aluminium_I_g23 insulator_s__flange_CIRC_g24 insulator_s__flange_CIRC_g25 insulator_s__flange_CIRC_g26 insulato__insulator_CIRC_g27 insulator_s__flange_CIRC_g28 insulator_s__flange_CIRC_g29 insulator_s__flange_CIRC_g30 insulator_s__flange_CIRC_g31 insulator_s__flange_CIRC_g32 insulato__insulator_CIRC_g33 insulato__insulator_CIRC_g34 insulator_s__flange_CIRC_g35 insulator_s__aluminium_I_g36 insulator_s__flange_CIRC_g37 insulator_s__flange_CIRC_g38 insulato__insulator_CIRC_g39 insulator_s__flange_CIRC_g40 insulator_s__flange_CIRC_g41 insulator_s__aluminium_I_g42 insulator_s__aluminium_I_g43 insulator_s__aluminium_I_g44 insulator_s__flange_CIRC_g45 insulator_s__flange_CIRC_g46 insulator_s__flange_CIRC_g47 insulato__insulator_CIRC_g48 insulator_s__flange_CIRC_g49 insulator_s__flange_CIRC_g50 insulator_s__aluminium_I_g51 insulator_s__aluminium_I_g52 insulator_s__aluminium_I_g53 insulator_s__flange_CIRC_g54 insulator_s__flange_CIRC_g55 insulator_s__flange_CIRC_g56 insulator_s__flange_CIRC_g57 insulato__insulator_CIRC_g58 insulator_s__flange_CIRC_g59 insulator_s__flange_CIRC_g60 insulator_s__flange_CIRC_g61 insulator_s__flange_CIRC_g62 insulator_s__flange_CIRC_g63 insulator_s__flange_CIRC_g64 insulator_s__flange_CIRC_g65 insulator_s__flange_CIRC_g66 insulator_s__flange_CIRC_g67 insulator_s__flange_CIRC_g68 insulato__insulator_CIRC_g69 insulator_s__flange_CIRC_g70 insulator_s__aluminium_I_g71 insulator_s__aluminium_I_g72 insulator_s__flange_CIRC_g73 insulator_s__flange_CIRC_g74 insulator_s__flange_CIRC_g75 insulator_s__flange_CIRC_g76 insulator_s__flange_CIRC_g77 insulator_s__flange_CIRC_g78 insulator_s__flange_CIRC_g79 insulator_s__flange_CIRC_g80 insulator_s__aluminium_I_g81 insulator_s__flange_CIRC_g82 insulator_s__flange_CIRC_g83 insulator_s__flange_CIRC_g84 insulator_s__flange_CIRC_g85 insulator_s__flange_CIRC_g86 insulator_s__flange_CIRC_g87 insulator_s__flange_CIRC_g88 insulator_s__flange_CIRC_g89 insulator_s__flange_CIRC_g90 insulator_s__flange_CIRC_g91 insulator_s__flange_CIRC_g92 insulato__insulator_CIRC_g93 insulator_s__flange_CIRC_g94 insulato__insulator_CIRC_g95 insulator_s__flange_CIRC_g96 insulator_s__flange_CIRC_g97 insulator_s__flange_CIRC_g98 insulator_s__flange_CIRC_g99 insulator___flange_CIRC_g100 insulator___flange_CIRC_g101 insulator___flange_CIRC_g102 insulator___flange_CIRC_g103 insulator___flange_CIRC_g104 insulator___flange_CIRC_g105 insulator___flange_CIRC_g106 insulator___flange_CIRC_g107 insulator___flange_CIRC_g108 insulator___flange_CIRC_g109 insulator___aluminium_I_g110 insulator___flange_CIRC_g111 insulator___flange_CIRC_g112 insulator___flange_CIRC_g113 insulator___flange_CIRC_g114 insulat__insulator_CIRC_g115 insulat__insulator_CIRC_g116 insulator___flange_CIRC_g117 insulator___flange_CIRC_g118 insulator___flange_CIRC_g119 insulator___flange_CIRC_g120 insulator___flange_CIRC_g121 insulator___flange_CIRC_g122 insulator___flange_CIRC_g123 insulator___flange_CIRC_g124 insulator___flange_CIRC_g125 insulator___flange_CIRC_g126 insulator___flange_CIRC_g127 insulator___flange_CIRC_g128 insulator___flange_CIRC_g129 insulator___flange_CIRC_g130 insulator___flange_CIRC_g131 insulator___flange_CIRC_g132 insulator___flange_CIRC_g133 insulator___flange_CIRC_g134 insulator___flange_CIRC_g135 insulator___flange_CIRC_g136 insulat__insulator_CIRC_g137 insulator___flange_CIRC_g138 insulator___flange_CIRC_g139 insulator___flange_CIRC_g140 insulator___flange_CIRC_g141 insulator___flange_CIRC_g142 insulator___flange_CIRC_g143 insulator___flange_CIRC_g144 insulator___flange_CIRC_g145 insulat__insulator_CIRC_g146 insulator___flange_CIRC_g147 insulator___flange_CIRC_g148 insulator___flange_CIRC_g149 insulator___flange_CIRC_g150 insulator___flange_CIRC_g151 insulator___flange_CIRC_g152 insulator___flange_CIRC_g153 insulator___flange_CIRC_g154 insulator___aluminium_I_g155 insulator___flange_CIRC_g156 insulator___flange_CIRC_g157 insulat__insulator_CIRC_g158 insulator___flange_CIRC_g159 insulator___flange_CIRC_g160 insulator___flange_CIRC_g161 insulator___flange_CIRC_g162 insulator___flange_CIRC_g163 insulator___flange_CIRC_g164 insulator___flange_CIRC_g165 insulator___aluminium_I_g166 insulator___flange_CIRC_g167 insulator___flange_CIRC_g168 insulator___flange_CIRC_g169 insulator___flange_CIRC_g170 insulator___flange_CIRC_g171 insulator___flange_CIRC_g172 insulator___flange_CIRC_g173 insulator___flange_CIRC_g174 insulator___flange_CIRC_g175 insulator___flange_CIRC_g176 mpc_beam_links_g1 mpc_beam_links_g2 mpc_beam_links_g3 mpc_beam_links_g4 mpc_beam_links_g5 mpc_beam_links_g6 mpc_beam_links_g7 mpc_beam_links_g8 mpc_beam_links_g9 mpc_beam_links_g10 mpc_beam_links_g11 mpc_beam_links_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 3
    variable = rot_x
    zeta = 0.005697
    alpha = 0.0
  []
  [sd_rot_y]
    type = StressDivergenceBeam
    block = 'insulator_su__aluminium_I_g1 insulator_su__aluminium_I_g2 insulator_su__aluminium_I_g3 insulator_su__aluminium_I_g4 insulator_su__aluminium_I_g5 insulator_su__aluminium_I_g6 insulator_su__aluminium_I_g7 insulator_su__flange_CIRC_g8 insulator_su__flange_CIRC_g9 insulator_s__flange_CIRC_g10 insulato__insulator_CIRC_g11 insulator_s__flange_CIRC_g12 insulator_s__aluminium_I_g13 insulator_s__flange_CIRC_g14 insulator_s__flange_CIRC_g15 insulator_s__flange_CIRC_g16 insulato__insulator_CIRC_g17 insulator_s__flange_CIRC_g18 insulator_s__flange_CIRC_g19 insulator_s__flange_CIRC_g20 insulator_s__aluminium_I_g21 insulator_s__aluminium_I_g22 insulator_s__aluminium_I_g23 insulator_s__flange_CIRC_g24 insulator_s__flange_CIRC_g25 insulator_s__flange_CIRC_g26 insulato__insulator_CIRC_g27 insulator_s__flange_CIRC_g28 insulator_s__flange_CIRC_g29 insulator_s__flange_CIRC_g30 insulator_s__flange_CIRC_g31 insulator_s__flange_CIRC_g32 insulato__insulator_CIRC_g33 insulato__insulator_CIRC_g34 insulator_s__flange_CIRC_g35 insulator_s__aluminium_I_g36 insulator_s__flange_CIRC_g37 insulator_s__flange_CIRC_g38 insulato__insulator_CIRC_g39 insulator_s__flange_CIRC_g40 insulator_s__flange_CIRC_g41 insulator_s__aluminium_I_g42 insulator_s__aluminium_I_g43 insulator_s__aluminium_I_g44 insulator_s__flange_CIRC_g45 insulator_s__flange_CIRC_g46 insulator_s__flange_CIRC_g47 insulato__insulator_CIRC_g48 insulator_s__flange_CIRC_g49 insulator_s__flange_CIRC_g50 insulator_s__aluminium_I_g51 insulator_s__aluminium_I_g52 insulator_s__aluminium_I_g53 insulator_s__flange_CIRC_g54 insulator_s__flange_CIRC_g55 insulator_s__flange_CIRC_g56 insulator_s__flange_CIRC_g57 insulato__insulator_CIRC_g58 insulator_s__flange_CIRC_g59 insulator_s__flange_CIRC_g60 insulator_s__flange_CIRC_g61 insulator_s__flange_CIRC_g62 insulator_s__flange_CIRC_g63 insulator_s__flange_CIRC_g64 insulator_s__flange_CIRC_g65 insulator_s__flange_CIRC_g66 insulator_s__flange_CIRC_g67 insulator_s__flange_CIRC_g68 insulato__insulator_CIRC_g69 insulator_s__flange_CIRC_g70 insulator_s__aluminium_I_g71 insulator_s__aluminium_I_g72 insulator_s__flange_CIRC_g73 insulator_s__flange_CIRC_g74 insulator_s__flange_CIRC_g75 insulator_s__flange_CIRC_g76 insulator_s__flange_CIRC_g77 insulator_s__flange_CIRC_g78 insulator_s__flange_CIRC_g79 insulator_s__flange_CIRC_g80 insulator_s__aluminium_I_g81 insulator_s__flange_CIRC_g82 insulator_s__flange_CIRC_g83 insulator_s__flange_CIRC_g84 insulator_s__flange_CIRC_g85 insulator_s__flange_CIRC_g86 insulator_s__flange_CIRC_g87 insulator_s__flange_CIRC_g88 insulator_s__flange_CIRC_g89 insulator_s__flange_CIRC_g90 insulator_s__flange_CIRC_g91 insulator_s__flange_CIRC_g92 insulato__insulator_CIRC_g93 insulator_s__flange_CIRC_g94 insulato__insulator_CIRC_g95 insulator_s__flange_CIRC_g96 insulator_s__flange_CIRC_g97 insulator_s__flange_CIRC_g98 insulator_s__flange_CIRC_g99 insulator___flange_CIRC_g100 insulator___flange_CIRC_g101 insulator___flange_CIRC_g102 insulator___flange_CIRC_g103 insulator___flange_CIRC_g104 insulator___flange_CIRC_g105 insulator___flange_CIRC_g106 insulator___flange_CIRC_g107 insulator___flange_CIRC_g108 insulator___flange_CIRC_g109 insulator___aluminium_I_g110 insulator___flange_CIRC_g111 insulator___flange_CIRC_g112 insulator___flange_CIRC_g113 insulator___flange_CIRC_g114 insulat__insulator_CIRC_g115 insulat__insulator_CIRC_g116 insulator___flange_CIRC_g117 insulator___flange_CIRC_g118 insulator___flange_CIRC_g119 insulator___flange_CIRC_g120 insulator___flange_CIRC_g121 insulator___flange_CIRC_g122 insulator___flange_CIRC_g123 insulator___flange_CIRC_g124 insulator___flange_CIRC_g125 insulator___flange_CIRC_g126 insulator___flange_CIRC_g127 insulator___flange_CIRC_g128 insulator___flange_CIRC_g129 insulator___flange_CIRC_g130 insulator___flange_CIRC_g131 insulator___flange_CIRC_g132 insulator___flange_CIRC_g133 insulator___flange_CIRC_g134 insulator___flange_CIRC_g135 insulator___flange_CIRC_g136 insulat__insulator_CIRC_g137 insulator___flange_CIRC_g138 insulator___flange_CIRC_g139 insulator___flange_CIRC_g140 insulator___flange_CIRC_g141 insulator___flange_CIRC_g142 insulator___flange_CIRC_g143 insulator___flange_CIRC_g144 insulator___flange_CIRC_g145 insulat__insulator_CIRC_g146 insulator___flange_CIRC_g147 insulator___flange_CIRC_g148 insulator___flange_CIRC_g149 insulator___flange_CIRC_g150 insulator___flange_CIRC_g151 insulator___flange_CIRC_g152 insulator___flange_CIRC_g153 insulator___flange_CIRC_g154 insulator___aluminium_I_g155 insulator___flange_CIRC_g156 insulator___flange_CIRC_g157 insulat__insulator_CIRC_g158 insulator___flange_CIRC_g159 insulator___flange_CIRC_g160 insulator___flange_CIRC_g161 insulator___flange_CIRC_g162 insulator___flange_CIRC_g163 insulator___flange_CIRC_g164 insulator___flange_CIRC_g165 insulator___aluminium_I_g166 insulator___flange_CIRC_g167 insulator___flange_CIRC_g168 insulator___flange_CIRC_g169 insulator___flange_CIRC_g170 insulator___flange_CIRC_g171 insulator___flange_CIRC_g172 insulator___flange_CIRC_g173 insulator___flange_CIRC_g174 insulator___flange_CIRC_g175 insulator___flange_CIRC_g176 mpc_beam_links_g1 mpc_beam_links_g2 mpc_beam_links_g3 mpc_beam_links_g4 mpc_beam_links_g5 mpc_beam_links_g6 mpc_beam_links_g7 mpc_beam_links_g8 mpc_beam_links_g9 mpc_beam_links_g10 mpc_beam_links_g11 mpc_beam_links_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 4
    variable = rot_y
    zeta = 0.005697
    alpha = 0.0
  []
  [sd_rot_z]
    type = StressDivergenceBeam
    block = 'insulator_su__aluminium_I_g1 insulator_su__aluminium_I_g2 insulator_su__aluminium_I_g3 insulator_su__aluminium_I_g4 insulator_su__aluminium_I_g5 insulator_su__aluminium_I_g6 insulator_su__aluminium_I_g7 insulator_su__flange_CIRC_g8 insulator_su__flange_CIRC_g9 insulator_s__flange_CIRC_g10 insulato__insulator_CIRC_g11 insulator_s__flange_CIRC_g12 insulator_s__aluminium_I_g13 insulator_s__flange_CIRC_g14 insulator_s__flange_CIRC_g15 insulator_s__flange_CIRC_g16 insulato__insulator_CIRC_g17 insulator_s__flange_CIRC_g18 insulator_s__flange_CIRC_g19 insulator_s__flange_CIRC_g20 insulator_s__aluminium_I_g21 insulator_s__aluminium_I_g22 insulator_s__aluminium_I_g23 insulator_s__flange_CIRC_g24 insulator_s__flange_CIRC_g25 insulator_s__flange_CIRC_g26 insulato__insulator_CIRC_g27 insulator_s__flange_CIRC_g28 insulator_s__flange_CIRC_g29 insulator_s__flange_CIRC_g30 insulator_s__flange_CIRC_g31 insulator_s__flange_CIRC_g32 insulato__insulator_CIRC_g33 insulato__insulator_CIRC_g34 insulator_s__flange_CIRC_g35 insulator_s__aluminium_I_g36 insulator_s__flange_CIRC_g37 insulator_s__flange_CIRC_g38 insulato__insulator_CIRC_g39 insulator_s__flange_CIRC_g40 insulator_s__flange_CIRC_g41 insulator_s__aluminium_I_g42 insulator_s__aluminium_I_g43 insulator_s__aluminium_I_g44 insulator_s__flange_CIRC_g45 insulator_s__flange_CIRC_g46 insulator_s__flange_CIRC_g47 insulato__insulator_CIRC_g48 insulator_s__flange_CIRC_g49 insulator_s__flange_CIRC_g50 insulator_s__aluminium_I_g51 insulator_s__aluminium_I_g52 insulator_s__aluminium_I_g53 insulator_s__flange_CIRC_g54 insulator_s__flange_CIRC_g55 insulator_s__flange_CIRC_g56 insulator_s__flange_CIRC_g57 insulato__insulator_CIRC_g58 insulator_s__flange_CIRC_g59 insulator_s__flange_CIRC_g60 insulator_s__flange_CIRC_g61 insulator_s__flange_CIRC_g62 insulator_s__flange_CIRC_g63 insulator_s__flange_CIRC_g64 insulator_s__flange_CIRC_g65 insulator_s__flange_CIRC_g66 insulator_s__flange_CIRC_g67 insulator_s__flange_CIRC_g68 insulato__insulator_CIRC_g69 insulator_s__flange_CIRC_g70 insulator_s__aluminium_I_g71 insulator_s__aluminium_I_g72 insulator_s__flange_CIRC_g73 insulator_s__flange_CIRC_g74 insulator_s__flange_CIRC_g75 insulator_s__flange_CIRC_g76 insulator_s__flange_CIRC_g77 insulator_s__flange_CIRC_g78 insulator_s__flange_CIRC_g79 insulator_s__flange_CIRC_g80 insulator_s__aluminium_I_g81 insulator_s__flange_CIRC_g82 insulator_s__flange_CIRC_g83 insulator_s__flange_CIRC_g84 insulator_s__flange_CIRC_g85 insulator_s__flange_CIRC_g86 insulator_s__flange_CIRC_g87 insulator_s__flange_CIRC_g88 insulator_s__flange_CIRC_g89 insulator_s__flange_CIRC_g90 insulator_s__flange_CIRC_g91 insulator_s__flange_CIRC_g92 insulato__insulator_CIRC_g93 insulator_s__flange_CIRC_g94 insulato__insulator_CIRC_g95 insulator_s__flange_CIRC_g96 insulator_s__flange_CIRC_g97 insulator_s__flange_CIRC_g98 insulator_s__flange_CIRC_g99 insulator___flange_CIRC_g100 insulator___flange_CIRC_g101 insulator___flange_CIRC_g102 insulator___flange_CIRC_g103 insulator___flange_CIRC_g104 insulator___flange_CIRC_g105 insulator___flange_CIRC_g106 insulator___flange_CIRC_g107 insulator___flange_CIRC_g108 insulator___flange_CIRC_g109 insulator___aluminium_I_g110 insulator___flange_CIRC_g111 insulator___flange_CIRC_g112 insulator___flange_CIRC_g113 insulator___flange_CIRC_g114 insulat__insulator_CIRC_g115 insulat__insulator_CIRC_g116 insulator___flange_CIRC_g117 insulator___flange_CIRC_g118 insulator___flange_CIRC_g119 insulator___flange_CIRC_g120 insulator___flange_CIRC_g121 insulator___flange_CIRC_g122 insulator___flange_CIRC_g123 insulator___flange_CIRC_g124 insulator___flange_CIRC_g125 insulator___flange_CIRC_g126 insulator___flange_CIRC_g127 insulator___flange_CIRC_g128 insulator___flange_CIRC_g129 insulator___flange_CIRC_g130 insulator___flange_CIRC_g131 insulator___flange_CIRC_g132 insulator___flange_CIRC_g133 insulator___flange_CIRC_g134 insulator___flange_CIRC_g135 insulator___flange_CIRC_g136 insulat__insulator_CIRC_g137 insulator___flange_CIRC_g138 insulator___flange_CIRC_g139 insulator___flange_CIRC_g140 insulator___flange_CIRC_g141 insulator___flange_CIRC_g142 insulator___flange_CIRC_g143 insulator___flange_CIRC_g144 insulator___flange_CIRC_g145 insulat__insulator_CIRC_g146 insulator___flange_CIRC_g147 insulator___flange_CIRC_g148 insulator___flange_CIRC_g149 insulator___flange_CIRC_g150 insulator___flange_CIRC_g151 insulator___flange_CIRC_g152 insulator___flange_CIRC_g153 insulator___flange_CIRC_g154 insulator___aluminium_I_g155 insulator___flange_CIRC_g156 insulator___flange_CIRC_g157 insulat__insulator_CIRC_g158 insulator___flange_CIRC_g159 insulator___flange_CIRC_g160 insulator___flange_CIRC_g161 insulator___flange_CIRC_g162 insulator___flange_CIRC_g163 insulator___flange_CIRC_g164 insulator___flange_CIRC_g165 insulator___aluminium_I_g166 insulator___flange_CIRC_g167 insulator___flange_CIRC_g168 insulator___flange_CIRC_g169 insulator___flange_CIRC_g170 insulator___flange_CIRC_g171 insulator___flange_CIRC_g172 insulator___flange_CIRC_g173 insulator___flange_CIRC_g174 insulator___flange_CIRC_g175 insulator___flange_CIRC_g176 mpc_beam_links_g1 mpc_beam_links_g2 mpc_beam_links_g3 mpc_beam_links_g4 mpc_beam_links_g5 mpc_beam_links_g6 mpc_beam_links_g7 mpc_beam_links_g8 mpc_beam_links_g9 mpc_beam_links_g10 mpc_beam_links_g11 mpc_beam_links_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 5
    variable = rot_z
    zeta = 0.005697
    alpha = 0.0
  []
  [if_disp_x_uminium_I_g1]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_uminium_I_g1]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_uminium_I_g1]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_uminium_I_g1]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_uminium_I_g1]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_uminium_I_g1]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_uminium_I_g2]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g2'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_uminium_I_g2]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g2'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_uminium_I_g2]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g2'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_uminium_I_g2]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g2'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_uminium_I_g2]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g2'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_uminium_I_g2]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g2'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_uminium_I_g3]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g3'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_uminium_I_g3]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g3'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_uminium_I_g3]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g3'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_uminium_I_g3]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g3'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_uminium_I_g3]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g3'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_uminium_I_g3]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g3'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_uminium_I_g4]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g4'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_uminium_I_g4]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g4'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_uminium_I_g4]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g4'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_uminium_I_g4]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g4'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_uminium_I_g4]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g4'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_uminium_I_g4]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g4'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_uminium_I_g5]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g5'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_uminium_I_g5]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g5'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_uminium_I_g5]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g5'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_uminium_I_g5]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g5'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_uminium_I_g5]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g5'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_uminium_I_g5]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g5'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_uminium_I_g6]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g6'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_uminium_I_g6]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g6'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_uminium_I_g6]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g6'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_uminium_I_g6]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g6'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_uminium_I_g6]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g6'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_uminium_I_g6]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g6'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_uminium_I_g7]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g7'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_uminium_I_g7]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g7'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_uminium_I_g7]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g7'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_uminium_I_g7]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g7'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_uminium_I_g7]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g7'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_uminium_I_g7]
    type = InertialForceBeam
    block = 'insulator_su__aluminium_I_g7'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ange_CIRC_g8]
    type = InertialForceBeam
    block = 'insulator_su__flange_CIRC_g8'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ange_CIRC_g8]
    type = InertialForceBeam
    block = 'insulator_su__flange_CIRC_g8'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ange_CIRC_g8]
    type = InertialForceBeam
    block = 'insulator_su__flange_CIRC_g8'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ange_CIRC_g8]
    type = InertialForceBeam
    block = 'insulator_su__flange_CIRC_g8'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ange_CIRC_g8]
    type = InertialForceBeam
    block = 'insulator_su__flange_CIRC_g8'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ange_CIRC_g8]
    type = InertialForceBeam
    block = 'insulator_su__flange_CIRC_g8'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ange_CIRC_g9]
    type = InertialForceBeam
    block = 'insulator_su__flange_CIRC_g9'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ange_CIRC_g9]
    type = InertialForceBeam
    block = 'insulator_su__flange_CIRC_g9'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ange_CIRC_g9]
    type = InertialForceBeam
    block = 'insulator_su__flange_CIRC_g9'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ange_CIRC_g9]
    type = InertialForceBeam
    block = 'insulator_su__flange_CIRC_g9'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ange_CIRC_g9]
    type = InertialForceBeam
    block = 'insulator_su__flange_CIRC_g9'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ange_CIRC_g9]
    type = InertialForceBeam
    block = 'insulator_su__flange_CIRC_g9'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g10]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g10'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g10]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g10'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g10]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g10'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g10]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g10'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g10]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g10'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g10]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g10'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_tor_CIRC_g11]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g11'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_tor_CIRC_g11]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g11'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_tor_CIRC_g11]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g11'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_tor_CIRC_g11]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g11'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_tor_CIRC_g11]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g11'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_tor_CIRC_g11]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g11'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g12]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g12]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g12]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g12]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g12]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g12]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_minium_I_g13]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g13'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_minium_I_g13]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g13'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_minium_I_g13]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g13'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_minium_I_g13]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g13'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_minium_I_g13]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g13'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_minium_I_g13]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g13'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g14]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g14'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g14]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g14'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g14]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g14'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g14]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g14'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g14]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g14'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g14]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g14'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g15]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g15'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g15]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g15'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g15]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g15'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g15]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g15'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g15]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g15'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g15]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g15'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g16]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g16'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g16]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g16'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g16]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g16'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g16]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g16'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g16]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g16'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g16]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g16'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_tor_CIRC_g17]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g17'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_tor_CIRC_g17]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g17'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_tor_CIRC_g17]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g17'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_tor_CIRC_g17]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g17'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_tor_CIRC_g17]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g17'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_tor_CIRC_g17]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g17'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g18]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g18'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g18]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g18'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g18]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g18'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g18]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g18'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g18]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g18'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g18]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g18'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g19]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g19'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g19]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g19'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g19]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g19'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g19]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g19'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g19]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g19'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g19]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g19'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g20]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g20'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g20]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g20'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g20]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g20'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g20]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g20'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g20]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g20'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g20]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g20'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_minium_I_g21]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g21'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_minium_I_g21]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g21'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_minium_I_g21]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g21'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_minium_I_g21]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g21'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_minium_I_g21]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g21'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_minium_I_g21]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g21'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_minium_I_g22]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g22'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_minium_I_g22]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g22'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_minium_I_g22]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g22'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_minium_I_g22]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g22'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_minium_I_g22]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g22'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_minium_I_g22]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g22'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_minium_I_g23]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g23'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_minium_I_g23]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g23'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_minium_I_g23]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g23'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_minium_I_g23]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g23'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_minium_I_g23]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g23'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_minium_I_g23]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g23'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g24]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g24'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g24]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g24'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g24]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g24'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g24]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g24'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g24]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g24'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g24]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g24'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g25]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g25'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g25]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g25'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g25]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g25'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g25]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g25'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g25]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g25'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g25]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g25'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g26]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g26'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g26]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g26'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g26]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g26'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g26]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g26'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g26]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g26'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g26]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g26'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_tor_CIRC_g27]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g27'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_tor_CIRC_g27]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g27'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_tor_CIRC_g27]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g27'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_tor_CIRC_g27]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g27'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_tor_CIRC_g27]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g27'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_tor_CIRC_g27]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g27'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g28]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g28'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g28]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g28'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g28]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g28'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g28]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g28'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g28]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g28'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g28]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g28'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g29]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g29'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g29]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g29'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g29]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g29'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g29]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g29'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g29]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g29'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g29]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g29'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g30]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g30'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g30]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g30'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g30]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g30'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g30]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g30'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g30]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g30'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g30]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g30'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g31]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g31'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g31]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g31'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g31]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g31'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g31]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g31'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g31]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g31'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g31]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g31'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g32]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g32'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g32]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g32'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g32]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g32'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g32]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g32'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g32]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g32'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g32]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g32'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_tor_CIRC_g33]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g33'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_tor_CIRC_g33]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g33'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_tor_CIRC_g33]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g33'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_tor_CIRC_g33]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g33'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_tor_CIRC_g33]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g33'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_tor_CIRC_g33]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g33'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_tor_CIRC_g34]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g34'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_tor_CIRC_g34]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g34'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_tor_CIRC_g34]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g34'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_tor_CIRC_g34]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g34'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_tor_CIRC_g34]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g34'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_tor_CIRC_g34]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g34'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g35]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g35'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g35]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g35'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g35]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g35'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g35]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g35'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g35]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g35'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g35]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g35'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_minium_I_g36]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g36'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_minium_I_g36]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g36'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_minium_I_g36]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g36'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_minium_I_g36]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g36'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_minium_I_g36]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g36'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_minium_I_g36]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g36'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g37]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g37'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g37]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g37'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g37]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g37'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g37]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g37'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g37]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g37'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g37]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g37'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g38]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g38'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g38]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g38'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g38]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g38'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g38]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g38'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g38]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g38'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g38]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g38'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_tor_CIRC_g39]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g39'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_tor_CIRC_g39]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g39'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_tor_CIRC_g39]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g39'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_tor_CIRC_g39]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g39'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_tor_CIRC_g39]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g39'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_tor_CIRC_g39]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g39'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g40]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g40'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g40]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g40'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g40]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g40'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g40]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g40'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g40]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g40'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g40]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g40'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g41]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g41'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g41]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g41'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g41]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g41'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g41]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g41'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g41]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g41'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g41]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g41'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_minium_I_g42]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g42'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_minium_I_g42]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g42'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_minium_I_g42]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g42'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_minium_I_g42]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g42'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_minium_I_g42]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g42'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_minium_I_g42]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g42'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_minium_I_g43]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g43'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_minium_I_g43]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g43'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_minium_I_g43]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g43'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_minium_I_g43]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g43'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_minium_I_g43]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g43'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_minium_I_g43]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g43'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_minium_I_g44]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g44'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_minium_I_g44]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g44'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_minium_I_g44]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g44'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_minium_I_g44]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g44'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_minium_I_g44]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g44'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_minium_I_g44]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g44'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g45]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g45'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g45]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g45'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g45]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g45'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g45]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g45'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g45]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g45'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g45]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g45'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g46]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g46'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g46]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g46'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g46]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g46'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g46]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g46'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g46]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g46'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g46]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g46'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g47]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g47'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g47]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g47'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g47]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g47'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g47]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g47'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g47]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g47'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g47]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g47'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_tor_CIRC_g48]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g48'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_tor_CIRC_g48]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g48'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_tor_CIRC_g48]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g48'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_tor_CIRC_g48]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g48'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_tor_CIRC_g48]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g48'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_tor_CIRC_g48]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g48'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g49]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g49'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g49]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g49'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g49]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g49'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g49]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g49'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g49]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g49'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g49]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g49'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g50]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g50'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g50]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g50'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g50]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g50'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g50]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g50'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g50]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g50'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g50]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g50'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_minium_I_g51]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g51'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_minium_I_g51]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g51'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_minium_I_g51]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g51'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_minium_I_g51]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g51'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_minium_I_g51]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g51'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_minium_I_g51]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g51'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_minium_I_g52]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g52'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_minium_I_g52]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g52'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_minium_I_g52]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g52'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_minium_I_g52]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g52'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_minium_I_g52]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g52'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_minium_I_g52]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g52'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_minium_I_g53]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g53'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_minium_I_g53]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g53'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_minium_I_g53]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g53'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_minium_I_g53]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g53'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_minium_I_g53]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g53'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_minium_I_g53]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g53'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g54]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g54'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g54]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g54'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g54]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g54'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g54]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g54'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g54]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g54'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g54]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g54'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g55]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g55'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g55]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g55'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g55]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g55'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g55]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g55'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g55]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g55'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g55]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g55'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g56]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g56'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g56]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g56'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g56]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g56'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g56]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g56'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g56]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g56'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g56]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g56'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g57]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g57'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g57]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g57'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g57]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g57'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g57]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g57'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g57]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g57'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g57]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g57'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_tor_CIRC_g58]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g58'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_tor_CIRC_g58]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g58'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_tor_CIRC_g58]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g58'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_tor_CIRC_g58]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g58'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_tor_CIRC_g58]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g58'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_tor_CIRC_g58]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g58'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g59]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g59'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g59]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g59'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g59]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g59'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g59]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g59'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g59]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g59'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g59]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g59'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g60]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g60'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g60]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g60'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g60]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g60'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g60]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g60'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g60]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g60'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g60]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g60'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g61]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g61'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g61]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g61'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g61]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g61'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g61]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g61'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g61]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g61'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g61]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g61'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g62]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g62'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g62]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g62'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g62]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g62'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g62]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g62'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g62]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g62'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g62]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g62'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g63]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g63'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g63]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g63'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g63]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g63'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g63]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g63'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g63]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g63'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g63]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g63'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g64]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g64'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g64]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g64'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g64]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g64'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g64]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g64'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g64]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g64'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g64]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g64'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g65]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g65'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g65]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g65'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g65]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g65'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g65]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g65'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g65]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g65'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g65]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g65'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g66]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g66'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g66]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g66'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g66]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g66'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g66]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g66'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g66]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g66'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g66]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g66'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g67]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g67'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g67]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g67'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g67]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g67'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g67]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g67'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g67]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g67'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g67]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g67'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g68]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g68'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g68]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g68'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g68]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g68'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g68]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g68'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g68]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g68'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g68]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g68'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_tor_CIRC_g69]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g69'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_tor_CIRC_g69]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g69'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_tor_CIRC_g69]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g69'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_tor_CIRC_g69]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g69'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_tor_CIRC_g69]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g69'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_tor_CIRC_g69]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g69'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g70]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g70'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g70]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g70'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g70]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g70'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g70]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g70'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g70]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g70'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g70]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g70'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_minium_I_g71]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g71'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_minium_I_g71]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g71'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_minium_I_g71]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g71'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_minium_I_g71]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g71'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_minium_I_g71]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g71'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_minium_I_g71]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g71'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_minium_I_g72]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g72'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_minium_I_g72]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g72'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_minium_I_g72]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g72'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_minium_I_g72]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g72'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_minium_I_g72]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g72'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_minium_I_g72]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g72'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g73]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g73'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g73]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g73'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g73]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g73'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g73]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g73'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g73]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g73'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g73]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g73'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g74]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g74'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g74]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g74'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g74]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g74'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g74]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g74'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g74]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g74'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g74]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g74'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g75]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g75'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g75]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g75'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g75]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g75'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g75]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g75'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g75]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g75'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g75]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g75'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g76]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g76'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g76]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g76'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g76]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g76'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g76]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g76'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g76]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g76'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g76]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g76'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g77]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g77'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g77]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g77'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g77]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g77'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g77]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g77'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g77]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g77'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g77]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g77'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g78]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g78'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g78]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g78'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g78]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g78'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g78]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g78'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g78]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g78'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g78]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g78'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g79]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g79'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g79]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g79'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g79]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g79'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g79]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g79'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g79]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g79'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g79]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g79'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g80]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g80'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g80]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g80'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g80]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g80'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g80]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g80'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g80]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g80'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g80]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g80'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_minium_I_g81]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g81'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_minium_I_g81]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g81'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_minium_I_g81]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g81'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_minium_I_g81]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g81'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_minium_I_g81]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g81'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_minium_I_g81]
    type = InertialForceBeam
    block = 'insulator_s__aluminium_I_g81'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g82]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g82'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g82]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g82'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g82]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g82'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g82]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g82'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g82]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g82'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g82]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g82'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g83]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g83'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g83]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g83'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g83]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g83'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g83]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g83'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g83]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g83'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g83]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g83'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g84]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g84'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g84]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g84'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g84]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g84'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g84]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g84'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g84]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g84'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g84]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g84'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g85]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g85'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g85]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g85'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g85]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g85'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g85]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g85'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g85]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g85'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g85]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g85'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g86]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g86'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g86]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g86'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g86]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g86'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g86]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g86'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g86]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g86'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g86]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g86'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g87]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g87'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g87]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g87'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g87]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g87'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g87]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g87'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g87]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g87'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g87]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g87'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g88]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g88'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g88]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g88'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g88]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g88'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g88]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g88'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g88]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g88'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g88]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g88'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g89]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g89'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g89]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g89'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g89]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g89'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g89]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g89'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g89]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g89'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g89]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g89'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g90]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g90'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g90]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g90'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g90]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g90'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g90]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g90'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g90]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g90'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g90]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g90'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g91]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g91'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g91]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g91'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g91]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g91'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g91]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g91'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g91]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g91'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g91]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g91'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g92]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g92'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g92]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g92'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g92]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g92'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g92]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g92'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g92]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g92'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g92]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g92'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_tor_CIRC_g93]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g93'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_tor_CIRC_g93]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g93'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_tor_CIRC_g93]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g93'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_tor_CIRC_g93]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g93'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_tor_CIRC_g93]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g93'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_tor_CIRC_g93]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g93'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g94]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g94'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g94]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g94'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g94]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g94'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g94]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g94'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g94]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g94'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g94]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g94'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_tor_CIRC_g95]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g95'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_tor_CIRC_g95]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g95'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_tor_CIRC_g95]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g95'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_tor_CIRC_g95]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g95'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_tor_CIRC_g95]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g95'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_tor_CIRC_g95]
    type = InertialForceBeam
    block = 'insulato__insulator_CIRC_g95'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g96]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g96'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g96]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g96'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g96]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g96'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g96]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g96'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g96]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g96'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g96]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g96'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g97]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g97'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g97]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g97'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g97]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g97'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g97]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g97'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g97]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g97'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g97]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g97'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g98]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g98'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g98]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g98'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g98]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g98'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g98]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g98'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g98]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g98'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g98]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g98'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_nge_CIRC_g99]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g99'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_nge_CIRC_g99]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g99'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_nge_CIRC_g99]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g99'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_nge_CIRC_g99]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g99'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_nge_CIRC_g99]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g99'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_nge_CIRC_g99]
    type = InertialForceBeam
    block = 'insulator_s__flange_CIRC_g99'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g100]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g100'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g100]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g100'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g100]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g100'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g100]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g100'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g100]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g100'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g100]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g100'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g101]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g101'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g101]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g101'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g101]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g101'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g101]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g101'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g101]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g101'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g101]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g101'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g102]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g102'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g102]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g102'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g102]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g102'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g102]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g102'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g102]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g102'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g102]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g102'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g103]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g103'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g103]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g103'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g103]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g103'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g103]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g103'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g103]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g103'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g103]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g103'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g104]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g104'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g104]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g104'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g104]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g104'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g104]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g104'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g104]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g104'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g104]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g104'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g105]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g105'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g105]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g105'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g105]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g105'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g105]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g105'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g105]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g105'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g105]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g105'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g106]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g106'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g106]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g106'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g106]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g106'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g106]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g106'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g106]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g106'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g106]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g106'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g107]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g107'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g107]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g107'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g107]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g107'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g107]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g107'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g107]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g107'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g107]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g107'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g108]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g108'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g108]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g108'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g108]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g108'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g108]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g108'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g108]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g108'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g108]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g108'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g109]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g109'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g109]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g109'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g109]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g109'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g109]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g109'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g109]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g109'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g109]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g109'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_inium_I_g110]
    type = InertialForceBeam
    block = 'insulator___aluminium_I_g110'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_inium_I_g110]
    type = InertialForceBeam
    block = 'insulator___aluminium_I_g110'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_inium_I_g110]
    type = InertialForceBeam
    block = 'insulator___aluminium_I_g110'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_inium_I_g110]
    type = InertialForceBeam
    block = 'insulator___aluminium_I_g110'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_inium_I_g110]
    type = InertialForceBeam
    block = 'insulator___aluminium_I_g110'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_inium_I_g110]
    type = InertialForceBeam
    block = 'insulator___aluminium_I_g110'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g111]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g111'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g111]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g111'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g111]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g111'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g111]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g111'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g111]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g111'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g111]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g111'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g112]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g112'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g112]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g112'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g112]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g112'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g112]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g112'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g112]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g112'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g112]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g112'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g113]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g113'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g113]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g113'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g113]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g113'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g113]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g113'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g113]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g113'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g113]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g113'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g114]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g114'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g114]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g114'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g114]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g114'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g114]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g114'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g114]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g114'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g114]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g114'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_or_CIRC_g115]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g115'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_or_CIRC_g115]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g115'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_or_CIRC_g115]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g115'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_or_CIRC_g115]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g115'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_or_CIRC_g115]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g115'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_or_CIRC_g115]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g115'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_or_CIRC_g116]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g116'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_or_CIRC_g116]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g116'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_or_CIRC_g116]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g116'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_or_CIRC_g116]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g116'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_or_CIRC_g116]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g116'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_or_CIRC_g116]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g116'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g117]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g117'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g117]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g117'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g117]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g117'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g117]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g117'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g117]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g117'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g117]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g117'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g118]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g118'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g118]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g118'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g118]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g118'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g118]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g118'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g118]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g118'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g118]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g118'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g119]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g119'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g119]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g119'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g119]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g119'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g119]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g119'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g119]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g119'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g119]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g119'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g120]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g120'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g120]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g120'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g120]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g120'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g120]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g120'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g120]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g120'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g120]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g120'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g121]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g121'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g121]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g121'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g121]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g121'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g121]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g121'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g121]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g121'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g121]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g121'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g122]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g122'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g122]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g122'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g122]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g122'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g122]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g122'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g122]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g122'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g122]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g122'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g123]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g123'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g123]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g123'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g123]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g123'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g123]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g123'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g123]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g123'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g123]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g123'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g124]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g124'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g124]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g124'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g124]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g124'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g124]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g124'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g124]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g124'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g124]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g124'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g125]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g125'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g125]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g125'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g125]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g125'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g125]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g125'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g125]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g125'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g125]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g125'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g126]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g126'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g126]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g126'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g126]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g126'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g126]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g126'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g126]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g126'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g126]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g126'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g127]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g127'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g127]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g127'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g127]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g127'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g127]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g127'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g127]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g127'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g127]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g127'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g128]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g128'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g128]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g128'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g128]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g128'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g128]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g128'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g128]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g128'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g128]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g128'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g129]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g129'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g129]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g129'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g129]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g129'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g129]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g129'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g129]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g129'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g129]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g129'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g130]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g130'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g130]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g130'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g130]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g130'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g130]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g130'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g130]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g130'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g130]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g130'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g131]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g131'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g131]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g131'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g131]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g131'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g131]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g131'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g131]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g131'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g131]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g131'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g132]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g132'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g132]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g132'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g132]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g132'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g132]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g132'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g132]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g132'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g132]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g132'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g133]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g133'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g133]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g133'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g133]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g133'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g133]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g133'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g133]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g133'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g133]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g133'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g134]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g134'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g134]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g134'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g134]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g134'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g134]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g134'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g134]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g134'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g134]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g134'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g135]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g135'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g135]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g135'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g135]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g135'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g135]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g135'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g135]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g135'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g135]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g135'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g136]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g136'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g136]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g136'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g136]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g136'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g136]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g136'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g136]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g136'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g136]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g136'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_or_CIRC_g137]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g137'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_or_CIRC_g137]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g137'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_or_CIRC_g137]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g137'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_or_CIRC_g137]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g137'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_or_CIRC_g137]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g137'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_or_CIRC_g137]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g137'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g138]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g138'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g138]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g138'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g138]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g138'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g138]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g138'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g138]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g138'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g138]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g138'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g139]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g139'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g139]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g139'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g139]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g139'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g139]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g139'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g139]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g139'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g139]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g139'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g140]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g140'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g140]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g140'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g140]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g140'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g140]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g140'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g140]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g140'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g140]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g140'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g141]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g141'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g141]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g141'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g141]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g141'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g141]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g141'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g141]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g141'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g141]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g141'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g142]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g142'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g142]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g142'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g142]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g142'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g142]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g142'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g142]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g142'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g142]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g142'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g143]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g143'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g143]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g143'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g143]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g143'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g143]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g143'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g143]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g143'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g143]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g143'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g144]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g144'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g144]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g144'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g144]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g144'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g144]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g144'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g144]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g144'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g144]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g144'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g145]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g145'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g145]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g145'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g145]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g145'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g145]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g145'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g145]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g145'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g145]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g145'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_or_CIRC_g146]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g146'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_or_CIRC_g146]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g146'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_or_CIRC_g146]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g146'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_or_CIRC_g146]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g146'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_or_CIRC_g146]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g146'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_or_CIRC_g146]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g146'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g147]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g147'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g147]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g147'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g147]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g147'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g147]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g147'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g147]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g147'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g147]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g147'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g148]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g148'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g148]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g148'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g148]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g148'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g148]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g148'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g148]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g148'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g148]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g148'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g149]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g149'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g149]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g149'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g149]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g149'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g149]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g149'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g149]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g149'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g149]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g149'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g150]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g150'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g150]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g150'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g150]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g150'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g150]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g150'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g150]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g150'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g150]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g150'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g151]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g151'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g151]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g151'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g151]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g151'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g151]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g151'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g151]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g151'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g151]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g151'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g152]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g152'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g152]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g152'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g152]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g152'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g152]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g152'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g152]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g152'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g152]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g152'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g153]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g153'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g153]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g153'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g153]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g153'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g153]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g153'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g153]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g153'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g153]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g153'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g154]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g154'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g154]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g154'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g154]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g154'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g154]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g154'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g154]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g154'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g154]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g154'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_inium_I_g155]
    type = InertialForceBeam
    block = 'insulator___aluminium_I_g155'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_inium_I_g155]
    type = InertialForceBeam
    block = 'insulator___aluminium_I_g155'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_inium_I_g155]
    type = InertialForceBeam
    block = 'insulator___aluminium_I_g155'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_inium_I_g155]
    type = InertialForceBeam
    block = 'insulator___aluminium_I_g155'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_inium_I_g155]
    type = InertialForceBeam
    block = 'insulator___aluminium_I_g155'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_inium_I_g155]
    type = InertialForceBeam
    block = 'insulator___aluminium_I_g155'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g156]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g156'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g156]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g156'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g156]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g156'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g156]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g156'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g156]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g156'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g156]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g156'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g157]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g157'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g157]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g157'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g157]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g157'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g157]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g157'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g157]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g157'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g157]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g157'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_or_CIRC_g158]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g158'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_or_CIRC_g158]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g158'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_or_CIRC_g158]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g158'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_or_CIRC_g158]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g158'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_or_CIRC_g158]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g158'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_or_CIRC_g158]
    type = InertialForceBeam
    block = 'insulat__insulator_CIRC_g158'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g159]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g159'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g159]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g159'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g159]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g159'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g159]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g159'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g159]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g159'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g159]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g159'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g160]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g160'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g160]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g160'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g160]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g160'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g160]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g160'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g160]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g160'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g160]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g160'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g161]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g161'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g161]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g161'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g161]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g161'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g161]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g161'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g161]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g161'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g161]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g161'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g162]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g162'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g162]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g162'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g162]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g162'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g162]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g162'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g162]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g162'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g162]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g162'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g163]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g163'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g163]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g163'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g163]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g163'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g163]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g163'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g163]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g163'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g163]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g163'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g164]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g164'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g164]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g164'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g164]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g164'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g164]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g164'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g164]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g164'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g164]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g164'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g165]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g165'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g165]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g165'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g165]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g165'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g165]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g165'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g165]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g165'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g165]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g165'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_inium_I_g166]
    type = InertialForceBeam
    block = 'insulator___aluminium_I_g166'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_inium_I_g166]
    type = InertialForceBeam
    block = 'insulator___aluminium_I_g166'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_inium_I_g166]
    type = InertialForceBeam
    block = 'insulator___aluminium_I_g166'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_inium_I_g166]
    type = InertialForceBeam
    block = 'insulator___aluminium_I_g166'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_inium_I_g166]
    type = InertialForceBeam
    block = 'insulator___aluminium_I_g166'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_inium_I_g166]
    type = InertialForceBeam
    block = 'insulator___aluminium_I_g166'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 7400
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g167]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g167'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g167]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g167'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g167]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g167'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g167]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g167'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g167]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g167'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g167]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g167'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g168]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g168'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g168]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g168'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g168]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g168'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g168]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g168'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g168]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g168'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g168]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g168'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g169]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g169'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g169]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g169'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g169]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g169'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g169]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g169'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g169]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g169'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g169]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g169'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g170]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g170'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g170]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g170'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g170]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g170'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g170]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g170'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g170]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g170'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g170]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g170'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g171]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g171'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g171]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g171'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g171]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g171'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g171]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g171'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g171]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g171'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g171]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g171'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g172]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g172'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g172]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g172'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g172]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g172'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g172]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g172'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g172]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g172'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g172]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g172'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g173]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g173'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g173]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g173'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g173]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g173'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g173]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g173'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g173]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g173'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g173]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g173'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g174]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g174'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g174]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g174'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g174]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g174'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g174]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g174'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g174]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g174'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g174]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g174'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g175]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g175'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g175]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g175'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g175]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g175'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g175]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g175'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g175]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g175'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g175]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g175'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_ge_CIRC_g176]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g176'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_ge_CIRC_g176]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g176'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_ge_CIRC_g176]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g176'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_ge_CIRC_g176]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g176'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_ge_CIRC_g176]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g176'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_ge_CIRC_g176]
    type = InertialForceBeam
    block = 'insulator___flange_CIRC_g176'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 62458
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_eam_links_g1]
    type = InertialForceBeam
    block = 'mpc_beam_links_g1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_eam_links_g1]
    type = InertialForceBeam
    block = 'mpc_beam_links_g1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_eam_links_g1]
    type = InertialForceBeam
    block = 'mpc_beam_links_g1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_eam_links_g1]
    type = InertialForceBeam
    block = 'mpc_beam_links_g1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_eam_links_g1]
    type = InertialForceBeam
    block = 'mpc_beam_links_g1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_eam_links_g1]
    type = InertialForceBeam
    block = 'mpc_beam_links_g1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_eam_links_g2]
    type = InertialForceBeam
    block = 'mpc_beam_links_g2'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_eam_links_g2]
    type = InertialForceBeam
    block = 'mpc_beam_links_g2'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_eam_links_g2]
    type = InertialForceBeam
    block = 'mpc_beam_links_g2'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_eam_links_g2]
    type = InertialForceBeam
    block = 'mpc_beam_links_g2'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_eam_links_g2]
    type = InertialForceBeam
    block = 'mpc_beam_links_g2'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_eam_links_g2]
    type = InertialForceBeam
    block = 'mpc_beam_links_g2'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_eam_links_g3]
    type = InertialForceBeam
    block = 'mpc_beam_links_g3'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_eam_links_g3]
    type = InertialForceBeam
    block = 'mpc_beam_links_g3'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_eam_links_g3]
    type = InertialForceBeam
    block = 'mpc_beam_links_g3'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_eam_links_g3]
    type = InertialForceBeam
    block = 'mpc_beam_links_g3'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_eam_links_g3]
    type = InertialForceBeam
    block = 'mpc_beam_links_g3'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_eam_links_g3]
    type = InertialForceBeam
    block = 'mpc_beam_links_g3'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_eam_links_g4]
    type = InertialForceBeam
    block = 'mpc_beam_links_g4'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_eam_links_g4]
    type = InertialForceBeam
    block = 'mpc_beam_links_g4'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_eam_links_g4]
    type = InertialForceBeam
    block = 'mpc_beam_links_g4'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_eam_links_g4]
    type = InertialForceBeam
    block = 'mpc_beam_links_g4'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_eam_links_g4]
    type = InertialForceBeam
    block = 'mpc_beam_links_g4'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_eam_links_g4]
    type = InertialForceBeam
    block = 'mpc_beam_links_g4'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_eam_links_g5]
    type = InertialForceBeam
    block = 'mpc_beam_links_g5'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_eam_links_g5]
    type = InertialForceBeam
    block = 'mpc_beam_links_g5'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_eam_links_g5]
    type = InertialForceBeam
    block = 'mpc_beam_links_g5'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_eam_links_g5]
    type = InertialForceBeam
    block = 'mpc_beam_links_g5'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_eam_links_g5]
    type = InertialForceBeam
    block = 'mpc_beam_links_g5'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_eam_links_g5]
    type = InertialForceBeam
    block = 'mpc_beam_links_g5'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_eam_links_g6]
    type = InertialForceBeam
    block = 'mpc_beam_links_g6'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_eam_links_g6]
    type = InertialForceBeam
    block = 'mpc_beam_links_g6'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_eam_links_g6]
    type = InertialForceBeam
    block = 'mpc_beam_links_g6'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_eam_links_g6]
    type = InertialForceBeam
    block = 'mpc_beam_links_g6'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_eam_links_g6]
    type = InertialForceBeam
    block = 'mpc_beam_links_g6'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_eam_links_g6]
    type = InertialForceBeam
    block = 'mpc_beam_links_g6'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_eam_links_g7]
    type = InertialForceBeam
    block = 'mpc_beam_links_g7'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_eam_links_g7]
    type = InertialForceBeam
    block = 'mpc_beam_links_g7'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_eam_links_g7]
    type = InertialForceBeam
    block = 'mpc_beam_links_g7'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_eam_links_g7]
    type = InertialForceBeam
    block = 'mpc_beam_links_g7'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_eam_links_g7]
    type = InertialForceBeam
    block = 'mpc_beam_links_g7'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_eam_links_g7]
    type = InertialForceBeam
    block = 'mpc_beam_links_g7'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_eam_links_g8]
    type = InertialForceBeam
    block = 'mpc_beam_links_g8'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_eam_links_g8]
    type = InertialForceBeam
    block = 'mpc_beam_links_g8'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_eam_links_g8]
    type = InertialForceBeam
    block = 'mpc_beam_links_g8'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_eam_links_g8]
    type = InertialForceBeam
    block = 'mpc_beam_links_g8'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_eam_links_g8]
    type = InertialForceBeam
    block = 'mpc_beam_links_g8'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_eam_links_g8]
    type = InertialForceBeam
    block = 'mpc_beam_links_g8'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_eam_links_g9]
    type = InertialForceBeam
    block = 'mpc_beam_links_g9'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_eam_links_g9]
    type = InertialForceBeam
    block = 'mpc_beam_links_g9'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_eam_links_g9]
    type = InertialForceBeam
    block = 'mpc_beam_links_g9'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_eam_links_g9]
    type = InertialForceBeam
    block = 'mpc_beam_links_g9'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_eam_links_g9]
    type = InertialForceBeam
    block = 'mpc_beam_links_g9'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_eam_links_g9]
    type = InertialForceBeam
    block = 'mpc_beam_links_g9'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_am_links_g10]
    type = InertialForceBeam
    block = 'mpc_beam_links_g10'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_am_links_g10]
    type = InertialForceBeam
    block = 'mpc_beam_links_g10'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_am_links_g10]
    type = InertialForceBeam
    block = 'mpc_beam_links_g10'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_am_links_g10]
    type = InertialForceBeam
    block = 'mpc_beam_links_g10'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_am_links_g10]
    type = InertialForceBeam
    block = 'mpc_beam_links_g10'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_am_links_g10]
    type = InertialForceBeam
    block = 'mpc_beam_links_g10'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_am_links_g11]
    type = InertialForceBeam
    block = 'mpc_beam_links_g11'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_am_links_g11]
    type = InertialForceBeam
    block = 'mpc_beam_links_g11'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_am_links_g11]
    type = InertialForceBeam
    block = 'mpc_beam_links_g11'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_am_links_g11]
    type = InertialForceBeam
    block = 'mpc_beam_links_g11'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_am_links_g11]
    type = InertialForceBeam
    block = 'mpc_beam_links_g11'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_am_links_g11]
    type = InertialForceBeam
    block = 'mpc_beam_links_g11'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 5
    variable = rot_z
  []
  [if_disp_x_am_links_g12]
    type = InertialForceBeam
    block = 'mpc_beam_links_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 0
    variable = disp_x
  []
  [if_disp_y_am_links_g12]
    type = InertialForceBeam
    block = 'mpc_beam_links_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 1
    variable = disp_y
  []
  [if_disp_z_am_links_g12]
    type = InertialForceBeam
    block = 'mpc_beam_links_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 2
    variable = disp_z
  []
  [if_rot_x_am_links_g12]
    type = InertialForceBeam
    block = 'mpc_beam_links_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 3
    variable = rot_x
  []
  [if_rot_y_am_links_g12]
    type = InertialForceBeam
    block = 'mpc_beam_links_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 4
    variable = rot_y
  []
  [if_rot_z_am_links_g12]
    type = InertialForceBeam
    block = 'mpc_beam_links_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    accelerations = 'accel_x accel_y accel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
    area = 64000
    Iy = 3.1e+10
    Iz = 3.1e+10
    density = density
    component = 5
    variable = rot_z
  []
[]

[NodalKernels]
  [mass_x]
    type = NodalTranslationalInertia
    variable = disp_x
    boundary = '_PickedSet172'
    mass = 96
    velocity = vel_x
    acceleration = accel_x
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
  []
  [mass_y]
    type = NodalTranslationalInertia
    variable = disp_y
    boundary = '_PickedSet172'
    mass = 96
    velocity = vel_y
    acceleration = accel_y
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
  []
  [mass_z]
    type = NodalTranslationalInertia
    variable = disp_z
    boundary = '_PickedSet172'
    mass = 96
    velocity = vel_z
    acceleration = accel_z
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
  []
  [rotin_x]
    type = NodalRotationalInertia
    variable = rot_x
    boundary = '_PickedSet172'
    rotations = 'rot_x rot_y rot_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    Ixx = 3.03e+08
    Iyy = 3.03e+08
    Izz = 3.24e+08
    Ixy = 0
    Ixz = 0
    Iyz = 0
    component = 0
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
  []
  [rotin_y]
    type = NodalRotationalInertia
    variable = rot_y
    boundary = '_PickedSet172'
    rotations = 'rot_x rot_y rot_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    Ixx = 3.03e+08
    Iyy = 3.03e+08
    Izz = 3.24e+08
    Ixy = 0
    Ixz = 0
    Iyz = 0
    component = 1
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
  []
  [rotin_z]
    type = NodalRotationalInertia
    variable = rot_z
    boundary = '_PickedSet172'
    rotations = 'rot_x rot_y rot_z'
    rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
    rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'
    Ixx = 3.03e+08
    Iyy = 3.03e+08
    Izz = 3.24e+08
    Ixy = 0
    Ixz = 0
    Iyz = 0
    component = 2
    beta = 0.25
    gamma = 0.5
    eta = 0.0702
    alpha = 0.0
  []
[]

[BCs]
  [fix_disp_y]
    type = PresetDisplacement
    variable = disp_y
    boundary = '_PickedSet150__insulator_sum'
    function = zero
    velocity = vel_y
    acceleration = accel_y
    beta = 0.25
  []
  [fix_disp_z]
    type = PresetDisplacement
    variable = disp_z
    boundary = '_PickedSet150__insulator_sum'
    function = zero
    velocity = vel_z
    acceleration = accel_z
    beta = 0.25
  []
  [fix_rot_x]
    type = PresetDisplacement
    variable = rot_x
    boundary = '_PickedSet150__insulator_sum'
    function = zero
    velocity = rot_vel_x
    acceleration = rot_accel_x
    beta = 0.25
  []
  [fix_rot_y]
    type = PresetDisplacement
    variable = rot_y
    boundary = '_PickedSet150__insulator_sum'
    function = zero
    velocity = rot_vel_y
    acceleration = rot_accel_y
    beta = 0.25
  []
  [fix_rot_z]
    type = PresetDisplacement
    variable = rot_z
    boundary = '_PickedSet150__insulator_sum'
    function = zero
    velocity = rot_vel_z
    acceleration = rot_accel_z
    beta = 0.25
  []
  [accel_bc_disp_x]
    type = PresetAcceleration
    variable = disp_x
    boundary = '_PickedSet173__insulator_sum'
    function = rg_x
    scale_factor = 3920
    velocity = vel_x
    acceleration = accel_x
    beta = 0.25
  []
[]

[Materials]
  [elasticity_uminium_I_g1]
    type = ComputeElasticityBeam
    block = 'insulator_su__aluminium_I_g1'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_uminium_I_g1]
    type = ComputeBeamResultants
    block = 'insulator_su__aluminium_I_g1'
  []
  [strain_uminium_I_g1]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_su__aluminium_I_g1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0.965926 0.258819 -0'
  []
  [density_uminium_I_g1]
    type = GenericConstantMaterial
    block = 'insulator_su__aluminium_I_g1'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_uminium_I_g2]
    type = ComputeElasticityBeam
    block = 'insulator_su__aluminium_I_g2'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_uminium_I_g2]
    type = ComputeBeamResultants
    block = 'insulator_su__aluminium_I_g2'
  []
  [strain_uminium_I_g2]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_su__aluminium_I_g2'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0.707107 0.707107 -0'
  []
  [density_uminium_I_g2]
    type = GenericConstantMaterial
    block = 'insulator_su__aluminium_I_g2'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_uminium_I_g3]
    type = ComputeElasticityBeam
    block = 'insulator_su__aluminium_I_g3'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_uminium_I_g3]
    type = ComputeBeamResultants
    block = 'insulator_su__aluminium_I_g3'
  []
  [strain_uminium_I_g3]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_su__aluminium_I_g3'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0.258819 0.965926 -0'
  []
  [density_uminium_I_g3]
    type = GenericConstantMaterial
    block = 'insulator_su__aluminium_I_g3'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_uminium_I_g4]
    type = ComputeElasticityBeam
    block = 'insulator_su__aluminium_I_g4'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_uminium_I_g4]
    type = ComputeBeamResultants
    block = 'insulator_su__aluminium_I_g4'
  []
  [strain_uminium_I_g4]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_su__aluminium_I_g4'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0.258819 -0.965926 0'
  []
  [density_uminium_I_g4]
    type = GenericConstantMaterial
    block = 'insulator_su__aluminium_I_g4'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_uminium_I_g5]
    type = ComputeElasticityBeam
    block = 'insulator_su__aluminium_I_g5'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_uminium_I_g5]
    type = ComputeBeamResultants
    block = 'insulator_su__aluminium_I_g5'
  []
  [strain_uminium_I_g5]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_su__aluminium_I_g5'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0.707107 -0.707107 0'
  []
  [density_uminium_I_g5]
    type = GenericConstantMaterial
    block = 'insulator_su__aluminium_I_g5'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_uminium_I_g6]
    type = ComputeElasticityBeam
    block = 'insulator_su__aluminium_I_g6'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_uminium_I_g6]
    type = ComputeBeamResultants
    block = 'insulator_su__aluminium_I_g6'
  []
  [strain_uminium_I_g6]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_su__aluminium_I_g6'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0.5 0.866025 -0'
  []
  [density_uminium_I_g6]
    type = GenericConstantMaterial
    block = 'insulator_su__aluminium_I_g6'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_uminium_I_g7]
    type = ComputeElasticityBeam
    block = 'insulator_su__aluminium_I_g7'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_uminium_I_g7]
    type = ComputeBeamResultants
    block = 'insulator_su__aluminium_I_g7'
  []
  [strain_uminium_I_g7]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_su__aluminium_I_g7'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0.866025 0.5 -0'
  []
  [density_uminium_I_g7]
    type = GenericConstantMaterial
    block = 'insulator_su__aluminium_I_g7'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_ange_CIRC_g8]
    type = ComputeElasticityBeam
    block = 'insulator_su__flange_CIRC_g8'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ange_CIRC_g8]
    type = ComputeBeamResultants
    block = 'insulator_su__flange_CIRC_g8'
  []
  [strain_ange_CIRC_g8]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_su__flange_CIRC_g8'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013106 -0.08583'
  []
  [density_ange_CIRC_g8]
    type = GenericConstantMaterial
    block = 'insulator_su__flange_CIRC_g8'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ange_CIRC_g9]
    type = ComputeElasticityBeam
    block = 'insulator_su__flange_CIRC_g9'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ange_CIRC_g9]
    type = ComputeBeamResultants
    block = 'insulator_su__flange_CIRC_g9'
  []
  [strain_ange_CIRC_g9]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_su__flange_CIRC_g9'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013107 -0.085831'
  []
  [density_ange_CIRC_g9]
    type = GenericConstantMaterial
    block = 'insulator_su__flange_CIRC_g9'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g10]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g10'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g10]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g10'
  []
  [strain_nge_CIRC_g10]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g10'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013106 -0.085827'
  []
  [density_nge_CIRC_g10]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g10'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_tor_CIRC_g11]
    type = ComputeElasticityBeam
    block = 'insulato__insulator_CIRC_g11'
    youngs_modulus = 20000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_tor_CIRC_g11]
    type = ComputeBeamResultants
    block = 'insulato__insulator_CIRC_g11'
  []
  [strain_tor_CIRC_g11]
    type = ComputeIncrementalBeamStrain
    block = 'insulato__insulator_CIRC_g11'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013106 -0.085829'
  []
  [density_tor_CIRC_g11]
    type = GenericConstantMaterial
    block = 'insulato__insulator_CIRC_g11'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g12]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g12'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g12]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g12'
  []
  [strain_nge_CIRC_g12]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013106 -0.085828'
  []
  [density_nge_CIRC_g12]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g12'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_minium_I_g13]
    type = ComputeElasticityBeam
    block = 'insulator_s__aluminium_I_g13'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_minium_I_g13]
    type = ComputeBeamResultants
    block = 'insulator_s__aluminium_I_g13'
  []
  [strain_minium_I_g13]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__aluminium_I_g13'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0 1 -0'
  []
  [density_minium_I_g13]
    type = GenericConstantMaterial
    block = 'insulator_s__aluminium_I_g13'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_nge_CIRC_g14]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g14'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g14]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g14'
  []
  [strain_nge_CIRC_g14]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g14'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984808 0 0.173646'
  []
  [density_nge_CIRC_g14]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g14'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g15]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g15'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g15]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g15'
  []
  [strain_nge_CIRC_g15]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g15'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984808 0 0.173649'
  []
  [density_nge_CIRC_g15]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g15'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g16]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g16'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g16]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g16'
  []
  [strain_nge_CIRC_g16]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g16'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984808 0 0.17365'
  []
  [density_nge_CIRC_g16]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g16'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_tor_CIRC_g17]
    type = ComputeElasticityBeam
    block = 'insulato__insulator_CIRC_g17'
    youngs_modulus = 20000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_tor_CIRC_g17]
    type = ComputeBeamResultants
    block = 'insulato__insulator_CIRC_g17'
  []
  [strain_tor_CIRC_g17]
    type = ComputeIncrementalBeamStrain
    block = 'insulato__insulator_CIRC_g17'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984808 0 0.173648'
  []
  [density_tor_CIRC_g17]
    type = GenericConstantMaterial
    block = 'insulato__insulator_CIRC_g17'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g18]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g18'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g18]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g18'
  []
  [strain_nge_CIRC_g18]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g18'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984807 0 0.173651'
  []
  [density_nge_CIRC_g18]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g18'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g19]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g19'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g19]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g19'
  []
  [strain_nge_CIRC_g19]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g19'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984809 0 0.173642'
  []
  [density_nge_CIRC_g19]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g19'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g20]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g20'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g20]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g20'
  []
  [strain_nge_CIRC_g20]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g20'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984807 0 0.173652'
  []
  [density_nge_CIRC_g20]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g20'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_minium_I_g21]
    type = ComputeElasticityBeam
    block = 'insulator_s__aluminium_I_g21'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_minium_I_g21]
    type = ComputeBeamResultants
    block = 'insulator_s__aluminium_I_g21'
  []
  [strain_minium_I_g21]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__aluminium_I_g21'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0.965926 -0.258819 0'
  []
  [density_minium_I_g21]
    type = GenericConstantMaterial
    block = 'insulator_s__aluminium_I_g21'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_minium_I_g22]
    type = ComputeElasticityBeam
    block = 'insulator_s__aluminium_I_g22'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_minium_I_g22]
    type = ComputeBeamResultants
    block = 'insulator_s__aluminium_I_g22'
  []
  [strain_minium_I_g22]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__aluminium_I_g22'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0.5 0.866025 -0'
  []
  [density_minium_I_g22]
    type = GenericConstantMaterial
    block = 'insulator_s__aluminium_I_g22'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_minium_I_g23]
    type = ComputeElasticityBeam
    block = 'insulator_s__aluminium_I_g23'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_minium_I_g23]
    type = ComputeBeamResultants
    block = 'insulator_s__aluminium_I_g23'
  []
  [strain_minium_I_g23]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__aluminium_I_g23'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0 1 -0'
  []
  [density_minium_I_g23]
    type = GenericConstantMaterial
    block = 'insulator_s__aluminium_I_g23'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_nge_CIRC_g24]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g24'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g24]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g24'
  []
  [strain_nge_CIRC_g24]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g24'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984807 -0 -0.173651'
  []
  [density_nge_CIRC_g24]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g24'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g25]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g25'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g25]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g25'
  []
  [strain_nge_CIRC_g25]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g25'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984809 -0 -0.173642'
  []
  [density_nge_CIRC_g25]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g25'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g26]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g26'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g26]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g26'
  []
  [strain_nge_CIRC_g26]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g26'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984807 -0 -0.173652'
  []
  [density_nge_CIRC_g26]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g26'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_tor_CIRC_g27]
    type = ComputeElasticityBeam
    block = 'insulato__insulator_CIRC_g27'
    youngs_modulus = 20000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_tor_CIRC_g27]
    type = ComputeBeamResultants
    block = 'insulato__insulator_CIRC_g27'
  []
  [strain_tor_CIRC_g27]
    type = ComputeIncrementalBeamStrain
    block = 'insulato__insulator_CIRC_g27'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984808 -0 -0.173648'
  []
  [density_tor_CIRC_g27]
    type = GenericConstantMaterial
    block = 'insulato__insulator_CIRC_g27'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g28]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g28'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g28]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g28'
  []
  [strain_nge_CIRC_g28]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g28'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984808 -0 -0.173647'
  []
  [density_nge_CIRC_g28]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g28'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g29]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g29'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g29]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g29'
  []
  [strain_nge_CIRC_g29]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g29'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984808 -0 -0.173646'
  []
  [density_nge_CIRC_g29]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g29'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g30]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g30'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g30]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g30'
  []
  [strain_nge_CIRC_g30]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g30'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013207 0.1498'
  []
  [density_nge_CIRC_g30]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g30'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g31]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g31'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g31]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g31'
  []
  [strain_nge_CIRC_g31]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g31'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013207 0.149802'
  []
  [density_nge_CIRC_g31]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g31'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g32]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g32'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g32]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g32'
  []
  [strain_nge_CIRC_g32]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g32'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013207 0.149801'
  []
  [density_nge_CIRC_g32]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g32'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_tor_CIRC_g33]
    type = ComputeElasticityBeam
    block = 'insulato__insulator_CIRC_g33'
    youngs_modulus = 20000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_tor_CIRC_g33]
    type = ComputeBeamResultants
    block = 'insulato__insulator_CIRC_g33'
  []
  [strain_tor_CIRC_g33]
    type = ComputeIncrementalBeamStrain
    block = 'insulato__insulator_CIRC_g33'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013207 0.149803'
  []
  [density_tor_CIRC_g33]
    type = GenericConstantMaterial
    block = 'insulato__insulator_CIRC_g33'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_tor_CIRC_g34]
    type = ComputeElasticityBeam
    block = 'insulato__insulator_CIRC_g34'
    youngs_modulus = 20000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_tor_CIRC_g34]
    type = ComputeBeamResultants
    block = 'insulato__insulator_CIRC_g34'
  []
  [strain_tor_CIRC_g34]
    type = ComputeIncrementalBeamStrain
    block = 'insulato__insulator_CIRC_g34'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013207 0.149802'
  []
  [density_tor_CIRC_g34]
    type = GenericConstantMaterial
    block = 'insulato__insulator_CIRC_g34'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g35]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g35'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g35]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g35'
  []
  [strain_nge_CIRC_g35]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g35'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013207 0.149802'
  []
  [density_nge_CIRC_g35]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g35'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_minium_I_g36]
    type = ComputeElasticityBeam
    block = 'insulator_s__aluminium_I_g36'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_minium_I_g36]
    type = ComputeBeamResultants
    block = 'insulator_s__aluminium_I_g36'
  []
  [strain_minium_I_g36]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__aluminium_I_g36'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0.866025 -0.5 0'
  []
  [density_minium_I_g36]
    type = GenericConstantMaterial
    block = 'insulator_s__aluminium_I_g36'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_nge_CIRC_g37]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g37'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g37]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g37'
  []
  [strain_nge_CIRC_g37]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g37'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013107 -0.085828'
  []
  [density_nge_CIRC_g37]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g37'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g38]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g38'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g38]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g38'
  []
  [strain_nge_CIRC_g38]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g38'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013106 -0.08583'
  []
  [density_nge_CIRC_g38]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g38'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_tor_CIRC_g39]
    type = ComputeElasticityBeam
    block = 'insulato__insulator_CIRC_g39'
    youngs_modulus = 20000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_tor_CIRC_g39]
    type = ComputeBeamResultants
    block = 'insulato__insulator_CIRC_g39'
  []
  [strain_tor_CIRC_g39]
    type = ComputeIncrementalBeamStrain
    block = 'insulato__insulator_CIRC_g39'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013106 -0.085829'
  []
  [density_tor_CIRC_g39]
    type = GenericConstantMaterial
    block = 'insulato__insulator_CIRC_g39'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g40]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g40'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g40]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g40'
  []
  [strain_nge_CIRC_g40]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g40'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013107 -0.085831'
  []
  [density_nge_CIRC_g40]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g40'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g41]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g41'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g41]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g41'
  []
  [strain_nge_CIRC_g41]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g41'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013106 -0.085826'
  []
  [density_nge_CIRC_g41]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g41'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_minium_I_g42]
    type = ComputeElasticityBeam
    block = 'insulator_s__aluminium_I_g42'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_minium_I_g42]
    type = ComputeBeamResultants
    block = 'insulator_s__aluminium_I_g42'
  []
  [strain_minium_I_g42]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__aluminium_I_g42'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0.707107 0.707107 -0'
  []
  [density_minium_I_g42]
    type = GenericConstantMaterial
    block = 'insulator_s__aluminium_I_g42'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_minium_I_g43]
    type = ComputeElasticityBeam
    block = 'insulator_s__aluminium_I_g43'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_minium_I_g43]
    type = ComputeBeamResultants
    block = 'insulator_s__aluminium_I_g43'
  []
  [strain_minium_I_g43]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__aluminium_I_g43'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '-0.5 0.866025 -0'
  []
  [density_minium_I_g43]
    type = GenericConstantMaterial
    block = 'insulator_s__aluminium_I_g43'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_minium_I_g44]
    type = ComputeElasticityBeam
    block = 'insulator_s__aluminium_I_g44'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_minium_I_g44]
    type = ComputeBeamResultants
    block = 'insulator_s__aluminium_I_g44'
  []
  [strain_minium_I_g44]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__aluminium_I_g44'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0.866025 0.5 -0'
  []
  [density_minium_I_g44]
    type = GenericConstantMaterial
    block = 'insulator_s__aluminium_I_g44'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_nge_CIRC_g45]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g45'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g45]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g45'
  []
  [strain_nge_CIRC_g45]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g45'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013107 0.085831'
  []
  [density_nge_CIRC_g45]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g45'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g46]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g46'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g46]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g46'
  []
  [strain_nge_CIRC_g46]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g46'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013106 0.085826'
  []
  [density_nge_CIRC_g46]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g46'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g47]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g47'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g47]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g47'
  []
  [strain_nge_CIRC_g47]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g47'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013107 0.085831'
  []
  [density_nge_CIRC_g47]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g47'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_tor_CIRC_g48]
    type = ComputeElasticityBeam
    block = 'insulato__insulator_CIRC_g48'
    youngs_modulus = 20000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_tor_CIRC_g48]
    type = ComputeBeamResultants
    block = 'insulato__insulator_CIRC_g48'
  []
  [strain_tor_CIRC_g48]
    type = ComputeIncrementalBeamStrain
    block = 'insulato__insulator_CIRC_g48'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013106 0.085829'
  []
  [density_tor_CIRC_g48]
    type = GenericConstantMaterial
    block = 'insulato__insulator_CIRC_g48'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g49]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g49'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g49]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g49'
  []
  [strain_nge_CIRC_g49]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g49'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013106 0.085829'
  []
  [density_nge_CIRC_g49]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g49'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g50]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g50'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g50]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g50'
  []
  [strain_nge_CIRC_g50]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g50'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013107 0.085828'
  []
  [density_nge_CIRC_g50]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g50'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_minium_I_g51]
    type = ComputeElasticityBeam
    block = 'insulator_s__aluminium_I_g51'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_minium_I_g51]
    type = ComputeBeamResultants
    block = 'insulator_s__aluminium_I_g51'
  []
  [strain_minium_I_g51]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__aluminium_I_g51'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '-0.5 0.866025 -0'
  []
  [density_minium_I_g51]
    type = GenericConstantMaterial
    block = 'insulator_s__aluminium_I_g51'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_minium_I_g52]
    type = ComputeElasticityBeam
    block = 'insulator_s__aluminium_I_g52'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_minium_I_g52]
    type = ComputeBeamResultants
    block = 'insulator_s__aluminium_I_g52'
  []
  [strain_minium_I_g52]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__aluminium_I_g52'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0.866025 -0.5 0'
  []
  [density_minium_I_g52]
    type = GenericConstantMaterial
    block = 'insulator_s__aluminium_I_g52'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_minium_I_g53]
    type = ComputeElasticityBeam
    block = 'insulator_s__aluminium_I_g53'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_minium_I_g53]
    type = ComputeBeamResultants
    block = 'insulator_s__aluminium_I_g53'
  []
  [strain_minium_I_g53]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__aluminium_I_g53'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '1 0 0'
  []
  [density_minium_I_g53]
    type = GenericConstantMaterial
    block = 'insulator_s__aluminium_I_g53'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_nge_CIRC_g54]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g54'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g54]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g54'
  []
  [strain_nge_CIRC_g54]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g54'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013207 -0.1498'
  []
  [density_nge_CIRC_g54]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g54'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g55]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g55'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g55]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g55'
  []
  [strain_nge_CIRC_g55]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g55'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013207 -0.149802'
  []
  [density_nge_CIRC_g55]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g55'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g56]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g56'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g56]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g56'
  []
  [strain_nge_CIRC_g56]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g56'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013207 -0.149801'
  []
  [density_nge_CIRC_g56]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g56'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g57]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g57'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g57]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g57'
  []
  [strain_nge_CIRC_g57]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g57'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 0.013207 -0.149807'
  []
  [density_nge_CIRC_g57]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g57'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_tor_CIRC_g58]
    type = ComputeElasticityBeam
    block = 'insulato__insulator_CIRC_g58'
    youngs_modulus = 20000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_tor_CIRC_g58]
    type = ComputeBeamResultants
    block = 'insulato__insulator_CIRC_g58'
  []
  [strain_tor_CIRC_g58]
    type = ComputeIncrementalBeamStrain
    block = 'insulato__insulator_CIRC_g58'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013207 -0.149803'
  []
  [density_tor_CIRC_g58]
    type = GenericConstantMaterial
    block = 'insulato__insulator_CIRC_g58'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g59]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g59'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g59]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g59'
  []
  [strain_nge_CIRC_g59]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g59'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013207 -0.149802'
  []
  [density_nge_CIRC_g59]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g59'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g60]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g60'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g60]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g60'
  []
  [strain_nge_CIRC_g60]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g60'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 0.013207 -0.149806'
  []
  [density_nge_CIRC_g60]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g60'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g61]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g61'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g61]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g61'
  []
  [strain_nge_CIRC_g61]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g61'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013208 -0.149802'
  []
  [density_nge_CIRC_g61]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g61'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g62]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g62'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g62]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g62'
  []
  [strain_nge_CIRC_g62]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g62'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 0.013208 -0.149807'
  []
  [density_nge_CIRC_g62]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g62'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g63]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g63'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g63]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g63'
  []
  [strain_nge_CIRC_g63]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g63'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013106 -0.085827'
  []
  [density_nge_CIRC_g63]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g63'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g64]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g64'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g64]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g64'
  []
  [strain_nge_CIRC_g64]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g64'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013107 -0.08583'
  []
  [density_nge_CIRC_g64]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g64'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g65]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g65'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g65]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g65'
  []
  [strain_nge_CIRC_g65]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g65'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996223 0.013107 -0.085833'
  []
  [density_nge_CIRC_g65]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g65'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g66]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g66'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g66]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g66'
  []
  [strain_nge_CIRC_g66]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g66'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996223 0.013107 -0.085833'
  []
  [density_nge_CIRC_g66]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g66'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g67]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g67'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g67]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g67'
  []
  [strain_nge_CIRC_g67]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g67'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013107 -0.085828'
  []
  [density_nge_CIRC_g67]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g67'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g68]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g68'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g68]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g68'
  []
  [strain_nge_CIRC_g68]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g68'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 0.013207 -0.149808'
  []
  [density_nge_CIRC_g68]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g68'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_tor_CIRC_g69]
    type = ComputeElasticityBeam
    block = 'insulato__insulator_CIRC_g69'
    youngs_modulus = 20000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_tor_CIRC_g69]
    type = ComputeBeamResultants
    block = 'insulato__insulator_CIRC_g69'
  []
  [strain_tor_CIRC_g69]
    type = ComputeIncrementalBeamStrain
    block = 'insulato__insulator_CIRC_g69'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013207 -0.149802'
  []
  [density_tor_CIRC_g69]
    type = GenericConstantMaterial
    block = 'insulato__insulator_CIRC_g69'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g70]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g70'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g70]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g70'
  []
  [strain_nge_CIRC_g70]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g70'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 0.013207 -0.149805'
  []
  [density_nge_CIRC_g70]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g70'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_minium_I_g71]
    type = ComputeElasticityBeam
    block = 'insulator_s__aluminium_I_g71'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_minium_I_g71]
    type = ComputeBeamResultants
    block = 'insulator_s__aluminium_I_g71'
  []
  [strain_minium_I_g71]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__aluminium_I_g71'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0.965926 -0.258819 0'
  []
  [density_minium_I_g71]
    type = GenericConstantMaterial
    block = 'insulator_s__aluminium_I_g71'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_minium_I_g72]
    type = ComputeElasticityBeam
    block = 'insulator_s__aluminium_I_g72'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_minium_I_g72]
    type = ComputeBeamResultants
    block = 'insulator_s__aluminium_I_g72'
  []
  [strain_minium_I_g72]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__aluminium_I_g72'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0.965926 0.258819 -0'
  []
  [density_minium_I_g72]
    type = GenericConstantMaterial
    block = 'insulator_s__aluminium_I_g72'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_nge_CIRC_g73]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g73'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g73]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g73'
  []
  [strain_nge_CIRC_g73]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g73'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984809 0 0.173644'
  []
  [density_nge_CIRC_g73]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g73'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g74]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g74'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g74]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g74'
  []
  [strain_nge_CIRC_g74]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g74'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984808 0 0.173645'
  []
  [density_nge_CIRC_g74]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g74'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g75]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g75'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g75]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g75'
  []
  [strain_nge_CIRC_g75]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g75'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984806 0 0.173656'
  []
  [density_nge_CIRC_g75]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g75'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g76]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g76'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g76]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g76'
  []
  [strain_nge_CIRC_g76]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g76'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984808 0 0.173644'
  []
  [density_nge_CIRC_g76]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g76'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g77]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g77'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g77]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g77'
  []
  [strain_nge_CIRC_g77]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g77'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013206 0.149799'
  []
  [density_nge_CIRC_g77]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g77'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g78]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g78'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g78]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g78'
  []
  [strain_nge_CIRC_g78]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g78'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 0.013208 0.149808'
  []
  [density_nge_CIRC_g78]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g78'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g79]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g79'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g79]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g79'
  []
  [strain_nge_CIRC_g79]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g79'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 0.013207 0.149805'
  []
  [density_nge_CIRC_g79]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g79'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g80]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g80'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g80]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g80'
  []
  [strain_nge_CIRC_g80]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g80'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 0.013207 0.149808'
  []
  [density_nge_CIRC_g80]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g80'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_minium_I_g81]
    type = ComputeElasticityBeam
    block = 'insulator_s__aluminium_I_g81'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_minium_I_g81]
    type = ComputeBeamResultants
    block = 'insulator_s__aluminium_I_g81'
  []
  [strain_minium_I_g81]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__aluminium_I_g81'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '1 0 0'
  []
  [density_minium_I_g81]
    type = GenericConstantMaterial
    block = 'insulator_s__aluminium_I_g81'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_nge_CIRC_g82]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g82'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g82]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g82'
  []
  [strain_nge_CIRC_g82]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g82'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013106 -0.085826'
  []
  [density_nge_CIRC_g82]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g82'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g83]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g83'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g83]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g83'
  []
  [strain_nge_CIRC_g83]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g83'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013107 -0.085831'
  []
  [density_nge_CIRC_g83]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g83'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g84]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g84'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g84]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g84'
  []
  [strain_nge_CIRC_g84]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g84'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013106 -0.085829'
  []
  [density_nge_CIRC_g84]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g84'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g85]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g85'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g85]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g85'
  []
  [strain_nge_CIRC_g85]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g85'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984808 -0 -0.173649'
  []
  [density_nge_CIRC_g85]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g85'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g86]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g86'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g86]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g86'
  []
  [strain_nge_CIRC_g86]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g86'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984808 -0 -0.17365'
  []
  [density_nge_CIRC_g86]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g86'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g87]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g87'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g87]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g87'
  []
  [strain_nge_CIRC_g87]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g87'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984809 -0 -0.173644'
  []
  [density_nge_CIRC_g87]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g87'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g88]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g88'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g88]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g88'
  []
  [strain_nge_CIRC_g88]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g88'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984808 -0 -0.173645'
  []
  [density_nge_CIRC_g88]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g88'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g89]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g89'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g89]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g89'
  []
  [strain_nge_CIRC_g89]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g89'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984806 -0 -0.173656'
  []
  [density_nge_CIRC_g89]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g89'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g90]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g90'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g90]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g90'
  []
  [strain_nge_CIRC_g90]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g90'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984808 -0 -0.173644'
  []
  [density_nge_CIRC_g90]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g90'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g91]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g91'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g91]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g91'
  []
  [strain_nge_CIRC_g91]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g91'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '1 0 0'
  []
  [density_nge_CIRC_g91]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g91'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g92]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g92'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g92]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g92'
  []
  [strain_nge_CIRC_g92]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g92'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '1 0 0'
  []
  [density_nge_CIRC_g92]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g92'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_tor_CIRC_g93]
    type = ComputeElasticityBeam
    block = 'insulato__insulator_CIRC_g93'
    youngs_modulus = 20000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_tor_CIRC_g93]
    type = ComputeBeamResultants
    block = 'insulato__insulator_CIRC_g93'
  []
  [strain_tor_CIRC_g93]
    type = ComputeIncrementalBeamStrain
    block = 'insulato__insulator_CIRC_g93'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '1 0 0'
  []
  [density_tor_CIRC_g93]
    type = GenericConstantMaterial
    block = 'insulato__insulator_CIRC_g93'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g94]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g94'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g94]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g94'
  []
  [strain_nge_CIRC_g94]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g94'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '1 0 0'
  []
  [density_nge_CIRC_g94]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g94'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_tor_CIRC_g95]
    type = ComputeElasticityBeam
    block = 'insulato__insulator_CIRC_g95'
    youngs_modulus = 20000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_tor_CIRC_g95]
    type = ComputeBeamResultants
    block = 'insulato__insulator_CIRC_g95'
  []
  [strain_tor_CIRC_g95]
    type = ComputeIncrementalBeamStrain
    block = 'insulato__insulator_CIRC_g95'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '1 0 0'
  []
  [density_tor_CIRC_g95]
    type = GenericConstantMaterial
    block = 'insulato__insulator_CIRC_g95'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g96]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g96'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g96]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g96'
  []
  [strain_nge_CIRC_g96]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g96'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '1 0 0'
  []
  [density_nge_CIRC_g96]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g96'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g97]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g97'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g97]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g97'
  []
  [strain_nge_CIRC_g97]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g97'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013106 -0.085826'
  []
  [density_nge_CIRC_g97]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g97'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g98]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g98'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g98]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g98'
  []
  [strain_nge_CIRC_g98]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g98'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013107 -0.085831'
  []
  [density_nge_CIRC_g98]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g98'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_nge_CIRC_g99]
    type = ComputeElasticityBeam
    block = 'insulator_s__flange_CIRC_g99'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_nge_CIRC_g99]
    type = ComputeBeamResultants
    block = 'insulator_s__flange_CIRC_g99'
  []
  [strain_nge_CIRC_g99]
    type = ComputeIncrementalBeamStrain
    block = 'insulator_s__flange_CIRC_g99'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013106 -0.085829'
  []
  [density_nge_CIRC_g99]
    type = GenericConstantMaterial
    block = 'insulator_s__flange_CIRC_g99'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g100]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g100'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g100]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g100'
  []
  [strain_ge_CIRC_g100]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g100'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 0.013207 0.149807'
  []
  [density_ge_CIRC_g100]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g100'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g101]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g101'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g101]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g101'
  []
  [strain_ge_CIRC_g101]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g101'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 0.013207 0.149806'
  []
  [density_ge_CIRC_g101]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g101'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g102]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g102'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g102]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g102'
  []
  [strain_ge_CIRC_g102]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g102'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013208 0.149802'
  []
  [density_ge_CIRC_g102]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g102'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g103]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g103'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g103]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g103'
  []
  [strain_ge_CIRC_g103]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g103'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 0.013208 0.149807'
  []
  [density_ge_CIRC_g103]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g103'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g104]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g104'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g104]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g104'
  []
  [strain_ge_CIRC_g104]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g104'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013106 -0.085828'
  []
  [density_ge_CIRC_g104]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g104'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g105]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g105'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g105]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g105'
  []
  [strain_ge_CIRC_g105]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g105'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013106 -0.085827'
  []
  [density_ge_CIRC_g105]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g105'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g106]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g106'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g106]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g106'
  []
  [strain_ge_CIRC_g106]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g106'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013106 -0.085827'
  []
  [density_ge_CIRC_g106]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g106'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g107]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g107'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g107]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g107'
  []
  [strain_ge_CIRC_g107]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g107'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013107 -0.08583'
  []
  [density_ge_CIRC_g107]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g107'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g108]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g108'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g108]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g108'
  []
  [strain_ge_CIRC_g108]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g108'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996223 -0.013107 -0.085833'
  []
  [density_ge_CIRC_g108]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g108'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g109]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g109'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g109]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g109'
  []
  [strain_ge_CIRC_g109]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g109'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996223 -0.013107 -0.085833'
  []
  [density_ge_CIRC_g109]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g109'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_inium_I_g110]
    type = ComputeElasticityBeam
    block = 'insulator___aluminium_I_g110'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_inium_I_g110]
    type = ComputeBeamResultants
    block = 'insulator___aluminium_I_g110'
  []
  [strain_inium_I_g110]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___aluminium_I_g110'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0.258819 0.965926 -0'
  []
  [density_inium_I_g110]
    type = GenericConstantMaterial
    block = 'insulator___aluminium_I_g110'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_ge_CIRC_g111]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g111'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g111]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g111'
  []
  [strain_ge_CIRC_g111]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g111'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013207 -0.149802'
  []
  [density_ge_CIRC_g111]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g111'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g112]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g112'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g112]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g112'
  []
  [strain_ge_CIRC_g112]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g112'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013206 -0.149799'
  []
  [density_ge_CIRC_g112]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g112'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g113]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g113'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g113]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g113'
  []
  [strain_ge_CIRC_g113]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g113'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 -0.013208 -0.149808'
  []
  [density_ge_CIRC_g113]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g113'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g114]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g114'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g114]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g114'
  []
  [strain_ge_CIRC_g114]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g114'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 -0.013207 -0.149805'
  []
  [density_ge_CIRC_g114]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g114'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_or_CIRC_g115]
    type = ComputeElasticityBeam
    block = 'insulat__insulator_CIRC_g115'
    youngs_modulus = 20000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_or_CIRC_g115]
    type = ComputeBeamResultants
    block = 'insulat__insulator_CIRC_g115'
  []
  [strain_or_CIRC_g115]
    type = ComputeIncrementalBeamStrain
    block = 'insulat__insulator_CIRC_g115'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013207 -0.149803'
  []
  [density_or_CIRC_g115]
    type = GenericConstantMaterial
    block = 'insulat__insulator_CIRC_g115'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_or_CIRC_g116]
    type = ComputeElasticityBeam
    block = 'insulat__insulator_CIRC_g116'
    youngs_modulus = 20000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_or_CIRC_g116]
    type = ComputeBeamResultants
    block = 'insulat__insulator_CIRC_g116'
  []
  [strain_or_CIRC_g116]
    type = ComputeIncrementalBeamStrain
    block = 'insulat__insulator_CIRC_g116'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013207 -0.149802'
  []
  [density_or_CIRC_g116]
    type = GenericConstantMaterial
    block = 'insulat__insulator_CIRC_g116'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g117]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g117'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g117]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g117'
  []
  [strain_ge_CIRC_g117]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g117'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 -0.013207 -0.149808'
  []
  [density_ge_CIRC_g117]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g117'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g118]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g118'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g118]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g118'
  []
  [strain_ge_CIRC_g118]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g118'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013207 -0.149801'
  []
  [density_ge_CIRC_g118]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g118'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g119]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g119'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g119]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g119'
  []
  [strain_ge_CIRC_g119]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g119'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013207 -0.1498'
  []
  [density_ge_CIRC_g119]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g119'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g120]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g120'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g120]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g120'
  []
  [strain_ge_CIRC_g120]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g120'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013207 -0.149802'
  []
  [density_ge_CIRC_g120]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g120'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g121]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g121'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g121]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g121'
  []
  [strain_ge_CIRC_g121]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g121'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 -0.013207 -0.149807'
  []
  [density_ge_CIRC_g121]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g121'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g122]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g122'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g122]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g122'
  []
  [strain_ge_CIRC_g122]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g122'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 -0.013207 -0.149806'
  []
  [density_ge_CIRC_g122]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g122'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g123]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g123'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g123]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g123'
  []
  [strain_ge_CIRC_g123]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g123'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013208 -0.149802'
  []
  [density_ge_CIRC_g123]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g123'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g124]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g124'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g124]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g124'
  []
  [strain_ge_CIRC_g124]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g124'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 -0.013208 -0.149807'
  []
  [density_ge_CIRC_g124]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g124'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g125]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g125'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g125]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g125'
  []
  [strain_ge_CIRC_g125]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g125'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013106 0.085826'
  []
  [density_ge_CIRC_g125]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g125'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g126]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g126'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g126]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g126'
  []
  [strain_ge_CIRC_g126]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g126'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013106 0.08583'
  []
  [density_ge_CIRC_g126]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g126'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g127]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g127'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g127]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g127'
  []
  [strain_ge_CIRC_g127]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g127'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013106 0.085828'
  []
  [density_ge_CIRC_g127]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g127'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g128]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g128'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g128]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g128'
  []
  [strain_ge_CIRC_g128]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g128'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013106 0.085827'
  []
  [density_ge_CIRC_g128]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g128'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g129]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g129'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g129]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g129'
  []
  [strain_ge_CIRC_g129]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g129'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013106 0.085827'
  []
  [density_ge_CIRC_g129]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g129'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g130]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g130'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g130]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g130'
  []
  [strain_ge_CIRC_g130]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g130'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013107 0.08583'
  []
  [density_ge_CIRC_g130]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g130'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g131]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g131'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g131]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g131'
  []
  [strain_ge_CIRC_g131]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g131'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996223 0.013107 0.085833'
  []
  [density_ge_CIRC_g131]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g131'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g132]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g132'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g132]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g132'
  []
  [strain_ge_CIRC_g132]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g132'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996223 0.013107 0.085833'
  []
  [density_ge_CIRC_g132]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g132'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g133]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g133'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g133]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g133'
  []
  [strain_ge_CIRC_g133]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g133'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013207 0.1498'
  []
  [density_ge_CIRC_g133]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g133'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g134]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g134'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g134]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g134'
  []
  [strain_ge_CIRC_g134]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g134'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013207 0.149802'
  []
  [density_ge_CIRC_g134]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g134'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g135]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g135'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g135]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g135'
  []
  [strain_ge_CIRC_g135]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g135'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013207 0.149801'
  []
  [density_ge_CIRC_g135]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g135'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g136]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g136'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g136]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g136'
  []
  [strain_ge_CIRC_g136]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g136'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 -0.013207 0.149807'
  []
  [density_ge_CIRC_g136]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g136'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_or_CIRC_g137]
    type = ComputeElasticityBeam
    block = 'insulat__insulator_CIRC_g137'
    youngs_modulus = 20000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_or_CIRC_g137]
    type = ComputeBeamResultants
    block = 'insulat__insulator_CIRC_g137'
  []
  [strain_or_CIRC_g137]
    type = ComputeIncrementalBeamStrain
    block = 'insulat__insulator_CIRC_g137'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013207 0.149803'
  []
  [density_or_CIRC_g137]
    type = GenericConstantMaterial
    block = 'insulat__insulator_CIRC_g137'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g138]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g138'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g138]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g138'
  []
  [strain_ge_CIRC_g138]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g138'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013207 0.149802'
  []
  [density_ge_CIRC_g138]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g138'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g139]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g139'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g139]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g139'
  []
  [strain_ge_CIRC_g139]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g139'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 -0.013207 0.149806'
  []
  [density_ge_CIRC_g139]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g139'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g140]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g140'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g140]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g140'
  []
  [strain_ge_CIRC_g140]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g140'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013208 0.149802'
  []
  [density_ge_CIRC_g140]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g140'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g141]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g141'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g141]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g141'
  []
  [strain_ge_CIRC_g141]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g141'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 -0.013208 0.149807'
  []
  [density_ge_CIRC_g141]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g141'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g142]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g142'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g142]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g142'
  []
  [strain_ge_CIRC_g142]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g142'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013106 0.08583'
  []
  [density_ge_CIRC_g142]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g142'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g143]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g143'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g143]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g143'
  []
  [strain_ge_CIRC_g143]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g143'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013107 0.085831'
  []
  [density_ge_CIRC_g143]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g143'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g144]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g144'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g144]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g144'
  []
  [strain_ge_CIRC_g144]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g144'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013106 0.085827'
  []
  [density_ge_CIRC_g144]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g144'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g145]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g145'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g145]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g145'
  []
  [strain_ge_CIRC_g145]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g145'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013106 0.085827'
  []
  [density_ge_CIRC_g145]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g145'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_or_CIRC_g146]
    type = ComputeElasticityBeam
    block = 'insulat__insulator_CIRC_g146'
    youngs_modulus = 20000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_or_CIRC_g146]
    type = ComputeBeamResultants
    block = 'insulat__insulator_CIRC_g146'
  []
  [strain_or_CIRC_g146]
    type = ComputeIncrementalBeamStrain
    block = 'insulat__insulator_CIRC_g146'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013106 0.085829'
  []
  [density_or_CIRC_g146]
    type = GenericConstantMaterial
    block = 'insulat__insulator_CIRC_g146'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g147]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g147'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g147]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g147'
  []
  [strain_ge_CIRC_g147]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g147'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013107 0.08583'
  []
  [density_ge_CIRC_g147]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g147'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g148]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g148'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g148]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g148'
  []
  [strain_ge_CIRC_g148]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g148'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996223 -0.013107 0.085833'
  []
  [density_ge_CIRC_g148]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g148'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g149]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g149'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g149]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g149'
  []
  [strain_ge_CIRC_g149]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g149'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996223 -0.013107 0.085833'
  []
  [density_ge_CIRC_g149]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g149'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g150]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g150'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g150]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g150'
  []
  [strain_ge_CIRC_g150]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g150'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '1 0 0'
  []
  [density_ge_CIRC_g150]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g150'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g151]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g151'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g151]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g151'
  []
  [strain_ge_CIRC_g151]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g151'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013206 -0.149799'
  []
  [density_ge_CIRC_g151]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g151'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g152]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g152'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g152]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g152'
  []
  [strain_ge_CIRC_g152]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g152'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 0.013208 -0.149808'
  []
  [density_ge_CIRC_g152]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g152'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g153]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g153'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g153]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g153'
  []
  [strain_ge_CIRC_g153]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g153'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013207 -0.149799'
  []
  [density_ge_CIRC_g153]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g153'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g154]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g154'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g154]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g154'
  []
  [strain_ge_CIRC_g154]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g154'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013207 -0.149803'
  []
  [density_ge_CIRC_g154]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g154'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_inium_I_g155]
    type = ComputeElasticityBeam
    block = 'insulator___aluminium_I_g155'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_inium_I_g155]
    type = ComputeBeamResultants
    block = 'insulator___aluminium_I_g155'
  []
  [strain_inium_I_g155]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___aluminium_I_g155'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0.707107 -0.707107 0'
  []
  [density_inium_I_g155]
    type = GenericConstantMaterial
    block = 'insulator___aluminium_I_g155'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_ge_CIRC_g156]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g156'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g156]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g156'
  []
  [strain_ge_CIRC_g156]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g156'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '1 0 0'
  []
  [density_ge_CIRC_g156]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g156'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g157]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g157'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g157]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g157'
  []
  [strain_ge_CIRC_g157]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g157'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 -0.013207 0.149808'
  []
  [density_ge_CIRC_g157]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g157'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_or_CIRC_g158]
    type = ComputeElasticityBeam
    block = 'insulat__insulator_CIRC_g158'
    youngs_modulus = 20000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_or_CIRC_g158]
    type = ComputeBeamResultants
    block = 'insulat__insulator_CIRC_g158'
  []
  [strain_or_CIRC_g158]
    type = ComputeIncrementalBeamStrain
    block = 'insulat__insulator_CIRC_g158'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013207 0.149802'
  []
  [density_or_CIRC_g158]
    type = GenericConstantMaterial
    block = 'insulat__insulator_CIRC_g158'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g159]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g159'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g159]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g159'
  []
  [strain_ge_CIRC_g159]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g159'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 -0.013207 0.149805'
  []
  [density_ge_CIRC_g159]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g159'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g160]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g160'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g160]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g160'
  []
  [strain_ge_CIRC_g160]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g160'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013106 0.085826'
  []
  [density_ge_CIRC_g160]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g160'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g161]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g161'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g161]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g161'
  []
  [strain_ge_CIRC_g161]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g161'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013107 0.085831'
  []
  [density_ge_CIRC_g161]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g161'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g162]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g162'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g162]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g162'
  []
  [strain_ge_CIRC_g162]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g162'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013106 0.085826'
  []
  [density_ge_CIRC_g162]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g162'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g163]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g163'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g163]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g163'
  []
  [strain_ge_CIRC_g163]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g163'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013107 0.085828'
  []
  [density_ge_CIRC_g163]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g163'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g164]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g164'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g164]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g164'
  []
  [strain_ge_CIRC_g164]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g164'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013106 0.085828'
  []
  [density_ge_CIRC_g164]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g164'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g165]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g165'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g165]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g165'
  []
  [strain_ge_CIRC_g165]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g165'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 0.013106 -0.085826'
  []
  [density_ge_CIRC_g165]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g165'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_inium_I_g166]
    type = ComputeElasticityBeam
    block = 'insulator___aluminium_I_g166'
    youngs_modulus = 72000
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_inium_I_g166]
    type = ComputeBeamResultants
    block = 'insulator___aluminium_I_g166'
  []
  [strain_inium_I_g166]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___aluminium_I_g166'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 7400
    Ay = 6166.67
    Az = 6166.67
    Ix = 838432
    Iy = 2.78372e+07
    Iz = 8.13147e+06
    y_orientation = '0.258819 -0.965926 0'
  []
  [density_inium_I_g166]
    type = GenericConstantMaterial
    block = 'insulator___aluminium_I_g166'
    prop_names = 'density'
    prop_values = '2.7e-09'
  []
  [elasticity_ge_CIRC_g167]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g167'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g167]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g167'
  []
  [strain_ge_CIRC_g167]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g167'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013206 0.149799'
  []
  [density_ge_CIRC_g167]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g167'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g168]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g168'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g168]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g168'
  []
  [strain_ge_CIRC_g168]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g168'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988627 -0.013208 0.149808'
  []
  [density_ge_CIRC_g168]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g168'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g169]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g169'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g169]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g169'
  []
  [strain_ge_CIRC_g169]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g169'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013207 0.149799'
  []
  [density_ge_CIRC_g169]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g169'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g170]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g170'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g170]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g170'
  []
  [strain_ge_CIRC_g170]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g170'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 0.013207 0.149803'
  []
  [density_ge_CIRC_g170]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g170'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g171]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g171'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g171]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g171'
  []
  [strain_ge_CIRC_g171]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g171'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013207 -0.149799'
  []
  [density_ge_CIRC_g171]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g171'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g172]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g172'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g172]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g172'
  []
  [strain_ge_CIRC_g172]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g172'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013207 -0.149803'
  []
  [density_ge_CIRC_g172]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g172'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g173]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g173'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g173]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g173'
  []
  [strain_ge_CIRC_g173]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g173'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.984808 0 0.173647'
  []
  [density_ge_CIRC_g173]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g173'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g174]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g174'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g174]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g174'
  []
  [strain_ge_CIRC_g174]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g174'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.996224 -0.013106 0.085829'
  []
  [density_ge_CIRC_g174]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g174'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g175]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g175'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g175]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g175'
  []
  [strain_ge_CIRC_g175]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g175'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013207 0.149799'
  []
  [density_ge_CIRC_g175]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g175'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_ge_CIRC_g176]
    type = ComputeElasticityBeam
    block = 'insulator___flange_CIRC_g176'
    youngs_modulus = 6666
    poissons_ratio = 0.33
    shear_coefficient = 1.0
  []
  [resultants_ge_CIRC_g176]
    type = ComputeBeamResultants
    block = 'insulator___flange_CIRC_g176'
  []
  [strain_ge_CIRC_g176]
    type = ComputeIncrementalBeamStrain
    block = 'insulator___flange_CIRC_g176'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 62458
    Ay = 56212.2
    Az = 56212.2
    Ix = 6.20864e+08
    Iy = 3.10432e+08
    Iz = 3.10432e+08
    y_orientation = '0.988628 -0.013207 0.149803'
  []
  [density_ge_CIRC_g176]
    type = GenericConstantMaterial
    block = 'insulator___flange_CIRC_g176'
    prop_names = 'density'
    prop_values = '4.94434e-09'
  []
  [elasticity_eam_links_g1]
    type = ComputeElasticityBeam
    block = 'mpc_beam_links_g1'
    youngs_modulus = 2.06e+07
    poissons_ratio = 0
    shear_coefficient = 1.0
  []
  [resultants_eam_links_g1]
    type = ComputeBeamResultants
    block = 'mpc_beam_links_g1'
  []
  [strain_eam_links_g1]
    type = ComputeIncrementalBeamStrain
    block = 'mpc_beam_links_g1'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 64000
    Ay = 0
    Az = 0
    Ix = 6.2e+10
    Iy = 3.1e+10
    Iz = 3.1e+10
    y_orientation = '0.910174 0 -0.414227'
  []
  [density_eam_links_g1]
    type = GenericConstantMaterial
    block = 'mpc_beam_links_g1'
    prop_names = 'density'
    prop_values = '1.0762e-09'
  []
  [elasticity_eam_links_g2]
    type = ComputeElasticityBeam
    block = 'mpc_beam_links_g2'
    youngs_modulus = 2.06e+07
    poissons_ratio = 0
    shear_coefficient = 1.0
  []
  [resultants_eam_links_g2]
    type = ComputeBeamResultants
    block = 'mpc_beam_links_g2'
  []
  [strain_eam_links_g2]
    type = ComputeIncrementalBeamStrain
    block = 'mpc_beam_links_g2'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 64000
    Ay = 0
    Az = 0
    Ix = 6.2e+10
    Iy = 3.1e+10
    Iz = 3.1e+10
    y_orientation = '0.978317 0.075945 0.192688'
  []
  [density_eam_links_g2]
    type = GenericConstantMaterial
    block = 'mpc_beam_links_g2'
    prop_names = 'density'
    prop_values = '1.0762e-09'
  []
  [elasticity_eam_links_g3]
    type = ComputeElasticityBeam
    block = 'mpc_beam_links_g3'
    youngs_modulus = 2.06e+07
    poissons_ratio = 0
    shear_coefficient = 1.0
  []
  [resultants_eam_links_g3]
    type = ComputeBeamResultants
    block = 'mpc_beam_links_g3'
  []
  [strain_eam_links_g3]
    type = ComputeIncrementalBeamStrain
    block = 'mpc_beam_links_g3'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 64000
    Ay = 0
    Az = 0
    Ix = 6.2e+10
    Iy = 3.1e+10
    Iz = 3.1e+10
    y_orientation = '0.978317 -0.075945 -0.192688'
  []
  [density_eam_links_g3]
    type = GenericConstantMaterial
    block = 'mpc_beam_links_g3'
    prop_names = 'density'
    prop_values = '1.0762e-09'
  []
  [elasticity_eam_links_g4]
    type = ComputeElasticityBeam
    block = 'mpc_beam_links_g4'
    youngs_modulus = 2.06e+07
    poissons_ratio = 0
    shear_coefficient = 1.0
  []
  [resultants_eam_links_g4]
    type = ComputeBeamResultants
    block = 'mpc_beam_links_g4'
  []
  [strain_eam_links_g4]
    type = ComputeIncrementalBeamStrain
    block = 'mpc_beam_links_g4'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 64000
    Ay = 0
    Az = 0
    Ix = 6.2e+10
    Iy = 3.1e+10
    Iz = 3.1e+10
    y_orientation = '0.978317 0.075945 -0.192688'
  []
  [density_eam_links_g4]
    type = GenericConstantMaterial
    block = 'mpc_beam_links_g4'
    prop_names = 'density'
    prop_values = '1.0762e-09'
  []
  [elasticity_eam_links_g5]
    type = ComputeElasticityBeam
    block = 'mpc_beam_links_g5'
    youngs_modulus = 2.06e+07
    poissons_ratio = 0
    shear_coefficient = 1.0
  []
  [resultants_eam_links_g5]
    type = ComputeBeamResultants
    block = 'mpc_beam_links_g5'
  []
  [strain_eam_links_g5]
    type = ComputeIncrementalBeamStrain
    block = 'mpc_beam_links_g5'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 64000
    Ay = 0
    Az = 0
    Ix = 6.2e+10
    Iy = 3.1e+10
    Iz = 3.1e+10
    y_orientation = '0.933441 0.079596 -0.349789'
  []
  [density_eam_links_g5]
    type = GenericConstantMaterial
    block = 'mpc_beam_links_g5'
    prop_names = 'density'
    prop_values = '1.0762e-09'
  []
  [elasticity_eam_links_g6]
    type = ComputeElasticityBeam
    block = 'mpc_beam_links_g6'
    youngs_modulus = 2.06e+07
    poissons_ratio = 0
    shear_coefficient = 1.0
  []
  [resultants_eam_links_g6]
    type = ComputeBeamResultants
    block = 'mpc_beam_links_g6'
  []
  [strain_eam_links_g6]
    type = ComputeIncrementalBeamStrain
    block = 'mpc_beam_links_g6'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 64000
    Ay = 0
    Az = 0
    Ix = 6.2e+10
    Iy = 3.1e+10
    Iz = 3.1e+10
    y_orientation = '0.933441 0.079596 0.349789'
  []
  [density_eam_links_g6]
    type = GenericConstantMaterial
    block = 'mpc_beam_links_g6'
    prop_names = 'density'
    prop_values = '1.0762e-09'
  []
  [elasticity_eam_links_g7]
    type = ComputeElasticityBeam
    block = 'mpc_beam_links_g7'
    youngs_modulus = 2.06e+07
    poissons_ratio = 0
    shear_coefficient = 1.0
  []
  [resultants_eam_links_g7]
    type = ComputeBeamResultants
    block = 'mpc_beam_links_g7'
  []
  [strain_eam_links_g7]
    type = ComputeIncrementalBeamStrain
    block = 'mpc_beam_links_g7'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 64000
    Ay = 0
    Az = 0
    Ix = 6.2e+10
    Iy = 3.1e+10
    Iz = 3.1e+10
    y_orientation = '0.933441 -0.079596 -0.349789'
  []
  [density_eam_links_g7]
    type = GenericConstantMaterial
    block = 'mpc_beam_links_g7'
    prop_names = 'density'
    prop_values = '1.0762e-09'
  []
  [elasticity_eam_links_g8]
    type = ComputeElasticityBeam
    block = 'mpc_beam_links_g8'
    youngs_modulus = 2.06e+07
    poissons_ratio = 0
    shear_coefficient = 1.0
  []
  [resultants_eam_links_g8]
    type = ComputeBeamResultants
    block = 'mpc_beam_links_g8'
  []
  [strain_eam_links_g8]
    type = ComputeIncrementalBeamStrain
    block = 'mpc_beam_links_g8'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 64000
    Ay = 0
    Az = 0
    Ix = 6.2e+10
    Iy = 3.1e+10
    Iz = 3.1e+10
    y_orientation = '0.910174 0 0.414227'
  []
  [density_eam_links_g8]
    type = GenericConstantMaterial
    block = 'mpc_beam_links_g8'
    prop_names = 'density'
    prop_values = '1.0762e-09'
  []
  [elasticity_eam_links_g9]
    type = ComputeElasticityBeam
    block = 'mpc_beam_links_g9'
    youngs_modulus = 2.06e+07
    poissons_ratio = 0
    shear_coefficient = 1.0
  []
  [resultants_eam_links_g9]
    type = ComputeBeamResultants
    block = 'mpc_beam_links_g9'
  []
  [strain_eam_links_g9]
    type = ComputeIncrementalBeamStrain
    block = 'mpc_beam_links_g9'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 64000
    Ay = 0
    Az = 0
    Ix = 6.2e+10
    Iy = 3.1e+10
    Iz = 3.1e+10
    y_orientation = '1 0 0'
  []
  [density_eam_links_g9]
    type = GenericConstantMaterial
    block = 'mpc_beam_links_g9'
    prop_names = 'density'
    prop_values = '1.0762e-09'
  []
  [elasticity_am_links_g10]
    type = ComputeElasticityBeam
    block = 'mpc_beam_links_g10'
    youngs_modulus = 2.06e+07
    poissons_ratio = 0
    shear_coefficient = 1.0
  []
  [resultants_am_links_g10]
    type = ComputeBeamResultants
    block = 'mpc_beam_links_g10'
  []
  [strain_am_links_g10]
    type = ComputeIncrementalBeamStrain
    block = 'mpc_beam_links_g10'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 64000
    Ay = 0
    Az = 0
    Ix = 6.2e+10
    Iy = 3.1e+10
    Iz = 3.1e+10
    y_orientation = '0.978317 -0.075945 0.192688'
  []
  [density_am_links_g10]
    type = GenericConstantMaterial
    block = 'mpc_beam_links_g10'
    prop_names = 'density'
    prop_values = '1.0762e-09'
  []
  [elasticity_am_links_g11]
    type = ComputeElasticityBeam
    block = 'mpc_beam_links_g11'
    youngs_modulus = 2.06e+07
    poissons_ratio = 0
    shear_coefficient = 1.0
  []
  [resultants_am_links_g11]
    type = ComputeBeamResultants
    block = 'mpc_beam_links_g11'
  []
  [strain_am_links_g11]
    type = ComputeIncrementalBeamStrain
    block = 'mpc_beam_links_g11'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 64000
    Ay = 0
    Az = 0
    Ix = 6.2e+10
    Iy = 3.1e+10
    Iz = 3.1e+10
    y_orientation = '0.933441 -0.079596 0.349789'
  []
  [density_am_links_g11]
    type = GenericConstantMaterial
    block = 'mpc_beam_links_g11'
    prop_names = 'density'
    prop_values = '1.0762e-09'
  []
  [elasticity_am_links_g12]
    type = ComputeElasticityBeam
    block = 'mpc_beam_links_g12'
    youngs_modulus = 2.06e+07
    poissons_ratio = 0
    shear_coefficient = 1.0
  []
  [resultants_am_links_g12]
    type = ComputeBeamResultants
    block = 'mpc_beam_links_g12'
  []
  [strain_am_links_g12]
    type = ComputeIncrementalBeamStrain
    block = 'mpc_beam_links_g12'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 64000
    Ay = 0
    Az = 0
    Ix = 6.2e+10
    Iy = 3.1e+10
    Iz = 3.1e+10
    y_orientation = '1 0 0'
  []
  [density_am_links_g12]
    type = GenericConstantMaterial
    block = 'mpc_beam_links_g12'
    prop_names = 'density'
    prop_values = '1.0762e-09'
  []
[]

[Executioner]
  type = Transient
  # NEWTON: 残差~1e-6 N 触底即收 (rel 1e-3); 个别步不收时接受当前解
  # (LINEAR 对本模型积分不稳定 — 某 kernel Jacobian 非精确, 勿用)
  solve_type = NEWTON
  dt = 0.01
  end_time = 65
  [TimeIntegrator]
    type = NewmarkBeta
    beta = 0.25
    gamma = 0.5
  []
  petsc_options_iname = '-pc_type -ksp_type -snes_linesearch_type'
    petsc_options_value = 'lu      preonly   basic'
  nl_rel_tol = 1e-3
  nl_abs_tol = 1e-4
  l_tol = 1e-8
  nl_max_its = 8
  abort_on_solve_fail = false
  dtmin = 1e-6
[]

[Postprocessors]
  [top_disp_x]
    type = PointValue
    variable = disp_x
    point = '0 0 17360'
  []
[]

[Outputs]
  file_base = pr_rg_400gal_x_out
  exodus = true
  csv = true
  print_linear_residuals = false
[]
