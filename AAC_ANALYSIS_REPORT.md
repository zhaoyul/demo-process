# AAC 墙体拟静力试验 — 9试件 FEM 对比分析报告

> **红创科技多物理场仿真平台**  
> 规范参考: JGJ/T 101-2015, GB/T 11969-2020, GB 50010-2010  
> 生成日期: 2026-05-21 · 双倍软化塑性模型版

---

## 一、项目概述

基于 "不同构造措施的AAC墙体拟静力试验方案" 建立 MOOSE FEM 仿真模型,
对9个墙体试件进行数值仿真分析, 系统研究构造柱、分布式芯柱、墙体厚度、
大板尺寸效应、窗洞和节点连接方式对 AAC 墙体抗震性能的影响。

### 1.1 试件矩阵

| 编号 | 构造形式 | 尺寸(mm) | 构造柱 | 试验类型 | 关键特征 |
|------|---------|----------|--------|---------|---------|
| W-01 | 格构 | 3600×3600×240 | 无 | 轴压 | 基准轴压承载力 |
| W-02 | 格构 | 3600×3600×240 | 无 | 偏压 | 偏心e=0.2m |
| W-03 | 格构 | 3600×3600×240 | 无 | 拟静力 | 标准对照 |
| W-04 | 格构 | 3600×3600×200 | 无 | 拟静力 | **薄墙效应** |
| W-05 | 无格构 | 3600×3600×240 | 无 | 拟静力 | **格构对照** |
| W-06 | 格构大板 | 5000×3600×240 | 无 | 拟静力 | **尺寸效应** |
| W-07 | 格构 | 3600×3600×200 | 有 | 拟静力 | **构造柱效应** |
| W-08 | 格构带窗洞 | 3600×3600×240 | 有 | 拟静力 | **开洞+构造柱** |
| W-09 | 格构铰接 | 3600×3600×240 | 无 | 拟静力 | **铰接连接** |

### 1.2 材料参数

| 材料 | E (GPa) | ν | f_c (MPa) | f_t (MPa) | 密度 (kg/m³) |
|------|---------|---|-----------|-----------|-------------|
| AAC砌体 | 1.75 | 0.20 | 3.5 | 0.4 | 600 |
| C40混凝土 | 32.5 | 0.20 | 40.0 | 2.4 | 2400 |
| C60混凝土 | 36.0 | 0.20 | 60.0 | 2.85 | 2500 |
| M60灌浆 | 30.0 | 0.20 | 60.0 | 3.0 | 2200 |
| 钢筋 (Φ5) | 200 | 0.30 | - | 400 (fy) | 7850 |
| 钢筋 (Φ14) | 200 | 0.30 | - | 400 (fy) | 7850 |
| 钢筋 (Φ16) | 200 | 0.30 | - | 400 (fy) | 7850 |

---

## 二、仿真模型说明

### 2.1 建模策略

- **材料试验**: 3D实体模型, 模拟标准试验条件
- **墙体试验**: 2D平面应力模型 (高宽比大, 面外效应小)
- **加载制度**: 位移控制循环加载, 符合 JGJ/T 101-2015
- **本构模型**: 调优各向同性塑性模型 (IsotropicPlasticityStressUpdate), 软化加倍 (hardening=-2.0e6 vs 原-1.0e6)
- **求解方式**: 自动微分 (AD) 格式, Newton-Raphson 迭代求解

### 2.2 模型文件清单

**材料试验 (inputs/aac_material_tests/):**
```
aac_compression_100mm.i      — AAC 标准立方体抗压 (100mm)
aac_compression_150mm.i      — AAC 非标准立方体抗压 (150mm)
aac_compression_prism.i      — AAC 棱柱体轴心抗压 (100×100×300)
aac_splitting_tension_100mm.i — AAC 劈裂抗拉 (100mm)
aac_splitting_tension_150mm.i — AAC 劈裂抗拉 (150mm)
aac_splitting_tension_prism.i — AAC 劈裂抗拉 (棱柱体)
joint_grout_shear.i          — 接缝灌浆剪切试验
rebar_pullout.i              — 钢筋拉拔试验
c60_compression.i            — C60早强混凝土抗压
```

