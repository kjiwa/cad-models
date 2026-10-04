/**
 * Parametric mounting plate to secure curtain rod brackets to walls or trim.
 * All dimensions are in millimeters.
 */

/* [Plate] */
// Width of the mounting plate
Plate_Width = 152.4;

// Height of the mounting plate
Plate_Height = 101.6;

// Thickness of the mounting plate
Plate_Thickness = 6.35;

// Chamfer size along the top edges
Edge_Chamfer = 3.175;

/* [Screw Holes] */
// Diameter of the wall screw holes and bracket screw holes through the boss (4.7625 for #8 screws)
Screw_Hole_Diameter = 4.7625;

// Number of wall screw holes per side
Holes_Per_Side = 2; // [1:1:10]

// Vertical center-to-center distance between the outermost holes on each side
Hole_Span = 76.2;

// Distance from the side edge to the screw hole centers
Hole_Edge_Inset = 12.7;

/* [Nut Boss] */
// Width of the boss block
Boss_Width = 12.7;

// Height of the boss block
Boss_Height = 38.1;

// Rear protrusion of the boss block
Boss_Thickness = 6.35;

// Offset of the boss along X from the plate center
Boss_Offset = 0;

// Number of hex nut pockets
Nut_Count = 2; // [1:1:10]

// Vertical center-to-center distance between the outermost nut pockets
Nut_Span = 22.225;

// Distance across the flats of the hex nut
Nut_Width_Across_Flats = 8.334375;

// Depth of each hex nut pocket
Nut_Pocket_Depth = 3.175;

/* [Hidden] */
$fn = 64;
EPSILON = 0.254;

// Generates the base plate with top-edge chamfers via convex hull.
module chamfered_plate(width = Plate_Width, height = Plate_Height, thickness = Plate_Thickness, chamfer = Edge_Chamfer) {
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
module mounting_hole_pattern(width = Plate_Width, thickness = Plate_Thickness, hole_dia = Screw_Hole_Diameter, side_margin = Hole_Edge_Inset, count = Holes_Per_Side, spacing = Hole_Span) {
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
module hex_nut_boss(width = Boss_Width, height = Boss_Height, thickness = Boss_Thickness, x_offset = Boss_Offset) {
  translate([x_offset, 0, -thickness / 2])
    cube([width, height, thickness], center = true);
}

// Generates hex nut pockets and screw clearance through-holes in the boss.
module hex_nut_boss_pattern(thickness = Boss_Thickness, plate_thick = Plate_Thickness, x_offset = Boss_Offset, flats_dia = Nut_Width_Across_Flats, nut_depth = Nut_Pocket_Depth, count = Nut_Count, spacing = Nut_Span, screw_dia = Screw_Hole_Diameter) {
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

curtain_rod_mounting_plate();
