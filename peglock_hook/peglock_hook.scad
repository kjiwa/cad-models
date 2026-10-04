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

/* [Hook] */
Hook_Shape = "Square";  // [Circle, Square, Triangle, RightTriangle]
Hook_Width = 12.7;
Hook_Height = 6.35;
Hook_Depth = 6.35;
Hook_Wall_Thickness = 1.5875;
Hook_Lip_Thickness = 3.175;
Hook_Lip_Height = 3.175;
Hook_Roundover = 1.5875;
Hook_Root_Fillet = 0; // Stress relief root fillet (0 for standard/tested profile, >0 to strengthen)
// Upward tilt of the hook arm in degrees (0 for horizontal)
Hook_Tilt_Angle = 0; // [0:5:45]
// Orientation of the retaining lip when the arm is tilted
Hook_Lip_Orientation = "perpendicular"; // [perpendicular: Square to hook arm, vertical: Parallel to backplate]
Hook_Rows = 1;
Hook_Columns = 1;
Hook_Item_Quantity = 1;
Hook_Row_Spacing = 19.05;
Hook_Column_Spacing = 19.05;

assert(Hook_Tilt_Angle >= 0 && Hook_Tilt_Angle <= 45, "Hook_Tilt_Angle must be between 0 and 45");

/* [Peglock] */
Peglock_Width = SOCKET_WIDTH;
Peglock_Height = SOCKET_HEIGHT;
Peglock_Depth = SOCKET_DEPTH;
Peglock_Spacing = 25.4;
Peglock_Roundover = SOCKET_ROUNDOVER;

/* [Hidden] */
$fn = 128;
EPSILON = 0.02;

overallHookHeight = Hook_Height + 2 * Hook_Lip_Height;
overallHookWidth = Hook_Width;
gridWidth = (Hook_Columns - 1) * Hook_Column_Spacing + Hook_Width;
gridHeight = (Hook_Rows - 1) * Hook_Row_Spacing + Hook_Height;

effective_spacing = (Peglock_Spacing != 25.4 && Peg_Spacing == 25.4) ? Peglock_Spacing : Peg_Spacing;
numPeglocks = max(floor(max(gridWidth, Peglock_Width) / Peglock_Width), 1);
peglockBaseWidth = peglock_base_width(numPeglocks, Peglock_Width, effective_spacing);

fillet_max_depth = Hook_Depth * 0.35;
fillet_max_height = min(Hook_Lip_Height * 0.4, Hook_Height * 0.35);
fillet_max_width = Hook_Width * 0.35;

fillet_reach_y = min(Hook_Root_Fillet, fillet_max_depth);
fillet_flare_z = min(Hook_Root_Fillet, fillet_max_height);
fillet_flare_x = min(Hook_Root_Fillet, fillet_max_width);

arm_slice_drop = Hook_Height * (1 / cos(Hook_Tilt_Angle) - 1);
tilt_root_drop = max(0, arm_slice_drop - fillet_flare_z);

backerWidth = max(gridWidth + 2 * fillet_flare_x, (Mount_Type == "peglock" ? peglockBaseWidth : effective_spacing));
backerHeight = max(gridHeight + fillet_flare_z + tilt_root_drop, (Mount_Type == "peglock" ? Peglock_Height : effective_spacing + 10));

if (Hook_Columns > 1) assert(Hook_Column_Spacing >= (Hook_Width));
if (Hook_Rows > 1) assert(Hook_Row_Spacing * cos(Hook_Tilt_Angle) >= (Hook_Height + Hook_Lip_Height));

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

module HookProfile(depth) {
  if (Hook_Shape == "Circle") {
    scale([Hook_Width, 1, Hook_Height])
      rotate([-90, 0, 0])
      cylinder(d=1, h=depth);
  } else if (Hook_Shape == "Square") {
    translate([0, depth / 2, 0])
      cuboid([Hook_Width, depth, Hook_Height], rounding=Hook_Roundover, except=[FRONT, BACK]);
  } else if (Hook_Shape == "RightTriangle") {
    RoundedRightTriangle(Hook_Width, Hook_Height, depth, Hook_Roundover);
  } else if (Hook_Shape == "Triangle") {
    rotate([-90, 0, 0])
      linear_extrude(depth)
      RoundedTriangle(Hook_Width, Hook_Height, Hook_Roundover);
  }
}

