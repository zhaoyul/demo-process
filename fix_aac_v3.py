#!/usr/bin/env python3
"""Definitive fixer for AAC .i files.
Moves misplaced stress_* blocks into proper [AuxVariables]/[AuxKernels] blocks."""
import os, re

INPUT_DIRS = ["inputs/aac_material_tests", "inputs/aac_wall_tests"]

IDX_MAP = {
    'stress_xx': (0,0),'stress_xy':(0,1),'stress_xz':(0,2),
    'stress_yx':(1,0),'stress_yy':(1,1),'stress_yz':(1,2),
    'stress_zx':(2,0),'stress_zy':(2,1),'stress_zz':(2,2),
}

def block_range(lines, name, start=0):
    """Return (start_idx, end_idx_inclusive) of a block by name, tracking nesting."""
    for i in range(start, len(lines)):
        if lines[i].strip() == f'[{name}]':
            depth = 1
            for j in range(i+1, len(lines)):
                s = lines[j].strip()
                if s.startswith('['):
                    if s == '[]':
                        depth -= 1
                        if depth == 0:
                            return (i, j)
                    elif not s.startswith('[./') and not s.startswith('[../'):
                        depth += 1
            return (i, len(lines)-1)
    return None

def get_sub_names(lines, br):
    """Get names of direct sub-blocks."""
    if not br: return set()
    s, e = br
    names = set()
    for i in range(s+1, e):
        m = re.match(r'^\s*\[(\w+)\]', lines[i])
        if m and not lines[i].strip().startswith('[./'):
            names.add(m.group(1))
    return names

def fix_file(path):
    with open(path, 'r') as f:
        original = f.read()
    lines = original.split('\n')
    
    # Get stress vars from Postprocessors (tracking nesting)
    pp = block_range(lines, 'Postprocessors')
    needed = set()
    if pp:
        for i in range(pp[0]+1, pp[1]):
            m = re.search(r'variable\s*=\s*(stress_\w+)', lines[i])
            if m:
                needed.add(m.group(1))
    
    if not needed:
        print(f"  SKIP: {os.path.basename(path)} (no stress vars needed)")
        return
    
    # Check existing AuxVariables/AuxKernels
    aux_range = block_range(lines, 'AuxVariables')
    auxk_range = block_range(lines, 'AuxKernels')
    
    existing_aux = get_sub_names(lines, aux_range)
    existing_auxk = get_sub_names(lines, auxk_range)
    
    missing_aux = needed - existing_aux
    missing_auxk = needed - {k.replace('_kernel','') for k in existing_auxk if k.endswith('_kernel')}
    
    if not missing_aux and not missing_auxk:
        print(f"  OK: {os.path.basename(path)} (already have all)")
        return
    
    # Build new lines, skipping misplaced stress blocks
    new_lines = []
    i = 0
    while i < len(lines):
        line = lines[i]
        s = line.strip()
        m_var = re.match(r'^\[(stress_\w+)\]$', s)
        m_ker = re.match(r'^\[(stress_\w+_kernel)\]$', s)
        
        if m_var or m_ker:
            # Skip this entire sub-block
            depth = 1
            i += 1
            while i < len(lines) and depth > 0:
                ss = lines[i].strip()
                if ss == '[]':
                    depth -= 1
                elif ss.startswith('[') and not ss.startswith('[./'):
                    depth += 1
                i += 1
            continue
        
        new_lines.append(line)
        i += 1
    
    # Now insert missing vars into new_lines
    aux_range2 = block_range(new_lines, 'AuxVariables')
    auxk_range2 = block_range(new_lines, 'AuxKernels')
    
    if missing_aux and aux_range2:
        insert_at = aux_range2[1]  # before closing []
        entries = []
        for sv in sorted(missing_aux):
            entries.extend([f'  [{sv}]', '    order = CONSTANT', '    family = MONOMIAL', '  []'])
        for line in reversed(entries):
            new_lines.insert(insert_at, line)
    
    if missing_auxk and auxk_range2:
        auxk_range2 = block_range(new_lines, 'AuxKernels')
        insert_at = auxk_range2[1]
        entries = []
        for sv in sorted(missing_auxk):
            if sv not in IDX_MAP: continue
            ii, jj = IDX_MAP[sv]
            entries.extend([
                f'  [{sv}_kernel]',
                f'    type = RankTwoAux',
                f'    variable = {sv}',
                f'    rank_two_tensor = stress',
                f'    index_i = {ii}',
                f'    index_j = {jj}',
                f"    execute_on = 'TIMESTEP_END'",
                f'  []',
            ])
        for line in reversed(entries):
            new_lines.insert(insert_at, line)
    
    result = '\n'.join(new_lines).rstrip('\n') + '\n'
    if result != original:
        with open(path, 'w') as f:
            f.write(result)
        print(f"  FIXED: {os.path.basename(path)}  added={sorted(missing_aux)}{' + kernels' if missing_auxk else ''}")
    else:
        print(f"  UNCHANGED: {os.path.basename(path)}")

for d in INPUT_DIRS:
    for f in sorted(os.listdir(d)):
        if f.endswith('.i'):
            fix_file(os.path.join(d, f))

print("\nAll files processed.")
