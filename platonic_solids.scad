/* ##  #   # # ###  ## ### ### ### ###    ## ### ### ###
 * # # #   # # #   #    #  # # # # #     #   # # #    #
 * ##  #   # # ##   #   #  # # # # ##     #  # # ##   #
 * # # #   # # #     #  #  # # # # #       # # # #    #
 * ##  ### ### ### ##   #  ### # # ###   ##  ### #    #
 *
 * Graphical toolkit module - platonic_solids - version 1.0
 *
 * OpenSCAD has cubes, but this module adds support for the other
 * 3-dimensional platonic solids
 * (Tetrahedron, Octahedron, Dodecahedron, Icosahedron)
 *
 * Usages:
 *     tetrahedron(s)  - Draws a tetrahedron, default size 1mm
 *     octahedron(s)   - Draws an octahedron, default size 1mm
 *     dodecahedron(s) - Draws a dodecahedron, default size 1mm
 *     icosahedron(s)  - Draws an icosahedron, default size 1mm
 * Note: size refers to the desired side length.
 * Note: Due to the way the icosahedron is constructed, you have an
 *   optional variable "t" short for "TINY" - Set this to be very low
 *   if, for some reason, the model requires NO flattened edges. By
 *   default, it's set to 0.001, so this shouldn't be necessary.
 *
 * The dodecahedron code came from Thingiverse, thing #204547 -
 * "Simple openscad dodecahedron" by RevK
 *
 * Put the bug-fix history here.
 */

// Put the test model here. Don't worry, it'll only be visible when
// the module is called using include.
cube(center = true);
translate([0, 2.5, 0]) tetrahedron();
translate([2.5, 0, 0]) octahedron();
translate([0, -2.5, 0]) dodecahedron();
translate([-2.5, 0, 0]) icosahedron();

module tetrahedron(s = 1) {
    s = s / 2;
    f = s * sqrt(2) / 2;
    polyhedron(
        points = [ [s, 0, -f], [-s, 0, -f], [0, s, f], [0, -s, f] ],
        faces  = [ [2, 1, 0], [0, 1, 3], [1, 2, 3], [2, 0, 3] ]
    );
}

module octahedron(s = 1) {
    s = s / sqrt(2);
    polyhedron(
        points = [ [s, 0, 0], [-s, 0, 0], [0, s, 0], [0, -s, 0],
            [0, 0, s], [0, 0, -s] ],
        faces = [ [4, 2, 0], [0, 2, 5], [0, 3, 4], [5, 3, 0],
            [1, 2, 4], [5, 2, 1], [4, 3, 1], [1, 3, 5] ]
    );
}

module dodecahedron(s = 1) {
    s = s * (1 + sqrt(5)) / 2;
    f = atan(sqrt(5) / 2 - 0.5);
    hull()
        for(a=[0 : 72 : 288])
            rotate([f, 0, a])
                translate([-s / 2, -s / 2, -s / 2])
                    cube(s);
}

module icosahedron(s = 1, t = 0.001) {
    p = s * (1 + sqrt(5)) / 2;
    hull() {
        cube([s, p, t], center = true);
        cube([t, s, p], center = true);
        cube([p, t, s], center = true);
    }
}