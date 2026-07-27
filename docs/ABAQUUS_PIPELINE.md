# Abaqus → MOOSE 转换流水线复盘与复用指南

> 来源: bead de-96v, 2026-07-23/24, 算例 6-15 (AAC 砌体墙拟静力)
> 可复用入口: **`tools/abaqus_pipeline.sh`**
> 详细工具文档: `docs/ABAQUUS_CONVERTER.md`

---

## 一、07-23/24 提交时间线 (8 commits)

| 时间 | 提交 | 内容 |
|------|------|------|
| 07-23 16:50 | `54a4c46` | **v1 全流程打通**: `abaqus2exodus.py` 转换器 (Part/Instance 装配、C3D8R→HEX8、T3D2→TRUSS、节点合并等效 *Tie、材料/幅值/步 JSON 报告) + `abaqus_6_15.i` MOOSE 算例 + pvpython 渲染 + 两条 MP4 |
| 07-23 17:33 | `3ad15ad` | 输出目录 readme |
| 07-23 20:52 | `146c7f5` | **v2 约束完整映射**: *Tie×9 节点缝合 (防翻转 det(J)>0 校验)、*Embedded 钢筋缝合进求解、*Coupling→整体 Dirichlet、钢筋 LinearElasticTruss 刚度、求解器改 MUMPS |
| 07-24 04:32 | `b3fae24` | gitignore 维护 |
| 07-24 11:00 | `11f736e` | **v3 位移耦合与几何显示分离**: 求解保持缝合 + 新增 truss_stress 输出; 新增 `build_rebar_result.py` 把结果回弹到原始直线钢筋几何 (`--render-map`) |
| 07-24 11:48 | `e07a4e2` | **钢筋位移改宿主单元形函数插值** u=ΣNᵢ·uᵢ (凸组合); 修复 MOOSE 输出节点/单元重排导致的跨文件映射错位 (按坐标匹配) |
| 07-24 16:55 | `bed228d` | **v4 零断点 + 弹塑性应力**: 求解网格不缝合不删除零长单元 (纯实体求解, 6110 钢筋单元全部保留); 应力按 inp *Plastic 弹塑性曲线屈服截断 |

## 二、问题反馈与解决方案 (按客户反馈轮次)

| # | 反馈/问题 | 根因 | 解决方案 | 可复用经验 |
|---|----------|------|---------|-----------|
| 1 | v1 视频中钢筋与墙体分离，不随墙体变形 | 钢筋未参与求解，仅作几何叠加 | v2: 三类 Abaqus 约束全部映射 (*Tie→节点缝合, *Embedded→共享自由度, *Coupling→整体 Dirichlet) | **约束映射是转换的核心工作量**；几何转换只是起点 |
| 2 | 钢/混凝土刚度差异大，AMG 求解崩溃 | 刚度矩阵条件数过大 | 换 MUMPS 直接求解 | 多材料大刚度比 → 直接上 MUMPS，不要试 AMG |
| 3 | 钢筋出现非预期弯折 | 缝合把钢筋节点拉到最远 87mm 外的实体节点 | v3: 位移耦合与几何显示分离 — 求解释放缝合，`--render-map` 记录原始几何，后处理回弹 | **求解保真与显示保形分离** |
| 4 | 钢筋云图应力为零 | truss 未输出应力变量 | MOOSE 增加 `truss_stress` (axial_stress) 输出 | 交付前检查每个交付变量的非零性 |
| 5 | 钢筋探出墙体轮廓 + 直线变折线 | 渲染取缝合节点位移，采样点偏离实际位置 | 宿主单元形函数插值 u=ΣNᵢ·uᵢ（凸组合 ⇒ 不越界；场平滑 ⇒ 不折弯），与 *Embedded Element 运动学一致 | **凸组合插值是安全约束**：越界/折弯两类伪影同时消除 |
| 6 | 跨文件节点/单元引用错位 | MOOSE 输出 .e 会重排节点/单元编号（node_num_map 为 identity 但坐标顺序不同） | 跨文件一律按坐标最近邻 (cKDTree) 匹配，断言 max dist < 1e-3 | **永远不要跨 .e 文件用编号引用** |
| 7 | 钢筋笼"断开"（到处是缺口） | v2/v3 缝合产生 1078 个零长单元被删（占 18%），渲染映射排除这些单元 | v4: 纯实体求解（钢筋不进求解网格），全部 6110 单元做宿主插值重构 | 删除"坏"单元前，先问它们是否承载交付物 |
| 8 | 应力偏大（线弹性无上限 + 断点伪影） | 线弹性 σ=E·ε 无屈服上限 | 按 inp *Plastic 弹塑性曲线计算并屈服截断 (gangjin 300→360, HPB400 400→540) | 后处理应力也应尊重材料本构 |
| 9 | MOOSE 原生嵌入约束/MPC 求解失败 | EqualValueEmbeddedConstraint / LinearNodalConstraint ×17k 导致 MUMPS 零主元（约束结构病态） | 弃用求解器侧嵌入约束，改后处理侧宿主插值 | **大规模等式约束慎用**；能后处理就不要进求解器 |
| 10 | Pressure BC 崩溃 | `SideSetsFromNodeSetsGenerator` 未限定 nodesets，共享表面节点的 truss 0D 侧面混入 | `nodesets_to_convert` 显式限定压力面 | 网格生成器对混合维度网格要显式限定作用域 |

