# 红创科技多物理场仿真平台 —— Arch Linux 本地开发与白标化实施方案

了解！在 Arch Linux 上进行本地开发是一个非常明智的选择。Arch 的滚动更新机制和强大的包管理器（`pacman` / AUR）能让你极其方便地获取最新的 C++ 编译器（GCC 14+ / Clang）、CMake 以及各种依赖库，省去了在 Ubuntu/CentOS 上漫长且痛苦的依赖编译过程。

既然不需要集群，我们将重心放在**单机源码编译、深度白标化（打上"红创科技"标签）以及构建自动化工作流**上。

以下是为您定制的 Arch Linux 本地开发与实施方案，建议您**从最简单的 Gmsh 换皮开始，逐步深入到最核心的 MOOSE 求解器**。

---

## 第 0 步：准备 Arch Linux 基础编译环境

打开您的终端，使用 `pacman` 安装底层依赖：

```bash
# 安装基础编译工具链、MPI、HDF5 以及 Gmsh/ParaView 依赖的 GUI 库
sudo pacman -Syu
sudo pacman -S base-devel cmake git mpich hdf5 fltk qt5-base qt5-tools python python-pip vtk
```

---

## 第一阶段：定制前处理引擎（将 Gmsh 包装为"红创网格工具"）

Gmsh 基于 FLTK，源码结构清晰，编译速度极快（在现代机器上通常只需几分钟），非常适合作为第一个练手项目。

**1. 获取源码：**
```bash
git clone https://gitlab.onelab.info/gmsh/gmsh.git
cd gmsh
```

**2. 深度定制（源码修改）：**

- **修改窗口标题**：
  打开 `Fltk/GUI.cpp`，搜索 `Window->label("Gmsh")` 或 `Window->label`，将其修改为：
  ```
  Window->label("红创科技多物理场前处理系统 V1.0")
  ```
- **修改关于信息**：
  打开 `Fltk/graphicWindow.cpp`，找到 `about_cb` 回调函数，将里面的 "Gmsh" 替换为您的公司信息。
- **替换图标**：
  将您的公司 Logo 制作成 PNG 和 ICO 格式，替换源码目录 `res/` 下的 `gmsh.png`、`logo.png` 和 `gmsh.ico`。

**3. 编译出红创专属版：**
```bash
mkdir build && cd build
# 配置 CMake，确保开启 FLTK (GUI) 支持
cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_FLTK=ON -DENABLE_OCC=ON ..
# 使用全核心编译
make -j$(nproc)
```

**阶段验证**：运行 `./gmsh`，您将看到一个标题为"红创科技多物理场前处理系统"、带有您公司 Logo 的独立软件。为了方便调用，可将重命名后的可执行文件移至工作区：

```bash
cp gmsh ~/hongchuang_workspace/hongchuang_mesh
```

---

## 第二阶段：定制核心求解器（基于 MOOSE 创建"红创求解器"）

这是整个平台的核心。MOOSE 的最佳实践不是直接修改它的核心源码，而是**基于它创建一个您的专属 App**。

**1. 部署 MOOSE 依赖框架：**

MOOSE 推荐使用自家的 `mamba` 环境来隔离复杂的依赖（如特定版本的 libMesh 和 PETSc），以防与 Arch 激进的系统库冲突。

```bash
# 获取 MOOSE
mkdir ~/projects && cd ~/projects
git clone https://github.com/idaholab/moose.git
cd moose
# 使用官方脚本安装 Mamba 环境 (一路选 Yes)
bash scripts/miniforge_setup.sh
# 激活环境
conda activate moose
```

**2. 编译 MOOSE 基础框架：**
```bash
cd ~/projects/moose/test
make -j$(nproc)
```

**3. 创建"红创科技"专属 App 并植入品牌：**
```bash
cd ~/projects
# 创建属于您的独立求解器，名为 hongchuang
~/projects/moose/scripts/moose_wrapper --create hongchuang
cd hongchuang
```

- **修改启动 ASCII Logo（非常重要，这是展示硬核实力的门面）**：
  打开 `src/base/HongchuangApp.C`。在这个文件里，您会看到一个 `header()` 或者类似打印欢迎信息的函数。
  将其中的 ASCII 字符画替换为您公司的名称（推荐使用在线 ASCII Art 生成器生成 "Hongchuang Tech" 的字符）：

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