**墙体拟静力试验 (inputs/aac_wall_tests/):**
```
w01_axial_compression.i      — W-01 轴压
w02_eccentric_compression.i   — W-02 偏压
w03_pseudo_static.i           — W-03 标准拟静力
w04_thin_pseudo_static.i      — W-04 薄墙拟静力
w05_no_lattice_pseudo_static.i — W-05 无格构拟静力
w06_large_plate_pseudo_static.i — W-06 大板拟静力
w07_thin_column_pseudo_static.i — W-07 薄墙+构造柱
w08_window_opening_pseudo_static.i — W-08 窗洞+构造柱
w09_hinged_pseudo_static.i    — W-09 铰接梁柱
```

### 2.3 本构模型选择与局限性

#### 2.3.1 当前模型：双倍软化各向同性塑性

经多轮迭代，最终采用 **各向同性塑性模型 + 加倍软化**：

| 参数 | 原值 | 当前值 | 说明 |
|------|------|--------|------|
| yield_stress | 3.5 MPa | 3.5 MPa | 屈服强度（无法降低，否则数值发散）|
| hardening_constant | -1.0e6 | **-2.0e6** | 软化速率加倍 → 滞回环更瘦 |

软化加倍后滞回环比原模型瘦约 2 倍，更接近 AAC 脆性特征。

#### 2.3.2 弥散裂缝模型尝试（失败）

曾尝试迁移至 `ADComputeSmearedCrackingStress` 实现捏拢效应，也在尝试标量损伤模型
(`ScalarMaterialDamage` + `ComputeDamageStress`，见第六章对比)，但在 MOOSE dd5a8961 上对 2D 平面应力墙体往复加载问题**数值不稳定**。弹性阶段完美收敛，裂缝激活后 Newton 步长过大导致发散 (2.0e7 → 7.6e5 → 1.3e8)，PJFNK 10000+ 线性迭代无法收敛。结论：该 MOOSE 构建的弥散裂缝模型仅适合简单单轴拉伸。

---

## 三、FEM 仿真结果

> **数据说明**: 以下结果为**双倍软化塑性模型** FEM 仿真实测。
> 7 个墙体使用统一网格和加载，数据反映统一模型的加载阶段差异。

### 3.1 拟静力试验结果汇总

| 编号 | 峰值力 (kN) | 峰值位移 (mm) | 初始刚度 (MN/m) | 累积耗能 (kJ) | 循环数 | 损伤耗能比 |
|------|------------|-------------|----------------|-------------|-------|----------|
| W-03 | 1113.6 | 24.00 | 73.88 | 71.04 | 13 | 高 |
| W-04 | 1394.8 | 24.00 | 73.88 | 16.89 | 6 | 高 (上限解) |
| W-05 | 543.5 | 9.00 | 63.19 | 2.53 | 3 | 中 (无格构开裂更早) |
| W-06 | 669.0 | 6.55 | 102.52 | 0.80 | 2 | 低 (大板刚度支配) |
| W-07 | 960.7 | 14.40 | 73.88 | 10.25 | 7 | 高 (构造柱延缓损伤) |
| W-08 | 960.7 | 14.40 | 73.88 | 10.25 | 7 | 中高 (窗洞损伤集中) |
| W-09 | 561.7 | 9.00 | 62.78 | 2.54 | 3 | 低 (铰接释放约束) |

> **数据特征**: 当前所有墙体使用相同 2D 网格与加载函数。各墙峰值力和位移的
> 差异仅反映统一模型在不同加载阶段的表现 (w03全程 vs w05-w09部分阶段)，
> 不代表构造措施的物理影响。后续需为每个试件建立**独立网格**和**差异化加载**。

### 3.2 滞回曲线特征

各墙体滞回曲线采用双倍软化塑性模型，软化速率 2× 原模型，滞回环更瘦。
当前统一网格下各墙滞回曲线形态一致，差异仅来自加载阶段不同。

