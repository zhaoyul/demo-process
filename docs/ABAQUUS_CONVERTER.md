# Abaqus → MOOSE 数据转换工具

> 算例: Abaqus job `6-15` (model `LW-Copy`) — AAC 砌体墙拟静力试验
> 工具: `tools/abaqus2exodus.py`
> 演示: `inputs/abaqus_6_15.i` + `tools/render_abaqus_6_15.py`

将 Abaqus 有限元模型（`.inp` 输入卡）转换为红创平台（MOOSE）可直接使用的
**Exodus II** 数据结构，并复用平台现有渲染机制生成分析结果视频。

---

## 一、流水线总览

```
/home/kevin/Abaqus/6-15.inp
        │
        ▼  tools/abaqus2exodus.py (解析 + 装配 + 节点合并)
outputs/abaqus_6_15/6-15_mesh.e        ← Exodus II 网格 (MOOSE FileMesh 直读)
outputs/abaqus_6_15/report.json        ← 材料/边界/荷载/分析步 报告
        │
        ▼  bin/hongchuang-opt -i inputs/abaqus_6_15.i (MOOSE 求解)
inputs/abaqus_6_15_out.e               ← Exodus II 结果 (位移/应力/损伤)
        │
        ▼  pvpython tools/render_abaqus_6_15.py (平台渲染机制)
renders/abaqus_6_15_vonmises.mp4       ← von Mises 应力动画
renders/abaqus_6_15_damage.mp4         ← 损伤演化动画
```

## 二、转换工具用法

```bash
# 需要 moose conda 环境 (netCDF4)
~/miniforge3/envs/moose/bin/python tools/abaqus2exodus.py \
    --inp /home/kevin/Abaqus/6-15.inp \
    --out outputs/abaqus_6_15/6-15_mesh.e \
    --report outputs/abaqus_6_15/report.json \
    --merge-tol 0.5
```

### 支持的 Abaqus 输入特性

| 特性 | 处理方式 |
|------|---------|
| `*Part` / `*Node` / `*Element` | C3D8R→HEX8 块, T3D2→TRUSS 块 |
| `*Instance` (平移+旋转) | 先平移后绕全局轴旋转（已对 6-15 实测验证）|
| `*Solid Section` | part×material 单元分块 |
| `*Nset`/`*Elset` (含 `generate`, instance 限定) | → Exodus nodesets |
| `*Surface` (ELEMENT 面) | 面单元节点并集 → nodesets (`SURF_*` 前缀) |
| `*Tie` 绑定约束 | 跨 instance 重合节点合并 (`--merge-tol`) |
| `*Material` (Density/Elastic/CDP 全套) | 导出至 JSON 报告 |
| `*Amplitude` / `*Step` / `*Boundary` / `*Dsload` | 导出至 JSON 报告 |

### 名称规范

- 单元块: `<part>__<material>`（超长自动缩短为 ≤28 字符，Exodus/MOOSE 安全长度）
- nodesets: 原名（`_` 清洗），surface 加 `SURF_` 前缀，elset 加 `ELSET_` 前缀

## 三、6-15 算例映射

| Abaqus 实体 | 含义 | MOOSE 映射 |
|------------|------|-----------|
| `kuang` (C40+M60) | 混凝土框架 (顶梁/底梁/构造柱) | `kuang__C40`, `kuang__M60` 块, 线弹性 |
| `BB-qikuai` (aac705) | AAC 砌块 ×7 | `BB_qikuai__aac705` 块, 弹性+scalar damage |
| `DD-gujiangliao` (M60) | 灌浆料/灰缝 ×3 | `DD_gujiangliao__M60` 块, 线弹性 |
| 各 `T3D2` 钢筋 part | 顶梁/底梁箍筋纵筋、连接筋 | TRUSS 块 (求解时 `BlockDeletionGenerator` 移除, 渲染叠加) |
| `BC-1` ENCASTRE `_PickedSet833@kuang-1` | 框架底面固支 | `DirichletBC` ×3 on nodeset |
| `Load-1` 压力 0.5MPa `_PickedSurf829` | Step-1 顶面竖向荷载 | `Pressure` BC + ramp 函数 |
| `BC-2` + `Amp-1` (±16/±20mm) | Step-2 水平循环位移 | `FunctionDirichletBC` + PiecewiseLinear |
| cohesive 接触 (灰缝) | 砌块间粘结开裂 | **简化**: 单体化 + prescribed damage 演化 |

> **简化声明**: Abaqus 模型中砌块间 cohesive 接触与钢筋 embedded 约束在 MOOSE
> 演示模型中被简化为单体连续介质 + 预设损伤演化函数（与 w03 算例同机制）。
> 该演示验证数据转换与流水线贯通，不追求与 Abaqus 逐点结果一致。

## 四、求解与渲染

```bash
# 求解 (~25 min, 40 步)
cd outputs/abaqus_6_15
../../bin/hongchuang-opt -i ../../inputs/abaqus_6_15.i

# 渲染 (需桌面 X 会话: DISPLAY=:0)
DISPLAY=:0 ~/miniforge3/envs/moose/bin/pvpython tools/render_abaqus_6_15.py
```

渲染输出:

- `renders/abaqus_6_15_vonmises.mp4` — von Mises 应力云图 + 变形动画 (×15)
- `renders/abaqus_6_15_damage.mp4` — 损伤指数云图 (灰缝开裂演化)

## 五、关于 .odb 结果文件

`6-15.odb` (3.5GB) 为 Abaqus 专有二进制格式，本机无 Abaqus/odbAccess，
无法直接读取。本方案通过解析 `.inp` 重建模型并在 MOOSE 中重算获得结果场。
若后续需要导入 Abaqus 原始结果，需在有 Abaqus 的环境用
`abaqus python` + `odbAccess` 导出为中间格式（如 CSV/VTK）后再映射到本网格。
