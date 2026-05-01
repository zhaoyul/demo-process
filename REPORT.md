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

## 三、仿真结果

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

## 四、网格收敛性

| 网格 | 单元数 | δ_FEM (m) | δ_theory (m) | 误差 |
|------|--------|-----------|-------------|------|
| 粗 (lc=0.05) | 985 | -8.444e-06 | -9.375e-06 | 9.9% |
| 细 (lc=0.02) | 12,198 | -9.365e-06 | -9.375e-06 | **0.11%** |

精细网格结果与理论解吻合，验证了 MOOSE 求解器 + Gmsh 网格管线的正确性。

## 五、输出文件

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

## 六、命令行复现

```bash
# 1. 激活环境
conda activate moose

# 2. 网格生成
gmsh -3 -format msh2 -order 1 -o outputs/cantilever_beam.msh inputs/cantilever_beam.geo

# 3. 红创求解器
bin/hongchuang-opt -i inputs/cantilever_beam.i

# 4. 可视化
paraview --data=outputs/cantilever_beam_out.e
```
