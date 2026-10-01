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
Holder_Roundover = 3.175;
Holder_Rows = 1;
Holder_Columns = 1;

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

backerWidth = max(overallHolderWidth, (Mount_Type == "peglock" ? peglockBaseWidth : effective_spacing));
backerHeight = max(Holder_Height, (Mount_Type == "peglock" ? Peglock_Height : effective_spacing + 10));

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

module HolderGrid() {
  z = Holder_Height + (Holder_Closed_Bottom ? Holder_Wall_Thickness : 0);
  difference() {
    union() {
      translate([0, overallHolderDepth / 2, 0])
        cuboid([overallHolderWidth, overallHolderDepth, z], rounding=Holder_Roundover, except=[TOP, BOTTOM, FRONT]);
      translate([0, overallHolderDepth, z / 2]) HolderLip();
    }

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
    translate([x, -Holder_Wall_Thickness, z_top])
      pegboard_upper_hook(
        pin_d = Peg_Diameter,
        board_t = Pegboard_Thickness,
        rise = Hook_Rise,
        backplate_t = Holder_Wall_Thickness
      );
    for (k = [1 : num_peg_intervals]) {
      translate([x, -Holder_Wall_Thickness, z_top - k * effective_spacing])
        pegboard_lower_pin(
          pin_d = Peg_Diameter,
          board_t = Pegboard_Thickness,
          backplate_t = Holder_Wall_Thickness
        );
    }
  }
}

module HolderBacker() {
  translate([0, Holder_Wall_Thickness / 2, 0])
    cuboid([backerWidth, Holder_Wall_Thickness, backerHeight], rounding=Peglock_Roundover, except=[FRONT, BACK]);
}

module Holder() {
  h = Holder_Height + (Holder_Closed_Bottom ? Holder_Wall_Thickness : 0);
  tz = (h - Peglock_Height) / 2 + Peglock_Roundover;
  if (Mount_Type == "peglock") {
    translate([0, -Holder_Wall_Thickness + EPSILON, 0])
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
  translate([0, -Holder_Wall_Thickness, 0]) HolderBacker();
  translate([0, 0, h < (Peglock_Height - 2 * Peglock_Roundover) ? tz : 0]) HolderGrid();
}

rotate([0, 0, 180]) {
  Holder();
}
