#!/usr/bin/env python3
"""convert_audit.py — Abaqus→Exodus 转换强制审核 (mandatory conversion audit)

对比 .inp 源文件字段清单与 abaqus2exodus.py 的 report.json, 逐项核对
关键字段是否被完整提取。任何 FAIL 都以退出码 1 阻断流水线 ——
宁可转换失败, 也不交付缺字段的模型 (客户曾因此发现约束丢失)。

审核项:
  1. 约束 (*MPC / '** Constraint:'): 每条约束必须解析且生成连杆
  2. 集中质量 (*Mass) 与转动惯量 (*Rotary Inertia)
  3. 非结构质量 (*Nonstructural Mass)
  4. 梁截面 (*Beam Section)
  5. 材料 (*Material)
  6. 幅值曲线 (*Amplitude)
  7. 边界条件 (分析步内 *Boundary)
  8. 端部释放 (*RELEASE)
  9. 动力分析步 (*Dynamic)

用法:
  tools/convert_audit.py --inp job.inp --report outputs/<name>/report.json
退出码: 0 = 全部通过; 1 = 存在 FAIL 项
"""

import argparse
import json
import re
import sys

# 需要统计数据行的关键字 (小写, 不含星号)
TRACKED = {
    'mpc', 'mass', 'rotary inertia', 'nonstructural mass',
    'beam section', 'material', 'amplitude', 'boundary', 'release',
    'dynamic', 'tie', 'coupling', 'embedded element',
}


def inventory_inp(path):
    """轻量 .inp 扫描: 关键字数据行计数 + 关键字段提取"""
    inv = {k: 0 for k in TRACKED}
    materials, amplitudes, beam_elsets = [], [], []
    mass_values, rotary_count = [], 0
    constraints = []            # '** Constraint:' 注释名
    beam_sec_pairs = []         # (material, section)
    elem_counts = {}            # 单元类型 -> 行数
    boundary_in_step = 0
    in_step = False
    pending = None              # 暂存的 constraint 注释

    with open(path, encoding='utf-8', errors='ignore') as f:
        for raw in f:
            ln = raw.strip()
            if not ln:
                continue
            if ln.startswith('**'):
                cm = re.match(r'^\*\*\s*Constraint:\s*(.+?)\s*$', ln)
                if cm:
                    pending = cm.group(1)
                continue
            if ln.startswith('*'):
                kw = ln[1:].split(',')[0].strip().lower()
                kv = dict(re.findall(r'(\w[\w ]*?)\s*=\s*([^,]+)',
                                     ln.split(',', 1)[1] if ',' in ln else ''))
                kv = {k.strip().lower(): v.strip() for k, v in kv.items()}
                if kw == 'step':
                    in_step = True
                elif kw == 'end step':
                    in_step = False
                elif kw == 'material':
                    materials.append(kv.get('name', ''))
                elif kw == 'amplitude':
                    amplitudes.append(kv.get('name', ''))
                elif kw == 'beam section':
                    beam_elsets.append(kv.get('elset', ''))
                    beam_sec_pairs.append((kv.get('material', ''),
                                           kv.get('section', '')))
                elif kw == 'element':
                    et = kv.get('type', '?').upper()
                    elem_counts.setdefault(et, 0)
                    cur = ('__elem__', et)
                    pending = None
                    continue
                elif kw == 'mpc':
                    constraints.append(pending)
                pending = None
                cur = kw if kw in TRACKED else None
                continue
            # 数据行
            if isinstance(cur, tuple) and cur[0] == '__elem__':
                elem_counts[cur[1]] += 1      # 每行一个单元 (首列单元号)
                continue
            if cur == 'boundary' and not in_step:
                cur = None            # 只统计分析步内边界
                continue
            if cur is None:
                continue
            inv[cur] += 1
            if cur == 'mass':
                try:
                    mass_values.append(float(ln.rstrip(',').split(',')[0]))
                except ValueError:
                    pass
            elif cur == 'rotary inertia':
                rotary_count += 1
    inv['boundary'] = boundary_in_step or inv['boundary']
    return {
        'counts': inv,
        'materials': [m for m in materials if m],
        'amplitudes': [a for a in amplitudes if a],
        'beam_elsets': beam_elsets,
        'mass_values': mass_values,
        'rotary_count': rotary_count,
        'constraints': constraints,
        'beam_sec_pairs': beam_sec_pairs,
        'elem_counts': elem_counts,
    }


