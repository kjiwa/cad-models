/**
 * Shared backplate primitives. Requires EPSILON from the including model.
 */

// Generates the 45-degree top-rear chamfer cutter for pegboard swing-in clearance.
module backplate_tilt_chamfer(width, chamfer, z_top) {
  translate([0, 0, z_top])
    rotate([45, 0, 0])
      cube([width + 2 * EPSILON, chamfer * sqrt(2), chamfer * sqrt(2)], center = true);
}

// Generates a 2D rounded stadium profile centered at the origin.
module stadium_cutout_2d(width, height) {
  r = width / 2;
  hull() {
    translate([0, -height / 2 + r]) circle(r = r);
    translate([0, height / 2 - r]) circle(r = r);
  }
}

// Generates a single countersunk screw clearance through-hole; the countersink leaves 1 mm of plate.
module countersunk_screw_hole(screw_d, cs_d, thickness) {
  cs_depth = (cs_d - screw_d) / 2;
  actual_cs_depth = min(cs_depth, thickness - 1.0);

  translate([0, thickness + EPSILON, 0]) {
    rotate([90, 0, 0]) {
      cylinder(d1 = cs_d, d2 = screw_d, h = actual_cs_depth + EPSILON);
      cylinder(d = screw_d, h = thickness + 2 * EPSILON);
    }
  }
}
