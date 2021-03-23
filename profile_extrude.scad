/* ##  #   # # ###  ## ### ### ### ###    ## ### ### ###
 * # # #   # # #   #    #  # # # # #     #   # # #    #
 * ##  #   # # ##   #   #  # # # # ##     #  # # ##   #
 * # # #   # # #     #  #  # # # # #       # # # #    #
 * ##  ### ### ### ##   #  ### # # ###   ##  ### #    #
 *
 * Graphical toolkit module - profile_extrude() - version 1.2
 *
 * Functionally equivalent to
 * ` rotate_extrude(angle = 360)
 * `   polygon(points = profile_points)
 * except instead of rolling around a circle, the profile
 * rolls around another polygon defined by shape_points
 *
 * The difficulty I experienced in this project came from:
 *   - Using polyhedron() for the first time
 *   - Forgetting to debug the shape with Thrown Together mode
 *   - Adding support for a concave profile_points
 *   - Creating an efficient design with as few faces as possible
 *
 * Usage: profile_extrude(profile_points, shape_points, show_points)
 *     profile_points  The desired profile of the new shape
 *     shape_points    The polygon to extrude to the profile
 *     show_points     true/false - Show the computed points
 *
 * Bug-fix history:
 *   2021-03-23 14:24  WMays287 
 *     Code didn't work for shape_points[] with more than 4 elements.
 *     It's been corrected (replaced the number 4 with shape_len in
 *     lines 74, 80, 81, 82, and 83)
 *   2021-03-23 16:44  WMays287
 *     Received a bug report about non-existent points and degenerate
 *     polygons in the test model. Found out I was accidentally over-
 *     scanning the point set, and luckily this was a quick fix.
 *     (change a single number in line 77 from 1 to 2)
 */

// Test model, showcasing support for concave profiles
profile_extrude(
    profile_points = [
        [1, 0], [1, 5], [2, 5], [2, 3],
        [3, 3], [3, 6], [1, 6], [1, 10]
    ],
    shape_points = [
        [-1, -1], [-1, 1], [1, 1], [1, -1]
    ],
    show_points = false
);

module profile_extrude(profile_points, shape_points, show_points = true) {

    shape_len = len(shape_points);

    // Compute all points required for polyhedron
    new_points = [
        for (p = profile_points)
            for (q = shape_points)
                [q.x * p.x, q.y * p.x, p.y]
    ];

    // If requested, mark points with small cubes
    if (show_points)
        for (p = new_points)
            translate(p)
                cube(0.1, center = true);

    // Create the actual polyhedron
    polyhedron(

        // Pass in the points we've already computed
        points = new_points,

        faces = [

            // End cap for bottom of extruded shape
            [for (i = [shape_len - 1 : -1 : 0]) i],

            // End cap for top of extruded shape
            [for (i = [0 : 1 : shape_len - 1]) len(new_points) - shape_len + i],

            // Faces along the profile of shape
            for (j = [0 : 1 : len(profile_points) - 2])
                for (i = [0 : 1 : shape_len - 1])
                    [
                        j * shape_len +              i,
                        j * shape_len +             (i + 1) % shape_len,
                        j * shape_len + shape_len + (i + 1) % shape_len,
                        j * shape_len + shape_len +  i
                    ]
            
        ]

    );

}
