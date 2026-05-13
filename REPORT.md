# 红创科技多物理场仿真平台 — 过程验证报告

> **日期**: 2026-05-13  
> **算例**: 悬臂梁静力学分析 (含5条评论修改汇总)  
> **求解器**: MOOSE Solid Mechanics (`hongchuang-opt`, 红创品牌)  
> **网格**: Gmsh 4.15.2 → tetrahedral mesh  
> **验证**: 对分析解 (均布载荷下 Euler-Bernoulli 悬臂梁)

## 一、系统环境

| 组件 | 版本 | 来源 |
|------|------|------|
| 操作系统 | Arch Linux | - |
| Python | 3.14.4 | pacman |
| Gmsh | 4.15.2 | conda-forge |
| MOOSE Framework | dd5a8961 | GitHub |
| libMesh | 2026.04.13 | INL conda |
| PETSc | 3.24.6 | INL conda |
| ParaView | 6.1.0 | conda-forge |
| MPI | MPICH 5.0.3 | conda-forge |

## 二、几何与物理模型

```
悬臂梁: 长 L=1.0m, 宽 W=0.1m, 高 H=0.2m
材料: 结构钢, E = 200 GPa, ν = 0.30
边界: x=0 固支 (u=0), z=H 顶面均布压力 P = 10 kPa
单元: 四节点四面体 (TET4), 线弹性小变形
```

### 理论解 (Euler-Bernoulli 梁, 均布载荷)

均布载荷 w = P × W = 10,000 × 0.1 = 1,000 N/m

```
I = bh³/12 = 0.1 × 0.2³ / 12 = 6.667 × 10⁻⁵ m⁴
δ_max = wL⁴ / (8EI) = 1000 × 1⁴ / (8 × 2 × 10¹¹ × 6.667 × 10⁻⁵)
     = 9.375 × 10⁻⁶ m
```

## 三、现场 Demo 输入说明

本次现场演示对应 `./demo.sh` 的三阶段流程: **前处理 → 求解 → 后处理**。为便于和录像逐段对照, 输入项按“文件/命令/作用”列出如下。

### 3.1 输入文件与脚本清单

| 类别 | 路径 | 现场画面/动作 | 关键内容 | 作用 |
|------|------|--------------|----------|------|
| 演示脚本 | `demo.sh` | 主持人执行 `./demo.sh` | 分阶段暂停、标题横幅、总结信息 | 串联整场 demo 节奏 |
| 调度入口 | `hongchuang_cli.py` | 脚本内部调用 `mesh/solve/post` | 统一封装前处理、求解、后处理 | 保持演示命令一致 |
| 几何输入 | `inputs/cantilever_beam.geo` | “第一步：前处理” | 8 个顶点、12 条边、1 个体；`fixed_end`/`load_surface` 物理分组 | 定义悬臂梁几何与边界命名 |
| 求解输入 | `inputs/cantilever_beam.i` | “第二步：求解器” | `FileMesh` 读取 `outputs/cantilever_beam.msh`；3 个位移变量；顶面压力 `-1.0e4` Pa；钢材 `E=2.0e11`, `ν=0.30` | 定义有限元方程、材料和输出 |
| 可视化状态 | `states/cantilever_beam_state.pvsm` | “第三步：后处理” | 读取 Exodus 结果；Warp By Vector；Von Mises 着色 | 保证视频中的显示效果可复现 |

### 3.2 输入参数摘要

| 输入项 | 数值/配置 | 说明 |
|------|-----------|------|
| 梁长 `L` | `1.0 m` | 主变形方向 |
| 梁宽 `W` | `0.1 m` | 载荷换算宽度 |
| 梁高 `H` | `0.2 m` | 截面高度 |
| 固支边界 | `fixed_end` | `disp_x = disp_y = disp_z = 0` |
| 载荷边界 | `load_surface` | 顶面均布压力 `-1.0e4 Pa` |
| 材料 | `E = 200 GPa`, `ν = 0.30` | 线弹性钢梁 |
| 求解方式 | `Steady + PJFNK` | 稳态小变形线弹性求解 |
| 结果输出 | `ExodusII + CSV + console` | 同时满足展示和数值核验 |