## 三、复用流程 (新算例 checklist)

```bash
# 一条命令跑全流程 (前提: .i 已按新算例编写, 见下)
tools/abaqus_pipeline.sh --inp /path/to/new.inp --name new_case \
    --moose-i inputs/new_case.i --render-script tools/render_new_case.py
```

### 阶段 0 — 算例调研 (人工, ~30min)
- 读 inp: part/instance 数量、单元类型、材料数、约束类型 (*Tie/*Embedded/*Coupling/接触)、Step/幅值/荷载
- 确认本机无 Abaqus ⇒ 走"解析 inp 重建 + MOOSE 重算"路线，.odb 不进 git

### 阶段 1 — 转换 (自动)
```bash
tools/abaqus_pipeline.sh --inp ... --name ... --skip-solve
```
- 产物: `outputs/<name>/<name>_mesh.e` + `report.json` + `rebar_render_map.json`
- **审查 report.json**: 材料参数是否齐全、nodesets 命名、幅值表 — 这是写 .i 的依据
- 容差调参: `--merge-tol` (instance 内重合节点, 默认 0.5mm), `--tie-tol` (*Tie 面间距, 默认 20mm)

### 阶段 2 — 编写 MOOSE .i (人工, 核心工作)
按 `inputs/abaqus_6_15.i` 模板 + 本文件第二节对照表映射:
- FileMesh 直读 mesh.e; 块名 `<part>__<material>`
- 材料: 弹性 + 损伤按 report.json；钢筋 truss 块不进求解网格时可省略
- BC: ENCASTRE→Dirichlet×3; 压力→Pressure+ramp; 位移幅值→FunctionDirichletBC+PiecewiseLinear
- 求解器: **MUMPS** (petsc `-pc_type lu`)
- `SideSetsFromNodeSetsGenerator` 加 `nodesets_to_convert` 限定
- 输出: `truss_stress` 等交付变量显式列出

### 阶段 3 — 求解 + 钢筋重构 (自动)
- 收敛判据参考: 40/40 步, ~20min (MUMPS)
- 钢筋后处理自动做宿主插值 + 弹塑性应力；检查输出 "应力范围" 是否落在屈服限值内

### 阶段 4 — 渲染 (半人工)
- 复制 `tools/render_abaqus_6_15.py` → 改: 相机中心 (用 mesh bbox)、SOLID/TRUSS 块名、色标范围、warp 倍数
- `DISPLAY=:0 pvpython` 需要桌面 X 会话

### 阶段 5 — 交付验证 checklist
- [ ] 求解日志全步收敛
- [ ] 每个交付变量非零且量级合理 (对比 Abaqus .dat/.sta 文本参考)
- [ ] 钢筋位移在实体 bbox 内 (凸组合保证, 仍抽查)
- [ ] 视频变形连续、无断裂伪影
- [ ] 输出目录 readme.txt 写明产物清单与复现命令

## 四、环境约定

| 依赖 | 路径 |
|------|------|
| python (netCDF4/scipy) | `~/miniforge3/envs/moose/bin/python` (可用 `MOOSE_PY` 覆盖) |
| pvpython | `~/miniforge3/envs/moose/bin/pvpython` (`MOOSE_PVPYTHON`) |
| MOOSE 求解器 | `bin/hongchuang-opt` (`HONGCHUANG_OPT`) |
| Abaqus 数据源 | `/home/kevin/Abaqus/` (外部引用, 大文件不进 git) |
