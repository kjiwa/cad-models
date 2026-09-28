include <BOSL2/std.scad>
include <peglock/peglock.scad>

// TODO: Add option to toggle between Sy's Peglock and monolithic integrated pegs (pegs.scad).

/* [Holder] */
Holder_Width = 12.7;
Holder_Depth = 6.35;
Holder_Height = 12.7;
Holder_Closed_Bottom = true;
Holder_Front_Opening = 6.35;
Holder_Front_Lip_Thickness = 3.175;
Holder_Front_Lip_Height = 3.175;
Holder_Wall_Thickness = 1.5875;
Holder_Roundover = 3.175;
Holder_Rows = 1;
Holder_Columns = 1;

/* [Peglock] */
Peglock_Width = 22;
Peglock_Height = 35.4;
Peglock_Depth = 6;
Peglock_Spacing = 25.4;
Peglock_Roundover = 3.175;

/* [Hidden] */
$fn = 128;
overallHolderWidth = Holder_Columns * (Holder_Width + Holder_Wall_Thickness) + Holder_Wall_Thickness;
overallHolderDepth = Holder_Rows * (Holder_Depth + Holder_Wall_Thickness);
numPeglocks = max(floor(overallHolderWidth / Peglock_Width), 1);
backerWidth = max(overallHolderWidth, Peglock_Width);
backerHeight = max(Holder_Height, Peglock_Height);

module HolderLip() {
  translate([0, -Holder_Front_Lip_Thickness / 2, Holder_Front_Lip_Height / 2])
    intersection() {
      cuboid([overallHolderWidth, Holder_Front_Lip_Thickness, Holder_Front_Lip_Height], rounding=0, edges=[FRONT]);
      translate([0, -Holder_Roundover + Holder_Front_Lip_Thickness / 2, 0])
        cuboid([overallHolderWidth, 2 * Holder_Roundover, Holder_Front_Lip_Height], rounding=Holder_Roundover, edges=[BACK+LEFT, BACK+RIGHT]);
    }
}

module Holder() {
  h = Holder_Height + (Holder_Closed_Bottom ? Holder_Wall_Thickness : 0);
  tz = (h - Peglock_Height) / 2 + Peglock_Roundover;
  translate([0, -Holder_Wall_Thickness, 0])
    PeglockBase(
      count = numPeglocks,
      width = Peglock_Width,
      height = Peglock_Height,
      depth = Peglock_Depth,
      spacing = Peglock_Spacing,
      roundover = Peglock_Roundover
    );
  translate([0, -Holder_Wall_Thickness, 0]) HolderBacker();
  translate([0, 0, h < (Peglock_Height - 2 * Peglock_Roundover) ? tz : 0]) HolderGrid();
}

module HolderBacker() {
  translate([0, Holder_Wall_Thickness / 2, 0])
    cuboid([backerWidth, Holder_Wall_Thickness, backerHeight], rounding=Peglock_Roundover, except=[FRONT, BACK]);
}

module SingleHolderInside() {
  z = Holder_Height + Holder_Front_Lip_Height + 2 + (Holder_Closed_Bottom ? Holder_Wall_Thickness : 0);
  tz = 1 + (Holder_Closed_Bottom ? Holder_Wall_Thickness : -1);
  translate([0, Holder_Depth / 2, tz])
    cuboid([Holder_Width, Holder_Depth, z], rounding=Holder_Roundover, except=[TOP, BOTTOM, FRONT]);
  translate([-Holder_Front_Opening / 2, 0, -z / 2])
    cube([Holder_Front_Opening, Holder_Wall_Thickness + 3 * Holder_Depth / 2, z]);
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
        translate([tx, ty, Holder_Front_Lip_Height / 2]) SingleHolderInside();
      }
    }
  }
}

rotate([0, 0, 180]) {
  Holder();
}
