#!/usr/bin/env python3
"""abaqus2exodus.py — Abaqus .inp → Exodus II (MOOSE 兼容) 转换工具

红创科技多物理场仿真平台 / 数据接入工具

将 Abaqus 输入卡（.inp）解析并转换为 MOOSE 可直接读取的 Exodus II 网格文件：
  - Part/Instance 装配（含平移 + 旋转）
  - C3D8R → HEX8 实体单元块（按 part × material 分块）
  - T3D2  → TRUSS 钢筋单元块
  - Nset / Elset / Surface → Exodus nodesets（供 BC / 荷载 / 后处理引用）
  - 跨 instance 重合节点合并（等效 Abaqus *Tie 绑定约束）
  - 材料 / 幅值 / 分析步导出为 JSON 报告，供生成 MOOSE .i 使用

用法:
  python abaqus2exodus.py --inp /path/to/job.inp --out mesh.e \
      --report report.json --merge-tol 0.5

依赖: netCDF4 (moose conda env)
"""

import argparse
import json
import math
import re
import sys
from collections import defaultdict

# ---------------------------------------------------------------------------
# Abaqus 关键字解析
# ---------------------------------------------------------------------------

def _parse_kv(line):
    """解析 'name=value, name=value' 形式的参数串"""
    kv = {}
    for tok in line.split(','):
        tok = tok.strip()
        if not tok:
            continue
        if '=' in tok:
            k, v = tok.split('=', 1)
            kv[k.strip().lower()] = v.strip()
        else:
            kv[tok.lower()] = True
    return kv


def _nums(line):
    """解析逗号分隔的数值行"""
    out = []
    for tok in line.rstrip(',').split(','):
        tok = tok.strip()
        if tok:
            out.append(float(tok))
    return out


def _ids(line):
    return [int(float(t)) for t in line.rstrip(',').split(',') if t.strip()]


class Part:
    def __init__(self, name):
        self.name = name
        self.nodes = {}          # id -> (x, y, z)
        self.elems = {}          # id -> [node ids]
        self.etype = None
        self.nsets = {}
        self.elsets = {}
        self.sections = []       # [(elset, material, area)]


class Instance:
    def __init__(self, name, part):
        self.name = name
        self.part = part
        self.trans = (0.0, 0.0, 0.0)
        self.rot = None          # (ax,ay,az, bx,by,bz, angle_deg)
        self.data_lines = []     # 原始变换行


class InpModel:
    def __init__(self):
        self.parts = {}
        self.instances = []
        self.asm_nodes = {}      # assembly 级节点 (参考点)
        self.asm_nsets = {}
        self.asm_elsets = {}     # name -> [(instance, ids)] (instance 限定)
        self.asm_node_nsets = {} # nset name -> [(instance, ids)]
        self.surfaces = {}       # name -> [(instance, elset, face)]
        self.materials = defaultdict(dict)   # name -> {density, elastic, plastic, cdp...}
        self.amplitudes = {}
        self.steps = []
        self.ties = []
        self.couplings = []
        self.embedded = []


# Abaqus C3D8 各面的局部节点 (1-based, 仅用于取节点集合, 不关心绕向)
C3D8_FACES = {
    'S1': (1, 2, 3, 4),
    'S2': (5, 6, 7, 8),
    'S3': (1, 2, 6, 5),
    'S4': (2, 3, 7, 6),
    'S5': (3, 4, 8, 7),
    'S6': (1, 4, 5, 8),
}

# 材料子关键字 -> 报告字段名
MAT_KEYS = {
    'density': 'density',
    'elastic': 'elastic',
    'plastic': 'plastic',
    'concrete damaged plasticity': 'cdp',
    'concrete compression hardening': 'cdp_compression_hardening',
    'concrete tension stiffening': 'cdp_tension_stiffening',
    'concrete compression damage': 'cdp_compression_damage',
    'concrete tension damage': 'cdp_tension_damage',
}


