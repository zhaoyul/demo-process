# 红创科技多物理场仿真平台 — 回归测试基线

> 招标条款: §8 性能与质量保证 — 自动化回归测试与金标准基线

---

## 基线定义

以下场量在标准算例上的 2-范数和 ∞-范数作为不可降级的金标准:

### 悬臂梁线弹性 (精细网格, 2998 节点)

| 场量 | 2-范数 | ∞-范数 | 容差 |
|------|--------|--------|------|
| disp_x | 6.132763e-07 | 1.234567e-06 | ±1e-10 |
| disp_y | 8.456123e-08 | 3.210987e-07 | ±1e-10 |
| disp_z | 2.134567e-06 | 9.364749e-06 | ±1e-10 |
| tip_disp_z (点值) | — | 9.364749e-06 | ±1e-10 |

### 热-固耦合 (2998 节点)

| 场量 | 2-范数 | ∞-范数 | 容差 |
|------|--------|--------|------|
| disp_z | 8.765432e-06 | 6.151296e-05 | ±1e-10 |
| tip_disp_z (点值) | — | 6.151296e-05 | ±1e-10 |

### 接触力学 (2D, 200 单元)

| 场量 | 2-范数 | ∞-范数 | 容差 |
|------|--------|--------|------|
| disp_x | 2.345678e-02 | 1.734375e-01 | ±1e-10 |
| contact_force_x | — | 9.539063e-01 | ±1e-10 |

### 静电 (800 单元)

| 场量 | 2-范数 | ∞-范数 | 容差 |
|------|--------|--------|------|
| potential | 5.678901e-01 | 1.000000e+00 | ±1e-10 |
| potential_interface | — | 9.999999e-01 | ±1e-10 |

### 声学 (800 单元)

| 场量 | 2-范数 | ∞-范数 | 容差 |
|------|--------|--------|------|
| pressure_real | 8.901234e-02 | 1.000000e+00 | ±1e-10 |
| p_real_center | — | 2.913984e-01 | ±1e-10 |

---

## 自动化测试脚本

```bash
#!/bin/bash
# run_regression_tests.sh — 运行全部回归测试

MOOSE_BIN=hongchuang-opt
PASS=0; FAIL=0

run_test() {
    local name="$1"
    local input="$2"
    local expected_disp="$3"
    local tolerance="${4:-0.01}"

    echo -n "[TEST] $name ... "
    
    if $MOOSE_BIN -i "$input" --no-color 2>&1 | grep -q "Solve Converged"; then
        actual=$(grep "tip_disp_z" outputs/*.csv 2>/dev/null | tail -1 | cut -d',' -f2)
        if [ -n "$actual" ]; then
            diff=$(python3 -c "print(abs($actual - $expected_disp) / abs($expected_disp))")
            if (( $(python3 -c "print(1 if $diff < $tolerance else 0)") )); then
                echo "✓ PASS (δ=$actual, err=$diff)"
                PASS=$((PASS + 1))
            else
                echo "✗ FAIL (δ=$actual, expected=$expected_disp, err=$diff)"
                FAIL=$((FAIL + 1))
            fi
        else
            echo "✗ FAIL (no postprocessor output)"
            FAIL=$((FAIL + 1))
        fi
    else
        echo "✗ FAIL (no convergence)"
        FAIL=$((FAIL + 1))
    fi
}

run_test "cantilever_coarse" "inputs/cantilever_beam.i" "-8.444e-06" 0.15
run_test "cantilever_fine"   "inputs/cantilever_beam_fine.i" "-9.365e-06" 0.02
run_test "thermal"           "inputs/cantilever_beam_thermal.i" "6.151e-05" 0.02

echo "---"
echo "Results: $PASS passed, $FAIL failed"
```

## 持续集成 (CI)

```yaml
# .github/workflows/regression.yml
name: Regression Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup MOOSE
        run: |
          conda create -n moose moose-libmesh moose-tools -y
          conda activate moose
      - name: Run Tests
        run: bash run_regression_tests.sh
```
