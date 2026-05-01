# 红创科技多物理场仿真平台 V1.0

端到端多物理场仿真平台，基于 Gmsh / MOOSE / ParaView 进行深度白标化（打上"红创科技"标签），
通过 Python 中枢 CLI 统一封装前处理、求解、后处理三大模块。

---

## 项目结构

```
.
├── hongchuang_cli.py            # 自动化中枢 CLI（统一入口）
├── demo.sh                      # 现场演示脚本
├── README.md                    # 本文件
├── inputs/                      # 算例输入
│   ├── cantilever_beam.geo      #   悬臂梁参数化几何模型
│   └── cantilever_beam.i        #   悬臂梁 MOOSE 求解输入
├── outputs/                     # 运行时输出（网格、结果）
├── states/                      # ParaView 状态文件 (.pvsm)
└── bin/                         # 白标化可执行文件（编译后放入）
    ├── hongchuang_mesh           #   Gmsh 换皮 → 红创网格工具
    ├── hongchuang-opt            #   MOOSE 红创 App → 红创求解器
    └── hongchuang_post           #   ParaView 换皮 → 红创后处理平台
```

---

## 快速开始

```bash
# 列出可用算例
./hongchuang_cli.py list

# 运行完整仿真流水线（模拟模式 — 无需编译底层工具）
./hongchuang_cli.py cantilever_beam

# 分步执行
./hongchuang_cli.py mesh cantilever_beam    # 仅前处理
./hongchuang_cli.py solve cantilever_beam   # 仅求解
./hongchuang_cli.py post cantilever_beam    # 仅后处理

# 现场演示（交互模式，带暂停）
./demo.sh

# 无头演示（一次性跑完）
./demo.sh --headless
```

当 `bin/` 目录下的白标化可执行文件就位后，CLI 自动切换为**真实模式**，
调用底层工具完成实际计算。未就位时自动退化为**模拟模式**（打印步骤但不执行），
方便提前演练演示流程。

---

## 白标化工具编译指南

以下为 Arch Linux 本地编译与深度定制的完整步骤。

### 第 0 步：准备 Arch Linux 基础编译环境

```bash
sudo pacman -Syu
sudo pacman -S base-devel cmake git mpich hdf5 fltk qt5-base qt5-tools python python-pip vtk
```

---

### 第一阶段：定制前处理引擎（将 Gmsh 包装为"红创网格工具"）

**1. 获取源码：**
```bash
git clone https://gitlab.onelab.info/gmsh/gmsh.git
cd gmsh
```

**2. 深度定制（源码修改）：**

- **修改窗口标题**：
  打开 `Fltk/GUI.cpp`，搜索 `Window->label("Gmsh")`，将其修改为：
  ```
  Window->label("红创科技多物理场前处理系统 V1.0")
  ```
- **修改关于信息**：
  打开 `Fltk/graphicWindow.cpp`，找到 `about_cb` 回调函数，将里面的 "Gmsh" 替换为您的公司信息。
- **替换图标**：
  将您的公司 Logo 制作成 PNG 和 ICO 格式，替换源码目录 `res/` 下的 `gmsh.png`、`logo.png` 和 `gmsh.ico`。

**3. 编译：**
```bash
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_FLTK=ON -DENABLE_OCC=ON ..
make -j$(nproc)
```

**4. 部署至平台：**
```bash
cp gmsh /path/to/hongchuang_workspace/bin/hongchuang_mesh
```

---

### 第二阶段：定制核心求解器（基于 MOOSE 创建"红创求解器"）

**1. 部署 MOOSE 依赖框架：**
```bash
mkdir ~/projects && cd ~/projects
git clone https://github.com/idaholab/moose.git
cd moose
bash scripts/miniforge_setup.sh
conda activate moose
```

**2. 编译基础框架：**
```bash
cd ~/projects/moose/test
make -j$(nproc)
```

