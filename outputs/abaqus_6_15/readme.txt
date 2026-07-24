================================================================================
Abaqus 6-15 (LW-Copy) → MOOSE 转换算例 — 输出文件说明
红创科技多物理场仿真平台 | 生成日期: 2026-07-23 | Bead: de-96v
================================================================================

源数据: /home/kevin/Abaqus/6-15.inp (Abaqus 2024 输入卡)
模型:   AAC 砌体墙拟静力试验 — C40 混凝土框架 + AAC705 砌块 + M60 灌浆灰缝
        + 钢筋骨架; Step-1 顶面竖压 0.5 MPa, Step-2 ±16/±20mm 水平循环加载
单位:   mm - N - MPa

--------------------------------------------------------------------------------
文件清单
--------------------------------------------------------------------------------

6-15_mesh.e            (2.4 MB)  转换后的有限元网格 (Exodus II 格式)
                                 由 tools/abaqus2exodus.py 从 6-15.inp 生成
                                 24,072 节点 / 19,530 单元 / 14 个材料块
                                 (HEX8 实体 + TRUSS 钢筋) / 480 个 nodesets
                                 → MOOSE FileMesh 直接读取, 可用 ParaView 打开

abaqus_6_15_out.e      (37 MB)   MOOSE 求解结果 (Exodus II 格式)
                                 41 个时间步: 位移 disp_x/y/z,
                                 von Mises 应力, 损伤指数 damage_index,
                                 钢筋轴向应力 truss_stress (v3 新增)
                                 v3: 钢筋 TRUSS 块经节点缝合参与求解,
                                 峰值钢筋应力 p99 ≈ 300 MPa
                                 → 视频渲染的数据源, 可用 ParaView 打开

rebar_result.e         (7.6 MB)  钢筋结果 (Exodus II, v4)
                                 全部 6110 个钢筋单元 (零删除无断点),
                                 原始直线几何 + 宿主单元插值位移 +
                                 弹塑性应力 (inp *Plastic 曲线,
                                 gangjin/HPB400, 屈服截断 ≤400 MPa)

rebar_render_map.json  (1.9 MB)  钢筋渲染映射 (转换器 --render-map 导出)

abaqus_6_15_out.csv    (1.3 kB)  后处理器时间历程 (CSV)
                                 load_disp_x (顶面水平位移), vonmises_max,
                                 damage_max 随时间的变化曲线数据

abaqus_6_15_solve.log  (256 kB)  MOOSE 求解日志
                                 40/40 步全部收敛, 总耗时约 23 分钟

report.json            (62 kB)   转换报告 (JSON)
                                 材料参数 (E/ν/CDP 曲线), 单元块统计,
                                 nodesets 清单, 边界条件/荷载/幅值/分析步
                                 的 Abaqus→MOOSE 映射明细

--------------------------------------------------------------------------------
如何复现
--------------------------------------------------------------------------------

1. 转换 (需 moose conda 环境的 netCDF4):
   ~/miniforge3/envs/moose/bin/python tools/abaqus2exodus.py \
       --inp /home/kevin/Abaqus/6-15.inp \
       --out outputs/abaqus_6_15/6-15_mesh.e \
       --report outputs/abaqus_6_15/report.json

2. 求解 (~23 分钟):
   cd outputs/abaqus_6_15
   ../../bin/hongchuang-opt -i ../../inputs/abaqus_6_15.i
   (求解器: MUMPS 直接求解 — 钢/混凝土刚度差异大, AMG 不适用)

3. 重构钢筋结果 + 渲染视频 (需桌面 X 会话):
   ~/miniforge3/envs/moose/bin/python tools/build_rebar_result.py
   DISPLAY=:0 ~/miniforge3/envs/moose/bin/pvpython tools/render_abaqus_6_15.py
   输出: renders/abaqus_6_15_vonmises.mp4, renders/abaqus_6_15_damage.mp4

详细文档: docs/ABAQUUS_CONVERTER.md
================================================================================
