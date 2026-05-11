# 红创科技多物理场仿真平台 — 六个现场 Demo 试验设计与结果对照

> 面向现场评标专家（仿真/计算方向）  
> 组织方式: **场景设计 → 试验设计 → 输入/输出 → 预期/实际对照**

---

## 一、六个演示视频与算例映射

| 视频文件 | 演示主题 | 核心输入 | 核心输出 | 说明 |
|----------|----------|----------|----------|------|
| `renders/beam_loading.mp4` | 悬臂梁渐变加载 | `inputs/cantilever_beam.geo` + `inputs/cantilever_beam_transient.i` | `outputs/cantilever_beam_transient.e/.csv` | 真实 FEM 网格上的线弹性加载过程 |
| `renders/contact.mp4` | 两体接触演化 | `inputs/contact_2d.i` | `outputs/contact_2d.e/.csv` | 非线性接触与摩擦求解 |
| `renders/electrostatic.mp4` | 双材料静电场 | `inputs/electrostatic_steel_concrete.i` | `outputs/electrostatic_steel_concrete.e/.csv` | 导体-介质电位分布 |
| `renders/multiphysics_coupling.mp4` | 热-力-损伤三场耦合 | `inputs/cantilever_multiphysics.i` | `outputs/cantilever_multiphysics.e/.csv` | 单求解器内直接耦合 |
| `renders/acoustic.mp4` | 空腔 Helmholtz 谐响应 | `inputs/acoustic_cavity.i` | `outputs/acoustic_cavity.e/.csv` | 频域声学复压力场 |
| `renders/fatigue.mp4` | 疲劳后处理 | `outputs/cantilever_beam_transient.e` + `fatigue_analysis.py` + `render_af.py` | `renders/fatigue.mp4` | 基于 FEM 场的 S-N / Miner 流程演示 |

---

## Demo 1: `beam_loading.mp4` — 悬臂梁线弹性渐变加载

### 1.1 场景设计

该 demo 对应一个标准悬臂梁基准问题: 一端固支，顶面均布压力从 0 线性增加到 10 kPa。  
目标不是做复杂工程细节，而是用**可解释的力学基准问题**验证:

1. 网格、边界条件和材料定义是否正确；
2. 渐变载荷下位移响应是否线性；
3. 视频动画的形变过程是否与求解结果逐步对应。

### 1.2 试验设计

| 项目 | 配置 |
|------|------|
| 几何 | 梁长 `1.0 m`，宽 `0.1 m`，高 `0.2 m` |
| 网格 | `outputs/cantilever_beam.msh`，350 节点 / 985 四面体单元 |
| 材料 | 结构钢，`E = 2.0e11 Pa`，`ν = 0.30` |
| 约束 | `fixed_end` 上 `disp_x = disp_y = disp_z = 0` |
| 载荷 | `load_surface` 上 `FunctionNeumannBC`，`q(t) = -1.0e4 * t` |
| 求解 | `Transient + PJFNK`，`dt = 0.1`，`num_steps = 10` |
| 观测量 | `tip_disp_z`，`load_magnitude` |

### 1.3 输入与输出

- **输入**:
  - `inputs/cantilever_beam.geo`
  - `inputs/cantilever_beam_transient.i`
- **输出**:
  - `outputs/cantilever_beam_transient.e`
  - `outputs/cantilever_beam_transient.csv`
  - `renders/beam_loading.mp4`

### 1.4 预期与实际对照

| 对比项 | 预期 | 实际 | 结论 |
|--------|------|------|------|
| 载荷-位移关系 | 在线弹性小变形假设下应近似线性 | `load_magnitude` 从 `0` 到 `-10000 Pa`，`tip_disp_z` 从 `0` 线性变化到 `-8.4442237891492e-06 m` | 与线弹性预期一致 |
| 终值与静力结果一致性 | 瞬态末步应回到同一载荷下的静力解 | 瞬态末步 `-8.4442237891492e-06 m`，与粗网格静力结果 `-8.4442237892724e-06 m` 一致 | 视频驱动结果与静力求解一致 |
| 动画物理含义 | 变形应逐步放大但不改变符号 | 视频中梁端持续向 `-z` 下挠，无反向振荡 | 适合现场解释“加载—响应”链路 |

