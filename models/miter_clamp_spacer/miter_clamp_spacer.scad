/**
 * Corner spacer for clamping a mitered frame: a right-triangle block with a slot that holds the
 * frame corner. All dimensions are in millimeters.
 */

/* [Frame] */
// Frame thickness (19.84375 for 25/32")
Frame_Thickness = 19.84375;

// Frame edge width the spacer overlaps (3.175 for 1/8")
Frame_Overhang = 3.175;

/* [Spacer] */
// Spacer thickness (28.575 for 1-1/8")
Holder_Thickness = 28.575;

// Diameter of the relief cut into the inside corner (3.175 for 1/8")
Corner_Relief_Diameter = 3.175;

// Side length of the square the spacer is cut from, at least Holder_Thickness (30 for 1-3/16")
Length = 30;

// Chamfer on the outer edges (1.5875 for 1/16") (0 to disable)
Edge_Chamfer = 1.5875;

/* [Hidden] */
$fn = 128;

wall_thickness = (Holder_Thickness - Frame_Thickness) / 2;

assert(Frame_Thickness < Holder_Thickness, "Frame_Thickness must be less than Holder_Thickness");
assert(Length >= Holder_Thickness, "Length must be at least Holder_Thickness");
assert(Edge_Chamfer >= 0 && Edge_Chamfer < wall_thickness, "Edge_Chamfer must be at least 0 and less than the wall thickness");

module CornerRelief() {
  l = Frame_Overhang + Corner_Relief_Diameter / 2;
  translate([0, 0, -1]) hull() {
    cylinder(d = Corner_Relief_Diameter, h = Holder_Thickness + 2);
    translate([l, l, 0]) cylinder(d = Corner_Relief_Diameter, h = Holder_Thickness + 2);
  }
}

module Body() {
  x = Holder_Thickness * sqrt(2);

  intersection() {
    difference() {
      cube([Length, Length, Holder_Thickness]);
      translate([wall_thickness, wall_thickness, wall_thickness]) cube([Length + 1, Length + 1, Frame_Thickness]);
      translate([wall_thickness + Frame_Overhang, wall_thickness + Frame_Overhang, -1]) cube([Length + 1, Length + 1, Holder_Thickness + 2]);
      translate([wall_thickness, wall_thickness, 0]) CornerRelief();
    }

    rotate([0, 0, 45]) translate([-x / 2, -x / 2, -1]) cube([x, x, Holder_Thickness + 2]);
  }
}

// The triangular outline of the spacer with the outer corner and the two outer leg edges chamfered; the diagonal face stays sharp.
module ChamferedOutline() {
  c = Edge_Chamfer;
  h = Holder_Thickness;
  hull() {
    translate([0, 0, c]) linear_extrude(height = h - 2 * c) polygon([[c, 0], [h, 0], [0, h], [0, c]]);
    for (z = [0, h - 0.001]) translate([0, 0, z]) linear_extrude(height = 0.001) polygon([[c, c], [h - c, c], [c, h - c]]);
  }
}

module Spacer() {
  if (Edge_Chamfer > 0) intersection() {
      Body();
      ChamferedOutline();
    }
  else Body();
}

Spacer();
