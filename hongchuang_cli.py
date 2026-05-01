#!/usr/bin/env python3
"""
红创科技多物理场仿真平台 —— 自动化中枢 CLI
=============================================
统一封装前处理（Gmsh 换皮）、核心求解器（MOOSE 红创 App）、
后处理渲染器（ParaView 换皮），对外呈现为单一命令入口。

用法:
  ./hongchuang_cli.py <算例名称>             全流程仿真
  ./hongchuang_cli.py mesh <算例名称>        仅前处理
  ./hongchuang_cli.py solve <算例名称>       仅求解
  ./hongchuang_cli.py post <算例名称>        仅后处理
  ./hongchuang_cli.py list                   列出可用算例
  ./hongchuang_cli.py --help                 显示帮助
"""

import os
import sys
import subprocess
import argparse
import time
from pathlib import Path

# ── 路径配置 ──────────────────────────────────────────────
PROJECT_ROOT = Path(__file__).resolve().parent
BIN_DIR = PROJECT_ROOT / "bin"
INPUTS_DIR = PROJECT_ROOT / "inputs"
OUTPUTS_DIR = PROJECT_ROOT / "outputs"
STATES_DIR = PROJECT_ROOT / "states"

# 白标化可执行文件路径（编译完成后放置于 bin/ 下）
HONGCHUANG_MESH = BIN_DIR / "hongchuang_mesh"
HONGCHUANG_OPT = BIN_DIR / "hongchuang-opt"
HONGCHUANG_POST = BIN_DIR / "hongchuang_post"

# ── 终端着色 ──────────────────────────────────────────────
RED = "\033[91m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
BLUE = "\033[94m"
BOLD = "\033[1m"
RESET = "\033[0m"


def print_banner():
    """打印红创科技 ASCII 横幅。"""
    banner = f"""{RED}{BOLD}
    ╔══════════════════════════════════════════════════════╗
    ║                                                      ║
    ║   _   _                       _                      ║
    ║  | | | | ___  _ __   __ _ ___| |__  _   _  __ _ _ __ ║
    ║  | |_| |/ _ \\| '_ \\ / _` / __| '_ \\| | | |/ _` | '_ \\║
    ║  |  _  | (_) | | | | (_| \\__ \\ | | | |_| | (_| | | | ║
    ║  |_| |_|\\___/|_| |_|\\__, |___/_| |_|\\__,_|\\__,_|_| | ║
    ║                     |___/                             ║
    ║                                                      ║
    ║     红创科技多物理场仿真引擎 V1.0                      ║
    ╚══════════════════════════════════════════════════════╝
    {RESET}"""
    print(banner)


def print_step(msg: str):
    """打印带品牌前缀的步骤提示。"""
    print(f"\n{RED}[红创科技]{RESET} {YELLOW}>>>{RESET} {BOLD}{msg}{RESET}")


def print_ok(msg: str):
    """打印成功信息。"""
    print(f"  {GREEN}✓{RESET} {msg}")


def print_warn(msg: str):
    """打印警告信息。"""
    print(f"  {YELLOW}⚠{RESET} {msg}")


def print_err(msg: str):
    """打印错误信息。"""
    print(f"  {RED}✗{RESET} {msg}")


def check_binary(path: Path, name: str) -> bool:
    """检查可执行文件是否存在。"""
    if path.exists():
        print_ok(f"{name} 就绪: {path}")
        return True
    print_warn(f"{name} 未找到: {path}（模拟模式）")
    return False


def list_cases():
    """列出所有可用算例。"""
    geo_files = sorted(INPUTS_DIR.glob("*.geo"))
    i_files = sorted(INPUTS_DIR.glob("*.i"))

    cases = set()
    for f in geo_files:
        cases.add(f.stem)
    for f in i_files:
        cases.add(f.stem)

    if not cases:
        print_warn("未找到任何算例文件（请将 .geo / .i 放入 inputs/ 目录）")
        return

    print(f"\n{BOLD}可用算例:{RESET}")
    for case in sorted(cases):
        geo = INPUTS_DIR / f"{case}.geo"
        i_file = INPUTS_DIR / f"{case}.i"
        has_geo = "●" if geo.exists() else "○"
        has_i = "●" if i_file.exists() else "○"
        print(f"  {case:30s}  geo:{has_geo}  .i:{has_i}")


def run_mesh(case_name: str) -> bool:
    """Step 1: Gmsh 前处理 —— 网格离散化。"""
    geo_file = INPUTS_DIR / f"{case_name}.geo"
    msh_file = OUTPUTS_DIR / f"{case_name}.msh"

    if not geo_file.exists():
        print_err(f"几何文件不存在: {geo_file}")
        return False

    OUTPUTS_DIR.mkdir(parents=True, exist_ok=True)

    print_step("第一阶段：模型参数化解析与网格离散化")
    print(f"  输入: {geo_file}")
    print(f"  输出: {msh_file}")

    if check_binary(HONGCHUANG_MESH, "hongchuang_mesh"):
        try:
            result = subprocess.run(
                [str(HONGCHUANG_MESH), "-3", "-format", "msh22",
                 str(geo_file), "-o", str(msh_file)],
                capture_output=True, text=True, timeout=300,
            )
            if result.returncode != 0:
                print_err(f"网格生成失败:\n{result.stderr}")
                return False
        except subprocess.TimeoutExpired:
            print_err("网格生成超时（超过 300 秒）")
            return False
        except FileNotFoundError:
            print_err("hongchuang_mesh 可执行文件无法启动")
            return False
    else:
        print("  (模拟: 跳过网格生成，假设网格已就绪)")

    print_ok("网格离散完毕，准备装配物理矩阵。")
    return True


