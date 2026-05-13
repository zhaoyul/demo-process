#!/usr/bin/env python3
"""Generate a structured Hex8 mesh for the cantilever beam (MSH2 format).
   
   Beam: L=1.0, W=0.1, H=0.2
   Mesh: 20×2×4 = 160 Hex8 elements, 21×3×5 = 315 nodes
   
   Physical groups:
     - fixed_end: x=0 face (quads on yz plane)
     - load_surface: z=0.2 face (quads on xy plane)  
     - beam: all hex elements
"""

import argparse
import os
import sys

def generate_msh(nx=20, ny=2, nz=4, L=1.0, W=0.1, H=0.2, outpath="outputs/cantilever_beam.msh"):
    """Generate structured hex mesh in MSH2 format."""
    
    # Node grid dimensions
    npx = nx + 1  # 21
    npy = ny + 1  # 3
    npz = nz + 1  # 5
    
    dx = L / nx
    dy = W / ny
    dz = H / nz
    
    # Generate nodes: i,j,k indexing where i→x, j→y, k→z
    nodes = []  # list of (x, y, z)
    node_map = {}  # (i,j,k) -> node_id (1-based)
    
    node_id = 1
    for k in range(npz):
        for j in range(npy):
            for i in range(npx):
                x = i * dx
                y = j * dy
                z = k * dz
                nodes.append((x, y, z))
                node_map[(i, j, k)] = node_id
                node_id += 1
    
    num_nodes = len(nodes)
    
    # Generate hex elements
    elements_3d = []  # list of node id tuples
    elements_2d_fixed_end = []  # quads on x=0 face
    elements_2d_load = []  # quads on z=H face
    
    elem3d_id = 1
    for k in range(nz):
        for j in range(ny):
            for i in range(nx):
                # Hex8 corner nodes in standard ordering
                # Bottom face (z=low): counterclockwise
                n0 = node_map[(i, j, k)]
                n1 = node_map[(i+1, j, k)]
                n2 = node_map[(i+1, j+1, k)]
                n3 = node_map[(i, j+1, k)]
                # Top face (z=high): counterclockwise  
                n4 = node_map[(i, j, k+1)]
                n5 = node_map[(i+1, j, k+1)]
                n6 = node_map[(i+1, j+1, k+1)]
                n7 = node_map[(i, j+1, k+1)]
                
                elements_3d.append((n0, n1, n2, n3, n4, n5, n6, n7))
                elem3d_id += 1
                
                # fixed_end quads: x=0 face (i=0)
                if i == 0:
                    # Quad on x=0: nodes (n0, n3, n7, n4) at i=0
                    elements_2d_fixed_end.append((n0, n3, n7, n4))
                
                # load_surface quads: z=H face (k=nz-1, top face)
                if k == nz - 1:
                    # Top face: nodes (n4, n5, n6, n7)
                    elements_2d_load.append((n4, n5, n6, n7))
    
    num_elems_3d = len(elements_3d)
    num_elems_2d_fixed = len(elements_2d_fixed_end)
    num_elems_2d_load = len(elements_2d_load)
    
    # Total elements: 3D hex + 2D quads for boundaries
    # Physical groups reference element indices
    # Elements are numbered sequentially starting from the 3D elements, then 2D
    total_elements = num_elems_3d + num_elems_2d_fixed + num_elems_2d_load
    
    # Physical group element lists
    beam_elems = list(range(1, num_elems_3d + 1))
    fixed_end_elems = list(range(num_elems_3d + 1, num_elems_3d + num_elems_2d_fixed + 1))
    load_elems = list(range(num_elems_3d + num_elems_2d_fixed + 1, total_elements + 1))
    
    # Write MSH2 file
    os.makedirs(os.path.dirname(outpath) if os.path.dirname(outpath) else '.', exist_ok=True)
    
    with open(outpath, 'w') as f:
        # Header
        f.write("$MeshFormat\n")
        f.write("2.2 0 8\n")
        f.write("$EndMeshFormat\n")
        
        # Physical names
        f.write("$PhysicalNames\n")
        f.write("3\n")
        f.write("2 1 \"fixed_end\"\n")
        f.write("2 2 \"load_surface\"\n")
        f.write("3 3 \"beam\"\n")
        f.write("$EndPhysicalNames\n")
        
        # Nodes
        f.write("$Nodes\n")
        f.write(f"{num_nodes}\n")
        for nid, (x, y, z) in enumerate(nodes, 1):
            f.write(f"{nid} {x:.16g} {y:.16g} {z:.16g}\n")
        f.write("$EndNodes\n")
        
        # Elements
        f.write("$Elements\n")
        f.write(f"{total_elements}\n")
        
        elem_id = 1
        
        # 3D hex elements (type 5) - beam volume
        for nids in elements_3d:
            f.write(f"{elem_id} 5 2 3 3 " + " ".join(str(n) for n in nids) + "\n")
            elem_id += 1
        
        # 2D quad elements (type 3) - fixed_end surface
        for nids in elements_2d_fixed_end:
            f.write(f"{elem_id} 3 2 1 1 " + " ".join(str(n) for n in nids) + "\n")
            elem_id += 1
        
        # 2D quad elements (type 3) - load_surface
        for nids in elements_2d_load:
            f.write(f"{elem_id} 3 2 2 2 " + " ".join(str(n) for n in nids) + "\n")
            elem_id += 1
        
        f.write("$EndElements\n")
    
    print(f"✓ Hex8 mesh generated: {outpath}")
    print(f"  Nodes: {num_nodes}")
    print(f"  Hex elements: {num_elems_3d}")
    print(f"  fixed_end quads: {num_elems_2d_fixed}")
    print(f"  load_surface quads: {num_elems_2d_load}")
    print(f"  Total elements: {total_elements}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate Hex8 mesh for cantilever beam")
    parser.add_argument("-nx", type=int, default=20, help="Elements along x (length)")
    parser.add_argument("-ny", type=int, default=2, help="Elements along y (width)")
    parser.add_argument("-nz", type=int, default=4, help="Elements along z (height)")
    parser.add_argument("-o", "--output", default="outputs/cantilever_beam.msh",
                        help="Output path")
    args = parser.parse_args()
    generate_msh(nx=args.nx, ny=args.ny, nz=args.nz, outpath=args.output)
