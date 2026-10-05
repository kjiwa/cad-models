include <BOSL2/std.scad>
include <peglock/peglock.scad>
include <pegboard/mount.scad>

/* [Layout] */
// Number of hook columns
Columns = 1;

// Number of hook rows
Rows = 1;

// Center-to-center distance between hook columns (at least Arm_Width)
Column_Spacing = 19.05;

// Center-to-center distance between hook rows
Row_Spacing = 19.05;

// Where the hooks sit on the backplate
Vertical_Alignment = "bottom"; // [bottom: Hooks at plate bottom, center: Hooks centered on plate]

/* [Arm] */
// Cross-section profile of the hook arm
Arm_Shape = "square"; // [circle: Circle, square: Square, triangle: Triangle, right_triangle: Right Triangle]

// Width of the hook arm
Arm_Width = 12.7;

// Length of the hook arm from the backplate to the lip
Arm_Length = 6.35;

// Height of the hook arm
Arm_Height = 6.35;

// Upward tilt of the hook arm in degrees (0 for horizontal)
Arm_Tilt_Angle = 0; // [0:5:45]

// Radius of the rounded arm edges
Arm_Edge_Radius = 1.5875;

// Number of hooks chained along each arm
Hooks_Per_Arm = 1; // [1:1:5]

/* [Lip] */
// Height of the retaining lip above the arm
Lip_Height = 3.175;

// Thickness of the retaining lip
Lip_Thickness = 3.175;

// Orientation of the retaining lip when the arm is tilted
Lip_Orientation = "perpendicular"; // [perpendicular: Square to hook arm, vertical: Parallel to backplate]

/* [Backplate] */
// Thickness of the mounting backplate
Backplate_Thickness = 1.5875;

// Stress relief fillet radius at the arm root (0 for standard/tested profile, above 0 to strengthen)
Root_Fillet_Radius = 0;

/* [Pegboard] */
// Mounting interface: modular Peglock wedge socket or monolithic integrated pegboard pegs
Mount_Type = "peglock"; // [peglock: Modular Peglock Socket, monolithic: Integrated Pegboard Pegs]

// Pegboard hole columns the mount engages, as Peglock sockets or peg columns (0 = auto: as many as fit within the body width)
Hole_Columns = 0; // [0:1:10]

// Pegboard hole center spacing (25.4 for 1" standard, 15.875 for 5/8" metal)
Hole_Spacing = 25.4;

// Pin diameter (5.7 for standard 1/4" hole fit, 6.0 for original Sy fit)
Pin_Diameter = 5.7;

// Pegboard thickness (6.35 for 1/4" board, 1.5875 for 1/16" thin metal)
Pegboard_Thickness = 6.35;

// Height of the retention hook tab behind the pegboard
Retention_Hook_Rise = 3.5;

/* [Hidden] */
$fn = 128;
EPSILON = 0.02;

assert(Arm_Tilt_Angle >= 0 && Arm_Tilt_Angle <= 45, "Arm_Tilt_Angle must be between 0 and 45");
assert(Hole_Columns >= 0, "Hole_Columns must not be negative");

overallHookHeight = Arm_Height + 2 * Lip_Height;
overallHookWidth = Arm_Width;
gridWidth = (Columns - 1) * Column_Spacing + Arm_Width;
gridHeight = (Rows - 1) * Row_Spacing + Arm_Height;

fillet_max_depth = Arm_Length * 0.35;
fillet_max_height = min(Lip_Height * 0.4, Arm_Height * 0.35);
fillet_max_width = Arm_Width * 0.35;

fillet_reach_y = min(Root_Fillet_Radius, fillet_max_depth);
fillet_flare_z = min(Root_Fillet_Radius, fillet_max_height);
fillet_flare_x = min(Root_Fillet_Radius, fillet_max_width);

arm_slice_drop = Arm_Height * (1 / cos(Arm_Tilt_Angle) - 1);
tilt_root_drop = arm_slice_drop;
arm_pivot_z = Arm_Height / 2;
arm_extra_back = Arm_Height * tan(Arm_Tilt_Angle) + 1;
arm_trim = arm_extra_back + Arm_Height + 1;

root_height = gridHeight + 2 * fillet_flare_z + tilt_root_drop;

bodyWidth = gridWidth + 2 * fillet_flare_x;
holeColumns = board_hole_columns(Hole_Columns, bodyWidth, Hole_Spacing);
backerSize = board_mount_size(Mount_Type, [bodyWidth, root_height], holeColumns, Hole_Spacing);
backerHeight = backerSize[1];
align_shift = Vertical_Alignment == "center" ? (backerHeight - root_height) / 2 : 0;

