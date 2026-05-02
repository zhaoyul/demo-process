# 红创科技多物理场仿真平台 — 用户手册

> 版本: V1.0 | 日期: 2026-05 | 招标条款: §10

---

## 一、快速入门

### 安装

```bash
# 1. 克隆仓库
git clone git@github.com:zhaoyul/demo-process.git
cd demo-process

# 2. 安装依赖
./install-deps.sh

# 3. 编译 (首次)
make all

# 4. 运行演示
./demo.sh
```

### 第一个仿真

```bash
# 1. 激活环境
conda activate moose

# 2. 生成网格
gmsh -3 -format msh2 -o outputs/beam.msh inputs/cantilever_beam.geo

# 3. 运行求解器
bin/hongchuang-opt -i inputs/cantilever_beam.i

# 4. 查看结果
paraview --data=outputs/cantilever_beam_out.e
```

## 二、建模流程

### 2.1 几何建模 (Gmsh)

```python
# inputs/my_model.geo
L = 1.0; W = 0.1; H = 0.2;
Point(1) = {0,0,0, 0.05};
Point(2) = {L,0,0, 0.05};
# ... 构造点、线、面、体
Physical Volume("body") = {1};
Physical Surface("fixed") = {1};
Physical Surface("loaded") = {2};
```

### 2.2 仿真定义 (MOOSE .i 文件)

```
[Mesh]
  type = FileMesh
  file = ../outputs/my_model.msh
[]

[Variables]
  [disp_x] []
[]

[Kernels]
  [TensorMechanics]
    displacements = 'disp_x disp_y disp_z'
  []
[]

[BCs]
  [fixed]
    type = DirichletBC
    variable = disp_x
    boundary = fixed
    value = 0.0
  []
[]
```

### 2.3 可视化 (ParaView)

1. 打开 `.e` 文件
2. 应用 `Warp By Vector` 滤镜 (位移变量)
3. 着色: `vonMisesStress` 或 `disp_z`
4. 保存状态: File → Save State → `.pvsm`

## 三、算例库

| 算例 | 说明 | 输入文件 |
|------|------|---------|
| 悬臂梁 | 线弹性, 网格收敛验证 | `cantilever_beam.i` |
| 热膨胀 | 热-固耦合, ΔT=50K | `cantilever_beam_thermal.i` |
| 接触 | 两体 Coulomb 摩擦 | `contact_2d.i` |
| 静电 | 钢筋-混凝土双材料 | `electrostatic_steel_concrete.i` |
| 声学 | 空腔 Helmholtz 1kHz | `acoustic_cavity.i` |
| 弹塑性 | J2 塑性硬化 | `cantilever_beam_plastic.i` |

详见 `CASE_REPRODUCE.md`

## 四、CLI 参考

### hongchuang_cli.py

```bash
# 一键仿真
./hongchuang_cli.py cantilever_beam

# 分步执行
./hongchuang_cli.py mesh cantilever_beam
./hongchuang_cli.py solve cantilever_beam
./hongchuang_cli.py post cantilever_beam

# 列出算例
./hongchuang_cli.py list

# 帮助
./hongchuang_cli.py --help
```

### hongchuang-opt

```bash
# 运行
hongchuang-opt -i input.i

# 并行 (8 核)
mpiexec -n 8 hongchuang-opt -i input.i

# 恢复
hongchuang-opt -i input.i --recover checkpoint_cp/LATEST

# 仅生成网格
hongchuang-opt -i input.i --mesh-only

# 显示版本
hongchuang-opt --version
```

### Gmsh

```bash
# 3D 网格
gmsh -3 -format msh2 -o output.msh input.geo

# 二阶单元
gmsh -3 -order 2 -format msh2 -o output.msh input.geo

# 查看网格
gmsh output.msh
```

### ParaView

```bash
# 打开结果
paraview --data=output.e

# 加载状态
paraview --state=state.pvsm

# 批处理 (Python)
pvpython script.py
```

## 五、常见问题

| 问题 | 解决方案 |
|------|---------|
| "File not found" | 检查 `file = ` 路径相对于 `.i` 文件位置 |
| "Material property not defined" | 确认 `block =` 参数覆盖所需子域 |
| Mesh 不收敛 | 加密网格, 检查单元质量 |
| PETSc 求解失败 | 尝试 `-pc_type lu -pc_factor_mat_solver_type mumps` |
| MPI 错误 | `conda activate moose; which mpicxx` |