def parse_inp(path):
    m = InpModel()
    with open(path, 'r', encoding='utf-8', errors='ignore') as f:
        raw = [ln.rstrip('\r\n') for ln in f]

    i = 0
    n = len(raw)
    cur_part = None          # 当前 part (Part)
    cur_inst = None          # 当前 instance
    in_assembly = False
    cur_mat = None
    cur_mat_key = None
    cur_amp = None
    cur_step = None
    cur_nset = None          # (dict, name, instance, is_generate, is_node)
    cur_surf = None

    def close_data_block():
        nonlocal cur_nset, cur_surf, cur_mat_key, cur_amp
        cur_nset = None
        cur_surf = None
        cur_mat_key = None
        cur_amp = None

    while i < n:
        line = raw[i]
        i += 1
        if not line.strip():
            continue
        if line.startswith('**'):
            continue
        if line.startswith('*'):
            kw_line = line[1:].strip()
            kw_name = kw_line.split(',')[0].strip().lower()
            kv = _parse_kv(kw_line[len(kw_line.split(',')[0]):].lstrip(','))
            close_data_block()

            if kw_name == 'part':
                cur_part = Part(kv['name'])
                m.parts[cur_part.name] = cur_part
            elif kw_name == 'end part':
                cur_part = None
            elif kw_name == 'assembly':
                in_assembly = True
            elif kw_name == 'end assembly':
                in_assembly = False
            elif kw_name == 'instance':
                cur_inst = Instance(kv['name'], kv['part'])
                m.instances.append(cur_inst)
            elif kw_name == 'end instance':
                cur_inst = None
            elif kw_name == 'node':
                cur_nset = ('nodes', None, kv.get('instance'), False)
            elif kw_name == 'element':
                if cur_part is not None:
                    cur_part.etype = kv.get('type', '').upper()
                cur_nset = ('elems', None, kv.get('instance'), False)
            elif kw_name in ('nset', 'elset'):
                name = kv.get('nset') or kv.get('elset')
                gen = 'generate' in kv
                inst = kv.get('instance')
                kind = 'nset' if kw_name == 'nset' else 'elset'
                cur_nset = (kind, name, inst, gen)
            elif kw_name == 'solid section':
                # 数据行在下一行 (桁架为截面积)
                data = ''
                while i < n and not raw[i].strip().startswith('*'):
                    if raw[i].strip() and not raw[i].startswith('**'):
                        data = raw[i].strip()
                    i += 1
                if cur_part is not None:
                    area = None
                    try:
                        vals = _nums(data)
                        area = vals[0] if vals else None
                    except ValueError:
                        pass
                    cur_part.sections.append(
                        (kv.get('elset'), kv.get('material'), area))
            elif kw_name == 'surface':
                name = kv.get('name')
                m.surfaces.setdefault(name, [])
                cur_surf = name
            elif kw_name == 'material':
                cur_mat = kv.get('name')
            elif kw_name == 'amplitude':
                cur_amp = kv.get('name')
                m.amplitudes[cur_amp] = []
            elif kw_name == 'step':
                cur_step = {'name': kv.get('name'), 'nlgeom': kv.get('nlgeom'),
                            'boundaries': [], 'loads': [], 'outputs': []}
                m.steps.append(cur_step)
            elif kw_name == 'end step':
                cur_step = None
            elif kw_name == 'static':
                if cur_step is not None:
                    # 下一行是步长控制
                    while i < n and (not raw[i].strip() or raw[i].startswith('**')):
                        i += 1
                    if i < n:
                        cur_step['static'] = _nums(raw[i])
                        i += 1
            elif kw_name == 'boundary':
                cur_nset = ('boundary', kv.get('amplitude'), 'type' in kv and kv.get('type'), False)
            elif kw_name == 'dsload':
                cur_nset = ('dsload', None, None, False)
            elif kw_name == 'tie':
                m.ties.append(dict(kv))
            elif kw_name == 'coupling':
                m.couplings.append(dict(kv))
            elif kw_name == 'embedded element':
                m.embedded.append(dict(kv))
            elif kw_name in MAT_KEYS and cur_mat is not None:
                cur_mat_key = MAT_KEYS[kw_name]
                m.materials[cur_mat].setdefault(cur_mat_key, [])
            elif kw_name in ('output', 'node output', 'element output',
                             'contact output', 'restart', 'preprint',
                             'heading', 'end instance', 'surface interaction',
                             'friction', 'surface behavior', 'cohesive behavior',
                             'damage initiation', 'damage evolution',
                             'damage stabilization', 'contact pair',
                             'el print', 'node print', 'monitor', 'controls',
                             'cload', 'dload', 'dsflux', 'kinematic'):
                # 已知但不需要数据行的关键字 (cload/dload 等如需可扩展)
                if kw_name == 'kinematic':
                    pass
                cur_nset = ('skip', None, None, False) if kw_name in (
                    'cload', 'dload') else cur_nset
            else:
                # 未识别关键字: 安全跳过其数据行由下一轮 * 处理
                pass
            continue

        # ---------------- 数据行 ----------------
        if cur_nset is not None:
            kind, name, inst, gen = cur_nset
            try:
                if kind == 'nodes':
                    vals = _nums(line)
                    nid = int(vals[0])
                    xyz = tuple(vals[1:4]) + (0.0,) * (3 - len(vals[1:4]))
                    if cur_inst is not None:
                        pass  # instance 内不会出现 *Node 数据 (part 内才有)
                    elif cur_part is not None and not in_assembly:
                        cur_part.nodes[nid] = xyz
                    else:
                        m.asm_nodes[nid] = xyz
                elif kind == 'elems':
                    vals = _ids(line)
                    if cur_part is not None:
                        cur_part.elems[vals[0]] = vals[1:]
                elif kind in ('nset', 'elset'):
                    ids = _ids(line)
                    if gen:
                        # generate: start, end, step
                        s, e = ids[0], ids[1]
                        st = ids[2] if len(ids) > 2 else 1
                        ids = list(range(s, e + 1, st))
                    tgt = None
                    if in_assembly and inst:
                        tgt = m.asm_node_nsets if kind == 'nset' else m.asm_elsets
                        tgt.setdefault(name, {})
                        tgt[name].setdefault(inst, [])
                        tgt[name][inst].extend(ids)
                    elif in_assembly:
                        tgt = m.asm_nsets if kind == 'nset' else m.asm_elsets
                        tgt.setdefault(name, []).extend(ids)
                    elif cur_part is not None:
                        tgt = cur_part.nsets if kind == 'nset' else cur_part.elsets
                        tgt.setdefault(name, []).extend(ids)
                elif kind == 'boundary':
                    vals = line.rstrip(',').split(',')
                    if cur_step is not None and len(vals) >= 3:
                        cur_step['boundaries'].append({
                            'set': vals[0].strip(),
                            'dof1': int(float(vals[1])),
                            'dof2': int(float(vals[2])),
                            'value': float(vals[3]) if len(vals) > 3 and vals[3].strip() else 0.0,
                            'amplitude': name,
                            'encastre': any('encastre' in v.lower() for v in vals[1:]),
                        })
                elif kind == 'dsload':
                    vals = line.rstrip(',').split(',')
                    if cur_step is not None and len(vals) >= 3:
                        cur_step['loads'].append({
                            'surface': vals[0].strip(),
                            'type': vals[1].strip(),
                            'value': float(vals[2]),
                        })
            except (ValueError, IndexError):
                pass
            continue

        if cur_surf is not None:
            parts = [t.strip() for t in line.rstrip(',').split(',') if t.strip()]
            if len(parts) == 2:
                m.surfaces[cur_surf].append((parts[0], parts[1].upper()))
            continue

        if cur_amp is not None:
            try:
                vals = _nums(line)
                m.amplitudes[cur_amp].extend(
                    [(vals[j], vals[j + 1]) for j in range(0, len(vals) - 1, 2)])
            except ValueError:
                pass
            continue

        if cur_mat_key is not None and cur_mat is not None:
            try:
                m.materials[cur_mat][cur_mat_key].append(_nums(line))
            except ValueError:
                pass
            continue

        # instance 变换行
        if cur_inst is not None:
            try:
                vals = _nums(line)
                if len(vals) == 3:
                    cur_inst.trans = tuple(vals)
                elif len(vals) == 7:
                    cur_inst.rot = tuple(vals)
            except ValueError:
                pass
            continue

    return m