def main():
    ap = argparse.ArgumentParser(description='转换强制审核: inp vs report.json')
    ap.add_argument('--inp', required=True)
    ap.add_argument('--report', required=True)
    args = ap.parse_args()

    inv = inventory_inp(args.inp)
    with open(args.report, encoding='utf-8') as f:
        rep = json.load(f)
    rep_text = json.dumps(rep, ensure_ascii=False)

    results = []   # (级别 PASS/WARN/FAIL, 审核项, 说明)

    def check(ok, item, detail, warn=False):
        lvl = 'PASS' if ok else ('WARN' if warn else 'FAIL')
        results.append((lvl, item, detail))
        return ok

    # 1. 约束 (*MPC) — 本次客户反馈的核心
    n_mpc_inp = inv['counts']['mpc']
    mpcs = rep.get('mpcs', [])
    audit = rep.get('constraints', [])
    check(len(mpcs) == n_mpc_inp, '*MPC 约束提取',
          f"inp {n_mpc_inp} 条 / report {len(mpcs)} 条")
    if audit:
        bad = [c for c in audit if c.get('status') != 'ok']
        check(not bad, '约束连杆生成',
              f"{sum(c['links'] for c in audit)} 根连杆 / "
              f"{len(audit)} 条约束全部解析"
              if not bad else
              f"未解析: {[c['name'] or c['slave'] for c in bad]}")
        unnamed = [c for c in audit if not c.get('name')]
        if unnamed:
            check(False, '约束命名 (** Constraint: 注释)',
                  f"{len(unnamed)} 条约束无名称注释 (建议追溯来源)", warn=True)
    elif n_mpc_inp:
        check(False, '约束审核记录', 'report.json 缺 constraints 字段 '
              '(转换器版本过旧?)')

    # 2. 集中质量 / 转动惯量
    pm = rep.get('point_mass', [])
    pm_mass = [p for p in pm if p.get('kind') == 'mass']
    pm_rot = [p for p in pm if p.get('kind') == 'rotary']
    n_mass_inp = len(inv['mass_values'])
    check(len(pm_mass) == n_mass_inp, '*Mass 集中质量',
          f"inp {n_mass_inp} / report {len(pm_mass)}")
    if n_mass_inp and len(pm_mass) == n_mass_inp:
        inp_v = sorted(inv['mass_values'])
        rep_v = sorted(p.get('mass', 0) for p in pm_mass)
        check(all(abs(a - b) <= 1e-6 * max(abs(a), 1) for a, b in zip(inp_v, rep_v)),
              '集中质量数值', f"inp={inp_v} report={rep_v}")
    check(len(pm_rot) == inv['rotary_count'], '*Rotary Inertia 转动惯量',
          f"inp {inv['rotary_count']} / report {len(pm_rot)}")

    # 3. 非结构质量
    check(len(rep.get('nonstructural_mass', [])) == inv['counts']['nonstructural mass'],
          '*Nonstructural Mass',
          f"inp {inv['counts']['nonstructural mass']} / "
          f"report {len(rep.get('nonstructural_mass', []))}")

    # 4. 梁截面: (材料, 截面) 组合覆盖 + 梁单元总数核对
    bs = rep.get('beam_sections', {})
    rep_pairs = {(v.get('material'), v.get('section'))
                 for v in bs.values() if v.get('section') != 'RIGID'}
    missing_p = [p for p in set(inv['beam_sec_pairs']) if p not in rep_pairs]
    check(not missing_p, '*Beam Section 截面',
          f"inp {len(inv['beam_sec_pairs'])} 个 (材料,截面) 组合全部覆盖"
          if not missing_p else f"(材料,截面) 未覆盖: {missing_p}")
    n_beam_inp = sum(c for t, c in inv['elem_counts'].items()
                     if t.startswith('B3') or t.startswith('B2'))
    if n_beam_inp:
        n_links = len(rep.get('mpc_links', []))
        n_elem_rep = sum(b['count'] for b in rep.get('blocks', {}).values())
        check(n_elem_rep - n_links == n_beam_inp, '梁单元总数',
              f"inp {n_beam_inp} / report {n_elem_rep - n_links} "
              f"(总 {n_elem_rep} - MPC连杆 {n_links})")

    # 5. 材料
    mats = set(rep.get('materials', {}))
    missing_m = [mname for mname in inv['materials'] if mname not in mats]
    check(not missing_m, '*Material 材料',
          f"{len(mats)}/{len(inv['materials'])} 覆盖"
          if not missing_m else f"缺失: {missing_m}")

    # 6. 幅值
    amps = rep.get('amplitudes', {})
    missing_a = [a for a in inv['amplitudes']
                 if a not in amps or not amps[a]]
    check(not missing_a, '*Amplitude 幅值曲线',
          f"{len(inv['amplitudes'])} 条全部提取且非空"
          if not missing_a else f"缺失/为空: {missing_a}")

    # 7. 边界条件 (分析步内)
    n_bc = sum(len(s.get('boundaries', [])) for s in rep.get('steps', []))
    check(n_bc == inv['counts']['boundary'], '*Boundary 边界条件',
          f"inp {inv['counts']['boundary']} 行 / report {n_bc} 条")

    # 8. 端部释放
    n_rel = inv['counts']['release']
    if n_rel:
        check(len(rep.get('releases_global', [])) > 0, '*RELEASE 端部释放',
              f"inp {n_rel} 行 / 解析到单元 {len(rep.get('releases_global', []))} 处")

    # 9. 动力分析步
    if inv['counts']['dynamic']:
        dyn = [s for s in rep.get('steps', []) if 'dynamic' in s]
        check(bool(dyn), '*Dynamic 动力步',
              f"{len(dyn)} 个分析步含 dynamic 参数")

    # 输出
    width = max(len(item) for _, item, _ in results) if results else 10
    print(f"=== 转换审核: {args.inp}")
    n_fail = 0
    for lvl, item, detail in results:
        mark = {'PASS': '✓', 'WARN': '⚠', 'FAIL': '✗'}[lvl]
        if lvl == 'FAIL':
            n_fail += 1
        print(f"  {mark} [{lvl:4s}] {item.ljust(width)}  {detail}")
    if n_fail:
        print(f"=== 审核未通过: {n_fail} 项 FAIL — 阻断流水线")
        sys.exit(1)
    print("=== 审核通过 ✓")


if __name__ == '__main__':
    main()