### 3.3 视频对照建议

| 视频阶段 | 建议重点说明的输入 | 对应信息 |
|----------|--------------------|----------|
| 第一段：前处理 | `cantilever_beam.geo` | 几何尺寸、物理分组、网格来源 |
| 第二段：求解 | `cantilever_beam.i` | 边界条件、材料参数、求解方法 |
| 第三段：后处理 | `cantilever_beam_state.pvsm` | 位移云图、应力云图、变形放大 |

## 四、现场 Demo 输出说明

### 4.1 直接输出物

| 输出项 | 路径 | 生成阶段 | 现场可见结果 | 说明 |
|--------|------|----------|--------------|------|
| 网格文件 | `outputs/cantilever_beam.msh` | 前处理 | 终端显示“网格离散完毕” | Gmsh 生成的 MSH2 网格, 大小约 44 KB |
| 结果文件 | `outputs/cantilever_beam_out.e` | 求解 | 后处理可直接打开 | ExodusII 结果文件, 大小约 103 KB |
| 数值摘要 | `outputs/cantilever_beam_out.csv` | 求解 | 可展示自由端挠度数值 | CSV 仅保留关键后处理量 |
| 精细网格 | `outputs/cantilever_beam_fine.msh` | 对比验证 | 报告展示 | 用于收敛性验证, 大小约 552 KB |
| 精细结果 | `outputs/cantilever_beam_fine.e` | 对比验证 | 报告展示 | 用于证明结果收敛, 大小约 526 KB |
| 精细挠度 | `outputs/cantilever_beam_fine.csv` | 对比验证 | 报告展示 | 对应精细网格的自由端挠度 |

### 4.2 控制台输出与结果含义

| 输出位置 | 典型内容 | 含义 |
|----------|----------|------|
| `demo.sh` 第一阶段 | `第一步：前处理 —— 参数化建模与网格离散化` | 进入几何解析和网格生成阶段 |
| `hongchuang_cli.py mesh` | `输入: inputs/cantilever_beam.geo` / `输出: outputs/cantilever_beam.msh` | 明确前处理输入输出路径 |
| `demo.sh` 第二阶段 | `第二步：求解器 —— 多物理场并行计算` | 进入有限元求解阶段 |
| `hongchuang_cli.py solve` | `计算完成，所有自由度已收敛。` | 说明非线性/线性求解已正常结束 |
| `demo.sh` 第三阶段 | `第三步：后处理 —— 可视化孪生图谱` | 进入结果展示阶段 |
| `hongchuang_cli.py post` | `可视化图谱生成完毕。` | 说明结果文件已可用于演示 |

### 4.3 关键数值输出

`outputs/cantilever_beam_out.csv` 原始内容如下（保留程序默认 `e` 记数法）:

```csv
time,tip_disp_z
0,0
1,-8.4442237892724e-06
```

说明:

- `time=0` 为初始状态, 自由端位移为 0。
- `time=1` 为稳态求解输出时刻, 对外报告可按 4 位有效数字（保留 4 位有效数字）写为 `tip_disp_z ≈ -8.444 × 10⁻⁶ m`；CSV 中仍保留原始值 `-8.4442237892724e-06` 以便追溯。
- 负号表示自由端沿 `-z` 方向下挠, 与顶面向下压力边界条件一致。
- 该值可作为视频口播中的“结果数字”, 与画面中的变形云图相互印证。

### 4.4 后处理画面建议解读

| 画面元素 | 对应输出 | 说明口径 |
|----------|----------|----------|
| 变形后的梁体 | `cantilever_beam_out.e` 位移场 | 说明结构整体向下弯曲 |
| 颜色分布 | Von Mises 应力 | 说明危险区域集中在固支端附近 |
| 放大变形 | `Warp By Vector` | 说明画面为展示效果, 实际位移约为 8 微米量级 |
| 数值对照 | `cantilever_beam_out.csv` | 说明结果可追溯, 不只是“看图” |

## 五、仿真结果

### 场景 1: 粗网格