**3. 创建红创专属 App：**
```bash
cd ~/projects
~/projects/moose/scripts/moose_wrapper --create hongchuang
cd hongchuang
```

修改 `src/base/HongchuangApp.C`，植入品牌 ASCII Logo：

```cpp
void HongchuangApp::header() const
{
  mooseConsole() << "========================================================\n"
                 << "  _   _                       _                         \n"
                 << " | | | | ___  _ __   __ _ ___| |__  _   _  __ _ _ __   ___\n"
                 << " | |_| |/ _ \\| '_ \\ / _` / __| '_ \\| | | |/ _` | '_ \\ / _ \\\n"
                 << " |  _  | (_) | | | | (_| \\__ \\ | | | |_| | (_| | | | |  __/\n"
                 << " |_| |_|\\___/|_| |_|\\__, |___/_| |_|\\__,_|\\__,_|_| |_|\\___|\n"
                 << "                    |___/                               \n"
                 << "   红创科技多物理场仿真引擎 (核心模块) V1.0             \n"
                 << "========================================================\n";
}
```

**4. 编译并部署：**
```bash
make -j$(nproc)
cp hongchuang-opt /path/to/hongchuang_workspace/bin/
```

---

### 第三阶段：后处理渲染器定制（编译 ParaView）

**1. 获取源码与定制：**
```bash
git clone --recursive https://gitlab.kitware.com/paraview/paraview.git
cd paraview
```

- **修改标题栏**：打开 `Clients/ParaView/ParaViewMainWindow.cxx`，修改 `setWindowTitle`：
  ```cpp
  setWindowTitle("红创科技 - 三维可视化分析平台")
  ```
- **替换启动图**：替换 `Clients/ParaView/Resources/` 下的启动背景图片。

**2. 编译并部署：**
```bash
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release \
      -DPARAVIEW_USE_PYTHON=ON \
      -DPARAVIEW_USE_MPI=ON \
      -DPARAVIEW_USE_QT=ON ..
make -j$(nproc)
cp bin/paraview /path/to/hongchuang_workspace/bin/hongchuang_post
```

---

## 算例说明

| 算例 | 物理场景 | 分析类型 | 文件 |
|------|----------|----------|------|
| `cantilever_beam` | 矩形截面钢梁一端固定，自由端集中载荷 | 线弹性静力学 | `.geo` + `.i` |

### 悬臂梁参数

| 参数 | 值 | 说明 |
|------|-----|------|
| 长度 L | 1.0 m | x 方向 |
| 宽度 W | 0.1 m | y 方向 |
| 高度 H | 0.2 m | z 方向 |
| 弹性模量 E | 200 GPa | 结构钢 |
| 泊松比 ν | 0.30 | — |
| 面载荷 | 10 kN/m² | -z 方向，顶面 |

---

## 实施路线图

| 时间 | 任务 | 目标 |
|------|------|------|
| **今天** | CLI + demo 脚本 + 算例输入 → 模拟模式演示 | 端到端流程可展示 |
| **明天** | 完成 Gmsh 定制编译 | 前处理就绪 |
| **后天** | 完成 MOOSE 环境搭建与编译 | 核心求解就绪 |
| **大后天** | 完成 ParaView 编译，真实模式端到端跑通 | 全平台就绪 |

---

## 技术栈

- **前处理**: Gmsh (FLTK GUI, C++) — 红创网格工具
- **求解器**: MOOSE (libMesh, PETSc, C++) — 红创求解器
- **后处理**: ParaView (Qt5, VTK, C++) — 红创后处理平台
- **中枢调度**: Python 3 (标准库，零外部依赖)
- **操作系统**: Arch Linux (滚动更新)
- **并行**: MPI (mpich)

---

## 许可证

内部项目。基于 Gmsh (GPL-2.0)、MOOSE (LGPL-2.1)、ParaView (BSD-3-Clause) 二次开发。
