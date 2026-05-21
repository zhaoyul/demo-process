#!/bin/bash
# AAC 全试验仿真流水线 - 不依赖 pi session
set -e

ROOT=/home/kevin/gt/demo/mayor/rig
BIN=$ROOT/bin/hongchuang-opt
OUT=$ROOT/outputs
MAT=$ROOT/inputs/aac_material_tests
WALL=$ROOT/inputs/aac_wall_tests

exec > $ROOT/aac_sim_results.log 2>&1

echo "========================================="
echo "  AAC 仿真流水线启动: $(date)"
echo "========================================="

# --- 材料试验 ---
echo ""
echo "=== Phase 1: 材料试验 (9个) ==="
for f in \
  aac_compression_100mm \
  aac_compression_150mm \
  aac_compression_prism \
  aac_splitting_tension_100mm \
  aac_splitting_tension_150mm \
  aac_splitting_tension_prism \
  c60_compression \
  joint_grout_shear \
  rebar_pullout; do
  
  echo "[$(date +%H:%M:%S)] $f 开始..."
  $BIN -i $MAT/${f}.i --timing 2>> $OUT/${f}.log
  if [ -f "$OUT/${f}.e" ]; then
    echo "[$(date +%H:%M:%S)] $f 完成 ✓ (.e $(du -h $OUT/${f}.e | cut -f1))"
  else
    echo "[$(date +%H:%M:%S)] $f 失败 ✗"
  fi
done

# --- 墙体拟静力 ---
echo ""
echo "=== Phase 2: 墙体拟静力试验 (9个) ==="
for f in \
  w01_axial_compression \
  w02_eccentric_compression \
  w03_pseudo_static \
  w04_thin_pseudo_static \
  w05_no_lattice_pseudo_static \
  w06_large_plate_pseudo_static \
  w07_thin_column_pseudo_static \
  w08_window_opening_pseudo_static \
  w09_hinged_pseudo_static; do
  
  echo "[$(date +%H:%M:%S)] $f 开始..."
  $BIN -i $WALL/${f}.i --timing 2>> $OUT/${f}.log
  if [ -f "$OUT/${f}.e" ]; then
    echo "[$(date +%H:%M:%S)] $f 完成 ✓ (.e $(du -h $OUT/${f}.e | cut -f1))"
  else
    echo "[$(date +%H:%M:%S)] $f 失败 ✗"
  fi
done

echo ""
echo "========================================="
echo "  全部完成: $(date)"
echo "========================================="
