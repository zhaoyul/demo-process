abaqus_8elc — Abaqus 8elc 排架-槽身结构地震响应 (El Centro 三向)
================================================================

源模型: /home/kevin/Abaqus/0724-8elc/8elc.inp (GBK, 已转 UTF-8 /tmp/8elc_utf8.inp)
  排架 paijia (con, 32890 hex) + 槽身 caoshen_dangkuai (con, 3499 hex)
  + 钢梁 gangliang ×5 (steel, 350 hex) + 钢筋 T3D2 ×10 块 (21381 单元)
  Step-1 静力重力 + Step-2 ELC 三向基底加速度 (0.80g/0.68g/0.52g, 13.75s)

流水线 (docs/ABAQUUS_PIPELINE.md):
  1. 转换: tools/abaqus_pipeline.sh --inp /tmp/8elc_utf8.inp --name abaqus_8elc --skip-solve \
       --add-nodeset 'CAOSHEN_TOP:caoshen_dangkuai__con:z>=3940' \
       --add-nodeset 'GL_BOTTOM:gangliang__steel:z<=3946'
  2. 界面缝合 (接触对 Int-1/2 + GL *Tie 补充):
     tools/stitch_interface.py ... --stitch 'SURF__PickedSurf2150 SURF__PickedSurf2151 : paijia__con' \
       --stitch 'GL_BOTTOM : caoshen_dangkuai__con' --tol 30
     (259+20 对, 防翻转回滚 0; 跨空段正确跳过)
  3. 求解: mpiexec -n 6 bin/hongchuang-opt -i inputs/abaqus_8elc.i
     (800 步 dt=0.005 强震段 0-4s, Newmark β=0.25, MUMPS, ~108 min)
  4. 钢筋后处理: tools/build_rebar_result.py --mesh ... --result ... (21381 单元全保留)
  5. 渲染: DISPLAY=:0 pvpython tools/render_abaqus_8elc.py

产物清单:
  abaqus_8elc_mesh.e        转换+缝合后 Exodus 网格 (求解用, 含界面 nodesets)
  abaqus_8elc_out.e         MOOSE 求解结果 (disp/vel/accel + vonmises, 801 步, 2.9GB)
  abaqus_8elc_out.csv       极值时间历程 (disp_x/z_max, vonmises_max)
  rebar_result.e            钢筋重构 (原始几何 + 宿主插值位移 + 弹塑性应力)
  rebar_render_map.json     原始钢筋几何映射 (abaqus2exodus --render-map)
  report.json               材料/边界/幅值/分析步报告
  amp_{X,Y,Z}.csv           三向地震动幅值 (原始采样 dt=0.00125, 截取 0-4.2s)
  abaqus_8elc_solve.log     求解日志 (800/800 收敛)
  mpc_interface.i           LinearNodalConstraint 试验片段 (未采用, 见下)

关键结果:
  顶点相对基底位移: x 峰值 6.96 mm @ t=2.65s (与 X 向 0.8g 峰值同期)
  vonmises 峰值 ~22 MPa (柱脚); 钢筋应力 [-408, 411] MPa (屈服截断内)
  基底运动即地震动位移 (El Centro 0-4s 段位移时程, 物理正确)

简化与决策 (详见 docs/ABAQUUS_PIPELINE.md 第四节增补):
  - con CDP / steel *Plastic → 线弹性 (钢筋后处理保留弹塑性截断)
  - 接触 Int-1/2 → 网格缝合; Int-3..6 侧向接触 → 忽略
  - 钢梁不施加重力 (部分缝合下重力致铰接伪影)
  - 约束路线否决: TiedValueConstraint 收敛慢且失收; LinearNodalConstraint
    本版 MOOSE Newton 方向不降残差 → 回归网格缝合 (6-15 验证路线)
  - 分析时长: 13.75s 截取强震段 0-4s (隐式 MUMPS 成本约束)

增补 (2026-07-27 晚):
  abaqus_8elc_out_rel.e    相对位移版结果 (tools/make_relative_disp.py 去刚体地面运动)
  rebar_result_rel.e       相对位移版钢筋重构 (渲染用, 结构原地振动不出画)
  视频 (renders/): abaqus_8elc_vonmises.mp4 (柱脚应力峰值 ~10MPa 色标),
                   abaqus_8elc_accel.mp4 (加速度幅值)
