#!/usr/bin/env python3
"""Minimal fix: add missing stress aux variables for Postprocessors.
Does NOT touch the [Kernels] block.
"""
import os, re

INPUT_DIRS = [
    "inputs/aac_material_tests",
    "inputs/aac_wall_tests",
]

IDX_MAP = {
    'stress_xx': (0, 0), 'stress_xy': (0, 1), 'stress_xz': (0, 2),
    'stress_yx': (1, 0), 'stress_yy': (1, 1), 'stress_yz': (1, 2),
    'stress_zx': (2, 0), 'stress_zy': (2, 1), 'stress_zz': (2, 2),
}

def find_block(lines, name, start=0):
    for i in range(start, len(lines)):
        if lines[i].strip() == f'[{name}]':
            depth = 1
            j = i + 1
            while j < len(lines) and depth > 0:
                s = lines[j].strip()
                if s.startswith('[') and not s.startswith('[./') and not s.startswith('[../'):
                    depth += 1
                elif s == '[]' or s == '[../]':
                    depth -= 1
                j += 1
            return (i, j - 1)
    return None

def extract_block_vars(lines, block_range):
    start, end = block_range
    vars = set()
    for i in range(start + 1, end):
        s = lines[i].strip()
        if s.startswith('[') and not s.startswith('[./'):
            name = s[1:-1].strip()
            if name:
                vars.add(name)
    return vars

def fix_file(path):
    with open(path, 'r') as f:
        lines = f.read().split('\n')

    # Find which stress vars are referenced in Postprocessors
    pp_stress_vars = set()
    for line in lines:
        m = re.match(r"\s*variable\s*=\s*['\"]?(stress_\w+)['\"]?", line.strip())
        if m:
            pp_stress_vars.add(m.group(1))

    if not pp_stress_vars:
        return  # nothing needed

    # Find existing AuxVariables
    aux_block = find_block(lines, 'AuxVariables')
    if not aux_block:
        print(f"  WARN: {os.path.basename(path)} has no [AuxVariables]")
        return

    existing_aux = extract_block_vars(lines, aux_block)
    missing = pp_stress_vars - existing_aux
    if not missing:
        return  # all defined

    auxk_block = find_block(lines, 'AuxKernels')
    if not auxk_block:
        print(f"  WARN: {os.path.basename(path)} has no [AuxKernels]")
        return

    # Insert AuxVariable entries just before the closing [] of AuxVariables
    # (aux_block[1] is the line index of the closing [])
    insert_at = aux_block[1]
    for sv in sorted(missing):
        entry = f"  [{sv}]\n    order = CONSTANT\n    family = MONOMIAL\n  []"
        lines.insert(insert_at, entry)
        insert_at += 4

    # Re-find blocks (indices shifted)
    auxk_block = find_block(lines, 'AuxKernels')
    insert_at = auxk_block[1]
    for sv in sorted(missing):
        if sv not in IDX_MAP:
            continue
        ii, jj = IDX_MAP[sv]
        entry = f"  [{sv}_kernel]\n    type = RankTwoAux\n    variable = {sv}\n    rank_two_tensor = stress\n    index_i = {ii}\n    index_j = {jj}\n    execute_on = 'TIMESTEP_END'\n  []"
        lines.insert(insert_at, entry)
        insert_at += 8

    with open(path, 'w') as f:
        f.write('\n'.join(lines))
    print(f"  Fixed: {os.path.basename(path)}  added={sorted(missing)}")

for d in INPUT_DIRS:
    for f in sorted(os.listdir(d)):
        if f.endswith('.i'):
            fix_file(os.path.join(d, f))

print("\nDone.")