### 1.5 专家说明

该算例是**可校核的结构基准问题**。对于评标专家，关键不在于场景复杂度，而在于:

- 输入文件参数可追溯；
- 数值响应与理论线弹性规律一致；
- 视频展示不是“伪动画”，而是由 `cantilever_beam_transient.e` 逐时刻结果驱动。

---

## Demo 2: `contact.mp4` — 两体接触力学演化

### 2.1 场景设计

该 demo 采用二维双块体压缩问题，目标是验证:

1. 接触对生成与界面分离/闭合机制；
2. Coulomb 摩擦模型下的非线性求解稳定性；
3. 接触反力随压入位移的单调演化。

这类问题更接近**算法能力验证**而非工程尺寸标定，因此参数采用基准化设置。

### 2.2 试验设计

| 项目 | 配置 |
|------|------|
| 模型 | 两个矩形块体并排放置，左块 `block=1`，右块 `block=2` |
| 网格 | `GeneratedMeshGenerator`，`10 × 10` 二维网格 |
| 接触处理 | `BreakMeshByBlockGenerator` + `Contact` 模块 |
| 材料 | `E = 100.0`，`ν = 0.30`（基准化弹性参数） |
| 接触模型 | `model = coulomb`，`friction_coefficient = 0.3` |
| 驱动边界 | 右边界位移函数 `disp_x = -0.05 * t` |
| 求解 | `Transient + PJFNK`，`num_steps = 10`，`dt = 0.5` |
| 观测量 | `right_disp`，`contact_force_x` |

### 2.3 输入与输出

- **输入**: `inputs/contact_2d.i`
- **输出**:
  - `outputs/contact_2d.e`
  - `outputs/contact_2d.csv`
  - `renders/contact.mp4`

### 2.4 预期与实际对照

| 对比项 | 预期 | 实际 | 结论 |
|--------|------|------|------|
| 接触反力演化 | 压入加深时接触反力绝对值应单调增加 | `contact_force_x` 从 `0` 单调变化到 `-0.95390625000128` | 与接触闭合预期一致 |
| 压入位移演化 | `right_disp` 应随时间持续增大（负向压入） | `right_disp` 从 `0` 到 `-0.1734375`，共 10 个步进结果 | 边界驱动正确传递 |
| 求解稳定性 | 非线性接触不应出现明显数值振荡 | CSV 中位移与反力均单调，无跳变反号 | 适合演示接触求解稳定性 |

### 2.5 专家说明

该问题的重点不是“力值大小是否对应某一具体设备”，而是:

- 接触面对、摩擦模型和罚函数参数是否能稳定收敛；
- 反力是否与压入过程保持一致的演化逻辑；
- 视频中的接触变形是否由 `contact_2d.e` 的逐步结果驱动。

---

## Demo 3: `electrostatic.mp4` — 双材料低频静电分析

### 3.1 场景设计

该 demo 抽象了钢筋-混凝土双材料界面问题。左侧为高导电钢筋，右侧为低导电混凝土。  
目标是验证**材料属性跳跃**与**界面电位连续性**的处理能力。

### 3.2 试验设计

| 项目 | 配置 |
|------|------|
| 几何 | 二维矩形区域，`x ∈ [-0.1, 0.1] m`，`y ∈ [0, 0.05] m` |
| 网格 | `40 × 10`，总计约 800 单元 |
| 子域 | 左侧 `steel`，右侧 `concrete` |
| 控制方程 | `MatDiffusion` 形式的稳态电位扩散 |
| 电导率 | 钢 `1.0e7 S/m`，混凝土 `1.0e-2 S/m` |
| 边界条件 | 左边界 `1 V`，右边界 `0 V` |
| 求解 | `Steady + PJFNK` |
| 观测量 | `potential_center_steel`，`potential_interface` |

### 3.3 输入与输出

- **输入**: `inputs/electrostatic_steel_concrete.i`
- **输出**:
  - `outputs/electrostatic_steel_concrete.e`
  - `outputs/electrostatic_steel_concrete.csv`
  - `renders/electrostatic.mp4`

### 3.4 预期与实际对照