**4. 编译专属求解器：**
```bash
make -j$(nproc)
```

**阶段验证**：运行 `./hongchuang-opt`，终端应该傲然打印出您刚刚定制的红创科技 Logo 和版权信息。这是未来现场演示时最吸引眼球的环节之一。

---

## 第三阶段：后处理渲染器定制（编译 ParaView）

ParaView 的编译相对耗时。在 Arch 上我们直接通过源码编译打标签。

**1. 获取源码与定制：**
```bash
git clone --recursive https://gitlab.kitware.com/paraview/paraview.git
cd paraview
```

- **修改标题栏**：打开 `Clients/ParaView/ParaViewMainWindow.cxx`，搜索 `setWindowTitle`，将其修改为：
  ```cpp
  setWindowTitle("红创科技 - 三维可视化分析平台")
  ```
- **替换启动图（Splash）**：替换 `Clients/ParaView/Resources/` 下的启动背景图片为红创的 UI 元素。

**2. 编译：**
```bash
mkdir build && cd build
# 在 Arch 上建议开启 Python 和 Qt5
cmake -DCMAKE_BUILD_TYPE=Release \
      -DPARAVIEW_USE_PYTHON=ON \
      -DPARAVIEW_USE_MPI=ON \
      -DPARAVIEW_USE_QT=ON ..
make -j$(nproc)
```

**阶段验证**：运行 `./bin/paraview`，将会展现红创科技定制的可视化界面。我们记为 `hongchuang_post`。

---

## 第四阶段：编写自动化中枢（仿真流程串联）

为了避免现场展示时专家看到您在终端里手敲各种零散的开源工具命令，我们需要用 Python 编写一个总控脚本。这个脚本将把上述三个白标化工具完美封装成一个"统一平台"。

在您的工作区创建一个名为 `hongchuang_cli.py` 的文件：

```python
#!/usr/bin/env python3
import os
import sys
import subprocess
import time

def print_step(msg):
    print(f"\n[\033[91m红创科技\033[0m] >>> {msg}")

def run_simulation(case_name):
    print_step("初始化仿真任务...")

    geo_file = f"inputs/{case_name}.geo"
    msh_file = f"outputs/{case_name}.msh"
    moose_input = f"inputs/{case_name}.i"

    # 1. 静默调用红创前处理 (Gmsh)
    print_step("第一阶段：模型参数化解析与网格离散化")
    # 假设您的白标可执行文件都放在 bin 目录下
    subprocess.run(["./bin/hongchuang_mesh", "-3", "-format", "msh22", geo_file, "-o", msh_file], capture_output=True)
    print("网格离散完毕，准备装配物理矩阵。")

    # 2. 调用红创求解器 (MOOSE)
    print_step("第二阶段：多物理场分布式并行计算启动")
    time.sleep(1)  # 制造一点系统调度的停顿感
    # 在 Arch 本地，我们可以使用 mpiexec 跑 4 到 8 个核展示并行能力
    subprocess.run(["mpiexec", "-n", "8", "./bin/hongchuang-opt", "-i", moose_input])

    # 3. 结果入库与可视化触发
    print_step("第三阶段：计算完成，正在生成可视化孪生图谱")
    # 这里调用红创后处理加载预设的状态文件 (pvsm)
    state_file = f"states/{case_name}_state.pvsm"
    subprocess.run(["./bin/hongchuang_post", f"--state={state_file}"])

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("用法: ./hongchuang_cli.py [算例名称 (例如: hydro_dam)]")
        sys.exit(1)

    # 模拟现场指令执行
    run_simulation(sys.argv[1])
```

---

## 实施路线图建议

| 时间 | 任务 | 目标 |
|------|------|------|
| **今天** | 完成 **Gmsh** 的定制和编译 | 最软的柿子，马上能看到"红创科技"的界面，建立信心 |
| **明天** | 完成 **MOOSE** 的框架搭建、环境配置和红创 App 的创建与 Logo 替换 | 核心硬骨头 |
| **后天** | 准备一个最简单的**悬臂梁受力算例**，包含对应的 `.geo` 和 `.i` 文件，使用 `hongchuang_cli.py` 将整个流程跑通 | 端到端验证 |

如果在编译 Gmsh 或 MOOSE 的过程中遇到任何 CMake 或依赖报错，可以直接把错误信息发过来进一步排查。