| 参数 | 值 |
|------|-----|
| 网格尺寸 (lc) | 0.05 m |
| 节点数 | 350 |
| 单元数 | 985 |
| DOF | 1,050 |
| Newton 迭代 | 2 |
| 求解时间 | ~27 s |
| **FEM 挠度** | **-8.444 × 10⁻⁶ m** |
| 误差 vs 理论 | **9.9%** |

### 场景 2: 精细网格

| 参数 | 值 |
|------|-----|
| 网格尺寸 (lc) | 0.02 m |
| 节点数 | 2,998 |
| 单元数 | 12,198 |
| DOF | 8,994 |
| Newton 迭代 | 2 |
| 求解时间 | ~27 s |
| **FEM 挠度** | **-9.365 × 10⁻⁶ m** |
| 误差 vs 理论 | **0.11%** ✅ |

## 六、网格收敛性

| 网格 | 单元数 | δ_FEM (m) | δ_theory (m) | 误差 |
|------|--------|-----------|-------------|------|
| 粗 (lc=0.05) | 985 | -8.444e-06 | -9.375e-06 | 9.9% |
| 细 (lc=0.02) | 12,198 | -9.365e-06 | -9.375e-06 | **0.11%** |

精细网格结果与理论解吻合，验证了 MOOSE 求解器 + Gmsh 网格管线的正确性。

## 七、输出文件

```
outputs/
├── cantilever_beam.msh            44 KB  粗网格 (Gmsh MSH2)
├── cantilever_beam_out.e         103 KB  粗网格结果 (ExodusII)
├── cantilever_beam_out.csv        43 B   粗网格挠度
├── cantilever_beam_fine.msh      552 KB  精细网格
├── cantilever_beam_fine.e        526 KB  精细网格结果 (ExodusII)
└── cantilever_beam_fine.csv       43 B   精细网格挠度
```

ParaView 打开 `cantilever_beam_fine.e` 可查看：
- 位移云图 (disp_x, disp_y, disp_z)
- 变形放大 (50×)
- 应力分布 (von Mises)

## 八、命令行复现

```bash
# 1. 激活环境
conda activate moose

# 2. 现场演示脚本
./demo.sh

# 3. 网格生成
gmsh -3 -format msh2 -order 1 -o outputs/cantilever_beam.msh inputs/cantilever_beam.geo

# 4. 红创求解器
bin/hongchuang-opt -i inputs/cantilever_beam.i

# 5. 可视化
paraview --data=outputs/cantilever_beam_out.e
```

---

# 九、五条评论修改汇总

> **更新时间**: 2026-05-13  
> **范围**: 对 5 条评论/审查意见逐条作出完整修改，涵盖文档、网格、接触、静电、CDP 五方面。

---

## 9.1 第1条：Markdown/CLI 加载路径一致性修正

### 问题
多个 Markdown 文档与 `hongchuang_cli.py` 的加载路径不一致，导致用户按文档操作时找不到文件。

### 修改内容

| 文件 | 修改点 | 说明 |
|------|--------|------|
| `inputs/cantilever_beam.i` | `file_base` 改用 `outputs/` 前缀 | 统一结果文件输出路径 |
| `USER_MANUAL.md` | 修正网格输出命名、ParaView 状态文件路径 | 补充 `all` 子命令说明 |
| `ARCHITECTURE.md` | 并行架构图中 `checkpoints/` 改为 `states/` | 与 CLI 实际目录名一致 |

### Git 提交

| Commit | 时间 | 作者 |
|--------|------|------|
| `5e60d1e` | 2026-05-13 10:35 | nitro |

---

## 9.2 第2条：悬臂梁 Hex8 六面体 + B-bar 剪切自锁 + 端部集中力 P=200N 对标

### 问题
原悬臂梁采用 TET4 四面体单元，存在剪切自锁问题；缺少端部集中力工况与 Timoshenko 理论解对标。

### 修改内容

#### 2a. Hex8 六面体网格 + B-bar 剪切自锁修正 (de-yda)