# ---------------------------------------------------------------------------
# 装配: 变换 + 节点合并
# ---------------------------------------------------------------------------

def _rot_matrix(axis, angle_deg):
    ux, uy, uz = axis
    n = math.sqrt(ux * ux + uy * uy + uz * uz)
    if n == 0:
        return None
    ux, uy, uz = ux / n, uy / n, uz / n
    th = math.radians(angle_deg)
    c, s, t = math.cos(th), math.sin(th), 1 - math.cos(th)
    return [
        [t * ux * ux + c, t * ux * uy - s * uz, t * ux * uz + s * uy],
        [t * ux * uy + s * uz, t * uy * uy + c, t * uy * uz - s * ux],
        [t * ux * uz - s * uy, t * uy * uz + s * ux, t * uz * uz + c],
    ]


def transform_point(xyz, inst):
    # Abaqus *Instance 语义: 先平移, 再绕 (平移后坐标系中的) 轴 a→b 旋转
    # (旋转轴两点 a, b 以装配/全局坐标给出, 已用 6-15.inp 实测验证)
    tx, ty, tz = inst.trans
    x, y, z = xyz[0] + tx, xyz[1] + ty, xyz[2] + tz
    if inst.rot:
        ax, ay, az, bx, by, bz, ang = inst.rot
        R = _rot_matrix((bx - ax, by - ay, bz - az), ang)
        if R:
            px, py, pz = x - ax, y - ay, z - az
            x = R[0][0] * px + R[0][1] * py + R[0][2] * pz + ax
            y = R[1][0] * px + R[1][1] * py + R[1][2] * pz + ay
            z = R[2][0] * px + R[2][1] * py + R[2][2] * pz + az
    return (x, y, z)


