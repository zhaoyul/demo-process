#!/usr/bin/env bash
#
# apply-gmsh-branding.sh — 红创科技 Gmsh 白标化脚本
#
# 将 Gmsh 源码白标化为"红创网格工具"。此脚本自动应用品牌化补丁、
# 替换图标文件并配置 CMake 编译选项。
#
# 用法:
#   ./apply-gmsh-branding.sh <gmsh-source-dir> [--build] [--icon-dir <icons-dir>]
#
# 选项:
#   --build         应用补丁后执行 cmake 配置 + make 编译
#   --icon-dir DIR  指定包含品牌图标文件的目录（默认: 同目录下的 icons/）
#
# 示例:
#   ./apply-gmsh-branding.sh ~/src/gmsh
#   ./apply-gmsh-branding.sh ~/src/gmsh --build
#   ./apply-gmsh-branding.sh ~/src/gmsh --icon-dir ./icons --build

set -euo pipefail

# ─── 颜色输出 ───────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m' # No Color

print_banner() {
    echo -e "${RED}${BOLD}"
    echo "╔══════════════════════════════════════════════════════╗"
    echo "║        红创科技 Gmsh 白标化部署脚本 V1.0            ║"
    echo "║     Hongchuang Technology Gmsh Branding Tool         ║"
    echo "╚══════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${GREEN}[红创]${NC} >>> ${BOLD}$1${NC}"
}

print_warn() {
    echo -e "${YELLOW}[警告] $1${NC}"
}

print_error() {
    echo -e "${RED}[错误] $1${NC}" >&2
}

# ─── 参数解析 ───────────────────────────────────────────────
GMSH_DIR=""
DO_BUILD=false
ICON_DIR=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --build)
            DO_BUILD=true
            shift
            ;;
        --icon-dir)
            ICON_DIR="$2"
            shift 2
            ;;
        --help|-h)
            echo "用法: $0 <gmsh-source-dir> [--build] [--icon-dir <icons-dir>]"
            exit 0
            ;;
        *)
            GMSH_DIR="$1"
            shift
            ;;
    esac
done

# ─── 验证输入 ───────────────────────────────────────────────
if [[ -z "$GMSH_DIR" ]]; then
    print_error "必须指定 Gmsh 源码目录"
    echo "用法: $0 <gmsh-source-dir> [--build] [--icon-dir <icons-dir>]"
    exit 1
fi

if [[ ! -d "$GMSH_DIR" ]]; then
    print_error "目录不存在: $GMSH_DIR"
    exit 1
fi

# 验证是 Gmsh 源码目录
if [[ ! -d "$GMSH_DIR/Fltk" ]]; then
    print_error "$GMSH_DIR 不是有效的 Gmsh 源码目录（缺少 Fltk/ 子目录）"
    exit 1
fi

if [[ ! -f "$GMSH_DIR/Fltk/GUI.cpp" ]]; then
    print_error "找不到 Fltk/GUI.cpp — 请确认这是完整的 Gmsh 源码树"
    exit 1
fi

# ─── 确定脚本位置与资源路径 ───────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCH_FILE="$SCRIPT_DIR/../patches/gmsh-branding.patch"

if [[ -z "$ICON_DIR" ]]; then
    ICON_DIR="$SCRIPT_DIR/../icons"
fi

# ─── 检查依赖 ───────────────────────────────────────────────
check_deps() {
    print_step "检查依赖工具..."
    local missing=()

    for cmd in patch git cmake make; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        print_warn "缺少以下工具，部分功能可能不可用: ${missing[*]}"
        print_warn "在 Arch Linux 上可以运行: sudo pacman -S base-devel cmake git"
    fi
}