| 文件 | 修改点 | 说明 |
|------|--------|------|
| `inputs/cantilever_beam.geo` | 添加 `Transfinite Line/Surface/Volume` + `Recombine` | 从四面体切换为结构化六面体网格 |
| `outputs/cantilever_beam.msh` | 重新生成 | Hex8 结构化网格 (20×2×4=160 单元, 315 节点) |
| `inputs/cantilever_beam.i` | `volumetric_locking_correction = true` | 启用 B-bar 剪切/体积自锁修正 |
| `bin/generate_hex_mesh.py` | 新增 | 结构化 Hex8 网格生成脚本 |
| `inputs/HEX_BENCHMARK.md` | 新增 | Timoshenko 剪切修正理论解对标报告 |

**理论基准 (均布载荷):**
```
δ_bend = wL⁴/(8EI) = 9.375e-6 m
δ_shear = wL²/(2κGA) = 3.90e-7 m
δ_total = δ_bend + δ_shear = 9.765e-6 m
```

#### 2b. 端部集中力 P=200N 工况 + 理论对标 (de-8ro)

| 文件 | 修改点 | 说明 |
|------|--------|------|
| `inputs/cantilever_beam_point.i` | 新增 | 端部集中力 P=200N (等效端面剪应力 τ = 10 kPa) |
| `inputs/HEX_BENCHMARK.md` | 扩展 | 添加集中力理论解 (Euler-Bernoulli + Timoshenko) 与 FEM 对标 |
| `bin/generate_hex_mesh.py` | 添加 `free_end` 物理组 | 自由端面用于施加集中力 BC |

**理论基准 (端部集中力 P=200N):**
```
δ_bend = PL³/(3EI) = 5.000e-6 m
δ_shear = PL/(κGA) = 2.600e-7 m
δ_total = δ_bend + δ_shear = 5.260e-6 m
```

### Git 提交

| Commit | 时间 | 作者 |
|--------|------|------|
| `7a1ef4c` | 2026-05-13 11:15 | kevinli |
| `4083068` | 2026-05-13 12:06 | guzzle |

---

## 9.3 第3条：接触力学 5s 真实 FEM Exodus 数据渲染

### 问题
原接触动画使用简化渲染管线，未直接读取 FEM Exodus 输出；模拟时间仅 1s，缺少变形比例标注。

### 修改内容

#### 3a. 真实 FEM Exodus 数据渲染 (de-4xh)

| 文件 | 修改点 | 说明 |
|------|--------|------|
| `render_contact.py` | 完全重写 | 使用 netCDF4 读取 Exodus 输出，提取位移场 + 接触压力 |
| `inputs/contact_blocks.i` | 改为瞬态求解器+渐变载荷 | Pressure BC 替代 NeumannBC，正弦渐变载荷 |
| `inputs/contact_blocks.geo` | 新增 | Gmsh 几何建模：两体分离块 + Coherence 节点一致性 |

**渲染管线特性:**
- 支持瞬态多时间步与稳态伪瞬态两种模式
- 3D 渲染使用 Poly3DCollection，暗色品牌风格
- 动画中实时显示 FEM 数值 (δ_z, P_contact)
- 自动检测零位移并显示警告

#### 3b. 模拟时间扩展至 5s + 变形比例标注 (de-6ga)

| 文件 | 修改点 | 说明 |
|------|--------|------|
| `inputs/contact_blocks.i` | `end_time 1.0→5.0` | ramped_pressure over full 5s |
| `render_contact.py` | 添加变形比例标注 | 动画帧上显示 `Disp. scale: N×` |

**求解参数:** dt=0.1 (50 步), dtmin=0.01 (自适应缩减), ANIM_DURATION=5.0s 与 FEM 计算时间一致。

### Git 提交

| Commit | 时间 | 作者 |
|--------|------|------|
| `48aef29` | 2026-05-13 11:32 | nitro |
| `33156ba` | 2026-05-13 11:55 | nitro |

---

## 9.4 第4条：双材料静电路径电位采样 + COMSOL 对标

### 问题
静电场演示仅有三维云图，缺少定量路径曲线与商业软件对标，无法满足评审专家对精度的要求。

### 修改内容

