# 红创科技多物理场仿真平台 — 过程验证报告

> **日期**: 2026-05-01  
> **算例**: 悬臂梁静力学分析  
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
| 演示脚本 | `demo.sh` | 主持人执行 `./demo.sh` | 分阶段暂停、标题横幅、总结话术 | 串联整场 demo 节奏 |
| 调度入口 | `hongchuang_cli.py` | 脚本内部调用 `mesh/solve/post` | 统一封装前处理、求解、后处理 | 保证演示命令一致 |
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
- `time=1` 为稳态求解输出时刻, 对外汇报可写为 `tip_disp_z ≈ -8.44 × 10⁻⁶ m`（由原始值 `-8.4442237892724e-06` 四舍五入）。
- 负号表示自由端沿 `-z` 方向下挠, 与顶面向下压力边界条件一致。
- 该值可作为视频口播中的“结果数字”, 与画面中的变形云图相互印证。

### 4.4 后处理画面建议解读

| 画面元素 | 对应输出 | 说明口径 |
|----------|----------|----------|
| 变形后的梁体 | `cantilever_beam_out.e` 位移场 | 说明结构整体向下弯曲 |
| 颜色分布 | Von Mises 应力 | 说明危险区域集中在固支端附近 |
| 放大变形 | `Warp By Vector` | 说明画面为展示效果, 实际位移量级为微米级 |
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

# 1.1 现场演示脚本
./demo.sh

# 2. 网格生成
gmsh -3 -format msh2 -order 1 -o outputs/cantilever_beam.msh inputs/cantilever_beam.geo

# 3. 红创求解器
bin/hongchuang-opt -i inputs/cantilever_beam.i

# 4. 可视化
paraview --data=outputs/cantilever_beam_out.e
```