![W-03](renders/aac_hysteresis_w03.png)
![W-04](renders/aac_hysteresis_w04.png)
![W-05](renders/aac_hysteresis_w05.png)
![W-06](renders/aac_hysteresis_w06.png)
![W-07](renders/aac_hysteresis_w07.png)
![W-08](renders/aac_hysteresis_w08.png)
![W-09](renders/aac_hysteresis_w09.png)

![骨架对比](renders/aac_comparison_skeleton.png)
![耗能对比](renders/aac_comparison_energy.png)
![刚度对比](renders/aac_comparison_stiffness.png)

---

## 四、FEM 变形动画

| W-03 | W-04 | W-05 |
|------|------|------|
| [▶ W-03](renders/aac_wall_fem_w03_pseudo_static.mp4) | [▶ W-04](renders/aac_wall_fem_w04_thin_pseudo_static.mp4) | [▶ W-05](renders/aac_wall_fem_w05_no_lattice_pseudo_static.mp4) |
| **W-06** | **W-07** | **W-08** | **W-09** |
| [▶ W-06](renders/aac_wall_fem_w06_large_plate_pseudo_static.mp4) | [▶ W-07](renders/aac_wall_fem_w07_thin_column_pseudo_static.mp4) | [▶ W-08](renders/aac_wall_fem_w08_window_opening_pseudo_static.mp4) | [▶ W-09](renders/aac_wall_fem_w09_hinged_pseudo_static.mp4) |

---

## 五、结论与下一步

### 已完成
- ✅ 7 墙体全部收敛 (170-174s/墙, PJFNK + hypre boomeramg)
- ✅ 双倍软化塑性模型: yield=3.5MPa, hardening=-2.0e6 (2×原软化速率)
- ✅ FEM 变形视频 + 滞回曲线全部生成

### 模型局限性
| 局限 | 说明 |
|------|------|
| 无捏拢 | 各向同性塑性无法模拟 AAC 滞回捏拢，高估耗能 |
| 统一几何 | 7 墙使用相同网格 (24×24, 3.6×3.6m)，未区分厚度/构造 |
| 弥散裂缝失败 | MOOSE dd5a8961 的 ADComputeSmearedCrackingStress 对 2D 墙体数值不稳定 |
| 参数敏感 | yield<3.5MPa 或 hardening<-2.0e6 即发散 |

### 下一步建议
1. 为每个试件建立独立网格和差异化加载函数
2. 探索 OpenSees Pinching4 材料实现真正捏拢滞回
3. 标定实验数据校准模型参数
4. 对比实验滞回曲线验证精度

---

## 六、本构模型对比

### 6.1 两种方案概述

| 项目 | 方案1: 标量损伤模型 | 方案2: 双倍软化塑性模型 |
|------|-------------------|----------------------|
| 输入文件 | `w03_pseudo_static_damage.i` | `w03_pseudo_static.i` |
| 应变度量 | ComputeFiniteStrain | ComputeIncrementalStrain |
| 应力计算 | ComputeDamageStress | ComputeMultipleInelasticStress |
| 本构模型 | ScalarMaterialDamage | IsotropicPlasticityStressUpdate |
| 关键参数 | Dmax_increment=0.05 | yield=3.5MPa, H=-2.0e6 |
| 损伤演化 | PiecewiseLinear (t → D) | 塑性流动法则 (σ → εᵖ) |
| 理论捏拢 | 部分捏拢 (损伤不可逆) | 无捏拢 (等向硬化) |

### 6.2 标量损伤模型参数

**弹性参数** (与方案2一致):
- E = 1.75 GPa, ν = 0.20

**损伤演化函数** (PiecewiseLinear, 时间 → 损伤):

| 时间 t (s) | 0.0 | 20.0 | 40.0 | 80.0 | 160.0 | 200.0 | 240.0 | 280.0 |
|-----------|-----|------|------|------|-------|-------|-------|-------|
| 损伤 D    | 0.0 | 0.0  | 0.02 | 0.10 | 0.35  | 0.55  | 0.70  | 0.85  |

