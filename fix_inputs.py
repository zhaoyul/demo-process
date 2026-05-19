#!/usr/bin/env python3
"""Fix MOOSE input files: add missing stress aux variables for postprocessors.
Keeps existing [Kernels] block (deprecation is just a warning, not error).
"""
import re, os

INPUT_DIRS = [
    "inputs/aac_material_tests",
    "inputs/aac_wall_tests",
]

def fix_file(path):
    with open(path, 'r') as f:
        content = f.read()

    restored = False
    # 1. Restore [Kernels] if we previously replaced it with [Physics]
    if '[Physics/SolidMechanics/QuasiStatic]' in content:
        dim = 2 if 'disp_z' not in content else 3
        if dim == 3:
            old_kernels = """[Kernels]
  [TensorMechanics]
    displacements = 'disp_x disp_y disp_z'
  []
[]"""
        else:
            old_kernels = """[Kernels]
  [TensorMechanics]
    displacements = 'disp_x disp_y'
  []
[]"""
        content = re.sub(
            r'\[Physics/SolidMechanics/QuasiStatic\].*?\n\[\]',
            old_kernels,
            content,
            flags=re.DOTALL
        )
        print(f"  Restored Kernels in {os.path.basename(path)}")
        restored = True

    # 2. Find which stress vars are used in Postprocessors but not defined as AuxVariables
    pp_stress_vars = set()
    for m in re.finditer(r"variable\s*=\s*['\"]?(stress_\w+)['\"]?", content):
        pp_stress_vars.add(m.group(1))

    # Find which are already defined as AuxVariables
    existing_vars = set()
    for m in re.finditer(r'\[AuxVariables\].*?\n\[\]', content, flags=re.DOTALL):
        aux_block = m.group(0)
        for vm in re.finditer(r'\[\s*(stress_\w+)\s*\]', aux_block):
            existing_vars.add(vm.group(1))

    missing = pp_stress_vars - existing_vars
    if not missing and restored:
        return
    if not missing and not restored:
        print(f"  OK: {os.path.basename(path)}")
        return

    # 3. Add missing stress vars as AuxVariables
    for sv in sorted(missing):
        # Insert before the first closing [] of AuxVariables, or before [AuxKernels]
        aux_var_entry = f"""  [{sv}]
    order = CONSTANT
    family = MONOMIAL
  []"""
        # Find [AuxVariables] block
        aux_match = re.search(r'\[AuxVariables\].*?\n\[\]', content, flags=re.DOTALL)
        if aux_match:
            # Insert before final []
            end_pos = aux_match.end() - 2  # before \n[]
            content = content[:end_pos] + '\n' + aux_var_entry + content[end_pos:]
        else:
            # No AuxVariables block - create one
            print(f"  WARNING: No AuxVariables block in {os.path.basename(path)}, cannot add {sv}")
            continue

    # 4. Add RankTwoAux kernels for missing stress vars
    # Determine index_i, index_j for each component
    idx_map = {
        'stress_xx': (0, 0), 'stress_xy': (0, 1), 'stress_xz': (0, 2),
        'stress_yx': (1, 0), 'stress_yy': (1, 1), 'stress_yz': (1, 2),
        'stress_zx': (2, 0), 'stress_zy': (2, 1), 'stress_zz': (2, 2),
    }
    for sv in sorted(missing):
        if sv not in idx_map:
            continue
        ii, jj = idx_map[sv]
        kernel_entry = f"""  [{sv}_kernel]
    type = RankTwoAux
    variable = {sv}
    rank_two_tensor = stress
    index_i = {ii}
    index_j = {jj}
    execute_on = 'TIMESTEP_END'
  []"""
        # Find [AuxKernels] block
        auxk_match = re.search(r'\[AuxKernels\].*?\n\[\]', content, flags=re.DOTALL)
        if auxk_match:
            end_pos = auxk_match.end() - 2
            content = content[:end_pos] + '\n' + kernel_entry + content[end_pos:]
        else:
            print(f"  WARNING: No AuxKernels in {os.path.basename(path)}")

    with open(path, 'w') as f:
        f.write(content)
    print(f"  Fixed: {os.path.basename(path)}  added={sorted(missing)}")

# Restore all files first (git checkout)
os.system("cd /home/kevin/gt/demo/polecats/chrome/demo && git checkout -- inputs/")

for d in INPUT_DIRS:
    for f in sorted(os.listdir(d)):
        if f.endswith('.i'):
            path = os.path.join(d, f)
            fix_file(path)

print("\nDone.")
