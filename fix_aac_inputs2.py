#!/usr/bin/env python3
"""Robust fix for AAC .i files: move misplaced stress blocks into proper parent blocks."""
import os, re, sys

INPUT_DIRS = ["inputs/aac_material_tests", "inputs/aac_wall_tests"]

STRESS_VAR_RE = re.compile(r'^\s*\[(stress_\w+)\]\s*$')
STRESS_KERNEL_RE = re.compile(r'^\s*\[(stress_\w+_kernel)\]\s*$')

IDX_MAP = {
    'stress_xx': (0, 0), 'stress_xy': (0, 1), 'stress_xz': (0, 2),
    'stress_yx': (1, 0), 'stress_yy': (1, 1), 'stress_yz': (1, 2),
    'stress_zx': (2, 0), 'stress_zy': (2, 1), 'stress_zz': (2, 2),
}

def get_block_close(lines, start_idx, block_depth=1):
    """Return the index of the line that closes the block starting at start_idx."""
    depth = block_depth
    for i in range(start_idx + 1, len(lines)):
        s = lines[i].strip()
        if s.startswith('[') and not s.startswith('[./') and not s.startswith('[../'):
            if s == '[]':
                depth -= 1
                if depth == 0:
                    return i
            else:
                depth += 1
        elif s in ('[]', '[../]'):
            # These shouldn't appear at top level but handle them
            depth -= 1
            if depth == 0:
                return i
    return len(lines) - 1

def find_block(lines, name):
    """Return (start_idx, end_idx) of a named top-level block."""
    for i, line in enumerate(lines):
        if line.strip() == f'[{name}]':
            end = get_block_close(lines, i)
            return (i, end)
    return None

def fix_file(path):
    with open(path, 'r') as f:
        content = f.read()
    lines = content.split('\n')

    # Step 1: Find needed stress variables from Postprocessors
    pp = find_block(lines, 'Postprocessors')
    needed_stress = set()
    if pp:
        for i in range(pp[0] + 1, pp[1]):
            m = re.search(r"variable\s*=\s*(stress_\w+)", lines[i])
            if m:
                needed_stress.add(m.group(1))

    if not needed_stress:
        # No stress vars needed - clean up any trailing blocks and done
        clean_trailing(lines)
        new_content = '\n'.join(lines).rstrip('\n') + '\n'
        if new_content != content:
            with open(path, 'w') as f:
                f.write(new_content)
            print(f"  Cleaned: {os.path.basename(path)}")
        return

    # Step 2: Find existing AuxVariable stress vars (properly inside [AuxVariables])
    aux_range = find_block(lines, 'AuxVariables')
    existing_aux_vars = set()
    if aux_range:
        for i in range(aux_range[0] + 1, aux_range[1]):
            m = STRESS_VAR_RE.match(lines[i])
            if m:
                existing_aux_vars.add(m.group(1))

    # Step 3: Find existing AuxKernel stress kernels (properly inside [AuxKernels])
    auxk_range = find_block(lines, 'AuxKernels')
    existing_aux_kernels = set()
    if auxk_range:
        for i in range(auxk_range[0] + 1, auxk_range[1]):
            m = STRESS_KERNEL_RE.match(lines[i])
            if m:
                sv = m.group(1).replace('_kernel', '')
                existing_aux_kernels.add(sv)

    # Step 4: Remove all misplaced stress blocks (any outside AuxVariables/AuxKernels)
    # Collect them first
    misplaced_vars = {}   # {name: [lines_of_block]}
    misplaced_kernels = {}  # {stress_var_name: [lines_of_block]}
    
    i = 0
    while i < len(lines):
        s = lines[i].strip()
        m = STRESS_VAR_RE.match(s)
        if m:
            name = m.group(1)
            block_lines = [lines[i]]
            i += 1
            while i < len(lines) and not lines[i].strip() == '[]':
                block_lines.append(lines[i])
                i += 1
            if i < len(lines):
                block_lines.append(lines[i])  # closing []
            misplaced_vars[name] = block_lines
            lines = lines[:i - len(block_lines) + 1] + lines[i + 1:]
            i = i - len(block_lines) + 1
            continue
        
        m = STRESS_KERNEL_RE.match(s)
        if m:
            kernel_name = m.group(1)
            stress_var = kernel_name.replace('_kernel', '')
            block_lines = [lines[i]]
            i += 1
            while i < len(lines) and not lines[i].strip() == '[]':
                block_lines.append(lines[i])
                i += 1
            if i < len(lines):
                block_lines.append(lines[i])
            misplaced_kernels[stress_var] = block_lines
            lines = lines[:i - len(block_lines) + 1] + lines[i + 1:]
            i = i - len(block_lines) + 1
            continue
        i += 1

    # Also remove any trailing stress blocks that might be at file end
    clean_trailing(lines)

    # Step 5: Re-find blocks (indices may have shifted)
    aux_range = find_block(lines, 'AuxVariables')
    auxk_range = find_block(lines, 'AuxKernels')

    missing_aux = needed_stress - existing_aux_vars
    missing_auxk = needed_stress - existing_aux_kernels

    fixes = []
    if missing_aux and aux_range:
        insert_at = aux_range[1]
        for sv in sorted(missing_aux):
            entry = [
                f'  [{sv}]',
                '    order = CONSTANT',
                '    family = MONOMIAL',
                '  []',
            ]
            for line in reversed(entry):
                lines.insert(insert_at, line)
        fixes.append(f"aux_vars={sorted(missing_aux)}")

    if missing_auxk and auxk_range:
        auxk_range = find_block(lines, 'AuxKernels')  # re-find due to shifts
        insert_at = auxk_range[1]
        for sv in sorted(missing_auxk):
            if sv not in IDX_MAP:
                continue
            ii, jj = IDX_MAP[sv]
            entry = [
                f'  [{sv}_kernel]',
                f'    type = RankTwoAux',
                f'    variable = {sv}',
                f'    rank_two_tensor = stress',
                f'    index_i = {ii}',
                f'    index_j = {jj}',
                f"    execute_on = 'TIMESTEP_END'",
                f'  []',
            ]
            for line in reversed(entry):
                lines.insert(insert_at, line)
        fixes.append(f"aux_kernels={sorted(missing_auxk)}")

    new_content = '\n'.join(lines).rstrip('\n') + '\n'
    if fixes or new_content != content:
        with open(path, 'w') as f:
            f.write(new_content)
        print(f"  Fixed: {os.path.basename(path)}  {' '.join(fixes)}")
    else:
        print(f"  OK: {os.path.basename(path)}")

def clean_trailing(lines):
    """Remove stress blocks at the end of the file."""
    i = len(lines) - 1
    while i >= 0:
        s = lines[i].strip()
        m_var = STRESS_VAR_RE.match(s)
        m_kern = STRESS_KERNEL_RE.match(s)
        if m_var or m_kern:
            # Found a stress block at the end, remove from its start
            j = i
            # Go back to find the start of this block
            while j >= 0:
                sj = lines[j].strip()
                if STRESS_VAR_RE.match(sj) or STRESS_KERNEL_RE.match(sj):
                    # Found the block start
                    del lines[j:i+1]
                    i = j
                    break
                elif sj == '[]':
                    # We're inside a block - go back more
                    j -= 1
                else:
                    j -= 1
            continue
        i -= 1

for d in INPUT_DIRS:
    file_list = sorted([f for f in os.listdir(d) if f.endswith('.i')])
    for f in file_list:
        fix_file(os.path.join(d, f))

print("\nDone.")
