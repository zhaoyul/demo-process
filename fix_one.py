#!/usr/bin/env python3
"""Fix one MOOSE input file: deprecated Kernels → Physics/SolidMechanics/QuasiStatic"""
import re, sys

path = sys.argv[1]

with open(path, 'r') as f:
    content = f.read()

# Determine dim
dim = 2 if "disp_z" not in content else 3

# Find stress vars used in postprocessors
stress_vars = set()
for m in re.finditer(r"variable\s*=\s*['\"]?(stress_\w+)['\"]?", content):
    stress_vars.add(m.group(1))
gen_out = ''
if stress_vars:
    gen_out = '\n        generate_output = ' + repr(' '.join(sorted(stress_vars)))

# Build new Physics block
new_physics = f"""[Physics]
  [SolidMechanics]
    [QuasiStatic]
      [all]
        add_variables = true
        strain = SMALL
        incremental = true{gen_out}
      []
    []
  []
[]"""

# Replace [Kernels] block
lines = content.split('\n')
result = []
i = 0
while i < len(lines):
    stripped = lines[i].strip()
    if stripped == '[Kernels]':
        result.extend(new_physics.split('\n'))
        i += 1
        depth = 1
        while i < len(lines) and depth > 0:
            s = lines[i].strip()
            if s.startswith('[') and not s.startswith('[./') and not s.startswith('[../]'):
                depth += 1
            elif s == '[]' or s == '[../]':
                depth -= 1
            i += 1
        continue
    result.append(lines[i])
    i += 1

with open(path, 'w') as f:
    f.write('\n'.join(result))
print(f"Fixed {path}: dim={dim}D stress={sorted(stress_vars)}")
