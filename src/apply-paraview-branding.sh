#!/usr/bin/env bash
# =============================================================================
# 红创科技 - ParaView 白标化部署脚本
# 红创可视化平台 V1.0
#
# 用法:
#   ./apply-paraview-branding.sh <paraview-source-dir>
#
# 示例:
#   ./apply-paraview-branding.sh ~/src/paraview
#
# 功能:
#   1. 应用窗口标题栏品牌 patch
#   2. 替换启动画面 (splash screen) 资源文件
#   3. 替换应用图标资源文件
#   4. 可选: 自动编译
# =============================================================================

set -euo pipefail

# --- 颜色定义 ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# --- Logo ---
print_banner() {
    echo -e "${RED}"
    echo "  ╔══════════════════════════════════════════════════════╗"
    echo "  ║                                                      ║"
    echo "  ║    _   _                       _                     ║"
    echo "  ║   | | | | ___  _ __   __ _ ___| |__  _   _  __ _    ║"
    echo "  ║   | |_| |/ _ \\| '_ \\ / _\` / __| '_ \\| | | |/ _\` |   ║"
    echo "  ║   |  _  | (_) | | | | (_| \\__ \\ | | | |_| | (_| |   ║"
    echo "  ║   |_| |_|\\___/|_| |_|\\__, |___/_| |_|\\__,_|\\__,_|   ║"
    echo "  ║                      |___/                           ║"
    echo "  ║                                                      ║"
    echo "  ║       红创科技 - 三维可视化分析平台 V1.0             ║"
    echo "  ║       ParaView 白标化部署工具                        ║"
    echo "  ║                                                      ║"
    echo "  ╚══════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# --- 检查参数 ---
if [ $# -lt 1 ]; then
    print_banner
    echo -e "${YELLOW}用法: $0 <paraview-source-dir> [--build]${NC}"
    echo ""
    echo "  paraview-source-dir    ParaView 源码目录路径"
    echo "  --build                应用 patch 后自动编译 (需要 cmake + make)"
    echo ""
    echo "示例:"
    echo "  $0 ~/src/paraview"
    echo "  $0 ~/src/paraview --build"
    exit 1
fi

PARAVIEW_DIR="$1"
DO_BUILD=false
if [ "${2:-}" = "--build" ]; then
    DO_BUILD=true
fi

# --- 获取脚本所在目录 (用于定位 patch 文件和资源) ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCH_DIR="${SCRIPT_DIR}/patches"
RESOURCES_DIR="${SCRIPT_DIR}/resources"

print_banner

# --- 验证 ParaView 源码目录 ---
echo -e "${BOLD}[1/4] 验证 ParaView 源码目录...${NC}"
if [ ! -f "${PARAVIEW_DIR}/CMakeLists.txt" ]; then
    echo -e "${RED}✗ 错误: ${PARAVIEW_DIR} 不是有效的 ParaView 源码目录 (缺少 CMakeLists.txt)${NC}"
    exit 1
fi
echo -e "${GREEN}✓ ParaView 源码目录验证通过${NC}"

# --- 应用窗口标题栏 patch ---
echo -e "${BOLD}[2/4] 应用红创科技品牌 patch...${NC}"
PATCH_FILE="${PATCH_DIR}/paraview-branding.patch"

if [ ! -f "${PATCH_FILE}" ]; then
    echo -e "${RED}✗ 错误: 找不到 patch 文件: ${PATCH_FILE}${NC}"
    exit 1
fi

# 试用 patch --dry-run 检查是否能干净应用
if patch -p1 --dry-run -d "${PARAVIEW_DIR}" < "${PATCH_FILE}" 2>/dev/null; then
    patch -p1 -d "${PARAVIEW_DIR}" < "${PATCH_FILE}"
    echo -e "${GREEN}✓ 品牌 patch 已应用${NC}"
else
    echo -e "${YELLOW}⚠ 警告: patch 无法干净应用, 尝试手动修改...${NC}"
    # 手动实现: 修改 ParaViewMainWindow.cxx
    MAINWINDOW_FILE="${PARAVIEW_DIR}/Clients/ParaView/ParaViewMainWindow.cxx"
    if [ -f "${MAINWINDOW_FILE}" ]; then
        echo "  → 修改 ${MAINWINDOW_FILE}"
        sed -i 's/setWindowTitle("ParaView");/setWindowTitle("红创科技 - 三维可视化分析平台");/g' "${MAINWINDOW_FILE}"
        sed -i 's/setWindowTitle("ParaView "/setWindowTitle("红创科技 - 三维可视化分析平台 "/g' "${MAINWINDOW_FILE}"
        echo -e "${GREEN}✓ 窗口标题已修改${NC}"
    else
        echo -e "${YELLOW}⚠ 未找到 ParaViewMainWindow.cxx, 跳过窗口标题修改${NC}"
    fi
fi

# --- 替换资源文件 ---
echo -e "${BOLD}[3/4] 替换红创科技品牌资源文件...${NC}"

# 替换启动画面 (splash screen)
if [ -f "${RESOURCES_DIR}/splash.png" ]; then
    SPLASH_DEST="${PARAVIEW_DIR}/Clients/ParaView/Resources/splash.png"
    if [ -f "${SPLASH_DEST}" ] || [ -d "$(dirname "${SPLASH_DEST}")" ]; then
        mkdir -p "$(dirname "${SPLASH_DEST}")"
        cp "${RESOURCES_DIR}/splash.png" "${SPLASH_DEST}"
        echo -e "${GREEN}✓ 启动画面已替换: ${SPLASH_DEST}${NC}"
    else
        echo -e "${YELLOW}⚠ 跳过启动画面: Resources 目录不存在${NC}"
    fi
else
    echo -e "${YELLOW}⚠ 未找到 splash.png 资源文件, 跳过${NC}"
fi

# 替换应用图标
if [ -f "${RESOURCES_DIR}/icon.png" ]; then
    ICON_DEST="${PARAVIEW_DIR}/Clients/ParaView/Resources/icon.png"
    if [ -f "${ICON_DEST}" ] || [ -d "$(dirname "${ICON_DEST}")" ]; then
        mkdir -p "$(dirname "${ICON_DEST}")"
        cp "${RESOURCES_DIR}/icon.png" "${ICON_DEST}"
        echo -e "${GREEN}✓ 应用图标已替换: ${ICON_DEST}${NC}"
    else
        echo -e "${YELLOW}⚠ 跳过应用图标: Resources 目录不存在${NC}"
    fi
else
    echo -e "${YELLOW}⚠ 未找到 icon.png 资源文件, 跳过${NC}"
fi

# --- 可选编译 ---
if [ "${DO_BUILD}" = true ]; then
    echo -e "${BOLD}[4/4] 编译红创可视化平台 (ParaView)...${NC}"
    BUILD_DIR="${PARAVIEW_DIR}/build"
    mkdir -p "${BUILD_DIR}"
    cd "${BUILD_DIR}"

    echo "  → 配置 CMake..."
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DPARAVIEW_USE_PYTHON=ON \
          -DPARAVIEW_USE_MPI=ON \
          -DPARAVIEW_USE_QT=ON \
          .. 2>&1 | tail -5

    echo "  → 编译 (使用 $(nproc) 核心)..."
    make -j$(nproc)

    if [ -f "${BUILD_DIR}/bin/paraview" ]; then
        echo -e "${GREEN}✓ 编译成功!${NC}"
        echo ""
        echo -e "${BOLD}红创可视化平台可执行文件:${NC}"
        echo "  ${BUILD_DIR}/bin/paraview"
        echo ""
        echo -e "${BOLD}建议重命名为:${NC}"
        echo "  cp ${BUILD_DIR}/bin/paraview ~/hongchuang_workspace/hongchuang_post"
    else
        echo -e "${RED}✗ 编译可能失败, 请检查上方的 CMake/make 输出${NC}"
        exit 1
    fi
else
    echo -e "${BOLD}[4/4] 跳过编译 (使用 --build 标志启用自动编译)${NC}"
fi

# --- 完成 ---
echo ""
echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}  红创科技 ParaView 白标化部署完成!${NC}"
echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "  窗口标题: ${RED}红创科技 - 三维可视化分析平台${NC}"
echo -e "  目标目录: ${PARAVIEW_DIR}"
echo ""
echo "  下一步:"
echo "    1. 确认修改: grep -r '红创科技' ${PARAVIEW_DIR}/Clients/ParaView/"
echo "    2. 编译部署: $0 ${PARAVIEW_DIR} --build"
echo "    3. 启动验证: ${PARAVIEW_DIR}/build/bin/paraview"
echo ""