| 对比项 | 预期 | 实际 | 结论 |
|--------|------|------|------|
| 钢区电位 | 由于电导率远高于混凝土，应近似等电位 | `potential_center_steel = 0.99999999949914 V` | 钢区压降可忽略 |
| 界面电位 | 界面应接近钢侧电位，绝大部分电位降落在混凝土内 | `potential_interface = 0.99999999900066 V` | 与高导电比预期一致 |
| 电位分布 | 1 V → 0 V 的主降落应在低导电材料中完成 | 视频中高电位区域主要停留在钢侧 | 适合说明多材料电位场分配 |

### 3.5 专家说明

该 demo 的核心价值在于:

- 验证**材料分区 + 界面连续性**建模路径；
- 说明平台可以处理多材料系数跨越多个数量级的问题；
- 结果不是“彩色示意图”，而是来自 `electrostatic_steel_concrete.e` 的稳态解。

---

## Demo 4: `multiphysics_coupling.mp4` — 热-力-损伤三场直接耦合

### 4.1 场景设计

该 demo 面向评标专家展示**单求解器内多场共存与数据传递**能力。  
输入文件同时定义:

1. 温度场 `temp`
2. 位移场 `disp_x/disp_y/disp_z`
3. 损伤变量 `d`

重点验证“热 → 膨胀 → 位移”和“损伤变量并行求解”的链路是否打通。

### 4.2 试验设计

| 项目 | 配置 |
|------|------|
| 网格 | `outputs/cantilever_beam.msh` |
| 主变量 | `disp_x`，`disp_y`，`disp_z`，`temp`，`d` |
| 热边界 | `load_surface = 100°C`，`fixed_end = 0°C` |
| 力学耦合 | `ComputeThermalExpansionEigenstrain` |
| 损伤演化 | `MatDiffusion + BodyForce`（演示型相场损伤变量） |
| 求解 | `Steady + PJFNK` |
| 观测量 | `temp_mid`，`tip_disp_z`，`damage_max` |

### 4.3 输入与输出

- **输入**: `inputs/cantilever_multiphysics.i`
- **输出**:
  - `outputs/cantilever_multiphysics.e`
  - `outputs/cantilever_multiphysics.csv`
  - `renders/multiphysics_coupling.mp4`

### 4.4 预期与实际对照

| 对比项 | 预期 | 实际 | 结论 |
|--------|------|------|------|
| 温度场 | 梁内形成由冷端到热端的温度梯度 | `temp_mid = 98.291798263979 °C` | 温度变量已成功求解并输出 |
| 热致变形 | 热膨胀应引起可观位移响应 | `tip_disp_z = -0.00056280736112305 m`（约 `-0.5628 mm`） | 热-力耦合链路已打通 |
| 损伤变量有界性 | `d` 应保持在 0~1 的演示区间内 | `damage_max = 0.49994462725162` | 损伤变量稳定输出 |

### 4.5 专家说明

该 demo 的定位是**耦合框架验证**，不是工程断裂标定报告。对行业专家可重点说明:

- 五个主变量在同一输入文件中统一装配；
- 热膨胀通过本征应变进入力学方程；
- 损伤变量 `d` 已参与同一求解流程并可单独输出、可视化；
- 视频可用于直观展示三场轮播，但底层结果仍对应 `cantilever_multiphysics.e/.csv`。

---

## Demo 5: `acoustic.mp4` — 空腔 Helmholtz 谐响应

### 5.1 场景设计

该 demo 使用二维矩形空腔，左壁施加 1 Pa 简谐激励，频率 1000 Hz。  
目标是验证平台是否具备**频域声学复变量求解**能力。

### 5.2 试验设计

| 项目 | 配置 |
|------|------|
| 几何 | 矩形空腔，`0.5 m × 0.25 m` |
| 网格 | `40 × 20` 二维网格 |
| 变量 | `pressure_real`，`pressure_imag` |
| 频率 | `f = 1000 Hz` |
| 波数 | `k = 18.3 rad/m` |
| 边界 | 左壁 `p = 1 + 0j Pa`，其余三壁零通量 |
| 求解 | `Steady + PJFNK + LU/MUMPS` |
| 观测量 | `p_real_center`，`p_imag_center` |

### 5.3 输入与输出

- **输入**: `inputs/acoustic_cavity.i`
- **输出**:
  - `outputs/acoustic_cavity.e`
  - `outputs/acoustic_cavity.csv`
  - `renders/acoustic.mp4`

