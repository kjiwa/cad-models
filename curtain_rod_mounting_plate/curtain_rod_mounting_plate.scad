/**
 * Parametric mounting plate to secure curtain rod brackets to walls or trim.
 * Dimensions are specified in inches and scaled to millimeters on export.
 */

/* [Dimensions] */
plate_width = 6.0;       // Width of the mounting plate in inches
plate_height = 4.0;      // Height of the mounting plate in inches
plate_thickness = 0.25;  // Thickness of the mounting plate in inches
chamfer_size = 0.125;    // Chamfer size along top edges in inches

/* [Mounting Holes] */
screw_hole_diameter = 0.1875;  // Diameter of screw clearance holes in inches (#8 screw diameter ~5/32")
hole_side_margin = 0.5;        // Distance from side edge to screw hole centers in inches
holes_per_column = 2;          // Number of screw holes per side column [1:1:10]
hole_spacing = 3.0;            // Vertical center-to-center spacing between outermost holes in inches

/* [Hex Nut Boss] */
boss_height = 1.5;             // Height of the boss block in inches
boss_width = 0.5;              // Width of the boss block in inches
boss_thickness = 0.25;         // Thickness of the boss block in inches
boss_x_offset = 0.0;           // Offset of the boss along X axis from center in inches
hex_nut_flats_dia = 0.328125;  // Distance across flats for hex nut in inches
hex_nut_depth = 0.125;         // Depth of hex nut pocket in inches
hex_nut_count = 2;             // Number of hex nut pockets [1:1:10]
hex_nut_spacing = 0.875;       // Vertical center-to-center spacing between outermost hex nuts in inches

/* [Hidden] */
$fn = 64;
EPSILON = 0.01;     // Small offset to ensure clean manifold boolean cuts
INCH_TO_MM = 25.4;  // Conversion factor from inches to millimeters

// Generates the base plate with top-edge chamfers via convex hull.
module chamfered_plate(width = plate_width, height = plate_height, thickness = plate_thickness, chamfer = chamfer_size) {
  if (chamfer > 0 && chamfer < min(width / 2, height / 2, thickness)) {
    hull() {
      translate([0, 0, (thickness - chamfer) / 2])
        cube([width, height, thickness - chamfer], center = true);
      translate([0, 0, thickness - EPSILON / 2])
        cube([width - 2 * chamfer, height - 2 * chamfer, EPSILON], center = true);
    }
  } else {
    translate([0, 0, thickness / 2])
      cube([width, height, thickness], center = true);
  }
}

// Generates wall mounting screw clearance holes along left and right margins.
module mounting_hole_pattern(width = plate_width, thickness = plate_thickness, hole_dia = screw_hole_diameter, side_margin = hole_side_margin, count = holes_per_column, spacing = hole_spacing) {
  x_positions = [-width / 2 + side_margin, width / 2 - side_margin];

  for (x = x_positions) {
    if (count <= 1) {
      translate([x, 0, -EPSILON])
        cylinder(d = hole_dia, h = thickness + 2 * EPSILON);
    } else {
      for (i = [0 : count - 1]) {
        y = -spacing / 2 + i * (spacing / (count - 1));
        translate([x, y, -EPSILON])
          cylinder(d = hole_dia, h = thickness + 2 * EPSILON);
      }
    }
  }
}

// Generates the raised rear boss block to house hex nuts for bracket mounting screws.
module hex_nut_boss(width = boss_width, height = boss_height, thickness = boss_thickness, x_offset = boss_x_offset) {
  translate([x_offset, 0, -thickness / 2])
    cube([width, height, thickness], center = true);
}

// Generates hex nut pockets and screw clearance through-holes in the boss.
module hex_nut_boss_pattern(thickness = boss_thickness, plate_thick = plate_thickness, x_offset = boss_x_offset, flats_dia = hex_nut_flats_dia, nut_depth = hex_nut_depth, count = hex_nut_count, spacing = hex_nut_spacing, screw_dia = screw_hole_diameter) {
  // Convert distance across flats to circumscribed cylinder diameter for 6-sided cylinder
  hex_outer_dia = flats_dia / cos(30);

  if (count <= 1) {
    translate([x_offset, 0, -thickness - EPSILON])
      cylinder(d = hex_outer_dia, h = nut_depth + EPSILON, $fn = 6);
    translate([x_offset, 0, -thickness - EPSILON])
      cylinder(d = screw_dia, h = thickness + plate_thick + 2 * EPSILON);
  } else {
    for (i = [0 : count - 1]) {
      y = -spacing / 2 + i * (spacing / (count - 1));
      translate([x_offset, y, -thickness - EPSILON])
        cylinder(d = hex_outer_dia, h = nut_depth + EPSILON, $fn = 6);
      translate([x_offset, y, -thickness - EPSILON])
        cylinder(d = screw_dia, h = thickness + plate_thick + 2 * EPSILON);
    }
  }
}

// Full assembly: plate with boss, minus wall screw and bracket mounting holes.
module curtain_rod_mounting_plate() {
  difference() {
    union() {
      chamfered_plate();
      hex_nut_boss();
    }
    mounting_hole_pattern();
    hex_nut_boss_pattern();
  }
}

// Convert from inch design units to standard millimeters for 3D printing
scale([INCH_TO_MM, INCH_TO_MM, INCH_TO_MM]) {
  curtain_rod_mounting_plate();
}
