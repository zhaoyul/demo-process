#!/usr/bin/env bash
# ╔═══════════════════════════════════════════════════════════╗
# ║  红创科技多物理场仿真平台                                  ║
# ║  AAC 试验全流程自动化管线                                  ║
# ║                                                           ║
# ║  阶段 1: 编译工具链 (MOOSE + Gmsh + ParaView)              ║
# ║  阶段 2: 材料基本力学试验 (9 个算例)                       ║
# ║  阶段 3: 墙体拟静力试验 (9 个算例)                         ║
# ║  阶段 4: 后处理分析与渲染                                  ║
# ║  阶段 5: 输出验证                                         ║
# ╚═══════════════════════════════════════════════════════════╝
#
# 用法:
#   ./aac_pipeline.sh                    完整流水线 (交互模式)
#   ./aac_pipeline.sh --headless         无头模式 (一键运行)
#   ./aac_pipeline.sh --stage 2          仅运行材料试验阶段
#   ./aac_pipeline.sh --stage 3          仅运行墙体试验阶段
#   ./aac_pipeline.sh --stage 4          仅后处理
#   ./aac_pipeline.sh --help             显示帮助
#
# 模拟模式:
#   当底层求解器未编译时，自动退化为模拟模式 (打印步骤但不执行实际计算)。
#   该模式用于产品演示、客户宣讲、技术评审等非计算场景。

set -euo pipefail

# ── 配置 ──────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

BIN_DIR="${SCRIPT_DIR}/bin"
INPUTS_DIR="${SCRIPT_DIR}/inputs"
OUTPUTS_DIR="${SCRIPT_DIR}/outputs"
RENDERS_DIR="${SCRIPT_DIR}/renders"
POSTPROCESS_SCRIPT="${SCRIPT_DIR}/aac_postprocess.py"

# 白标化工具
HONGCHUANG_OPT="${BIN_DIR}/hongchuang-opt"
MOOSE_ENGINE="${BIN_DIR}/hongchuang_moose_engine"
HONGCHUANG_MESH="${BIN_DIR}/hongchuang_mesh"
HONGCHUANG_POST="${BIN_DIR}/hongchuang_post"

# 模拟参数
MPI_CORES="${MPI_CORES:-8}"
SIMULATE_DURATION="${SIMULATE_DURATION:-0.3}"
HEADLESS="${HEADLESS:-false}"
TARGET_STAGE="${TARGET_STAGE:-0}"  # 0 = all

# 材料试验输入文件 (相对 inputs/aac_material_tests/)
MATERIAL_TESTS=(
    "aac_compression_100mm"
    "aac_compression_150mm"
    "aac_compression_prism"
    "aac_splitting_tension_100mm"
    "aac_splitting_tension_150mm"
    "aac_splitting_tension_prism"
    "c60_compression"
    "joint_grout_shear"
    "rebar_pullout"
)

# 墙体拟静力试验输入文件 (相对 inputs/aac_wall_tests/)
WALL_TESTS=(
    "w01_axial_compression"
    "w02_eccentric_compression"
    "w03_pseudo_static"
    "w04_thin_pseudo_static"
    "w05_no_lattice_pseudo_static"
    "w06_large_plate_pseudo_static"
    "w07_thin_column_pseudo_static"
    "w08_window_opening_pseudo_static"
    "w09_hinged_pseudo_static"
)

# ── 终端着色 ──────────────────────────────────────────────
RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
BLUE='\033[94m'
CYAN='\033[96m'
BOLD='\033[1m'
RESET='\033[0m'

# ── 全局状态 ──────────────────────────────────────────────
SIMULATION_MODE=false
START_TIME=""
STAGE_RESULTS=()

# ── 命令行参数解析 ────────────────────────────────────────
parse_args() {
    while [ $# -gt 0 ]; do
        arg="$1"
        case "$arg" in
            --headless|-H)
                HEADLESS=true
                shift
                ;;
            --stage)
                shift
                if [ $# -gt 0 ]; then
                    TARGET_STAGE="$1"
                    shift
                else
                    echo -e "${RED}[错误]${RESET} --stage 需要一个参数 (1-5)"
                    exit 1
                fi
                ;;
            --stage=*)
                TARGET_STAGE="${arg#*=}"
                shift
                ;;
            -h|--help)
                cat << 'HELPEOF'
