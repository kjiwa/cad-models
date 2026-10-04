include <BOSL2/std.scad>
include <peglock/peglock.scad>
include <pegboard/pegs.scad>

/* [Mounting] */
// Mounting interface: modular Peglock wedge socket or monolithic integrated pegboard pegs
Mount_Type = "peglock"; // [peglock: Modular Peglock Socket, monolithic: Integrated Pegboard Pegs]

/* [Pegboard] */
// Center-to-center hole spacing in mm (25.4 for 1" standard, 15.875 for 5/8" metal)
Peg_Spacing = 25.4;
// Pegboard hole diameter in mm (5.7 for standard 1/4" fit, 6.0 for original Sy fit)
Peg_Diameter = 5.7;
// Pegboard sheet thickness in mm (6.35 for 1/4" board, 1.5875 for 1/16" thin metal)
Pegboard_Thickness = 6.35;
// Retention hook tab rise height in mm
Hook_Rise = 3.5;

/* [Holder] */
Holder_Width = 12.7;
Holder_Depth = 6.35;
Holder_Height = 12.7;
Holder_Closed_Bottom = true;
Holder_Front_Opening = 6.35;
Holder_Front_Opening_Front_Only = false; // Only cut front access opening on the front-most row when multi-row
Holder_Opening_Bevel = 1.0; // Front opening lead-in bevel/chamfer in mm (0 to disable)
Holder_Front_Lip_Thickness = 3.175;
Holder_Front_Lip_Height = 3.175;
Holder_Wall_Thickness = 1.5875;
// Thickness of the backplate behind the pockets; thicker resists flex under heavy loads
Holder_Backer_Thickness = 1.5875;
// Where the pockets sit on the backplate
Holder_Vertical_Align = "bottom"; // [bottom: Pockets at plate bottom, center: Pockets centered on plate]
Holder_Roundover = 3.175;
// Rounds the pocket body's underside edges, except where it meets the plate (0 to disable)
Holder_Bottom_Roundover = 0;
// Size of the triangular web under the pockets where they meet the plate, clamped to the plate below them (0 to disable)
Holder_Junction_Gusset = 0;
// Forward tilt of the pockets in degrees (0 for vertical)
Holder_Tilt_Angle = 0; // [0:5:45]
Holder_Rows = 1;
Holder_Columns = 1;

assert(Holder_Tilt_Angle >= 0 && Holder_Tilt_Angle <= 45, "Holder_Tilt_Angle must be between 0 and 45");

/* [Peglock] */
Peglock_Width = SOCKET_WIDTH;
Peglock_Height = SOCKET_HEIGHT;
Peglock_Depth = SOCKET_DEPTH;
Peglock_Spacing = 25.4;
Peglock_Roundover = SOCKET_ROUNDOVER;

/* [Hidden] */
$fn = 128;
EPSILON = 0.02;

overallHolderWidth = Holder_Columns * (Holder_Width + Holder_Wall_Thickness) + Holder_Wall_Thickness;
overallHolderDepth = Holder_Rows * (Holder_Depth + Holder_Wall_Thickness);

effective_spacing = (Peglock_Spacing != 25.4 && Peg_Spacing == 25.4) ? Peglock_Spacing : Peg_Spacing;
numPeglocks = max(floor(overallHolderWidth / Peglock_Width), 1);
peglockBaseWidth = peglock_base_width(numPeglocks, Peglock_Width, effective_spacing);

h = Holder_Height + (Holder_Closed_Bottom ? Holder_Wall_Thickness : 0);
tilted_height = h * cos(Holder_Tilt_Angle) + overallHolderDepth * sin(Holder_Tilt_Angle);

tilt_drop = overallHolderDepth * sin(Holder_Tilt_Angle);
grid_tz = (Holder_Vertical_Align == "bottom" && tilted_height < (Peglock_Height - 2 * Peglock_Roundover))
  ? (h - Peglock_Height) / 2 + Peglock_Roundover + tilt_drop
  : (h * (1 - cos(Holder_Tilt_Angle)) + tilt_drop) / 2;

backerWidth = max(overallHolderWidth, (Mount_Type == "peglock" ? peglockBaseWidth : effective_spacing));
backerHeight = max(tilted_height, (Mount_Type == "peglock" ? Peglock_Height : effective_spacing + 10));

module HolderLip() {
  translate([0, -Holder_Front_Lip_Thickness / 2, Holder_Front_Lip_Height / 2])
    intersection() {
      cuboid([overallHolderWidth, Holder_Front_Lip_Thickness, Holder_Front_Lip_Height], rounding=0, edges=[FRONT]);
      translate([0, -Holder_Roundover + Holder_Front_Lip_Thickness / 2, 0])
        cuboid([overallHolderWidth, 2 * Holder_Roundover, Holder_Front_Lip_Height], rounding=Holder_Roundover, edges=[BACK+LEFT, BACK+RIGHT]);
    }
}

