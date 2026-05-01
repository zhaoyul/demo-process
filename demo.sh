#!/usr/bin/env bash
# ╔═══════════════════════════════════════════════════════════╗
# ║     红创科技多物理场仿真平台 —— 现场演示脚本              ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 用于产品发布会 / 技术评审 / 客户演示等现场活动。
# 自动运行悬臂梁算例并展示完整的仿真流程。
#
# 用法:
#   ./demo.sh              交互模式（带暂停，适合现场演示）
#   ./demo.sh --headless   无头模式（一次性跑完，输出摘要）

set -euo pipefail

# ── 配置 ──────────────────────────────────────────────────
CLI="./hongchuang_cli.py"
DEMO_CASE="cantilever_beam"
HEADLESS=false

# ── 终端着色 ──────────────────────────────────────────────
RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
BLUE='\033[94m'
BOLD='\033[1m'
RESET='\033[0m'

# ── 命令行参数解析 ────────────────────────────────────────
for arg in "$@"; do
    case "$arg" in
        --headless|-H) HEADLESS=true ;;
        -h|--help)
            echo "用法: $0 [--headless]"
            echo "  --headless    无头模式，不暂停等待按键"
            exit 0
            ;;
    esac
done

# ── 工具函数 ──────────────────────────────────────────────
section() {
    echo ""
    echo -e "${RED}${BOLD}┌─────────────────────────────────────────────────┐${RESET}"
    echo -e "${RED}${BOLD}│${RESET}  ${BOLD}$1${RESET}"
    echo -e "${RED}${BOLD}└─────────────────────────────────────────────────┘${RESET}"
    echo ""
}

info() {
    echo -e "  ${BLUE}→${RESET} $1"
}

done_msg() {
    echo -e "  ${GREEN}✓${RESET} $1"
}

pause() {
    if [ "$HEADLESS" = false ]; then
        echo ""
        echo -ne "  ${YELLOW}[ 按 Enter 继续 ]${RESET} "
        read -r
    else
        sleep 1
    fi
}

# ── 前置检查 ──────────────────────────────────────────────
section "系统环境检查"

# 检查 CLI
if [ ! -f "$CLI" ]; then
    echo -e "  ${RED}✗${RESET} 找不到 $CLI，请确认当前目录是否正确"
    exit 1
fi
done_msg "hongchuang_cli.py 就绪"

# 检查 Python
if command -v python3 &>/dev/null; then
    done_msg "Python3: $(python3 --version)"
elif command -v python &>/dev/null; then
    done_msg "Python: $(python --version)"
else
    echo -e "  ${RED}✗${RESET} 未找到 Python"
    exit 1
fi

# 检查算例文件
if [ -f "inputs/${DEMO_CASE}.geo" ]; then
    done_msg "几何文件: inputs/${DEMO_CASE}.geo"
else
    echo -e "  ${RED}✗${RESET} 缺少 inputs/${DEMO_CASE}.geo"
    exit 1
fi

if [ -f "inputs/${DEMO_CASE}.i" ]; then
    done_msg "求解输入: inputs/${DEMO_CASE}.i"
else
    echo -e "  ${RED}✗${RESET} 缺少 inputs/${DEMO_CASE}.i"
    exit 1
fi

# ── 介绍 ──────────────────────────────────────────────────
section "红创科技多物理场仿真平台 V1.0"
echo "  欢迎莅临红创科技产品发布会。"
echo "  今天我们为您演示基于自主白标化工具链的"
echo "  端到端多物理场仿真流程。"
echo ""
pause

section "演示算例：悬臂梁受力分析"
info "物理场景：一端固定的矩形截面钢梁，自由端施加集中载荷"
info "分析类型：线弹性静力学"
info "演示内容：从参数化建模到结果可视化的完整仿真链路"
echo ""
pause

section "第一步：前处理 —— 参数化建模与网格离散化"

info "正在调用红创网格工具 (hongchuang_mesh)..."
info "基于参数化几何自动生成高质量六面体网格"
echo ""

python3 "$CLI" mesh "$DEMO_CASE"
echo ""
done_msg "网格生成完毕"
pause

# ── 第二步：求解 ──────────────────────────────────────────
section "第二步：求解器 —— 多物理场并行计算"
info "正在启动红创求解器 (hongchuang-opt)..."
info "使用 MPI 并行加速，本机配置 8 核物理核心"
echo ""
echo "  部署模式：MPI 分布式并行"
echo "  自由度规模：≈ 3,000"
echo "  预期耗时：< 10 秒"
echo ""
pause

python3 "$CLI" solve "$DEMO_CASE"
echo ""
done_msg "求解收敛，位移场、应力场计算完成"
pause

# ── 第三步：后处理 ────────────────────────────────────────
section "第三步：后处理 —— 可视化孪生图谱"
info "正在启动红创后处理平台 (hongchuang_post)..."
info "渲染位移云图、应力分布、安全系数"
echo ""

python3 "$CLI" post "$DEMO_CASE"
echo ""
done_msg "可视化渲染完成"
pause

# ── 总结 ──────────────────────────────────────────────────
section "演示总结"
echo "  刚才我们完整展示了红创科技多物理场仿真平台的"
echo "  三大核心模块："
echo ""
echo "  1. 红创网格工具   —— 参数化几何与网格离散化"
echo "  2. 红创求解器      —— MPI 并行多物理场计算"
echo "  3. 红创后处理平台  —— 三维可视化与结果分析"
echo ""
echo "  技术亮点："
echo "    • 全链条自主白标化（每一环节均打上红创标签）"
echo "    • Arch Linux 原生编译，滚动更新保持技术领先"
echo "    • 模块化设计，支持算例热插拔"
echo "    • Python 中枢调度，轻松集成 CI/CD"
echo ""
echo ""
echo -e "${RED}${BOLD}  感谢各位专家和领导莅临指导！${RESET}"
echo ""

# ── 输出算例清单 ──────────────────────────────────────────
section "可用算例一览"
python3 "$CLI" list
echo ""
done_msg "演示完毕。"