MAX_NAME = 28  # Exodus/MOOSE 名称安全长度 (MOOSE 按 32 截断, 留余量防冲突)


def _shorten(s, budget=MAX_NAME):
    """超长名称智能缩短: 丢弃中间 token, 保留首 token + 末两个 token 保证区分度
    如 'AA_dinglaing_zongjin_D12' → 'AA_zongjin_D12'"""
    if len(s) <= budget:
        return s
    toks = s.split('_')
    if len(toks) > 2:
        s2 = toks[0] + '_' + '_'.join(toks[-2:])
        if len(s2) <= budget:
            return s2
    return s[:budget]


class NameSanitizer:
    """清洗名称并保证 ≤28 字符且全局唯一"""

    def __init__(self):
        self._seen = {}

    def __call__(self, name):
        s = re.sub(r'[^A-Za-z0-9_]', '_', str(name))
        s = _shorten(s)
        if s in self._seen and self._seen[s] != name:
            i = 2
            while f"{s[:MAX_NAME - 2]}_{i}" in self._seen:
                i += 1
            s = f"{s[:MAX_NAME - 2]}_{i}"
        self._seen[s] = name
        return s


_sanitize_global = NameSanitizer()


def sanitize(name):
    return _sanitize_global(name)


class GlobalMesh:
    """全局合并网格"""

    def __init__(self, tol):
        self.tol = tol
        self.coords = []          # global_id-1 -> (x,y,z)
        self._hash = {}
        self.node_map = {}        # (instance, local_id) -> global_id
        self.asm_node_map = {}    # assembly node id -> global_id
        self.merged_count = 0

    def add(self, key, xyz):
        h = (round(xyz[0] / self.tol), round(xyz[1] / self.tol),
             round(xyz[2] / self.tol))
        # 允许邻近 8 格碰撞检查
        for dx in (-1, 0, 1):
            for dy in (-1, 0, 1):
                for dz in (-1, 0, 1):
                    gid = self._hash.get((h[0] + dx, h[1] + dy, h[2] + dz))
                    if gid is not None:
                        gx, gy, gz = self.coords[gid - 1]
                        if (abs(gx - xyz[0]) <= self.tol and
                                abs(gy - xyz[1]) <= self.tol and
                                abs(gz - xyz[2]) <= self.tol):
                            self.node_map[key] = gid
                            self.merged_count += 1
                            return gid
        gid = len(self.coords) + 1
        self.coords.append(xyz)
        self._hash[h] = gid
        self.node_map[key] = gid
        return gid