module HookRootFillet() {
  if (Hook_Root_Fillet > 0) {
    hull() {
      scale([(Hook_Width + 2 * fillet_flare_x) / Hook_Width, 1, (Hook_Height + 2 * fillet_flare_z) / Hook_Height])
        HookProfile(0.01);
      translate([0, fillet_reach_y, 0])
        HookProfile(0.01);
    }
  }
}

module HookLipBody() {
  hull() {
    HookProfile(Hook_Lip_Thickness);
    translate([0, 0, Hook_Lip_Height]) HookProfile(Hook_Lip_Thickness);
  }
}

// Inside the tilted arm frame, counter-rotating the lip makes it parallel to the backplate;
// the hull with the arm's end face bridges the wedge that opens between them.
module HookLip() {
  if (Hook_Lip_Orientation == "vertical" && Hook_Tilt_Angle > 0) {
    hull() {
      translate([0, -0.01, 0]) HookProfile(0.01);
      rotate([-Hook_Tilt_Angle, 0, 0]) HookLipBody();
    }
  } else {
    HookLipBody();
  }
}

module SingleHook() {
  HookProfile(Hook_Depth);
  HookRootFillet();
  translate([0, Hook_Depth, 0]) HookLip();
}

// One grid cell: Hook_Item_Quantity hooks tilted about the arm's top-back edge. The arm is
// extended backward and trimmed at the backplate face so the root stays flush at any angle.
module HookArm() {
  extra_back = Hook_Height * tan(Hook_Tilt_Angle) + 1;
  trim = extra_back + Hook_Height + 1;
  pivot_z = Hook_Height / 2;

  difference() {
    union() {
      translate([0, 0, pivot_z])
        rotate([Hook_Tilt_Angle, 0, 0])
          translate([0, 0, -pivot_z]) {
            translate([0, -extra_back, 0]) HookProfile(Hook_Depth + extra_back);
            translate([0, Hook_Depth, 0]) HookLip();
            if (Hook_Item_Quantity > 1) {
              for (k = [2:Hook_Item_Quantity]) {
                translate([0, (k - 1) * (Hook_Depth + Hook_Lip_Thickness), 0]) SingleHook();
              }
            }
          }
      HookRootFillet();
    }
    translate([-(Hook_Width + 2) / 2, -trim, -trim]) cube([Hook_Width + 2, trim, 2 * trim]);
  }
}

module HookGrid() {
  x = (Hook_Columns - 1) * Hook_Column_Spacing;
  z_base = -backerHeight / 2 + Hook_Height / 2 + fillet_flare_z + tilt_root_drop;

  translate([-x / 2, 0, z_base])
    for (i=[1:Hook_Columns]) {
      for (j=[1:Hook_Rows]) {
        translate([(i - 1) * Hook_Column_Spacing, 0, (j - 1) * Hook_Row_Spacing]) HookArm();
      }
    }
}

module MonolithicPegs() {
  cols = max(floor((backerWidth - Peg_Diameter) / effective_spacing) + 1, 1);
  num_peg_intervals = max(floor((backerHeight - 10) / effective_spacing), 1);
  z_top = num_peg_intervals * effective_spacing / 2;

  for (c = [0 : cols - 1]) {
    x = (cols == 1) ? 0 : (c - (cols - 1) / 2) * effective_spacing;
    translate([x, -Hook_Wall_Thickness, z_top])
      pegboard_upper_hook(
        pin_d = Peg_Diameter,
        board_t = Pegboard_Thickness,
        rise = Hook_Rise,
        backplate_t = Hook_Wall_Thickness
      );
    for (k = [1 : num_peg_intervals]) {
      translate([x, -Hook_Wall_Thickness, z_top - k * effective_spacing])
        pegboard_lower_pin(
          pin_d = Peg_Diameter,
          board_t = Pegboard_Thickness,
          backplate_t = Hook_Wall_Thickness
        );
    }
  }
}

module HookBacker() {
  cuboid([backerWidth, Hook_Wall_Thickness, backerHeight], rounding=Peglock_Roundover, except=[FRONT, BACK]);
}

module Hook() {
  if (Mount_Type == "peglock") {
    translate([0, -Hook_Wall_Thickness + EPSILON, 0])
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
  translate([0, -Hook_Wall_Thickness / 2, 0]) HookBacker();
  HookGrid();
}

rotate([0, 0, 180]) Hook();