if (Columns > 1) assert(Column_Spacing >= Arm_Width, "Column_Spacing must be at least Arm_Width");
if (Rows > 1) assert(Row_Spacing * cos(Arm_Tilt_Angle) >= Arm_Height + Lip_Height, "Row_Spacing is too small for Arm_Height + Lip_Height");

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
  if (Arm_Shape == "circle") {
    scale([Arm_Width, 1, Arm_Height])
      rotate([-90, 0, 0])
      cylinder(d=1, h=depth);
  } else if (Arm_Shape == "square") {
    translate([0, depth / 2, 0])
      cuboid([Arm_Width, depth, Arm_Height], rounding=Arm_Edge_Radius, except=[FRONT, BACK]);
  } else if (Arm_Shape == "right_triangle") {
    RoundedRightTriangle(Arm_Width, Arm_Height, depth, Arm_Edge_Radius);
  } else if (Arm_Shape == "triangle") {
    rotate([-90, 0, 0])
      linear_extrude(depth)
      RoundedTriangle(Arm_Width, Arm_Height, Arm_Edge_Radius);
  }
}

module HookRootFillet() {
  if (Root_Fillet_Radius > 0) {
    hull() {
      scale([(Arm_Width + 2 * fillet_flare_x) / Arm_Width, 1, (Arm_Height + 2 * fillet_flare_z) / Arm_Height])
        HookProfile(0.01);
      translate([0, fillet_reach_y, 0])
        HookProfile(0.01);
    }
  }
}

module HookLipBody() {
  hull() {
    HookProfile(Lip_Thickness);
    translate([0, 0, Lip_Height]) HookProfile(Lip_Thickness);
  }
}

// Inside the tilted arm frame, counter-rotating the lip makes it parallel to the backplate;
// the hull with the arm's end face bridges the wedge that opens between them.
module HookLip() {
  if (Lip_Orientation == "vertical" && Arm_Tilt_Angle > 0) {
    hull() {
      translate([0, -0.01, 0]) HookProfile(0.01);
      rotate([-Arm_Tilt_Angle, 0, 0]) HookLipBody();
    }
  } else {
    HookLipBody();
  }
}

module SingleHook() {
  HookProfile(Arm_Length);
  HookRootFillet();
  translate([0, Arm_Length, 0]) HookLip();
}

// The arm tilted about its top-back edge and extended backward so it passes through the backplate face
module TiltedArm() {
  translate([0, 0, arm_pivot_z])
    rotate([Arm_Tilt_Angle, 0, 0])
      translate([0, -arm_extra_back, -arm_pivot_z])
        HookProfile(Arm_Length + arm_extra_back);
}

module ArmSlice(y) {
  intersection() {
    TiltedArm();
    translate([-Arm_Width, y, -arm_trim]) cube([2 * Arm_Width, 0.01, 2 * arm_trim]);
  }
}

// Root fillet for a tilted arm: the arm's cross-section at the backplate, flared about its
// centre, hulled with the plain cross-section where the fillet ends.
module TiltedRootFillet() {
  slice_height = Arm_Height / cos(Arm_Tilt_Angle);
  center_z = -arm_slice_drop / 2;
  hull() {
    translate([0, 0, center_z])
      scale([(Arm_Width + 2 * fillet_flare_x) / Arm_Width, 1, (slice_height + 2 * fillet_flare_z) / slice_height])
        translate([0, 0, -center_z])
          ArmSlice(0);
    ArmSlice(fillet_reach_y);
  }
}

// One grid cell: Hooks_Per_Arm hooks tilted about the arm's top-back edge. The arm is
// extended backward and trimmed at the backplate face so the root stays flush at any angle.
module HookArm() {
  difference() {
    union() {
      translate([0, 0, arm_pivot_z])
        rotate([Arm_Tilt_Angle, 0, 0])
          translate([0, 0, -arm_pivot_z]) {
            translate([0, -arm_extra_back, 0]) HookProfile(Arm_Length + arm_extra_back);
            translate([0, Arm_Length, 0]) HookLip();
            if (Hooks_Per_Arm > 1) {
              for (k = [2:Hooks_Per_Arm]) {
                translate([0, (k - 1) * (Arm_Length + Lip_Thickness), 0]) SingleHook();
              }
            }
          }
      if (Arm_Tilt_Angle > 0 && Root_Fillet_Radius > 0) TiltedRootFillet();
      else HookRootFillet();
    }
    translate([-(Arm_Width + 2) / 2, -arm_trim, -arm_trim]) cube([Arm_Width + 2, arm_trim, 2 * arm_trim]);
  }
}

module HookGrid() {
  x = (Columns - 1) * Column_Spacing;
  z_base = -backerHeight / 2 + Arm_Height / 2 + fillet_flare_z + tilt_root_drop + align_shift;

  translate([-x / 2, 0, z_base])
    for (i=[1:Columns]) {
      for (j=[1:Rows]) {
        translate([(i - 1) * Column_Spacing, 0, (j - 1) * Row_Spacing]) HookArm();
      }
    }
}

module Hook() {
  BoardMount(
    type = Mount_Type,
    size = backerSize,
    columns = holeColumns,
    backplate_t = Backplate_Thickness,
    hole_spacing = Hole_Spacing,
    pin_d = Pin_Diameter,
    board_t = Pegboard_Thickness,
    rise = Retention_Hook_Rise
  );
  HookGrid();
}

rotate([0, 0, 180]) Hook();
