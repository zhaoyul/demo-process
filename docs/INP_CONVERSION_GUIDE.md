# Abaqus .inp → MOOSE/直接求解 转换与计算说明

> 版本: 2026-08-11 (de-el8, 补充约束字段提取 + 强制审核)
> 相关文档: `docs/ABAQUUS_PIPELINE.md` (流水线复盘),
> `docs/ABAQUUS_CONVERTER.md` (转换器细节), `docs/PR_RG_400GAL_X.md` (算例报告)

本文说明：当前转换脚本支持哪些 .inp 参数、每个参数如何映射到 MOOSE .i /
直接求解器，以及有限元计算的完整过程。**每次转换必须通过强制审核**
（见第 4 节），未通过审核的模型禁止交付。

## 1. 全流程总览

```
job.inp
  │  阶段1  tools/abaqus2exodus.py
  ▼
mesh.e + report.json + rebar_render_map.json
  │  阶段1.5 tools/convert_audit.py   ← 强制审核, FAIL 即中断
  ▼
(审核通过)
  │  阶段2  求解 (二选一, 见第 3 节)
  ▼
result.e ── 阶段3 build_rebar_result.py (钢筋算例) ── 阶段4 pvpython 渲染 → mp4
```

一键入口: `tools/abaqus_pipeline.sh --inp job.inp --name <case> --moose-i inputs/<case>.i`

## 2. 支持的 .inp 参数与转换映射

### 2.1 结构与网格

