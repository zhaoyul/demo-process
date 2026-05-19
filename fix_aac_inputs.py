#!/usr/bin/env python3
"""Fix AAC .i files: properly place AuxVariable and AuxKernel stress blocks
inside their respective parent blocks, removing misplaced ones from the end."""
import os, re, sys

INPUT_DIRS = [
    "inputs/aac_material_tests",
    "inputs/aac_wall_tests",
]

IDX_MAP = {
    'stress_xx': (0, 0), 'stress_xy': (0, 1), 'stress_xz': (0, 2),
    'stress_yx': (1, 0), 'stress_yy': (1, 1), 'stress_yz': (1, 2),
    'stress_zx': (2, 0), 'stress_zy': (2, 1), 'stress_zz': (2, 2),
}

def find_block_range(lines, block_name, start=0):
    """Find the start and end line indices (inclusive) of a named block."""
    for i in range(start, len(lines)):
        stripped = lines[i].strip()
        if stripped == f'[{block_name}]':
            depth = 1
            j = i + 1
            while j < len(lines) and depth > 0:
                s = lines[j].strip()
                if s.startswith('[') and not s.startswith('[./') and not s.startswith('[../'):
                    depth += 1
                elif s == '[]':
                    depth -= 1
                j += 1
            return (i, j - 1)  # start, end (inclusive, the closing [])
    return None

def get_block_sub_names(lines, block_range):
    """Get names of sub-blocks within a block."""
    start, end = block_range
    names = set()
    for i in range(start + 1, end):
        s = lines[i].strip()
        if s.startswith('[') and not s.startswith('[./') and not s.startswith('[../'):
            name = s[1:-1].strip()
            if name:
                names.add(name)
    return names

def find_misplaced_stress_blocks(lines):
    """Find lines of misplaced stress_* and stress_*_kernel blocks (at top level)."""
    stress_vars = set()
    stress_kernels = set()
    # Find blocks that are at top level (no indentation context)
    # These are blocks after the last properly closed section
    for i, line in enumerate(lines):
        s = line.strip()
        # Check for top-level stress_* blocks (no leading whitespace beyond spaces)
        m = re.match(r'^\s*\[(stress_\w+)\]\s*$', s)
        if m:
            stress_vars.add(m.group(1))
        m = re.match(r'^\s*\[(stress_\w+_kernel)\]\s*$', s)
        if m:
            stress_kernels.add(m.group(1))
    return stress_vars, stress_kernels

def get_stress_vars_from_postprocessors(lines):
    """Extract stress variables referenced in Postprocessors block."""
    pp_range = find_block_range(lines, 'Postprocessors')
    if not pp_range:
        return set()
    start, end = pp_range
    stress_vars = set()
    for i in range(start + 1, end):
        m = re.search(r"variable\s*=\s*(stress_\w+)", lines[i])
        if m:
            stress_vars.add(m.group(1))
    return stress_vars

def get_stress_vars_from_auxkernels(lines):
    """Extract stress variables referenced in existing AuxKernels."""
    auxk_range = find_block_range(lines, 'AuxKernels')
    if not auxk_range:
        return set()
    start, end = auxk_range
    stress_vars = set()
    for i in range(start + 1, end):
        m = re.search(r"variable\s*=\s*(stress_\w+)", lines[i])
        if m:
            stress_vars.add(m.group(1))
    return stress_vars

def remove_trailing_stress_blocks(lines):
    """Remove misplaced stress blocks at the end of the file."""
    new_lines = []
    in_stress_block = False
    for line in lines:
        s = line.strip()
        # Detect start of top-level stress_ or stress_*_kernel blocks (anywhere)
        if re.match(r'^\[(stress_\w+_kernel|stress_\w+)\]$', s):
            in_stress_block = True
            continue
        if in_stress_block:
            if s == '[]':
                in_stress_block = False
            continue
        new_lines.append(line)
    # Strip trailing empty lines that may have been left
    while new_lines and new_lines[-1].strip() == '':
        new_lines.pop()
    return new_lines

def fix_file(path):
    with open(path, 'r') as f:
        content = f.read()

    lines = content.split('\n')

    # First, remove any trailing misplaced stress blocks
    lines = remove_trailing_stress_blocks(lines)

    # Get stress variables needed (from Postprocessors references)
    needed_stress = get_stress_vars_from_postprocessors(lines)

    if not needed_stress:
        # No stress variables needed - file is OK
        # Write back cleaned version
        new_content = '\n'.join(lines)
        if new_content != content:
            with open(path, 'w') as f:
                f.write(new_content)
            print(f"  Cleaned: {os.path.basename(path)}")
        return

    # Find AuxVariables block
    aux_range = find_block_range(lines, 'AuxVariables')
    if not aux_range:
        print(f"  WARN: {os.path.basename(path)} - no [AuxVariables] block")
        return

    existing_aux = get_block_sub_names(lines, aux_range)
    missing_aux = needed_stress - existing_aux
    # Also check what's already in AuxKernels
    existing_auxk_stress = get_stress_vars_from_auxkernels(lines)
    missing_auxk = needed_stress - existing_auxk_stress

    if not missing_aux and not missing_auxk:
        # Already all present
        new_content = '\n'.join(lines)
        if new_content != content:
            with open(path, 'w') as f:
                f.write(new_content)
            print(f"  Cleaned: {os.path.basename(path)}")
        return

    fixed = []

    # Insert missing AuxVariables before closing [] of AuxVariables
    if missing_aux:
        # Recalculate aux_range after previous modifications
        aux_range = find_block_range(lines, 'AuxVariables')
        insert_at = aux_range[1]  # index of closing []
        insertion_lines = []
        for sv in sorted(missing_aux):
            insertion_lines.append(f'  [{sv}]')
            insertion_lines.append('    order = CONSTANT')
            insertion_lines.append('    family = MONOMIAL')
            insertion_lines.append('  []')

        # Insert before closing bracket
        for line in reversed(insertion_lines):
            lines.insert(insert_at, line)
        fixed.append(f"aux_vars={sorted(missing_aux)}")

    # Insert missing AuxKernels
    if missing_auxk:
        auxk_range = find_block_range(lines, 'AuxKernels')
        if auxk_range:
            insert_at = auxk_range[1]
            insertion_lines = []
            for sv in sorted(missing_auxk):
                if sv not in IDX_MAP:
                    continue
                ii, jj = IDX_MAP[sv]
                insertion_lines.append(f'  [{sv}_kernel]')
                insertion_lines.append(f'    type = RankTwoAux')
                insertion_lines.append(f'    variable = {sv}')
                insertion_lines.append(f'    rank_two_tensor = stress')
                insertion_lines.append(f'    index_i = {ii}')
                insertion_lines.append(f'    index_j = {jj}')
                insertion_lines.append(f"    execute_on = 'TIMESTEP_END'")
                insertion_lines.append(f'  []')

            for line in reversed(insertion_lines):
                lines.insert(insert_at, line)
            fixed.append(f"aux_kernels={sorted(missing_auxk)}")

    new_content = '\n'.join(lines)
    with open(path, 'w') as f:
        f.write(new_content)
    print(f"  Fixed: {os.path.basename(path)}  {' '.join(fixed)}")

for d in INPUT_DIRS:
    file_list = sorted([f for f in os.listdir(d) if f.endswith('.i')])
    for f in file_list:
        fix_file(os.path.join(d, f))

print("\nDone fixing AAC input files.")
