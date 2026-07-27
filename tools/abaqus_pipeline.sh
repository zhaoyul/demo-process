#!/usr/bin/env bash
# abaqus_pipeline.sh — Abaqus .inp → MOOSE 求解 → 结果重构 → 渲染 全流程
#
# 由 2026-07-23/24 算例 6-15 (de-96v) 复盘提炼, 用不同输入重复同一任务。
# 用法:
#   tools/abaqus_pipeline.sh --inp /path/to/job.inp --name my_case \
#       --moose-i inputs/my_case.i [--skip-solve] [--from-stage N]
#
# 流水线阶段 (可用 --from-stage 断点续跑):
#   1 convert  abaqus2exodus.py: .inp → mesh.e + report.json + rebar_render_map.json
#   2 solve    hongchuang-opt -i <moose-i> (在 outputs/<name>/ 下运行, ~25min)
#   3 rebar    build_rebar_result.py: 钢筋宿主插值重构 → rebar_result.e
#   4 render   可选: --render-script <pvpython 脚本> (逐算例定制, 参考
#              tools/render_abaqus_6_15.py 复制修改相机/块名/色标)
#
# 前置条件:
#   - ~/miniforge3/envs/moose 环境 (netCDF4, scipy, pvpython)
#   - bin/hongchuang-opt 可执行 (白标 MOOSE app)
#   - MOOSE 输入 .i 需按算例编写 (依据第1阶段 report.json 中的
#     材料/边界/荷载/分析步映射, 参考 inputs/abaqus_6_15.i 与
#     docs/ABAQUUS_PIPELINE.md 的映射对照表)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PY="${MOOSE_PY:-$HOME/miniforge3/envs/moose/bin/python}"
PVPY="${MOOSE_PVPYTHON:-$HOME/miniforge3/envs/moose/bin/pvpython}"
SOLVER="${HONGCHUANG_OPT:-$ROOT/bin/hongchuang-opt}"

INP="" NAME="" MOOSE_I="" RENDER_SCRIPT=""
MERGE_TOL=0.5 TIE_TOL=20.0
SKIP_SOLVE=0 FROM_STAGE=1

usage() { sed -n '2,24p' "$0"; exit 1; }
while [ $# -gt 0 ]; do
  case "$1" in
    --inp) INP="$2"; shift 2;;
    --name) NAME="$2"; shift 2;;
    --moose-i) MOOSE_I="$2"; shift 2;;
    --render-script) RENDER_SCRIPT="$2"; shift 2;;
    --merge-tol) MERGE_TOL="$2"; shift 2;;
    --tie-tol) TIE_TOL="$2"; shift 2;;
    --skip-solve) SKIP_SOLVE=1; shift;;
    --from-stage) FROM_STAGE="$2"; shift 2;;
    -h|--help) usage;;
    *) echo "未知参数: $1"; usage;;
  esac
done
[ -n "$INP" ] && [ -n "$NAME" ] || usage
[ -f "$INP" ] || { echo "✗ inp 不存在: $INP"; exit 1; }

OUTDIR="$ROOT/outputs/$NAME"
mkdir -p "$OUTDIR"
MESH="$OUTDIR/${NAME}_mesh.e"
REPORT="$OUTDIR/report.json"
RMAP="$OUTDIR/rebar_render_map.json"
RESULT="$OUTDIR/${NAME}_out.e"
REBAR="$OUTDIR/rebar_result.e"

echo "=== Abaqus→MOOSE 流水线: $NAME ==="
echo "inp:    $INP"
echo "输出:   $OUTDIR"

# --- 阶段 1: 转换 -------------------------------------------------------
if [ "$FROM_STAGE" -le 1 ]; then
  echo "[1/4] 转换 .inp → Exodus II ..."
  "$PY" "$ROOT/tools/abaqus2exodus.py" \
      --inp "$INP" \
      --out "$MESH" \
      --report "$REPORT" \
      --render-map "$RMAP" \
      --merge-tol "$MERGE_TOL" \
      --tie-tol "$TIE_TOL"
  echo "      → $MESH"
  echo "      → $REPORT (材料/边界/荷载/分析步 — 编写 .i 的依据)"
fi

# --- 阶段 2: 求解 -------------------------------------------------------
if [ "$FROM_STAGE" -le 2 ]; then
  if [ "$SKIP_SOLVE" = 1 ]; then
    echo "[2/4] 跳过求解 (--skip-solve)"
  else
    [ -n "$MOOSE_I" ] || { echo "✗ 求解需要 --moose-i"; exit 1; }
    [ -x "$SOLVER" ] || { echo "✗ 求解器不可执行: $SOLVER"; exit 1; }
    echo "[2/4] MOOSE 求解 (输出落盘 $OUTDIR) ..."
    (cd "$OUTDIR" && "$SOLVER" -i "$ROOT/$MOOSE_I" \
        2>&1 | tee "${NAME}_solve.log" | tail -5)
    [ -f "$RESULT" ] || echo "⚠ 未找到 $RESULT — 检查 .i 中 Outputs/file_base"
  fi
fi

# --- 阶段 3: 钢筋结果重构 -------------------------------------------------
if [ "$FROM_STAGE" -le 3 ]; then
  if [ -f "$RESULT" ] && [ -f "$RMAP" ]; then
    echo "[3/4] 钢筋宿主插值重构 ..."
    "$PY" "$ROOT/tools/build_rebar_result.py" \
        --mesh "$MESH" --result "$RESULT" \
        --render-map "$RMAP" --report "$REPORT" \
        --out "$REBAR"
  else
    echo "[3/4] 跳过 (缺 $RESULT 或 $RMAP)"
  fi
fi

# --- 阶段 4: 渲染 -------------------------------------------------------
if [ "$FROM_STAGE" -le 4 ]; then
  if [ -n "$RENDER_SCRIPT" ]; then
    echo "[4/4] 渲染 ($RENDER_SCRIPT) ..."
    DISPLAY="${DISPLAY:-:0}" "$PVPY" "$RENDER_SCRIPT" "$RESULT"
  else
    echo "[4/4] 跳过 (未指定 --render-script; 可复制 tools/render_abaqus_6_15.py 定制)"
  fi
fi

echo "=== 完成: $NAME ==="
echo "产物:"
for f in "$MESH" "$REPORT" "$RMAP" "$RESULT" "$REBAR"; do
  [ -f "$f" ] && echo "  ✓ $f"
done
