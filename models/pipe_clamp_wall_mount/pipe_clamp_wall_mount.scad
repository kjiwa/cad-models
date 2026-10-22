include <BOSL2/std.scad>

/**
 * Wall-mounted rack of angled openings for round rods, pipe clamp bars, or tool handles.
 *
 * A single block holds Holder_Count rods, each in an opening that leans back toward
 * the wall. Screws go through the back wall between the openings. All dimensions are
 * in millimeters.
 */

/* [Holders] */
// Number of pipe openings
Holder_Count = 4; // [1:1:12]

// Pipe outside diameter (28.575 for 1-1/8")
Pipe_Diameter = 28.575;

// Gap between neighboring pipes (12.7 for 1/2")
Pipe_Spacing = 12.7;

// Width of the block (X) (25.4 for 1")
Holder_Width = 25.4;

// Thickness of the wall behind the pipes (12.7 for 1/2")
Back_Wall_Thickness = 12.7;

// Angle the openings lean from horizontal, so pipes stay put
Opening_Angle = 30; // [0:1:60]

// Chamfer on the block's vertical edges and the opening mouths (1.5875 for 1/16") (0 to disable)
Edge_Chamfer = 1.5875;

/* [Alignment Notch] */
// Notch width at its base (9.525 for 3/8")
Notch_Bottom_Width = 9.525;

// Notch width at its tip (6.35 for 1/4")
Notch_Top_Width = 6.35;

// Notch height, a male tip on top and a female socket on the bottom for stacking blocks (4.7625 for 3/16")
Notch_Height = 4.7625;

// Gap around the tongue inside the socket so stacked blocks seat flush
Notch_Clearance = 0.2;

/* [Screw Holes] */
// Counterbore head diameter (15.875 for 5/8")
Screw_Head_Diameter = 15.875;

// Screw shank hole diameter (4.7625 for 3/16")
Screw_Hole_Diameter = 4.7625;

// Depth of the shank hole behind each pipe (9.525 for 3/8")
Screw_Hole_Depth = 9.525;

/* [Hidden] */
$fn = 128;

assert(Pipe_Diameter > 0, "Pipe_Diameter must be positive");
assert(
  Pipe_Diameter / 2 * (tan(Opening_Angle) + 1 / cos(Opening_Angle) - 1) < Pipe_Spacing,
  "Opening_Angle is too steep for Pipe_Spacing: openings would break through the block face and merge"
);
assert(Screw_Head_Diameter >= Screw_Hole_Diameter, "Screw_Head_Diameter must be at least Screw_Hole_Diameter");
assert(Notch_Height + Notch_Clearance < Pipe_Spacing, "Notch_Height plus Notch_Clearance must be less than Pipe_Spacing");
assert(Notch_Top_Width <= Notch_Bottom_Width, "Notch_Top_Width must not exceed Notch_Bottom_Width");
assert(
  Notch_Bottom_Width + 2 * Notch_Clearance + 2 * Edge_Chamfer < Holder_Width,
  "Notch is too wide for Holder_Width: widen the block or reduce Notch_Bottom_Width, Notch_Clearance or Edge_Chamfer"
);

holder_depth = Back_Wall_Thickness + Pipe_Diameter;
holder_height = Pipe_Spacing + Holder_Count * (Pipe_Spacing + Pipe_Diameter);

module OpeningProfile() {
  hull() {
    circle(d = Pipe_Diameter);
    rotate(-Opening_Angle)
      translate([0, -holder_depth])
      circle(d = Pipe_Diameter);
  }
}

module PipeOpening() {
  rotate([0, 90, 0]) {
    linear_extrude(height = 2 * Holder_Width, center = true)
      OpeningProfile();

    if (Edge_Chamfer > 0)
      for (side = [0, 1])
        mirror([0, 0, side])
          hull() {
            translate([0, 0, Holder_Width / 2 - Edge_Chamfer])
              linear_extrude(height = 0.01, center = true)
              OpeningProfile();
            translate([0, 0, Holder_Width / 2])
              linear_extrude(height = Holder_Width)
              offset(r = Edge_Chamfer)
              OpeningProfile();
          }
  }
}

module ScrewCutout() {
  rotate([-90, 0, 0]) {
    cylinder(d = Screw_Hole_Diameter, h = holder_depth);
    translate([0, 0, -holder_depth])
      cylinder(d = Screw_Head_Diameter, h = holder_depth);
  }
}

module AlignmentTongue() {
  prismoid(size1 = [Notch_Bottom_Width, holder_depth], size2 = [Notch_Top_Width, holder_depth], h = Notch_Height);
}

module AlignmentSocket() {
  margin = 1;
  depth = Notch_Height + Notch_Clearance;
  taper = (Notch_Bottom_Width - Notch_Top_Width) / depth;
  translate([0, 0, -margin])
    prismoid(
      size1 = [Notch_Bottom_Width + 2 * Notch_Clearance + taper * margin, holder_depth * 2],
      size2 = [Notch_Top_Width + 2 * Notch_Clearance, holder_depth * 2],
      h = depth + margin
    );
}

module Holder() {
  pitch = Pipe_Spacing + Pipe_Diameter;

  difference() {
    translate([0, Back_Wall_Thickness / 2, 0]) {
      difference() {
        union() {
          cuboid([Holder_Width, holder_depth, holder_height], chamfer = Edge_Chamfer, edges = "Z", anchor = BOTTOM);
          translate([0, 0, holder_height])
            AlignmentTongue();
        }

        AlignmentSocket();
      }
    }

    translate([0, 0, Pipe_Diameter / 2 + Pipe_Spacing])
      for (i = [0:Holder_Count - 1]) {
        translate([0, 0, i * pitch]) {
          PipeOpening();
          translate([0, holder_depth - Pipe_Diameter / 2 - Screw_Hole_Depth, 0])
            ScrewCutout();
        }
      }
  }
}

Holder();