| 文件 | 修改点 | 说明 |
|------|--------|------|
| `inputs/electrostatic_steel_concrete.i` | 添加 `LineValueSampler` | 两条采样路径：界面路径 (x=0) + Centerline 路径 (y=0.025 贯穿双材料) |
| `outputs/…_line_centerline.csv` | 新增 (82行) | 沿 Centerline 每 1mm 采样电位 φ |
| `outputs/…_line_interface.csv` | 新增 (52行) | 沿钢-混凝土界面采样电位 φ |
| `outputs/reference_comsol_centerline.csv` | 新增 (82行) | COMSOL 对标参考数据 |
| `render_es_path.py` | 新增 (234行) | 电位沿路径变化曲线 + COMSOL 覆盖层 + 数值对标统计 + 60帧动画 |

**对标方式:**
- FEM 结果 vs COMSOL 参考数据叠加在同一曲线上
- 计算 RMS error、max error 等统计量
- 暗色主题，与 `render_es_fem.py` 视觉风格一致

**视频输出:** `renders/electrostatic_path.mp4` (78 KB, 60帧 @10fps)

### Git 提交

| Commit | 时间 | 作者 |
|--------|------|------|
| `20a50d6` | 2026-05-13 11:05 | kevinli |

---

## 9.5 第5条：CDP 混凝土塑性损伤模型完整 MOOSE 集成

### 问题
混凝土损伤模型未与 MOOSE 材料系统集成，缺少 C++ 本构类、FEM 求解与可视化渲染。

### 修改内容

#### 5a. CDP 后处理模块 (de-sxv)

| 文件 | 修改点 | 说明 |
|------|--------|------|
| `cdp_postprocess.py` | 新增 (116行) | 基于主应力的 CDP 损伤演化计算 (受拉/受压/总损伤) |

**材料参数 (C30 混凝土, GB 50010-2010):**
- 单轴抗拉强度 f_t = 2 MPa
- 单轴抗压强度 f_c = 20 MPa
- 损伤变量 d_t, d_c, d_total 基于主应力计算

#### 5b. CDP C++ 材料类 + FEM 求解 + 渲染 (de-dd1)

| 文件 | 修改点 | 说明 |
|------|--------|------|
| `src/materials/ConcreteDamagePlasticityStressUpdate.h` | 新增 (89行) | CDP 材料类声明，继承 `ADComputeStressBase` |
| `src/materials/ConcreteDamagePlasticityStressUpdate.C` | 新增 (168行) | 损伤本构算法实现 |
| `src/CMakeLists_hongchuang.txt` | 修改 | 注册 CDP 材料类到编译系统 |
| `src/HongchuangApp.C` | 修改 | 注册 CDP 材料到 MOOSE Factory |
| `inputs/cantilever_multiphysics_cdp.i` | 新增 (269行) | 热-力-损伤三场耦合输入文件 |
| `outputs/cantilever_multiphysics_cdp.e` | 新增 | ExodusII 结果文件 (~167 KB) |
| `outputs/cantilever_multiphysics_cdp.csv` | 新增 | 损伤数值摘要 |
| `render_cdp.py` | 新增 (274行) | 损伤 contour + 时间演化动画 (暗色主题) |
| `render_multiphysics_cdp.py` | 新增 (149行) | 多物理场三场轮播渲染 |
| `CDP_BENCHMARK.md` | 新增 (226行) | 完整基准验证报告 |
| `CASE_REPRODUCE.md` | 修改 | 添加 Demo 7 (CDP 损伤) 到案例映射 |
| `.gitignore` | 修改 | 添加 `renders/cdp_frames/` |

**核心算法 (ConcreteDamagePlasticityStressUpdate):**
```
弹性预测: σ_trial = C₀ : ε^el
主应力提取: σ₁, σ₂, σ₃ = eigenvalues(σ_trial)
受拉损伤 (σ₁ > f_t):  d_t = 1 - (f_t/σ₁)·exp(α_t·(f_t-σ₁))
受压损伤 (|σ₃| > f_c): d_c = 1 - (f_c/|σ₃|)·exp(α_c·(f_c-|σ₃|))
总损伤: d_total = max(d_t, d_c)
```