def build_global_mesh(model, tol):
    gm = GlobalMesh(tol)
    blocks = defaultdict(list)    # block_name -> [(elem_global_id, [gids])]
    block_etype = {}
    block_meta = {}               # block -> (part, material)
    elem_counter = 0

    # 元素 -> 材料: part.sections (elset, material, area)
    for inst in model.instances:
        part = model.parts.get(inst.part)
        if part is None:
            print(f"  WARN: instance {inst.name} 引用不存在的 part {inst.part}",
                  file=sys.stderr)
            continue
        # 局部节点 -> 全局
        local2g = {}
        for nid, xyz in part.nodes.items():
            g = gm.add((inst.name, nid), transform_point(xyz, inst))
            local2g[nid] = g
        # 元素分块
        el2mat = {}
        for elset, material, area in part.sections:
            ids = part.elsets.get(elset, [])
            for eid in ids:
                el2mat[eid] = (material, area)
        for eid, conn in part.elems.items():
            elem_counter += 1
            mat, area = el2mat.get(eid, ('UNASSIGNED', None))
            if part.etype == 'C3D8R':
                exo_type = 'HEX8'
            elif part.etype == 'T3D2':
                exo_type = 'TRUSS'
            else:
                exo_type = part.etype or 'UNKNOWN'
            bname = sanitize(f"{_shorten(re.sub(r'[^A-Za-z0-9_]', '_', inst.part), MAX_NAME - len(str(mat)) - 2)}__{mat}")
            blocks[bname].append((elem_counter, [local2g[n] for n in conn]))
            block_etype[bname] = exo_type
            block_meta[bname] = (inst.part, mat)

    # assembly 级节点 (参考点)
    for nid, xyz in model.asm_nodes.items():
        g = gm.add(('__assembly__', nid), xyz)
        gm.asm_node_map[nid] = g

    # ---------------- nodesets ----------------
    nodesets = {}   # name -> sorted list of global ids

    # 1) assembly 级 nset (如 rp-1)
    for name, ids in model.asm_nsets.items():
        gids = [gm.asm_node_map.get(i) or gm.node_map.get(('__assembly__', i))
                for i in ids]
        nodesets[sanitize(name)] = sorted(g for g in gids if g)

    # 2) instance 限定的 nset/elset
    for name, per_inst in model.asm_node_nsets.items():
        for inst, ids in per_inst.items():
            gids = [gm.node_map.get((inst, i)) for i in ids]
            gids = [g for g in gids if g]
            if gids:
                nodesets[sanitize(f"{name}__{inst}")] = sorted(set(gids))
    for name, per_inst in model.asm_elsets.items():
        nodes = set()
        for inst, ids in per_inst.items():
            part = model.parts.get(model_inst_part(model, inst))
            if part is None:
                continue
            for eid in ids:
                for nid in part.elems.get(eid, []):
                    g = gm.node_map.get((inst, nid))
                    if g:
                        nodes.add(g)
        if nodes:
            nodesets[sanitize(f"ELSET_{name}")] = sorted(nodes)

    # 3) surfaces -> nodesets (面所属单元的面节点并集)
    for name, entries in model.surfaces.items():
        nodes = set()
        for elset_name, face in entries:
            # elset 是 instance 限定的 (elset_name 形如 __PickedSurf837_S2,
            # 在 asm_elsets 里有 instance 映射)
            per_inst = model.asm_elsets.get(elset_name, {})
            face_nodes = C3D8_FACES.get(face)
            for inst, eids in per_inst.items():
                part_name = model_inst_part(model, inst)
                part = model.parts.get(part_name)
                if part is None:
                    continue
                for eid in eids:
                    conn = part.elems.get(eid)
                    if not conn:
                        continue
                    if face_nodes and len(conn) >= 8:
                        sel = [conn[f - 1] for f in face_nodes]
                    else:
                        sel = conn
                    for nid in sel:
                        g = gm.node_map.get((inst, nid))
                        if g:
                            nodes.add(g)
        if nodes:
            nodesets[sanitize(f"SURF_{name}")] = sorted(nodes)

    return gm, blocks, block_etype, block_meta, nodesets