# ─── 应用品牌化补丁 ─────────────────────────────────────────
apply_patch() {
    print_step "应用品牌化补丁..."

    if [[ ! -f "$PATCH_FILE" ]]; then
        print_error "找不到补丁文件: $PATCH_FILE"
        exit 1
    fi

    cd "$GMSH_DIR"

    # 先尝试 --dry-run 检查是否可以干净应用
    if patch --dry-run -p1 < "$PATCH_FILE" 2>/dev/null; then
        print_step "干运行通过，正在应用补丁..."
        patch -p1 < "$PATCH_FILE"
        echo -e "${GREEN}  ✓ 补丁应用成功${NC}"
    else
        # 尝试使用 Git apply（更智能的模糊匹配）
        if git apply --check "$PATCH_FILE" 2>/dev/null; then
            print_step "使用 git apply 应用补丁..."
            git apply "$PATCH_FILE"
            echo -e "${GREEN}  ✓ 补丁应用成功 (git apply)${NC}"
        else
            print_warn "补丁无法干净应用。尝试使用 fuzzy 模式..."

            # 显示哪些 hunk 失败了
            if patch --dry-run -p1 < "$PATCH_FILE" 2>&1 | grep -q "FAILED"; then
                local result
                result=$(patch --dry-run -p1 < "$PATCH_FILE" 2>&1 || true)
                echo "$result"

                print_warn "补丁可能已经部分应用，或 Gmsh 版本不匹配。"
                print_warn "请手动检查并完成以下文件的修改:"
                echo "  - Fltk/GUI.cpp: 将窗口标题改为 '红创科技多物理场前处理系统 V1.0'"
                echo "  - Fltk/graphicWindow.cpp: 将 about_cb 中的版权信息改为红创科技"

                read -rp "是否跳过补丁应用，继续图标替换？(y/N) " skip
                if [[ "$skip" != "y" && "$skip" != "Y" ]]; then
                    exit 1
                fi
            fi
        fi
    fi
}

# ─── 替换图标 ───────────────────────────────────────────────
replace_icons() {
    print_step "替换品牌图标..."

    local res_dir="$GMSH_DIR/res"

    if [[ ! -d "$res_dir" ]]; then
        print_warn "res/ 目录不存在，创建中..."
        mkdir -p "$res_dir"
    fi

    # 备份原始图标
    local backup_dir="$res_dir/orig_$(date +%Y%m%d_%H%M%S)"
    print_step "备份原始图标到 $backup_dir"
    mkdir -p "$backup_dir"

    for icon in gmsh.png logo.png gmsh.ico; do
        if [[ -f "$res_dir/$icon" ]]; then
            cp "$res_dir/$icon" "$backup_dir/$icon"
        fi
    done

    # 复制品牌图标
    local icon_sources=("gmsh.png" "logo.png" "gmsh.ico")
    local all_copied=true

    for icon in "${icon_sources[@]}"; do
        local src="$ICON_DIR/hongchuang_${icon}"
        local dst="$res_dir/$icon"

        if [[ -f "$src" ]]; then
            cp "$src" "$dst"
            echo -e "  ${GREEN}✓${NC} 已复制: $icon"
        else
            echo -e "  ${YELLOW}⚠${NC} 品牌图标不存在: $src"
            print_warn "请运行 src/generate_icons.py 生成图标，或将图标放入 $ICON_DIR/"
            all_copied=false
        fi
    done

    if $all_copied; then
        echo -e "${GREEN}  ✓ 所有图标已替换${NC}"
    fi
}

# ─── CMake 配置与编译 ────────────────────────────────────────
build_gmsh() {
    print_step "配置 CMake 并编译..."

    cd "$GMSH_DIR"

    local build_dir="build_hongchuang"

    if [[ -d "$build_dir" ]]; then
        print_warn "构建目录 $build_dir 已存在，将使用现有配置"
    else
        mkdir -p "$build_dir"
    fi

    cd "$build_dir"

    print_step "运行 CMake 配置..."
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DENABLE_FLTK=ON \
          -DENABLE_OCC=ON \
          ..

    local cores
    cores=$(nproc 2>/dev/null || echo 4)
    print_step "使用 $cores 核心编译..."
    make -j"$cores"

    echo -e "${GREEN}  ✓ 编译完成${NC}"
    echo ""
    echo -e "${BOLD}可执行文件:${NC} $GMSH_DIR/$build_dir/gmsh"
    echo -e "${BOLD}建议重命名:${NC}"
    echo "  cp $GMSH_DIR/$build_dir/gmsh ~/hongchuang_workspace/hongchuang_mesh"
}

# ─── 主流程 ──────────────────────────────────────────────────
main() {
    print_banner

    print_step "目标目录: $GMSH_DIR"
    echo ""

    check_deps
    echo ""
    apply_patch
    echo ""
    replace_icons
    echo ""

    if $DO_BUILD; then
        build_gmsh
    else
        print_step "跳过编译（使用 --build 可自动编译）"
        echo ""
        echo -e "${BOLD}手动编译命令:${NC}"
        echo "  cd '$GMSH_DIR'"
        echo "  mkdir -p build && cd build"
        echo "  cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_FLTK=ON .."
        echo "  make -j\$(nproc)"
    fi

    echo ""
    echo -e "${GREEN}${BOLD}============================================${NC}"
    echo -e "${GREEN}${BOLD}  红创科技 Gmsh 白标化完成！ ${NC}"
    echo -e "${GREEN}${BOLD}============================================${NC}"
}

main "$@"
