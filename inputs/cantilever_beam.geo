// Cantilever beam: L=1.0, W=0.1, H=0.2
// Structured hex mesh with shear locking correction
L = 1.0; W = 0.1; H = 0.2;

// Mesh divisions for structured hex
nx = 20;  // elements along length
ny = 2;   // elements along width
nz = 4;   // elements along height

// Corner points
Point(1) = {0, 0, 0, 0.05};
Point(2) = {L, 0, 0, 0.05};
Point(3) = {L, W, 0, 0.05};
Point(4) = {0, W, 0, 0.05};
Point(5) = {0, 0, H, 0.05};
Point(6) = {L, 0, H, 0.05};
Point(7) = {L, W, H, 0.05};
Point(8) = {0, W, H, 0.05};

// Edges
Line(1) = {1,2}; Line(2) = {2,3}; Line(3) = {3,4}; Line(4) = {4,1};
Line(5) = {5,6}; Line(6) = {6,7}; Line(7) = {7,8}; Line(8) = {8,5};
Line(9) = {1,5}; Line(10) = {2,6}; Line(11) = {3,7}; Line(12) = {4,8};

// Structured division
Transfinite Line {1,3,5,7} = nx+1 Using Progression 1;    // x-direction (length)
Transfinite Line {2,4,6,8} = ny+1 Using Progression 1;    // y-direction (width)
Transfinite Line {9,10,11,12} = nz+1 Using Progression 1; // z-direction (height)

// Surfaces
Line Loop(1) = {1,2,3,4}; Plane Surface(1) = {1};
Line Loop(2) = {5,6,7,8}; Plane Surface(2) = {2};
Line Loop(3) = {1,10,-5,-9}; Plane Surface(3) = {3};
Line Loop(4) = {2,11,-6,-10}; Plane Surface(4) = {4};
Line Loop(5) = {3,12,-7,-11}; Plane Surface(5) = {5};
Line Loop(6) = {4,9,-8,-12}; Plane Surface(6) = {6};

// Transfinite + Recombine for structured quads
Transfinite Surface {1,2,3,4,5,6};
Recombine Surface {1,2,3,4,5,6};

// Volume
Surface Loop(1) = {1,2,3,4,5,6};
Volume(1) = {1};
Transfinite Volume {1};

// First-order hex (Hex8)
Mesh.ElementOrder = 1;

// Physical groups
Physical Surface("fixed_end") = {6};
Physical Surface("load_surface") = {2};
Physical Volume("beam") = {1};