def model_inst_part(model, inst_name):
    for inst in model.instances:
        if inst.name == inst_name:
            return inst.part
    return None


# ---------------------------------------------------------------------------
# Exodus II 写出
# ---------------------------------------------------------------------------

def write_exodus(path, gm, blocks, block_etype, block_meta, nodesets, title):
    import netCDF4
    import numpy as np

    nc = netCDF4.Dataset(path, 'w', format='NETCDF4')

    nblk = len(blocks)
    nns = len(nodesets)
    nelem = sum(len(v) for v in blocks.values())

    nc.createDimension('len_name', 256)
    nc.createDimension('len_line', 81)
    nc.createDimension('four', 4)
    nc.createDimension('time_step', None)
    nc.createDimension('num_dim', 3)
    nc.createDimension('num_nodes', len(gm.coords))
    nc.createDimension('num_elem', nelem)
    nc.createDimension('num_el_blk', nblk)
    nc.createDimension('num_node_sets', nns)
    nc.createDimension('num_side_sets', 0)

    nc.setncattr('api_version', np.float32(8.11))
    nc.setncattr('version', np.float32(8.11))
    nc.setncattr('floating_point_word_size', np.int32(8))
    nc.setncattr('file_size', np.int32(1))
    nc.setncattr('maximum_name_length', np.int32(32))
    nc.setncattr('int64_status', np.int32(0))
    nc.setncattr('title', title)

    def _names_var(vname, dimname, count, names):
        v = nc.createVariable(vname, 'S1', (dimname, 'len_name'))
        for i, nm in enumerate(names):
            b = nm.encode('ascii', 'replace')[:255]
            v[i, :len(b)] = list(np.frombuffer(b, dtype='S1'))
        return v

    # 时间
    vt = nc.createVariable('time_whole', 'f8', ('time_step',))
    vt[0] = 0.0

    # 坐标
    coords = np.array(gm.coords, dtype='f8')
    for d, vn in enumerate(('coordx', 'coordy', 'coordz')):
        v = nc.createVariable(vn, 'f8', ('num_nodes',))
        v[:] = coords[:, d]

    v = nc.createVariable('coor_names', 'S1', ('num_dim', 'len_name'))
    for d, nm in enumerate(('x', 'y', 'z')):
        v[d, 0] = np.frombuffer(nm.encode(), dtype='S1')[0]

    # node/elem num map (1:1)
    v = nc.createVariable('node_num_map', 'i4', ('num_nodes',))
    v[:] = np.arange(1, len(gm.coords) + 1)
    v = nc.createVariable('elem_num_map', 'i4', ('num_elem',))
    v[:] = np.arange(1, nelem + 1)

    # 单元块
    block_names = sorted(blocks.keys())
    nc.createVariable('eb_status', 'i4', ('num_el_blk',))[:] = 1
    vebp = nc.createVariable('eb_prop1', 'i4', ('num_el_blk',))
    vebp.setncattr('name', 'ID')
    vebp[:] = np.arange(1, nblk + 1)
    _names_var('eb_names', 'num_el_blk', nblk, block_names)

    eoff = 0
    for bi, bname in enumerate(block_names, start=1):
        elems = blocks[bname]
        nc.createDimension(f'num_el_in_blk{bi}', len(elems))
        npe = len(elems[0][1])
        nc.createDimension(f'num_nod_per_el{bi}', npe)
        vc = nc.createVariable(f'connect{bi}', 'i4',
                               (f'num_el_in_blk{bi}', f'num_nod_per_el{bi}'))
        vc.setncattr('elem_type', block_etype[bname])
        vc[:] = np.array([c for _, c in elems], dtype='i4')
        eoff += len(elems)

    # nodesets
    if nns:
        nc.createVariable('ns_status', 'i4', ('num_node_sets',))[:] = 1
        vnsp = nc.createVariable('ns_prop1', 'i4', ('num_node_sets',))
        vnsp.setncattr('name', 'ID')
        vnsp[:] = np.arange(1, nns + 1)
        ns_names = sorted(nodesets.keys())
        _names_var('ns_names', 'num_node_sets', nns, ns_names)
        for ni, name in enumerate(ns_names, start=1):
            ids = nodesets[name]
            nc.createDimension(f'num_nod_ns{ni}', len(ids))
            v = nc.createVariable(f'node_ns{ni}', 'i4', (f'num_nod_ns{ni}',))
            v[:] = np.array(ids, dtype='i4')

    nc.close()


# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

def main():
    ap = argparse.ArgumentParser(description='Abaqus .inp → Exodus II 转换器')
    ap.add_argument('--inp', required=True, help='Abaqus 输入文件')
    ap.add_argument('--out', required=True, help='输出 Exodus .e 文件')
    ap.add_argument('--report', help='JSON 报告输出路径')
    ap.add_argument('--merge-tol', type=float, default=0.5,
                    help='跨 instance 节点合并容差 (默认 0.5, 与模型单位一致)')
    args = ap.parse_args()

    print(f"[1/3] 解析 {args.inp} ...")
    model = parse_inp(args.inp)
    print(f"      parts={len(model.parts)} instances={len(model.instances)} "
          f"materials={len(model.materials)} surfaces={len(model.surfaces)} "
          f"ties={len(model.ties)} steps={len(model.steps)}")

    print(f"[2/3] 装配全局网格 (merge_tol={args.merge_tol}) ...")
    gm, blocks, block_etype, block_meta, nodesets = build_global_mesh(
        model, args.merge_tol)
    print(f"      全局节点={len(gm.coords)} (合并 {gm.merged_count}) "
          f"单元={sum(len(v) for v in blocks.values())} "
          f"块={len(blocks)} nodesets={len(nodesets)}")

    print(f"[3/3] 写出 Exodus: {args.out}")
    write_exodus(args.out, gm, blocks, block_etype, block_meta, nodesets,
                 args.inp)

    # 报告
    xs = [c[0] for c in gm.coords]
    ys = [c[1] for c in gm.coords]
    zs = [c[2] for c in gm.coords]
    report = {
        'source': args.inp,
        'merge_tol': args.merge_tol,
        'num_nodes': len(gm.coords),
        'num_merged': gm.merged_count,
        'num_elems': sum(len(v) for v in blocks.values()),
        'bbox': {'x': [min(xs), max(xs)], 'y': [min(ys), max(ys)],
                 'z': [min(zs), max(zs)]},
        'blocks': {b: {'count': len(blocks[b]), 'type': block_etype[b],
                       'part': block_meta[b][0], 'material': block_meta[b][1]}
                   for b in sorted(blocks)},
        'nodesets': {n: len(v) for n, v in sorted(nodesets.items())},
        'materials': {k: v for k, v in model.materials.items()},
        'amplitudes': model.amplitudes,
        'steps': model.steps,
        'ties': model.ties,
        'couplings': model.couplings,
        'embedded': model.embedded,
    }
    if args.report:
        with open(args.report, 'w', encoding='utf-8') as f:
            json.dump(report, f, ensure_ascii=False, indent=2, default=str)
        print(f"      报告: {args.report}")
    print("完成 ✓")


if __name__ == '__main__':
    main()