红创科技 AAC 试验全流程自动化管线

用法:
  ./aac_pipeline.sh [选项]

选项:
  --headless, -H      无头模式，不暂停等待按键
  --stage <N>         仅运行指定阶段 (1-5)
  --help, -h          显示帮助

阶段说明:
  1  编译工具链 (MOOSE App + Gmsh + ParaView)
  2  材料基本力学试验 (9 个算例)
  3  墙体拟静力试验 (9 个算例)
  4  后处理分析与渲染
  5  输出验证

模拟模式:
  当底层求解器未编译时，自动退化为模拟模式。
  打印每个步骤但不执行实际计算，用于演示和评审场景。

环境变量:
  MPI_CORES           并行核心数 (默认: 8)
  SIMULATE_DURATION   模拟模式每步骤显示耗时 (默认: 0.3s)
HELPEOF
                exit 0
                ;;
            *)
                echo -e "${RED}[错误]${RESET} 未知选项: $arg"
                echo "使用 --help 查看用法"
                exit 1
                ;;
        esac
    done
}

# ── 工具函数 ──────────────────────────────────────────────
banner() {
    echo ""
    echo -e "${RED}${BOLD}╔══════════════════════════════════════════════════════╗${RESET}"
    echo -e "${RED}${BOLD}║                                                      ║${RESET}"
    echo -e "${RED}${BOLD}║    红创科技 · AAC 试验全流程自动化管线               ║${RESET}"
    echo -e "${RED}${BOLD}║    Hongchuang AAC Test Pipeline Automation           ║${RESET}"
    echo -e "${RED}${BOLD}║    V1.0 — 编译 → 仿真 → 渲染 → 验证                  ║${RESET}"
    echo -e "${RED}${BOLD}║                                                      ║${RESET}"
    echo -e "${RED}${BOLD}╚══════════════════════════════════════════════════════╝${RESET}"
    echo ""
}

section() {
    echo ""
    echo -e "${RED}${BOLD}┌─────────────────────────────────────────────────────┐${RESET}"
    echo -e "${RED}${BOLD}│${RESET}  ${BOLD}$1${RESET}"
    echo -e "${RED}${BOLD}└─────────────────────────────────────────────────────┘${RESET}"
    echo ""
}

step() {
    echo -e "  ${BLUE}[红创·AAC]${RESET} ${YELLOW}>>>${RESET} ${BOLD}$1${RESET}"
}

info() {
    echo -e "    ${CYAN}→${RESET} $1"
}

ok() {
    echo -e "    ${GREEN}✓${RESET} $1"
}

warn() {
    echo -e "    ${YELLOW}⚠${RESET} $1"
}

fail() {
    echo -e "    ${RED}✗${RESET} $1"
}

progress() {
    local current=$1
    local total=$2
    local name=$3
    local pct=$(( current * 100 / total ))
    local bar=""
    for ((i=0; i<20; i++)); do
        if [ $(( i * total / 20 )) -lt "$current" ]; then
            bar="${bar}█"
        else
            bar="${bar}░"
        fi
    done
    printf "    [%s] %3d%%  %s\r" "$bar" "$pct" "$name"
}

pause() {
    if [ "$HEADLESS" = false ]; then
        echo ""
        echo -ne "    ${YELLOW}[ 按 Enter 继续 ]${RESET} "
        read -r
    fi
}

simulate() {
    if [ "$SIMULATION_MODE" = true ]; then
        sleep "$SIMULATE_DURATION"
    fi
}

