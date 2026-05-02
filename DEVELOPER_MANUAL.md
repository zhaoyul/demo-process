# 红创科技多物理场仿真平台 — 开发者手册

> 版本: V1.0 | 日期: 2026-05 | 招标条款: §10

---

## 一、平台架构概述

```
┌─────────────────────────────────────────────────┐
│              hongchuang_cli.py                  │  ← 统一入口
├─────────────────────────────────────────────────┤
│  Gmsh 前处理  │  MOOSE 求解  │  ParaView 可视化 │
│   .geo → .msh │ .i → .e/.csv │ .e → 渲染       │
├─────────────────────────────────────────────────┤
│            MOOSE Framework (C++17)              │  ← 核心引擎
│  ┌──────────┬──────────┬──────────┬──────────┐ │
│  │Framework │ SolidMech│  Contact │   EM     │ │
│  │libMesh   │ HeatTrans│ PhaseFld │   FSI    │ │
│  │PETSc     │   XFEM   │ RayTrace │ Combined │ │
│  └──────────┴──────────┴──────────┴──────────┘ │
├─────────────────────────────────────────────────┤
│  conda/mamba (MPICH, HDF5, netCDF, Python)      │
└─────────────────────────────────────────────────┘
```

## 二、对象体系

MOOSE 采用**工厂/动作**模式, 所有物理/数值组件以**可注册对象**形式在运行期装配:

| 系统 | 描述 | 示例对象 |
|------|------|---------|
| Kernel | 体积分 PDE 弱形式 | StressDivergenceTensors, MatDiffusion |
| BC | 边界条件 | DirichletBC, NeumannBC, FunctionDirichletBC |
| Material | 材料本构 | ComputeIsotropicElasticityTensor, ComputeSmallStrain |
| Contact | 接触力学 | MechanicalContactConstraint |
| Postprocessor | 标量后处理 | PointValue, ElementExtremeValue |
| Output | 输出格式 | Exodus, CSV, Checkpoint |
| Executioner | 求解策略 | Steady, Transient |
| Mesh | 网格生成 | GeneratedMesh, FileMesh |

## 三、输入文件语法 (Hit 格式)

MOOSE 使用层级式 Hit 格式定义仿真:

```
[SectionName]
  [block_name]
    parameter = value
    vector_param = 'v1 v2 v3'
    string_param = 'text'
  []
[]
```

**核心分节**:

| 节 | 必需 | 描述 |
|----|------|------|
| `[Mesh]` | ✅ | 网格定义 (GeneratedMesh/FileMesh) |
| `[Variables]` | ✅ | 主未知量 (位移, 温度, 电位) |
| `[Kernels]` | ✅ | PDE 弱形式 |
| `[BCs]` | ✅ | 边界条件 |
| `[Materials]` | ✅ | 材料模型 |
| `[Executioner]` | ✅ | 求解器配置 |
| `[Outputs]` | ✅ | 输出格式 |
| `[Postprocessors]` | 否 | 标量指标 |
| `[Contact]` | 否 | 接触定义 |
| `[GlobalParams]` | 否 | 全局参数 |

## 四、编译与构建

### 依赖环境

```bash
# 安装 miniforge
curl -L -o Miniforge3.sh https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash Miniforge3.sh -b -p $HOME/miniforge3

# 创建 MOOSE 环境
conda config --add channels conda-forge
conda config --add channels https://conda.software.inl.gov/public
conda create -n moose moose-libmesh moose-tools
conda activate moose

# 安装编译器和工具
conda install -y c-compiler cxx-compiler fortran-compiler moose-wasp
conda install -y gmsh paraview
```

### 编译 MOOSE 框架

```bash
git clone --depth 1 https://github.com/idaholab/moose.git
cd moose/framework
LIBMESH_DIR=$CONDA_PREFIX WASP_DIR=$CONDA_PREFIX METHOD=opt make -j8
```

### 编译模块

```bash
# 逐个编译
for mod in solid_mechanics heat_transfer contact phase_field xfem electromagnetics fsi combined; do
    cd moose/modules/$mod
    LIBMESH_DIR=$CONDA_PREFIX WASP_DIR=$CONDA_PREFIX METHOD=opt make -j8
done
```

### 编译红创品牌求解器

```bash
cd build/hongchuang
LIBMESH_DIR=$CONDA_PREFIX WASP_DIR=$CONDA_PREFIX METHOD=opt make -j8
```

## 五、对象扩展指南

### 添加新材料

1. 在 `src/materials/` 创建 C++ 文件
2. 继承 `Material` 基类
3. 实现 `computeQpProperties()`
4. 注册: `registerMooseObject("HongchuangApp", MyMaterial);`

### 添加新 Kernel

1. 继承 `Kernel` 基类
2. 实现 `computeQpResidual()` 和 `computeQpJacobian()`
3. 支持 AD 自动微分: 继承 `ADKernel`

### 添加新模块

```bash
# 使用 MOOSE 模板
cd moose
./scripts/stork.sh MyModule
cd MyModule
# 编辑 src/ 和 include/
make -j8
```

## 六、并行与性能

### MPI 并行

```bash
mpiexec -n 8 hongchuang-opt -i input.i
```

### 线程并行

在输入文件中:
```
[Executioner]
  num_threads = 4
[]
```

### 弱缩放测试

固定每核自由度 (如 100K), 核数 32→512:
```bash
for n in 32 64 128 256 512; do
    mpiexec -n $n hongchuang-opt -i benchmark.i --timing
done
```

## 七、调试与测试

### 单元测试
```bash
cd moose/modules/combined
./run_tests -j8
```

### 回归测试基线
```bash
./run_tests --re=gold
```

### 性能剖析
```bash
hongchuang-opt -i input.i --timing
```