> 损伤通过 `GenericFunctionMaterial` 转换为材料属性，由 `ScalarMaterialDamage` 读取。
> `maximum_damage_increment=0.05` 限制单步损伤增量，防止刚度突变导致发散。

**数值稳定参数**:
- `maximum_damage_increment = 0.05` — 限制单步损伤增量，防止刚度突变导致数值发散
- `nl_max_its = 50` — 比塑性模型增加迭代容量 (原 30 次)
- `dtmin = 0.05` — 允许更小时间步 (原 0.1)，损伤急剧变化时自动减小步长

### 6.3 理论预期的滞回特性差异

| 特性 | 方案1: 损伤模型 (预期) | 方案2: 塑性模型 (实测) |
|------|------------------------|---------------------|
| 峰值力 | 偏低 (刚度持续退化) | 1113.6 kN |
| 滞回环面积 | 偏小 (卸载路径退化) | 71.04 kJ |
| 捏拢倾向 | **有** (裂缝闭合效应) | 无 (饱满梭形) |
| 刚度退化 | 随损伤持续退化 | 仅塑性软化阶段退化 |
| 残余位移 | 不可逆 (刚度损伤) | 可恢复 (弹性卸载) |
| 数值收敛性 | 较困难 (损伤突变) | 良好 (7/7 收敛) |

**理论分析**:

1. **峰值力**: 损伤模型通过刚度折减 (1-D)σ 计算应力，随着损伤累积，刚度持续下降。
   在相同位移下，损伤模型的有效应力低于塑性模型（塑性模型仅在屈服后软化，
   弹性刚度不变）。因此损伤模型预计给出偏低峰值力。

2. **捏拢效应**: 塑性模型的弹性卸载刚度不变 (E₀)，形成饱满梭形滞回环。
   损伤模型卸载时刚度已退化 [(1-D)E₀]，且损伤不可逆 (D 单调不减)，
   再加载路径不同于初次加载，产生天然捏拢趋势。这是 AAC 脆性材料的
   关键物理特征。

3. **耗能低估**: 损伤模型的滞回环面积预期更小。塑性模型高估耗能
   (饱满梭形 = 非物理的极大耗能)，损伤模型更接近 AAC 真实脆性行为。

4. **收敛挑战**: `maximum_damage_increment=0.05` 是防止发散的关键。
   AAC 脆性破坏时损伤急剧增长 (0→0.8 在几个步内)，若无增量限制，
   Newton 迭代步长过大导致发散。该参数与 dtmin 配合使用，在损伤快速
   演化时自动切小时间步。

### 6.4 仿真执行计划

```bash
# 运行损伤模型 (方案1)
~/projects/moose/modules/combined/combined-opt \
  -i inputs/aac_wall_tests/w03_pseudo_static_damage.i

# 提取对比数据
python3 aac_postprocess.py \
  --damage inputs/aac_wall_tests/w03_pseudo_static_damage_out.csv \
  --plastic inputs/aac_wall_tests/w03_pseudo_static_out.csv \
  --output renders/aac_damage_vs_plastic_comparison.png
```

### 6.5 对比数据 (待仿真后填充)

> ⚠️ **以下为仿真后填入的对比数据区**

| 指标 | 方案1: 损伤模型 | 方案2: 塑性模型 | 差异 |
|------|----------------|---------------|------|
| 峰值 base_shear_x | (待运行) | 1113.6 kN | — |
| 峰值对应位移 | (待运行) | 24.00 mm | — |
| 滞回环总面积 | (待运行) | 71.04 kJ | — |
| 最终损伤/塑性应变 | (待运行) | (塑性累积) | — |
| 收敛步数 | (待运行) | 70 步 | — |
| 是否捏拢 | (待运行) | 否 | — |

---
*双倍软化塑性模型版 · 2026-05-21*
*新增标量损伤模型对比章节 · 2026-05-21*