### 5.4 预期与实际对照

| 对比项 | 预期 | 实际 | 结论 |
|--------|------|------|------|
| 中心点复压力 | 中心点应呈现非零实部和虚部，反映幅值与相位 | `p_real_center = 0.29139840265636 Pa`，`p_imag_center = -0.4200703197082 Pa` | 复变量耦合成功 |
| 压力幅值 | 空腔内部响应幅值应小于 1 Pa 边界激励 | `|p| = 0.5112456381920804 Pa` | 量级合理 |
| 结果展示 | 视频应能展示声压场空间分布而非单点数字 | `acoustic.mp4` 对应 `acoustic_cavity.e` 的压力场可视化 | 适合现场说明频域声学能力 |

### 5.5 专家说明

该问题证明平台并不局限于结构力学，而是可以通过**实部/虚部分裂变量**处理频域 Helmholtz 问题。  
对评标专家而言，关键在于:

- 方程形式清晰；
- 复压力可落到可视化结果；
- 单点响应可从 CSV 文件直接核验。

---

## Demo 6: `fatigue.mp4` — 基于 FEM 场的疲劳后处理演示

### 6.1 场景设计

该 demo 对应**后处理能力验证**，不是完整疲劳试验数据库标定。  
其目的在于展示:

1. 能否从 FEM 输出场中提取用于疲劳评估的响应量；
2. 能否串联雨流计数、S-N 曲线和 Miner 累积损伤；
3. 能否将疲劳热点/寿命结果组织成现场可讲解的视频。

### 6.2 试验设计

| 项目 | 配置 |
|------|------|
| 上游输入 | `outputs/cantilever_beam_transient.e`（悬臂梁渐变加载结果） |
| 计算脚本 | `fatigue_analysis.py` |
| 视频脚本 | `render_af.py` |
| 疲劳模型 | `S-N: N_f = 1e12 / (Δσ)^3` + Miner 线性累积 |
| 视频变量 | `fatigue_damage = |field| / max(|field|)` 的归一化损伤展示 |
| 演示目标 | 从 FEM 结果生成损伤场、寿命场和热点展示 |

### 6.3 输入与输出

- **输入**:
  - `outputs/cantilever_beam_transient.e`
  - `fatigue_analysis.py`
  - `render_af.py`
- **输出**:
  - `renders/fatigue.mp4`

### 6.4 预期与实际对照

| 对比项 | 预期 | 实际 | 结论 |
|--------|------|------|------|
| 后处理链路 | 应能把 FEM 场映射为疲劳损伤/寿命指标 | `fatigue_analysis.py` 明确包含“应力读取 → 雨流计数 → Miner 损伤 → 寿命”流程 | 后处理链路完整 |
| 视频表现 | 损伤应随演示进度单调增长，便于现场说明 | `render_af.py` 中 `D_max` 随帧从 `0` 递增到 `1.0`，并展示 `N_f = 1e12/(Δσ)^3` | 适合做专家讲解演示 |
| 工程解释边界 | 不应将该 demo 误解为已完成材料疲劳标定 | 当前视频使用归一化损伤/寿命展示，主要说明方法链路而非交付设计寿命值 | 需明确定位为“流程验证” |

### 6.5 专家说明

对现场专家，建议把该 demo 解释为**疲劳分析后处理能力证明**:

- 上游可以接结构求解器输出的 `.e` 文件；
- 中游可接入雨流计数和 Miner 损伤模型；
- 下游可形成可视化视频和寿命热点说明；
- 若进入工程交付阶段，还需结合真实载荷谱、材料 S-N 曲线和试验标定参数。

---

## 七、建议的现场讲解顺序

1. **先讲线弹性基准 (`beam_loading.mp4`)**: 说明平台结果可校核、非“黑盒动画”；
2. **再讲接触 / 电磁 / 声学**: 体现多物理模块覆盖面；
3. **之后讲三场耦合**: 体现框架扩展性与统一求解能力；
4. **最后讲疲劳后处理**: 体现结果可进一步进入工程判据与寿命评估流程。

这样更符合评标专家的审阅逻辑: **先验证可信度，再展示广度，最后展示可扩展的工程后处理能力。**
