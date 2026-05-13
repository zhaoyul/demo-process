// 红创科技 — 接触力学: 两体压缩 · 分离块 + 节点一致性
SetFactory("OpenCASCADE");

Lx = 0.1; Ly = 0.05; Lz = 0.05;
MeshSize = Lx / 8;

// Two separate blocks stacked in Z
Box(1) = {0, 0, 0,        Lx, Ly, Lz/2};
Box(2) = {0, 0, Lz/2,     Lx, Ly, Lz/2};

// Merge coincident nodes at interface (surfaces remain separate)
Coherence;

// Physical volumes
Physical Volume("block_bottom", 1) = {1};
Physical Volume("block_top", 2) = {2};

// Physical surfaces
Physical Surface("bottom_fixed", 5) = {1};
Physical Surface("contact_bottom", 6) = {3};
Physical Surface("contact_top", 7) = {5};
Physical Surface("top_pressure", 8) = {7};

// Free tet mesh with optimization
Mesh.CharacteristicLengthMin = MeshSize * 0.3;
Mesh.CharacteristicLengthMax = MeshSize;
Mesh.Optimize = 1;
Mesh.OptimizeNetgen = 1;
Mesh.SecondOrderIncomplete = 0;