| .inp 关键字 | 提取内容 | 转换去向 |
|---|---|---|
| `*Part / *End Part` | 部件定义 | 网格分块前缀 |
| `*Node` | 节点坐标 | Exodus 节点 (跨 instance 按 merge_tol=0.5 合并) |
| `*Element, type=B31` | 梁单元 | Exodus BEAM2 块, 按 (材料, 截面, 投影 n1⊥轴向, 轴向) 细分块 |
| `*Element, type=C3D8R` | 实体单元 | Exodus HEX8 块 |
| `*Element, type=T3D2` | 桁架/钢筋单元 | Exodus 杆块 (配合钢筋缝合) |
| `*Element, type=MASS/ROTARYI` (assembly 级) | 点质量/惯量元素 | 见 2.3 |
| `*Instance / *End Instance` | 实例装配 (平移/旋转) | 全局坐标变换 |
| `*Nset / *Elset` (part/assembly 级) | 集合 | Exodus nodesets / 内部索引 |
| `*Surface, type=NODE` | 节点面 | *Tie/*Coupling 解析用 |

**梁单元分块规则 (重要)**: MOOSE `ComputeIncrementalBeamStrain` 要求
`y_orientation` 与每个单元轴向垂直 (容差 1e-4)。Abaqus 语义: n1 投影到
⊥t 平面, n2=t×n1；MOOSE: y=n1', z=x×y ⇒ Iy=I11(强轴), Iz=I22。
因此一个 Abaqus 截面块会被细分为多个方向组块 (如 8 截面 → 188 块)。

### 2.2 材料与截面

| .inp 关键字 | 提取内容 | 转换去向 |
|---|---|---|
| `*Material` | 材料名 | report.materials |
| `*Density` | 密度 | 单元密度 (t/mm³ 等, 跟随模型单位) |
| `*Elastic` | E, ν | 线弹性材料 |
| `*Damping` (材料子关键字) | Rayleigh α, β | 直接求解器 C=αM+βK; MOOSE 需在 .i 手写 |
| `*Beam Section, section=I/CIRC` | 截面类型+尺寸行+n1 方向 | 截面特性 (A, I11, I22, J) → .i / 直接求解器 |
| `*Plastic / *Concrete Damaged Plasticity` 等 | 见 MAT_KEYS | report 记录 (当前求解路径按线弹性处理) |

### 2.3 约束、质量与连接 (本次强化)

| .inp 字段 | 提取内容 | 转换去向 |
|---|---|---|
| `** Constraint: <name>` 注释 | 约束名 | 附加到 report.mpcs[].constraint, 审核追溯用 |
| `*MPC` (BEAM 型) | 类型, 从节点集, 主节点集 | ① 网格: 主-从刚性连杆 (spider) 单元, 块名 `mpc_beam_links_g*`, 可视化连接 ② 直接求解器: MPC 约束精确消元 (从节点 dof = 主节点刚体运动) ③ MOOSE: 刚性连杆梁 (E=7.2e7, A=1e5, I=1e9, ρ=0) |
| `*Mass, elset=...` | 集中质量值 | 直接求解器 M 矩阵对角; MOOSE `NodalTranslationalInertia` |
| `*Rotary Inertia` | I11..I23 | 直接求解器 M 矩阵; MOOSE `NodalRotationalInertia` |
| `*Nonstructural Mass` | 单位/数值 (如 MASS PER LENGTH) | 并入覆盖块密度 ρ_eff |
| `*Tie` | 绑定面对 | 节点缝合 (tie_tol=20, 等效 adjust=yes) |
| `*Coupling` | 耦合约束 | report 记录 |
| `*Embedded Element` | 钢筋嵌入 | 节点缝合 + 渲染映射; 或 `--mpc` 导出 LinearNodalConstraint 片段 |
| `*RELEASE` | 端部自由度释放 | 直接求解器: 静力凝聚 (注意: 本算例释放后基频 0.007Hz 近机构, 按工程判断忽略); MOOSE 梁不支持 |

> ⚠️ **约束硬失败规则**: 任何 `*MPC` 无法解析 (节点集为空/类型不支持)
> 时转换器以退出码 2 终止, 不再 WARN 静默跳过。确认可忽略时才加
> `--allow-unresolved-constraints`。约束丢失曾导致客户模型
> 连接不完整 (质量点与结构脱开)。

### 2.4 边界、荷载与分析步

| .inp 关键字 | 提取内容 | 转换去向 |
|---|---|---|
| `*Boundary` (分析步内) | 集合/自由度/值/幅值 | 固定端 (dof 2-6 固定); 基底激励: x 向 prescribed 加速度 = value × amplitude(t) |
| `*Amplitude` | (t, a) 曲线 | 直接求解器直接插值; MOOSE 用 PiecewiseLinear csv |
| `*Dynamic` | 时间步参数 | dt, T → Newmark (直接求解器) / Newmark+HHT (MOOSE) |
| `*Dsload` 等荷载 | 面荷载 | report.steps[].loads |
| `*Output / *Node Output / *Element Output` | 输出请求 | 不转换 (求解器自行输出全部位移/转角) |
| `*Spectrum / *Baseline Correction` | 反应谱/基线修正 | **不转换** (时程积分直接用幅值曲线, 无需反应谱) |
| `*Restart / *Preprint / *Heading` | 管理信息 | 忽略 |

### 2.5 幅值预缩放 (MOOSE bug 规避)

MOOSE `PresetAcceleration` 的 `scale_factor` **不被使用** (源码 bug:
computeQpValue 只取 function.value)。因此加速度幅值必须预先乘进
csv/Function 数据 (如 3920 × RG-X 谱 → rg_x_3920.csv)。直接求解器
无此问题 (scale 在插值时生效)。

## 3. 有限元计算 (两条求解路径)

### 路径 A: MOOSE (hongchuang-opt) — 首选, 但大模型慢

```bash
tools/abaqus_pipeline.sh --inp job.inp --name <case> --moose-i inputs/<case>.i
```

- .i 依据 report.json 手工/半自动编写 (梁算例参考 `tools/gen_beam_case.py`
  与 `inputs/pr_rg_400gal_x.i`; 实体+钢筋算例参考 `inputs/abaqus_6_15.i`)
- **必须 `solve_type = NEWTON`** (LINEAR 对梁模型数值不稳定 → NaN)
- 性能参考: i5-1038NG7 约 200μs/单元-核, 756 梁单元 6500 步需 15h+
  → 大模型不可行时用路径 B, MOOSE 只跑短窗口对照 (如 1s)

### 路径 B: 直接求解器 (tools/beam_direct_solver.py) — 梁模型实用路径

```bash
python3 tools/beam_direct_solver.py \
    --report outputs/<case>/report.json \
    --mesh   outputs/<case>/<case>_mesh.e \
    --out    outputs/<case>/<case>_out.e \
    --csv    outputs/<case>/<case>_top.csv \
    [--no-releases]        # 端部释放使模型近机构时忽略
```

- 精确组装 K/M/C + MPC 约束消元 + Newmark + 稀疏 LU 一次分解
- 6500 步约 10-15 分钟; 输出前 6 阶自振频率 (合理性检查: 对比 Abaqus 特征值)
- 与 MOOSE 短窗对照差异 ~13-28% (主要来自 MPC 处理: 精确消元 vs 刚性连杆)
- 线弹性体系专用; 非线性材料需走路径 A

### 求解后处理

```bash
# 相对位移 (减基底刚体运动)
python3 tools/make_relative_disp.py outputs/<case>/<case>_out.e
# 钢筋宿主插值重构 (仅钢筋算例)
python3 tools/build_rebar_result.py --mesh ... --result ... --render-map ... --report ... --out rebar_result.e
# 渲染 (pvpython; 复制 tools/render_pr_rg_400gal_x.py 定制相机/色标)
pvpython tools/render_<case>.py outputs/<case>/<case>_out.e
pvpython tools/render_<case>.py outputs/<case>/<case>_rel.e
```

## 4. 强制审核过程 (每次转换必须)

`tools/convert_audit.py` 已接入 `abaqus_pipeline.sh` 阶段 1.5,
FAIL 即中断流水线 (退出码 1)。审核项:

| # | 审核项 | 判定 |
|---|---|---|
| 1 | `*MPC` 约束提取 | inp 约束行数 == report.mpcs 条数 |
| 2 | 约束连杆生成 | report.constraints 每条 status=ok 且 links>0 |
| 3 | 约束命名 | 无 `** Constraint:` 名 → WARN (建议补注释) |
| 4 | `*Mass` 集中质量 | 数量+数值与 report.point_mass 一致 |
| 5 | `*Rotary Inertia` | 数量一致 |
| 6 | `*Nonstructural Mass` | 数量一致 |
| 7 | `*Beam Section` | (材料,截面) 组合全覆盖 |
| 8 | 梁单元总数 | inp B31 数 == report 单元数 − MPC 连杆数 |
| 9 | `*Material` | 名称全覆盖 |
| 10 | `*Amplitude` | 全部提取且数据非空 |
| 11 | `*Boundary` (步内) | 行数一致 |
| 12 | `*RELEASE` | 有释放行则必须解析到单元 |
| 13 | `*Dynamic` | 动力步参数存在 |

单独运行: `tools/convert_audit.py --inp job.inp --report outputs/<case>/report.json`

## 5. 已知坑 (三个算例复盘)

1. **约束静默丢失** (本次客户反馈): 已改为硬失败 + 审核项 1-3。
2. MOOSE PresetAcceleration scale_factor 无效 → 幅值预缩放 (2.5 节)。
3. MOOSE solve_type=LINEAR 梁模型发散 → 必须 NEWTON。
4. 梁 y_orientation 必须 ⊥ 轴向 → 转换器自动按方向分块。
5. *RELEASE 全释放可能使结构近机构 (f1≈0.007Hz) — 检查自振频率,
   非物理时 `--no-releases` 按刚接处理并在算例报告记录。
6. 非结构质量按 elset 整块覆盖时直接并入块密度 (ρ_eff)。
