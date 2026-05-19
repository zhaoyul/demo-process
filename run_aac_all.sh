#!/bin/bash
# Run all AAC simulations
# Usage: bash run_aac_all.sh
set -euo pipefail

ENGINE="/home/kevin/gt/demo/mayor/rig/build/moose/modules/solid_mechanics/solid_mechanics-opt"
DEMO_DIR="/home/kevin/gt/demo/polecats/chrome/demo"
TIMEOUT_PER_SIM=300  # 5 minutes per simulation max

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

cd "$DEMO_DIR"

run_sim() {
    local name="$1"
    local input_dir="$2"
    local input_file="${input_dir}/${name}.i"
    
    if [ ! -f "$input_file" ]; then
        echo "[SKIP] $name: input file not found"
        return 1
    fi
    
    echo "[$(date +%H:%M:%S)] Starting $name..."
    
    if timeout "$TIMEOUT_PER_SIM" "$ENGINE" -i "$input_file" > "outputs/${name}.log" 2>&1; then
        echo "[$(date +%H:%M:%S)] ✓ $name completed"
        return 0
    else
        local rc=$?
        if [ $rc -eq 124 ]; then
            echo "[$(date +%H:%M:%S)] ✗ $name TIMED OUT after ${TIMEOUT_PER_SIM}s"
        else
            echo "[$(date +%H:%M:%S)] ✗ $name FAILED (exit code $rc)"
        fi
        return $rc
    fi
}

echo "============================================"
echo "AAC Simulation Batch Runner"
echo "Engine: $ENGINE"
echo "Timeout per sim: ${TIMEOUT_PER_SIM}s"
echo "Started: $(date)"
echo "============================================"

# Run material tests
echo ""
echo "--- Material Tests (8) ---"
MATERIAL_PASS=0
MATERIAL_FAIL=0
for test in "${MATERIAL_TESTS[@]}"; do
    if run_sim "$test" "inputs/aac_material_tests"; then
        ((MATERIAL_PASS++))
    else
        ((MATERIAL_FAIL++))
    fi
done

# Run wall tests
echo ""
echo "--- Wall Tests (9) ---"
WALL_PASS=0
WALL_FAIL=0
for test in "${WALL_TESTS[@]}"; do
    if run_sim "$test" "inputs/aac_wall_tests"; then
        ((WALL_PASS++))
    else
        ((WALL_FAIL++))
    fi
done

echo ""
echo "============================================"
echo "Batch Complete: $(date)"
echo "Material: ${MATERIAL_PASS} passed, ${MATERIAL_FAIL} failed"
echo "Wall: ${WALL_PASS} passed, ${WALL_FAIL} failed"
echo "Total: $((MATERIAL_PASS + WALL_PASS)) passed, $((MATERIAL_FAIL + WALL_FAIL)) failed"
echo "============================================"