module SingleHolderInside(cut_front_opening = true) {
  z = Holder_Height + Holder_Front_Lip_Height + 2 + (Holder_Closed_Bottom ? Holder_Wall_Thickness : 0);
  tz = 1 + (Holder_Closed_Bottom ? Holder_Wall_Thickness : -1);
  translate([0, Holder_Depth / 2, tz])
    cuboid([Holder_Width, Holder_Depth, z], rounding=Holder_Roundover, except=[TOP, BOTTOM, FRONT]);
  if (cut_front_opening) {
    cut_depth = Holder_Wall_Thickness + 3 * Holder_Depth / 2;
    translate([-Holder_Front_Opening / 2, 0, -z / 2])
      cube([Holder_Front_Opening, cut_depth, z]);

    if (Holder_Opening_Bevel > 0) {
      b = min(Holder_Opening_Bevel, Holder_Front_Opening / 4);
      y_entry = Holder_Depth + Holder_Wall_Thickness;
      translate([-Holder_Front_Opening / 2, y_entry, 0])
        rotate([0, 0, 45])
          cube([b * sqrt(2), b * sqrt(2), z * 2], center=true);
      translate([Holder_Front_Opening / 2, y_entry, 0])
        rotate([0, 0, 45])
          cube([b * sqrt(2), b * sqrt(2), z * 2], center=true);
    }
  }
}

module HolderBody() {
  size = [overallHolderWidth, overallHolderDepth, h];
  bottom_roundover = min(Holder_Bottom_Roundover, Holder_Wall_Thickness);
  translate([0, overallHolderDepth / 2, 0]) {
    if (bottom_roundover > 0) {
      intersection() {
        cuboid(size, rounding=Holder_Roundover, except=[TOP, BOTTOM, FRONT]);
        cuboid(size, rounding=bottom_roundover, edges=BOTTOM, except=BACK);
      }
    } else {
      cuboid(size, rounding=Holder_Roundover, except=[TOP, BOTTOM, FRONT]);
    }
  }
}

// Rotates children forward about the bottom edge where the holder meets the backer
module Tilted() {
  translate([0, 0, -h / 2]) rotate([-Holder_Tilt_Angle, 0, 0]) translate([0, 0, h / 2]) children();
}

// Fills the wedge between the backer and the tilted back wall; the strip stops short of the
// rounded back corners so the fill never leaves the body's own outline.
module HolderRearFill() {
  hull() {
    Tilted() HolderBody();
    translate([-overallHolderWidth / 2 + Holder_Roundover, 0, -h / 2])
      cube([overallHolderWidth - 2 * Holder_Roundover, 0.01, h * cos(Holder_Tilt_Angle)]);
  }
}

// Triangular web from the plate face to the tilted underside, inset like HolderRearFill
module HolderJunctionGusset() {
  room = grid_tz - h / 2 + backerHeight / 2;
  size = min(Holder_Junction_Gusset, room, overallHolderDepth);
  width = overallHolderWidth - 2 * Holder_Roundover;
  if (size > 0) {
    hull() {
      translate([-width / 2, 0, -h / 2 - size]) cube([width, 0.01, size]);
      Tilted() translate([-width / 2, size, -h / 2]) cube([width, 0.01, 0.01]);
    }
  }
}

module HolderGrid() {
  difference() {
    union() {
      Tilted() {
        HolderBody();
        translate([0, overallHolderDepth, h / 2]) HolderLip();
      }
      if (Holder_Tilt_Angle > 0) HolderRearFill();
      if (Holder_Junction_Gusset > 0) HolderJunctionGusset();
    }

    Tilted()
      for (i=[1:Holder_Columns]) {
        tx = (i - 1) * (Holder_Width + Holder_Wall_Thickness) + (Holder_Width - overallHolderWidth) / 2 + Holder_Wall_Thickness;
        for (j=[1:Holder_Rows]) {
          ty = (j - 1) * (Holder_Depth + Holder_Wall_Thickness);
          cut_opening = (!Holder_Front_Opening_Front_Only || j == Holder_Rows);
          translate([tx, ty, Holder_Front_Lip_Height / 2]) SingleHolderInside(cut_opening);
        }
      }
  }
}

module MonolithicPegs() {
  cols = max(floor((backerWidth - Peg_Diameter) / effective_spacing) + 1, 1);
  num_peg_intervals = max(floor((backerHeight - 10) / effective_spacing), 1);
  z_top = num_peg_intervals * effective_spacing / 2;

  for (c = [0 : cols - 1]) {
    x = (cols == 1) ? 0 : (c - (cols - 1) / 2) * effective_spacing;
    translate([x, -Holder_Backer_Thickness, z_top])
      pegboard_upper_hook(
        pin_d = Peg_Diameter,
        board_t = Pegboard_Thickness,
        rise = Hook_Rise,
        backplate_t = Holder_Backer_Thickness
      );
    for (k = [1 : num_peg_intervals]) {
      translate([x, -Holder_Backer_Thickness, z_top - k * effective_spacing])
        pegboard_lower_pin(
          pin_d = Peg_Diameter,
          board_t = Pegboard_Thickness,
          backplate_t = Holder_Backer_Thickness
        );
    }
  }
}

module HolderBacker() {
  translate([0, Holder_Backer_Thickness / 2, 0])
    cuboid([backerWidth, Holder_Backer_Thickness, backerHeight], rounding=Peglock_Roundover, except=[FRONT, BACK]);
}

module Holder() {
  if (Mount_Type == "peglock") {
    translate([0, -Holder_Backer_Thickness + EPSILON, 0])
      PeglockBase(
        count = numPeglocks,
        width = Peglock_Width,
        height = Peglock_Height,
        depth = Peglock_Depth,
        spacing = effective_spacing,
        roundover = Peglock_Roundover
      );
  } else if (Mount_Type == "monolithic") {
    MonolithicPegs();
  }
  translate([0, -Holder_Backer_Thickness, 0]) HolderBacker();
  translate([0, 0, grid_tz]) HolderGrid();
}

rotate([0, 0, 180]) {
  Holder();
}