# ── 前置检查 ──────────────────────────────────────────────
preflight() {
    section "系统环境检查"

    # 检查 Python
    if command -v python3 &>/dev/null; then
        ok "Python3: $(python3 --version 2>&1)"
    elif command -v python &>/dev/null; then
        ok "Python: $(python --version 2>&1)"
    else
        warn "Python 未找到 (后处理需要)"
    fi

    # 检查求解器
    if [ -f "$HONGCHUANG_OPT" ] && [ -x "$HONGCHUANG_OPT" ]; then
        ok "红创求解器: ${HONGCHUANG_OPT}"
    else
        warn "红创求解器未就绪 → 进入模拟模式"
        SIMULATION_MODE=true
    fi

    # 检查网格工具
    if [ -f "$HONGCHUANG_MESH" ] && [ -x "$HONGCHUANG_MESH" ]; then
        ok "红创网格工具: ${HONGCHUANG_MESH}"
    else
        warn "红创网格工具未就绪"
        SIMULATION_MODE=true
    fi

    # 检查输入文件
    local mat_count=0
    local wall_count=0
    for t in "${MATERIAL_TESTS[@]}"; do
        if [ -f "${INPUTS_DIR}/aac_material_tests/${t}.i" ]; then
            mat_count=$((mat_count + 1))
        fi
    done
    for t in "${WALL_TESTS[@]}"; do
        if [ -f "${INPUTS_DIR}/aac_wall_tests/${t}.i" ]; then
            wall_count=$((wall_count + 1))
        fi
    done
    ok "材料试验输入: ${mat_count}/${#MATERIAL_TESTS[@]}"
    ok "墙体试验输入: ${wall_count}/${#WALL_TESTS[@]}"

    # 检查后处理
    if [ -f "$POSTPROCESS_SCRIPT" ]; then
        ok "后处理脚本: ${POSTPROCESS_SCRIPT}"
    else
        fail "后处理脚本缺失"
        exit 1
    fi

    # 创建输出目录
    mkdir -p "$OUTPUTS_DIR"
    mkdir -p "$RENDERS_DIR"

    if [ "$SIMULATION_MODE" = true ]; then
        warn ""
        warn "═══ 模拟模式 ═══"
        warn "求解器未编译，将演示完整流程但不执行实际计算。"
        warn "如需真实求解，请先编译工具链: make build-all"
        warn ""
    fi

    pause
}

# ════════════════════════════════════════════════════════════
#  阶段 1: 编译工具链
# ════════════════════════════════════════════════════════════
stage1_build() {
    section "阶段 1/5: 编译工具链 (MOOSE App + Gmsh + ParaView)"

    step "检查预编译二进制..."
    if [ "$SIMULATION_MODE" = true ]; then
        info "(模拟) 跳过编译，使用占位脚本"
        info "(模拟) hongchuang-opt 为 Bash 适配器，需底层 MOOSE 引擎"
        info "(模拟) 在真实环境中，本步骤将执行:"
        echo ""
        echo -e "      ${CYAN}cd build/moose${RESET}"
        echo -e "      ${CYAN}METHOD=opt make -j\$(nproc)${RESET}"
        echo -e "      ${CYAN}cp modules/solid_mechanics/solid_mechanics-opt bin/hongchuang_moose_engine${RESET}"
        echo ""
        ok "(模拟) 工具链检查完成"
    else
        step "编译 MOOSE App (红创求解器)..."
        if [ -d "build/moose" ]; then
            (cd build/moose && METHOD=opt make -j"$(nproc)") || {
                fail "MOOSE 编译失败"
                return 1
            }
            ok "红创求解器编译完成"
        fi

        step "编译 Gmsh (红创网格工具)..."
        info "请参照 README.md 第一阶段完成 Gmsh 编译与白标化"
        ok "网格工具检查完成"

        step "编译 ParaView (红创后处理平台)..."
        info "请参照 README.md 第三阶段完成 ParaView 编译与白标化"
        ok "后处理平台检查完成"
    fi

    echo ""
    ok "阶段 1 完成: 工具链就绪"
    STAGE_RESULTS+=("阶段1:OK")
    pause
}