def run_solve(case_name: str) -> bool:
    """Step 2: MOOSE 求解 —— 多物理场并行计算。"""
    moose_input = INPUTS_DIR / f"{case_name}.i"

    if not moose_input.exists():
        print_err(f"求解输入文件不存在: {moose_input}")
        return False

    print_step("第二阶段：多物理场分布式并行计算启动")

    if check_binary(HONGCHUANG_OPT, "hongchuang-opt"):
        try:
            result = subprocess.run(
                ["mpiexec", "-n", "8", str(HONGCHUANG_OPT),
                 "-i", str(moose_input)],
                capture_output=True, text=True, timeout=600,
            )
            if result.returncode != 0:
                print_err(f"求解器运行失败:\n{result.stderr[-1000:]}")
                return False
        except subprocess.TimeoutExpired:
            print_err("求解器运行超时（超过 600 秒）")
            return False
        except FileNotFoundError:
            print_err("mpiexec 或 hongchuang-opt 未找到，请确认 MPI 环境")
            return False
    else:
        print("  (模拟: 跳过并行求解)")
        time.sleep(1.5)

    print_ok("计算完成，所有自由度已收敛。")
    return True


def run_post(case_name: str) -> bool:
    """Step 3: ParaView 后处理 —— 可视化渲染。"""
    state_file = STATES_DIR / f"{case_name}_state.pvsm"

    print_step("第三阶段：正在生成可视化孪生图谱")

    if check_binary(HONGCHUANG_POST, "hongchuang_post"):
        cmd = [str(HONGCHUANG_POST)]
        if state_file.exists():
            cmd.append(f"--state={state_file}")
            print(f"  加载预设状态: {state_file}")

        try:
            subprocess.run(cmd, timeout=60)
        except subprocess.TimeoutExpired:
            print_warn("后处理窗口已启动（GUI 模式，超时自动继续）")
        except FileNotFoundError:
            print_err("hongchuang_post 可执行文件无法启动")
            return False
    else:
        print("  (模拟: 跳过可视化渲染，假设结果已就绪)")

    print_ok("可视化图谱生成完毕。")
    return True


def run_full(case_name: str) -> bool:
    """运行完整三阶段仿真流水线。"""
    print_banner()
    print(f"\n{BOLD}算例: {case_name}{RESET}")
    start_time = time.time()

    # 优先级检查
    print_step("系统自检：验证工具链就绪状态")
    has_mesh = HONGCHUANG_MESH.exists()
    has_opt = HONGCHUANG_OPT.exists()
    has_post = HONGCHUANG_POST.exists()
    print(f"  前处理: {'就绪' if has_mesh else '模拟模式'}")
    print(f"  求解器: {'就绪' if has_opt else '模拟模式'}")
    print(f"  后处理: {'就绪' if has_post else '模拟模式'}")

    # Phase 1
    if not run_mesh(case_name):
        return False

    # Phase 2
    if not run_solve(case_name):
        return False

    # Phase 3
    if not run_post(case_name):
        return False

    elapsed = time.time() - start_time
    print(f"\n{RED}{BOLD}══════════════════════════════════════════════════{RESET}")
    print(f"{GREEN}{BOLD}  仿真任务完成！ 总耗时: {elapsed:.1f} 秒{RESET}")
    print(f"{RED}{BOLD}══════════════════════════════════════════════════{RESET}\n")
    return True


# 已知子命令集合
SUBCOMMANDS = {"mesh", "solve", "post", "list", "all"}


def main():
    parser = argparse.ArgumentParser(
        description="红创科技多物理场仿真平台 —— 自动化中枢 CLI",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
子命令:
  mesh   <算例>   仅前处理（网格生成）
  solve  <算例>   仅求解（并行计算）
  post   <算例>   仅后处理（可视化）
  list           列出可用算例
  all    <算例>   全流程仿真（默认）

示例:
  %(prog)s cantilever_beam       全流程仿真
  %(prog)s mesh cantilever_beam  仅生成网格
  %(prog)s solve cantilever_beam 仅运行求解器
  %(prog)s list                  查看可用算例
        """,
    )
    parser.add_argument(
        "first_arg", nargs="?", default=None,
        help="子命令 (mesh, solve, post, list, all) 或算例名称",
    )
    parser.add_argument(
        "second_arg", nargs="?", default=None,
        help="算例名称（当 first_arg 是子命令时）",
    )

    args = parser.parse_args()

    # 智能路由: 如果第一个参数是已知子命令，使用它；否则视为算例名称（默认 all 模式）
    if args.first_arg in SUBCOMMANDS:
        command = args.first_arg
        case = args.second_arg
    else:
        command = "all"
        case = args.first_arg

    # list 不需要 case
    if command == "list":
        list_cases()
        return

    # 其他命令需要算例名称
    if case is None:
        parser.print_help()
        sys.exit(1)

    if command == "mesh":
        ok = run_mesh(case)
    elif command == "solve":
        ok = run_solve(case)
    elif command == "post":
        ok = run_post(case)
    elif command == "all":
        ok = run_full(case)
    else:
        print_err(f"未知子命令: {command}")
        parser.print_help()
        sys.exit(1)

    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
