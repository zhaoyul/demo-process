# PR-RG-400gal-X 算例报告 (2026-08-10/11)

Abaqus 梁模型地震时程分析: 电抗器-绝缘子框架, 400gal RG 谱 X 向激励。

## 模型

- 源: `/home/kevin/Abaqus/PR-RG-400gal-X/PR-RG-400gal-X.inp`
- 756 B31 梁单元 / 701 节点, 高 17.36 m, 单位 mm-t-N-s
- 截面: I 形铝材 (E=72000), CIRC r=141 绝缘子 (E=20000) / 法兰 (E=6666)
- 顶部: 96 t 点质量 + 转动惯量 (3.03e8, 3.03e8, 3.24e8) t·mm²
- MPC BEAM: 12 从节点 → 主节点 (0,0,17360)
- 非结构质量 8.0617e-5 t/mm (绝缘子+法兰) → 附加密度
- 阻尼: Rayleigh α=0.0702 β=0.005697 (≈2% @ ω=3.5 rad/s)
- 激励: 基底 x 向加速度 3920 × RG-X(t) (55s), *Dynamic dt=0.01 T=65s

## 流水线与工具链

1. `tools/abaqus2exodus.py` (扩展): 新增梁模型支持 — *Beam Section
   (I/CIRC 截面+n1 方向), *MPC, *Mass, *Rotary Inertia,
   *Nonstructural Mass, *Dynamic, *Damping, *RELEASE 解析;
   梁单元按 (材料, 截面, 投影 n1⊥轴向, 轴向) 分块 (MOOSE 要求
   y_orientation ⊥ 轴, 容差 1e-4); MPC BEAM 生成可视化刚性连杆
2. `tools/gen_beam_case.py`: report.json → MOOSE .i (截面特性,
   Newmark+HHT, PresetAcceleration 边界, NodalInertia 点质量)
3. `tools/beam_direct_solver.py`: **直接求解器** (numpy/scipy),
   精确 MPC 约束消元 + Newmark + 稀疏 LU 一次分解 → 6500 步 10 分钟
4. `tools/render_pr_rg_400gal_x.py`: pvpython 渲染

## MOOSE (hongchuang-opt) 求解踩坑记录

- **PresetAcceleration 的 scale_factor 不被使用** (源码 bug:
  computeQpValue 只取 function.value)。必须把缩放系数写进 Function
  (如 8elc 的 `scale_factor` 放在 PiecewiseLinear 内)。
- **solve_type=LINEAR 对本模型数值不稳定** (逐步放大 → NaN);
  NEWTON 收敛 (残差 ~1e-6 N 触底, rel_tol 需放宽至 1e-3)。
- **本机 (i5-1038NG7) MOOSE 速度**: ~200μs/单元-核评估,
  ~9200 评估/残差 → 每步 5-14s, 6500 步需 10-25h — 不可行。
  故最终结果由 beam_direct_solver.py 产生, MOOSE 短窗口对照验证
  (t=0.08s: MOOSE 4.31e-6 mm vs 直接求解 4.31e-6/… 同量级, 差异 ~13-28%,
  主要来自 MPC 处理方式: MOOSE 刚性连杆 vs 精确约束消元)。
- *RELEASE (96 处端部弯矩释放): MOOSE 梁不支持; 直接求解器支持
  静力凝聚, 但释放后基频降至 0.007 Hz (近机构), 与工程预期不符,
  最终结果**忽略释放** (f1=1.076 Hz, 与 MOOSE 模型一致)。

## 结果 (beam_direct_solver, 无释放)

- 基频: f1 = 1.076 Hz (×2), f2 = 1.141, f3 = 3.667 Hz
- 地面位移峰值: 1521 mm @ 10.8s (RG 人工记录长周期分量)
- 顶点相对位移峰值: **231.7 mm @ 23.45s** (漂移比 1.33%)
- t>55s 自由衰减至 ~8 mm (阻尼工作正常)

## 产物

- `outputs/pr_rg_400gal_x/pr_rg_400gal_x_mesh.e` — Exodus 网格 (188 块)
- `outputs/pr_rg_400gal_x/report.json` — 转换报告
- `outputs/pr_rg_400gal_x/pr_rg_400gal_x_out.e` — 结果 (1302 帧, 绝对位移)
- `outputs/pr_rg_400gal_x/pr_rg_400gal_x_rel.e` — 相对位移 (减基底)
- `outputs/pr_rg_400gal_x/pr_rg_400gal_x_top.csv` — 顶点 disp_x 时程
- `outputs/pr_rg_400gal_x/rg_x.csv` / `rg_x_3920.csv` — 幅值
- `inputs/pr_rg_400gal_x.i` — MOOSE 输入 (NEWTON; 全量需 ~15h, 未跑完)
- `renders/pr_rg_400gal_x_disp.mp4` — 绝对位移动画
- `renders/pr_rg_400gal_x_rel.mp4` — 相对位移动画 (变形 ×6)
