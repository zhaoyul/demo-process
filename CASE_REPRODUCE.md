# 红创科技多物理场仿真平台 — 算例复现手册

> 招标条款: §6 专用适配案例 — 一键复现

---

## 算例 1: 悬臂梁线弹性静力学

**招标对应**: §6.1 结构力学

**一键复现**:
```bash
conda activate moose
cd /path/to/demo
gmsh -3 -format msh2 -order 1 -o outputs/cantilever_beam.msh inputs/cantilever_beam.geo
bin/hongchuang-opt -i inputs/cantilever_beam.i
paraview --data=outputs/cantilever_beam_out.e
```

**输入文件**:
- `inputs/cantilever_beam.geo` — Gmsh 几何脚本 (8点12边6面体)
- `inputs/cantilever_beam.i` — MOOSE 线弹性输入

**输出文件**:
- `outputs/cantilever_beam.msh` — 网格 (MSH2.2)
- `outputs/cantilever_beam_out.e` — 结果 (ExodusII)
- `outputs/cantilever_beam_out.csv` — 自由端挠度

**理论验证**:
```
δ_theory = wL⁴/(8EI) = 1000×1/(8×2e11×6.667e-5) = 9.375×10⁻⁶ m
δ_FEM (精细) = -9.365×10⁻⁶ m, 误差 0.11% ✓
```

---

## 算例 2: 热-固耦合 (温度驱动热膨胀)

**招标对应**: §6.5 多物理耦合

**一键复现**:
```bash
bin/hongchuang-opt -i inputs/cantilever_beam_thermal.i
```

**输入**: `inputs/cantilever_beam_thermal.i`
- ΔT = +50K, α = 1.2×10⁻⁵/K
- E = 200 GPa, ν = 0.30

**输出**: `outputs/cantilever_beam_thermal.e`
- 自由端位移: +6.151×10⁻⁵ m (热膨胀上弯)

---

## 算例 3: 接触力学 (两体 Coulomb 摩擦)

**招标对应**: §6.1 非线性结构 (接触)

**一键复现**:
```bash
/home/kevin/gt/demo/mayor/rig/build/moose/modules/contact/contact-opt -i inputs/contact_2d.i
```

**输入**: `inputs/contact_2d.i`
- 2D 两体, Coulomb 摩擦 μ=0.3
- 右边界位移控制加载

**输出**: `outputs/contact_2d.e`
- 10 时间步, 接触力从 0 到 -0.954N

---

## 算例 4: 低频电磁 (双材料静电)

**招标对应**: §6.2 低频电磁场

**一键复现**:
```bash
/home/kevin/gt/demo/mayor/rig/build/moose/modules/electromagnetics/electromagnetics-opt -i inputs/electrostatic_steel_concrete.i
```

**输入**: `inputs/electrostatic_steel_concrete.i`
- 钢筋 (σ=10⁷ S/m, 左) + 混凝土 (σ=10⁻² S/m, 右)
- 左 1V → 右 0V

**输出**: `outputs/electrostatic_steel_concrete.e`
- 界面电位 ≈ 1.0V (钢筋零压降, 全压降在混凝土)

---

## 算例 5: 声学 (空腔 Helmholtz 谐响应)

**招标对应**: §6.3 声学仿真

**一键复现**:
```bash
bin/hongchuang-opt -i inputs/acoustic_cavity.i
```

**输入**: `inputs/acoustic_cavity.i`
- 0.5m×0.25m 矩形空腔, f=1kHz
- 左侧壁面振动 1Pa

**输出**: `outputs/acoustic_cavity.e`
- 中心声压: 0.291 + j(-0.420) Pa, |p| = 0.511 Pa

---

## 算例 6: 疲劳分析 (雨流计数 + Miner)

**招标对应**: §6.4 疲劳分析

**一键复现**:
```bash
source .venv/bin/activate
python3 fatigue_analysis.py outputs/cantilever_beam_out.e
```

**输入**: 任意 `.e` 文件中的 FEM 应力场

**输出**: 
- 雨流计数载荷谱
- Miner 累积损伤 D(x)
- 疲劳寿命 N_f(x)

---

## 算例 +: J2 弹塑性

**招标对应**: §6.1 非线性材料

**一键复现**:
```bash
bin/hongchuang-opt -i inputs/cantilever_beam_plastic.i
```

**输入**: `inputs/cantilever_beam_plastic.i`
- J2 塑性 + 各向同性硬化
- σ_y = 235 MPa, H = 2 GPa

**输出**: `outputs/cantilever_beam_plastic.e`