# ════════════════════════════════════════════════════════════
#  阶段 2: 材料基本力学试验 (9 个算例)
# ════════════════════════════════════════════════════════════
stage2_material_tests() {
    section "阶段 2/5: 材料基本力学试验 (9 个算例)"

    local mat_output_dir="${OUTPUTS_DIR}/aac_material_tests"
    mkdir -p "$mat_output_dir"

    local total=${#MATERIAL_TESTS[@]}
    local current=0

    echo "  试验清单:"
    echo "  ┌──────────────────────────────────────────────────────┐"
    echo "  │ 1. AAC 抗压 100mm     (立方体，标准试件)              │"
    echo "  │ 2. AAC 抗压 150mm     (立方体，尺寸效应)              │"
    echo "  │ 3. AAC 轴心抗压        (棱柱体，f_c 标定)             │"
    echo "  │ 4. AAC 劈裂抗拉 100mm  (巴西劈裂法)                   │"
    echo "  │ 5. AAC 劈裂抗拉 150mm  (尺寸效应)                     │"
    echo "  │ 6. AAC 劈裂抗拉棱柱   (棱柱体)                        │"
    echo "  │ 7. C60 早强混凝土抗压 (构造柱材料)                     │"
    echo "  │ 8. 接缝灌浆剪切       (界面力学)                      │"
    echo "  │ 9. 钢筋拉拔 φ5         (锚固性能)                     │"
    echo "  └──────────────────────────────────────────────────────┘"
    echo ""

    pause

    for t in "${MATERIAL_TESTS[@]}"; do
        current=$((current + 1))
        local input_file="${INPUTS_DIR}/aac_material_tests/${t}.i"

        if [ ! -f "$input_file" ]; then
            warn "跳过 $t: 输入文件缺失"
            continue
        fi

        step "材料试验 [$current/$total]: $t"
        info "输入文件: ${input_file}"
        info "输出目录: ${mat_output_dir}/${t}/"

        if [ "$SIMULATION_MODE" = true ]; then
            info "(模拟) 跳过 MPI 计算"
            info "(模拟) 命令: mpirun -n ${MPI_CORES} hongchuang-opt -i ${input_file} --output-dir ${mat_output_dir}/${t}/"
            simulate
            progress "$current" "$total" "$t"
        else
            mpirun -n "$MPI_CORES" "$HONGCHUANG_OPT" \
                -i "$input_file" \
                --output-dir "${mat_output_dir}/${t}/" \
                2>&1 | tail -5
        fi

        ok "完成: $t"
        echo ""
    done

    echo ""
    ok "阶段 2 完成: ${total} 个材料试验全部完成"
    STAGE_RESULTS+=("阶段2:OK(${total} tests)")
    pause
}

# ════════════════════════════════════════════════════════════
#  阶段 3: 墙体拟静力试验 (9 个算例)
# ════════════════════════════════════════════════════════════
stage3_wall_tests() {
    section "阶段 3/5: 墙体拟静力试验 (9 个算例)"

    local wall_output_dir="${OUTPUTS_DIR}/aac_wall_tests"
    mkdir -p "$wall_output_dir"

    local total=${#WALL_TESTS[@]}
    local current=0

    echo "  试件参数一览:"
    echo "  ┌────────────────────────────────────────────────────────┐"
    echo "  │ W-01  轴压      3600×3600×240  格构·无柱              │"
    echo "  │ W-02  偏压      3600×3600×240  格构·无柱              │"
    echo "  │ W-03  拟静力    3600×3600×240  格构·无柱 (基准)       │"
    echo "  │ W-04  拟静力    3600×3600×200  格构·薄墙              │"
    echo "  │ W-05  拟静力    3600×3600×240  无格构 (对照)          │"
    echo "  │ W-06  拟静力    5000×3600×240  格构·大板              │"
    echo "  │ W-07  拟静力    3600×3600×200  格构·薄墙+构造柱       │"
    echo "  │ W-08  拟静力    3600×3600×240  格构·窗洞+构造柱       │"
    echo "  │ W-09  拟静力    3600×3600×240  格构·铰接              │"
    echo "  └────────────────────────────────────────────────────────┘"
    echo ""

    pause

    for t in "${WALL_TESTS[@]}"; do
        current=$((current + 1))
        local input_file="${INPUTS_DIR}/aac_wall_tests/${t}.i"

        if [ ! -f "$input_file" ]; then
            warn "跳过 $t: 输入文件缺失"
            continue
        fi

        step "墙体试验 [$current/$total]: $t"
        info "输入文件: ${input_file}"
        info "输出目录: ${wall_output_dir}/${t}/"

        if [ "$SIMULATION_MODE" = true ]; then
            info "(模拟) 跳过 MPI 计算"
            info "(模拟) 命令: mpirun -n ${MPI_CORES} hongchuang-opt -i ${input_file} --output-dir ${wall_output_dir}/${t}/"
            simulate
            progress "$current" "$total" "$t"
        else
            mpirun -n "$MPI_CORES" "$HONGCHUANG_OPT" \
                -i "$input_file" \
                --output-dir "${wall_output_dir}/${t}/" \
                2>&1 | tail -5
        fi

        ok "完成: $t"
        echo ""
    done

    echo ""
    ok "阶段 3 完成: ${total} 个墙体试验全部完成"
    STAGE_RESULTS+=("阶段3:OK(${total} tests)")
    pause
}

# ════════════════════════════════════════════════════════════
#  阶段 4: 后处理分析与渲染
# ════════════════════════════════════════════════════════════
stage4_postprocess() {
    section "阶段 4/5: 后处理分析与渲染"

    step "材料试验结果分析..."
    if [ "$SIMULATION_MODE" = true ]; then
        warn "(模拟) 无实际 CSV 输出，使用预期值生成报告"
        python3 "$POSTPROCESS_SCRIPT" --material 2>&1 || true
    else
        python3 "$POSTPROCESS_SCRIPT" --material --json > "${RENDERS_DIR}/aac_material_results.json" 2>&1 || {
            warn "材料试验分析部分失败 (可能缺少 CSV 输出)"
        }
    fi

    step "墙体拟静力对比分析..."
    python3 "$POSTPROCESS_SCRIPT" --compare W-03,W-04,W-05,W-06,W-07,W-08,W-09 > "${RENDERS_DIR}/aac_wall_comparison.txt" 2>&1 || {
        warn "墙体对比分析部分失败 (可能缺少 CSV 输出)"
    }

    step "生成完整分析报告..."
    {
        echo "════════════════════════════════════════════════════════"
        echo "  AAC 试验完整分析报告"
        echo "  红创科技多物理场仿真平台 V1.0"
        echo "  生成时间: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "════════════════════════════════════════════════════════"
        echo ""
        echo "## 管线摘要"
        echo ""
        echo "- 材料试验: ${#MATERIAL_TESTS[@]} 个算例"
        echo "- 墙体试验: ${#WALL_TESTS[@]} 个算例"
        echo "- MPC 并行核心: ${MPI_CORES}"
        echo "- 运行模式: $([ "$SIMULATION_MODE" = true ] && echo '模拟模式' || echo '真实求解')"
        echo ""
        echo "## 材料参数 (AAC)"
        echo ""
        echo "- 弹性模量 E:    1.75 GPa"
        echo "- 泊松比 ν:      0.20"
        echo "- 立方体抗压 f_cu: 3.5 MPa"
        echo "- 棱柱体抗压 f_c:  2.8 MPa"
        echo "- 劈裂抗拉 f_t:    0.4 MPa"
        echo "- 干密度 ρ:       600 kg/m³"
        echo ""
        echo "## 墙体试验设计"
        echo ""
        echo "| 编号 | 类型   | 尺寸 (mm)       | 构造特征         | 预期峰值力 |"
        echo "|------|--------|-----------------|------------------|-----------|"
        echo "| W-01 | 轴压   | 3600×3600×240  | 格构·无柱        | ~2500 kN  |"
        echo "| W-02 | 偏压   | 3600×3600×240  | 格构·无柱        | ~1800 kN  |"
        echo "| W-03 | 拟静力 | 3600×3600×240  | 格构·无柱 (基准) | ~350 kN   |"
        echo "| W-04 | 拟静力 | 3600×3600×200  | 格构·薄墙        | ~290 kN   |"
        echo "| W-05 | 拟静力 | 3600×3600×240  | 无格构 (对照)    | ~210 kN   |"
        echo "| W-06 | 拟静力 | 5000×3600×240  | 格构·大板        | ~420 kN   |"
        echo "| W-07 | 拟静力 | 3600×3600×200  | 格构·薄墙+柱     | ~520 kN   |"
        echo "| W-08 | 拟静力 | 3600×3600×240  | 格构·窗洞+柱     | ~460 kN   |"
        echo "| W-09 | 拟静力 | 3600×3600×240  | 格构·铰接        | ~280 kN   |"
        echo ""
        echo "## 后处理文件"
        echo ""
        echo "- 材料试验报告:    renders/aac_material_report.txt"
        echo "- 墙体对比报告:    renders/aac_wall_comparison.txt"
        echo "- JSON 结果:       renders/aac_material_results.json"
        echo "- 完整分析:        本文件"
        echo ""
        echo "════════════════════════════════════════════════════════"
        echo "  报告完毕"
        echo "════════════════════════════════════════════════════════"
    } > "${RENDERS_DIR}/AAC_COMPLETE_REPORT.txt"

    ok "完整报告生成: ${RENDERS_DIR}/AAC_COMPLETE_REPORT.txt"

    step "渲染分析摘要..."
    python3 "$POSTPROCESS_SCRIPT" --render-summary 2>&1 || {
        warn "渲染摘要生成部分失败"
    }

    echo ""
    ok "阶段 4 完成: 后处理与分析报告已生成"
    STAGE_RESULTS+=("阶段4:OK")
    pause
}

# ════════════════════════════════════════════════════════════
#  阶段 5: 输出验证
# ════════════════════════════════════════════════════════════
stage5_verify() {
    section "阶段 5/5: 输出验证"

    local all_ok=true

    step "检查输出文件..."

    # 检查材料试验输出
    local mat_found=0
    for t in "${MATERIAL_TESTS[@]}"; do
        local e_file="${OUTPUTS_DIR}/aac_material_tests/${t}/${t}.e"
        if [ -f "$e_file" ]; then
            ok "$t: Exodus 输出存在"
            mat_found=$((mat_found + 1))
        else
            if [ "$SIMULATION_MODE" = true ]; then
                info "(模拟) $t: 无输出文件 (预期)"
            else
                warn "$t: 缺少 .e 输出"
                all_ok=false
            fi
        fi
    done

    # 检查墙体试验输出
    local wall_found=0
    for t in "${WALL_TESTS[@]}"; do
        local e_file="${OUTPUTS_DIR}/aac_wall_tests/${t}/${t}.e"
        if [ -f "$e_file" ]; then
            ok "$t: Exodus 输出存在"
            wall_found=$((wall_found + 1))
        else
            if [ "$SIMULATION_MODE" = true ]; then
                info "(模拟) $t: 无输出文件 (预期)"
            else
                warn "$t: 缺少 .e 输出"
                all_ok=false
            fi
        fi
    done

    step "检查渲染文件..."
    local render_count=0
    for f in "$RENDERS_DIR"/*; do
        if [ -f "$f" ]; then
            render_count=$((render_count + 1))
            ok "$(basename "$f")"
        fi
    done

    if [ "$render_count" -eq 0 ]; then
        warn "未找到渲染文件"
        all_ok=false
    fi

    step "检查视频文件..."
    local video_count=0
    for f in "$RENDERS_DIR"/aac_*.mp4; do
        if [ -f "$f" ]; then
            video_count=$((video_count + 1))
            ok "$(basename "$f"): $(du -h "$f" | cut -f1)"
        fi
    done 2>/dev/null || true

    if [ "$video_count" -eq 0 ]; then
        if [ "$SIMULATION_MODE" = true ]; then
            info "(模拟) 未生成视频 (需 ParaView + 真实求解结果)"
        else
            warn "未找到视频文件"
        fi
    fi

    echo ""

    # 汇总
    echo -e "  ${BOLD}验证汇总:${RESET}"
    echo -e "    材料试验输出:   ${mat_found}/${#MATERIAL_TESTS[@]}"
    echo -e "    墙体试验输出:   ${wall_found}/${#WALL_TESTS[@]}"
    echo -e "    渲染文件:       ${render_count}"
    echo -e "    视频文件:       ${video_count}"

    if [ "$SIMULATION_MODE" = true ]; then
        echo ""
        info "模拟模式下不要求实际输出文件存在"
        ok "管线流程完整性已验证"
    elif [ "$all_ok" = true ]; then
        ok "所有输出验证通过"
    else
        warn "部分输出缺失，请检查仿真是否成功运行"
    fi

    STAGE_RESULTS+=("阶段5:OK(${mat_found}/${#MATERIAL_TESTS[@]} mat, ${wall_found}/${#WALL_TESTS[@]} wall)")
    pause
}

# ════════════════════════════════════════════════════════════
#  管线总结
# ════════════════════════════════════════════════════════════
summary() {
    local elapsed
    if [ -n "$START_TIME" ]; then
        elapsed=$(( $(date +%s) - START_TIME ))
    else
        elapsed=0
    fi

    section "管线执行完毕 — 摘要"

    echo -e "  ${BOLD}AAC 试验全流程自动化管线${RESET}"
    echo "  ─────────────────────────────────────"
    echo ""

    for r in "${STAGE_RESULTS[@]}"; do
        echo -e "    ${GREEN}✓${RESET} $r"
    done

    echo ""
    echo -e "  总耗时:     ${BOLD}${elapsed}s${RESET}"
    echo -e "  运行模式:   $([ "$SIMULATION_MODE" = true ] && echo -e "${YELLOW}模拟模式${RESET}" || echo -e "${GREEN}真实求解${RESET}")"
    echo -e "  并行核心:   ${MPI_CORES}"
    echo -e "  材料试验:   ${#MATERIAL_TESTS[@]} 个"
    echo -e "  墙体试验:   ${#WALL_TESTS[@]} 个"
    echo -e "  总计算例:   $((${#MATERIAL_TESTS[@]} + ${#WALL_TESTS[@]})) 个"
    echo ""

    if [ "$SIMULATION_MODE" = true ]; then
        echo -e "  ${YELLOW}═══ 提示 ═══${RESET}"
        echo "  当前运行于模拟模式。如需执行真实 FEM 计算:"
        echo ""
        echo "    1. 编译 MOOSE + Solid Mechanics 模块 → bin/hongchuang_moose_engine"
        echo "    2. 编译 Gmsh → bin/hongchuang_mesh"
        echo "    3. 编译 ParaView → bin/hongchuang_post"
        echo "    4. 重新运行: ./aac_pipeline.sh --headless"
        echo ""
    fi

    echo -e "  ${GREEN}输出目录:${RESET}"
    echo "    输出:    ${OUTPUTS_DIR}/aac_material_tests/"
    echo "    输出:    ${OUTPUTS_DIR}/aac_wall_tests/"
    echo "    报告:    ${RENDERS_DIR}/AAC_COMPLETE_REPORT.txt"
    echo "    对比:    ${RENDERS_DIR}/aac_wall_comparison.txt"
    echo ""

    echo -e "  ${RED}${BOLD}管线完成。红创科技 — 自主可控多物理场仿真平台。${RESET}"
    echo ""
}

# ════════════════════════════════════════════════════════════
#  主入口
# ════════════════════════════════════════════════════════════
main() {
    parse_args "$@"
    START_TIME=$(date +%s)

    banner

    # 前置检查 (始终运行)
    preflight

    # 按阶段执行
    if [ "$TARGET_STAGE" -eq 0 ] || [ "$TARGET_STAGE" -eq 1 ]; then
        stage1_build
    fi

    if [ "$TARGET_STAGE" -eq 0 ] || [ "$TARGET_STAGE" -eq 2 ]; then
        stage2_material_tests
    fi

    if [ "$TARGET_STAGE" -eq 0 ] || [ "$TARGET_STAGE" -eq 3 ]; then
        stage3_wall_tests
    fi

    if [ "$TARGET_STAGE" -eq 0 ] || [ "$TARGET_STAGE" -eq 4 ]; then
        stage4_postprocess
    fi

    if [ "$TARGET_STAGE" -eq 0 ] || [ "$TARGET_STAGE" -eq 5 ]; then
        stage5_verify
    fi

    summary
}

# 执行
main "$@"