**FEM 结果:** damage_t_max=0.988, damage_c_max=0.000, tip_disp_z=-0.52mm

**渲染输出:**
- `renders/cdp_damage.mp4` — 损伤演化动画 (164 KB)
- `renders/cdp_damage_contour.png` — 损伤分布等高线图 (42 KB)

### Git 提交

| Commit | 时间 | 作者 |
|--------|------|------|
| `e0f8e01` | 2026-05-13 13:38 | mayor (Co-Authored-By: Claude Opus) |
| `51f8f81` | 2026-05-13 14:22 | guzzle |

---

# 十、Git 提交记录 (main 分支最新)

截至 2026-05-13 14:22，main 分支 5 条评论修改相关提交：

| # | Commit | 时间 | 作者 | 对应评论 | 描述 |
|---|--------|------|------|----------|------|
| 1 | `5e60d1e` | 10:35 | nitro | 第1条 | docs: 修正文档与CLI加载路径不一致 |
| 2 | `20a50d6` | 11:05 | kevinli | 第4条 | feat: Demo3静电路径电位采样与对标曲线 |
| 3 | `7a1ef4c` | 11:15 | kevinli | 第2条 | feat: Hex8六面体网格 + B-bar剪切自锁修正 |
| 4 | `48aef29` | 11:32 | nitro | 第3条 | feat: 接触力学动画改用真实FEM Exodus数据渲染 |
| 5 | `33156ba` | 11:55 | nitro | 第3条 | fix: extend contact simulation to 5s and add deformation scale annotation |
| 6 | `4083068` | 12:06 | guzzle | 第2条 | feat: 悬臂梁端部集中力P=200N工况 + 理论对标 |
| 7 | `e0f8e01` | 13:38 | mayor | 第5条 | feat: CDP postprocessor for concrete damage calculation |
| 8 | `2b1f804` | 13:27 | nitro | 第3/4条 | feat: regenerate updated video files and clean frame artifacts |
| 9 | `56dada6` | 13:38 | — | 第5条 | Merge CDP postprocessor from de-sxv (chrome) |
| 10 | `51f8f81` | 14:22 | guzzle | 第5条 | feat: complete CDP concrete damage model — C++ class + FEM solve + render + docs |

---

# 十一、新增/修改文件清单

## 11.1 按评论分类

### 第1条：文档路径一致性 (3 files)

| 文件 | 状态 | 类型 |
|------|------|------|
| `ARCHITECTURE.md` | 修改 | 文档 |
| `USER_MANUAL.md` | 修改 | 文档 |
| `inputs/cantilever_beam.i` | 修改 | 输入文件 |

### 第2条：Hex8 + B-bar + 集中力 (6 files)

| 文件 | 状态 | 类型 |
|------|------|------|
| `inputs/cantilever_beam.geo` | 修改 | 几何脚本 |
| `inputs/cantilever_beam.i` | 修改 | 输入文件 |
| `inputs/cantilever_beam_point.i` | 新增 | 输入文件 |
| `outputs/cantilever_beam.msh` | 重新生成 | 网格 |
| `bin/generate_hex_mesh.py` | 新增 | Python 脚本 |
| `inputs/HEX_BENCHMARK.md` | 新增+扩展 | 文档 |

### 第3条：接触力学 5s FEM 渲染 (4 files)

| 文件 | 状态 | 类型 |
|------|------|------|
| `inputs/contact_blocks.geo` | 新增 | 几何脚本 |
| `inputs/contact_blocks.i` | 修改 | 输入文件 |
| `render_contact.py` | 重写 | Python 脚本 |
| `renders/contact.mp4` | 重新生成 | 视频 |

### 第4条：静电路径采样 + COMSOL 对标 (5 files)

| 文件 | 状态 | 类型 |
|------|------|------|
| `inputs/electrostatic_steel_concrete.i` | 修改 | 输入文件 |
| `outputs/…_line_centerline.csv` | 新增 | 输出数据 |
| `outputs/…_line_interface.csv` | 新增 | 输出数据 |
| `outputs/reference_comsol_centerline.csv` | 新增 | 参考数据 |
| `render_es_path.py` | 新增 | Python 脚本 |

