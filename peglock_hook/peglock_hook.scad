include <BOSL2/std.scad>
include <peglock/peglock.scad>

// TODO: Add option to toggle between Sy's Peglock and monolithic integrated pegs (pegs.scad).

/* [Hook] */
Hook_Shape = "Square";  // [Circle, Square, Triangle, RightTriangle]
Hook_Width = 12.7;
Hook_Height = 6.35;
Hook_Depth = 6.35;
Hook_Wall_Thickness = 1.5875;
Hook_Lip_Thickness = 3.175;
Hook_Lip_Height = 3.175;
Hook_Roundover = 1.5875;
Hook_Rows = 1;
Hook_Columns = 1;
Hook_Item_Quantity = 1;
Hook_Row_Spacing = 19.05;
Hook_Column_Spacing = 19.05;

/* [Peglock] */
Peglock_Width = 22;
Peglock_Height = 35.4;
Peglock_Depth = 6;
Peglock_Spacing = 25.4;
Peglock_Roundover = 3.175;

/* [Hidden] */
$fn = 128;
overallHookHeight = Hook_Height + 2 * Hook_Lip_Height;
overallHookWidth = Hook_Width;
backerWidth = max((Hook_Columns - 1) * Hook_Column_Spacing + Hook_Width, Peglock_Width);
backerHeight = max((Hook_Rows - 1) * Hook_Row_Spacing + Hook_Height, Peglock_Height);
numPeglocks = max(floor(backerWidth / Peglock_Width), 1);

if (Hook_Columns > 1) assert(Hook_Column_Spacing >= (Hook_Width));
if (Hook_Rows > 1) assert(Hook_Row_Spacing >= (Hook_Height + Hook_Lip_Height));

module RoundedTriangle(w, h, r = 0) {
  translate([0, h / 2, 0]) {
    if (r <= 0) {
      polygon([[w / 2, 0], [0, -h], [-w / 2, 0]]);
    } else {
      dx = (w / 2) - r;
      dy = h - r;

      hull() {
        translate([dx, -r])  circle(r = r, $fn=32);
        translate([-dx, -r]) circle(r = r, $fn=32);
        translate([0, -dy]) circle(r = r, $fn=32);
      }
    }
  }
}

module RoundedRightTriangle(l, h, d, cr) {
  translate([-l / 2, 0, h / 2])
    rotate([-90, 0, 0])
    hull() {
      translate([l - cr, h - cr]) cylinder(r=cr, h=d);
      translate([cr, h - cr]) cylinder(r=cr, h=d);
      translate([cr, cr]) cylinder(r=cr, h=d);
    }
}

module HookBase() {
  if (Hook_Shape == "Circle") {
    scale([Hook_Width, 1, Hook_Height])
      rotate([-90, 0, 0])
      cylinder(d=1, h=Hook_Depth);
  } else if (Hook_Shape == "Square") {
    translate([0, Hook_Depth / 2, 0])
      cuboid([Hook_Width, Hook_Depth, Hook_Height], rounding=Hook_Roundover, except=[FRONT, BACK]);
  } else if (Hook_Shape == "RightTriangle") {
    RoundedRightTriangle(Hook_Width, Hook_Height, Hook_Depth, Hook_Roundover);
  } else if (Hook_Shape == "Triangle") {
    rotate([-90, 0, 0])
      linear_extrude(Hook_Depth)
      RoundedTriangle(Hook_Width, Hook_Height, Hook_Roundover);
  }
}

module HookLipBase() {
  if (Hook_Shape == "Circle") {
    scale([Hook_Width, 1, Hook_Height])
      rotate([-90, 0, 0])
      cylinder(d=1, h=Hook_Lip_Thickness);
  } else if (Hook_Shape == "Square") {
    translate([0, Hook_Lip_Thickness / 2, 0])
      cuboid([Hook_Width, Hook_Lip_Thickness, Hook_Height], rounding=Hook_Roundover, except=[FRONT, BACK]);
  } else if (Hook_Shape == "RightTriangle") {
    RoundedRightTriangle(Hook_Width, Hook_Height, Hook_Lip_Thickness, Hook_Roundover);
  } else if (Hook_Shape == "Triangle") {
    rotate([-90, 0, 0])
      linear_extrude(Hook_Lip_Thickness)
      RoundedTriangle(Hook_Width, Hook_Height, Hook_Roundover);
  }
}

module HookLip() {
  hull() {
    HookLipBase();
    translate([0, 0, Hook_Lip_Height]) HookLipBase();
  }
}

module SingleHook() {
  translate([0, 0, 0]) {
    HookBase();
    translate([0, Hook_Depth, 0]) HookLip();
  }
}

module HookGrid() {
  x = (Hook_Columns - 1) * Hook_Column_Spacing;
  z = backerHeight + 2 * Hook_Lip_Height;

  translate([-x / 2, 0, (Hook_Height - z) / 2 + Hook_Lip_Height])
    for (i=[1:Hook_Columns]) {
      for (j=[1:Hook_Rows]) {
        for (k=[1:Hook_Item_Quantity]) {
          translate([(i - 1) * Hook_Column_Spacing, (k - 1) * (Hook_Depth + Hook_Lip_Thickness), (j - 1) * Hook_Row_Spacing])
            SingleHook();
        }
      }
    }
}

module HookBacker() {
  cuboid([backerWidth, Hook_Wall_Thickness, backerHeight], rounding=min(Hook_Roundover, Peglock_Roundover), except=[FRONT, BACK]);
}

module Hook() {
  translate([0, -Hook_Wall_Thickness, 0])
    PeglockBase(
      count = numPeglocks,
      width = Peglock_Width,
      height = Peglock_Height,
      depth = Peglock_Depth,
      spacing = Peglock_Spacing,
      roundover = Peglock_Roundover
    );
  translate([0, -Hook_Wall_Thickness / 2, 0]) HookBacker();
  HookGrid();
}

rotate([0, 0, 180]) Hook();