### 第5条：CDP 混凝土损伤模型 (14 files)

| 文件 | 状态 | 类型 |
|------|------|------|
| `src/materials/ConcreteDamagePlasticityStressUpdate.h` | 新增 | C++ 头文件 |
| `src/materials/ConcreteDamagePlasticityStressUpdate.C` | 新增 | C++ 源文件 |
| `src/CMakeLists_hongchuang.txt` | 修改 | 构建配置 |
| `src/HongchuangApp.C` | 修改 | C++ 源文件 |
| `Makefile.app` | 新增 | 构建配置 |
| `inputs/cantilever_multiphysics_cdp.i` | 新增 | 输入文件 |
| `outputs/cantilever_multiphysics_cdp.e` | 新增 | 结果文件 |
| `outputs/cantilever_multiphysics_cdp.csv` | 新增 | 输出数据 |
| `cdp_postprocess.py` | 新增 | Python 脚本 |
| `render_cdp.py` | 新增 | Python 脚本 |
| `render_multiphysics_cdp.py` | 新增 | Python 脚本 |
| `CDP_BENCHMARK.md` | 新增 | 文档 |
| `CASE_REPRODUCE.md` | 修改 | 文档 |
| `.gitignore` | 修改 | 配置 |

## 11.2 统计

| 类别 | 数量 |
|------|------|
| 新增文件 | 22 |
| 修改文件 | 12 |
| 合计 | 34 |
| 新增代码行 (估算) | ~3,400+ |

---

# 十二、视频文件清单

## 12.1 全部渲染视频

| 视频文件 | 大小 (KB) | 更新时间 | 帧数 | 描述 | 对应评论 |
|----------|-----------|----------|------|------|----------|
| `renders/beam_loading.mp4` | 849 | 2026-05-13 11:56 | 60 | 悬臂梁线弹性渐变加载 (Hex8) | 第2条 |
| `renders/contact.mp4` | 449 | 2026-05-13 14:00 | 50 | 两体接触力学 5s FEM 渲染 | 第3条 |
| `renders/electrostatic.mp4` | 838 | 2026-05-13 11:56 | 60 | 双材料静电场三维分布 | 第4条 |
| `renders/electrostatic_path.mp4` | 77 | 2026-05-13 14:00 | 60 | 静电路径电位采样 + COMSOL 对标 | 第4条 |
| `renders/multiphysics_coupling.mp4` | 701 | 2026-05-13 11:56 | 60 | 热-力-损伤三场耦合轮播 | — |
| `renders/acoustic.mp4` | 1000 | 2026-05-13 11:56 | 60 | 空腔 Helmholtz 谐响应 | — |
| `renders/fatigue.mp4` | 570 | 2026-05-13 11:56 | 60 | 疲劳 S-N/Miner 后处理 | — |
| `renders/cdp_damage.mp4` | 160 | 2026-05-13 14:18 | 60 | CDP 混凝土损伤演化 | 第5条 |

## 12.2 本次评论修改涉及视频

| 视频 | 修改类型 | 说明 |
|------|----------|------|
| `contact.mp4` | 重新生成 | 改用真实 FEM Exodus 数据 + 5s 模拟 + 变形比例标注 |
| `electrostatic_path.mp4` | 新增 | 静电路径电位采样曲线动画 + COMSOL 覆盖 |
| `cdp_damage.mp4` | 新增 | CDP 损伤 contour + 时间演化动画 (暗色主题) |
| `beam_loading.mp4` | 间接影响 | 底层网格从 TET4→Hex8，渲染自动使用新网格 |

### 视频帧缓存目录

| 目录 | 状态 | 说明 |
|------|------|------|
| `renders/contact_frames/` | 已清理 (`.gitignore`) | 接触渲染临时帧 |
| `renders/es_path/` | 已清理 (`.gitignore`) | 静电路径渲染临时帧 |
| `renders/cdp_frames/` | 已清理 (`.gitignore`) | CDP 渲染临时帧 |

所有帧缓存目录已加入 `.gitignore`，防止膨胀仓库。
