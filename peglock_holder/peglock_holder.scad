include <BOSL2/std.scad>
include <peglock/peglock.scad>
include <pegboard/mount.scad>

/* [Layout] */
// Number of pocket columns
Columns = 1;

// Number of pocket rows
Rows = 1;

// Where the pockets sit on the backplate; bottom is centered once the body nearly fills the plate
Vertical_Alignment = "bottom"; // [bottom: Pockets near plate bottom, center: Pockets centered on plate]

/* [Pocket] */
// Pocket cross-section
Pocket_Shape = "rounded_rect"; // [rounded_rect: Rounded Rectangle, hexagon: Hexagon]

// Inner width of each pocket, across flats for a hexagon (6.75 for a 1/4" bit): one value for every column or one comma-separated value per column (12.7 for 1/2")
Pocket_Widths = "12.7";

// Inner depth of each pocket, same format as Pocket_Widths; a hexagon's depth is its width, so this is ignored
Pocket_Depths = "6.35";

// Inner height of each pocket
Pocket_Height = 12.7;

// Forward tilt of the pockets in degrees (0 for vertical)
Tilt_Angle = 0; // [0:5:45]

// Close the pocket bottoms
Closed_Bottom = true;

// Thickness of the pocket walls
Wall_Thickness = 1.5875;

// Radius of the rounded pocket body corners (0 for square corners)
Corner_Radius = 3.175;

// Rounds the pocket body's underside edges, except where it meets the plate (0 to disable)
Bottom_Edge_Radius = 0;

/* [Front] */
// Height of the front lip (0 for no lip)
Lip_Height = 3.175;

// Thickness of the front lip
Lip_Thickness = 3.175;

// Width of the front access opening (0 for none)
Opening_Width = 6.35;

// Front opening lead-in chamfer (0 to disable)
Opening_Chamfer = 1.0;

// Only cut the front access opening on the front-most row when multi-row
Opening_Front_Row_Only = false;

/* [Backplate] */
// Thickness of the backplate behind the pockets; thicker resists flex under heavy loads
Backplate_Thickness = 1.5875;

// Size of the triangular web under the pockets where they meet the plate, clamped to the plate below them (0 to disable)
Junction_Gusset = 0;

/* [Pegboard] */
// Mounting interface: modular Peglock wedge socket or monolithic integrated pegboard pegs
Mount_Type = "peglock"; // [peglock: Modular Peglock Socket, monolithic: Integrated Pegboard Pegs]

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

assert(Tilt_Angle >= 0 && Tilt_Angle <= 45, "Tilt_Angle must be between 0 and 45");
assert(Pocket_Shape == "rounded_rect" || Pocket_Shape == "hexagon", "Pocket_Shape must be rounded_rect or hexagon");

function positive_entry(name, text) =
  let(entry = str_strip(text, " "), value = parse_num(entry))
  assert(value > 0, str(name, " entry '", entry, "' is not a positive number"))
  value;

// One value per column from a comma-separated string; a single value applies to every column
function column_values(name, text, count) =
  let(values = [for (part = str_split(text, ",")) positive_entry(name, part)])
  assert(len(values) == 1 || len(values) == count, str(name, " has ", len(values), " values but Columns is ", count))
  len(values) == 1 ? [for (i = [1:count]) values[0]] : values;

sizes = column_values("Pocket_Widths", Pocket_Widths, Columns);
// A hexagon has flats facing front and back and corners pointing along the row, so its column is corner to corner wide
pocketWidths = Pocket_Shape == "hexagon" ? [for (w = sizes) 2 * w / sqrt(3)] : sizes;
pocketDepths = Pocket_Shape == "hexagon" ? sizes : column_values("Pocket_Depths", Pocket_Depths, Columns);
maxPocketDepth = max(pocketDepths);

overallHolderWidth = sum(pocketWidths) + (Columns + 1) * Wall_Thickness;
overallHolderDepth = Rows * (maxPocketDepth + Wall_Thickness);

function column_center_x(i) =
  -overallHolderWidth / 2 + Wall_Thickness + (i > 0 ? sum([for (k = [0:i - 1]) pocketWidths[k]]) + i * Wall_Thickness : 0)
    + pocketWidths[i] / 2;

h = Pocket_Height + (Closed_Bottom ? Wall_Thickness : 0);
tilted_height = h * cos(Tilt_Angle) + overallHolderDepth * sin(Tilt_Angle);

tilt_drop = overallHolderDepth * sin(Tilt_Angle);
grid_tz = (Vertical_Alignment == "bottom" && tilted_height < (SOCKET_HEIGHT - 2 * SOCKET_ROUNDOVER))
  ? (h - SOCKET_HEIGHT) / 2 + SOCKET_ROUNDOVER + tilt_drop
  : (h * (1 - cos(Tilt_Angle)) + tilt_drop) / 2;

numPeglocks = peglock_socket_count(overallHolderWidth);
backerSize = board_mount_size(Mount_Type, [overallHolderWidth, tilted_height], numPeglocks, Hole_Spacing);
backerHeight = backerSize[1];

module HolderLip() {
  rounding_depth = max(2 * Corner_Radius, Lip_Thickness);
  translate([0, -Lip_Thickness / 2, Lip_Height / 2])
    intersection() {
      cuboid([overallHolderWidth, Lip_Thickness, Lip_Height], rounding=0, edges=[FRONT]);
      translate([0, (Lip_Thickness - rounding_depth) / 2, 0])
        cuboid([overallHolderWidth, rounding_depth, Lip_Height], rounding=Corner_Radius, edges=[BACK+LEFT, BACK+RIGHT]);
    }
}

module PocketCutout(width, depth, height) {
  translate([0, depth / 2, 0]) {
    if (Pocket_Shape == "hexagon") {
      linear_extrude(height=height, center=true)
        polygon([for (i = [0:5]) [width / 2 * cos(60 * i), width / 2 * sin(60 * i)]]);
    } else {
      cuboid([width, depth, height], rounding=Corner_Radius, except=[TOP, BOTTOM, FRONT]);
    }
  }
}

module SingleHolderInside(width, depth, cut_front_opening = true) {
  z = Pocket_Height + Lip_Height + 2 + (Closed_Bottom ? Wall_Thickness : 0);
  tz = 1 + (Closed_Bottom ? Wall_Thickness : -1);
  translate([0, 0, tz]) PocketCutout(width, depth, z);
  if (cut_front_opening && Opening_Width > 0) {
    cut_depth = Wall_Thickness + 3 * maxPocketDepth / 2;
    translate([-Opening_Width / 2, 0, -z / 2])
      cube([Opening_Width, cut_depth, z]);

    if (Opening_Chamfer > 0) {
      b = min(Opening_Chamfer, Opening_Width / 4);
      y_entry = maxPocketDepth + Wall_Thickness;
      translate([-Opening_Width / 2, y_entry, 0])
        rotate([0, 0, 45])
          cube([b * sqrt(2), b * sqrt(2), z * 2], center=true);
      translate([Opening_Width / 2, y_entry, 0])
        rotate([0, 0, 45])
          cube([b * sqrt(2), b * sqrt(2), z * 2], center=true);
    }
  }
}

module HolderBody() {
  size = [overallHolderWidth, overallHolderDepth, h];
  bottom_roundover = min(Bottom_Edge_Radius, Wall_Thickness);
  translate([0, overallHolderDepth / 2, 0]) {
    if (bottom_roundover > 0) {
      intersection() {
        cuboid(size, rounding=Corner_Radius, except=[TOP, BOTTOM, FRONT]);
        cuboid(size, rounding=bottom_roundover, edges=BOTTOM, except=BACK);
      }
    } else {
      cuboid(size, rounding=Corner_Radius, except=[TOP, BOTTOM, FRONT]);
    }
  }
}

// Rotates children forward about the bottom edge where the holder meets the backer
module Tilted() {
  translate([0, 0, -h / 2]) rotate([-Tilt_Angle, 0, 0]) translate([0, 0, h / 2]) children();
}

// Fills the wedge between the backer and the tilted back wall; the strip stops short of the
// rounded back corners so the fill never leaves the body's own outline.
module HolderRearFill() {
  hull() {
    Tilted() HolderBody();
    translate([-overallHolderWidth / 2 + Corner_Radius, 0, -h / 2])
      cube([overallHolderWidth - 2 * Corner_Radius, 0.01, h * cos(Tilt_Angle)]);
  }
}

// Triangular web from the plate face to the tilted underside, inset like HolderRearFill
module HolderJunctionGusset() {
  room = grid_tz - h / 2 + backerHeight / 2;
  size = min(Junction_Gusset, room, overallHolderDepth);
  width = overallHolderWidth - 2 * Corner_Radius;
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
      if (Tilt_Angle > 0) HolderRearFill();
      if (Junction_Gusset > 0) HolderJunctionGusset();
    }

    Tilted()
      for (i=[1:Columns]) {
        tx = column_center_x(i - 1);
        for (j=[1:Rows]) {
          ty = (j - 1) * (maxPocketDepth + Wall_Thickness);
          cut_opening = (!Opening_Front_Row_Only || j == Rows);
          translate([tx, ty, Lip_Height / 2]) SingleHolderInside(pocketWidths[i - 1], pocketDepths[i - 1], cut_opening);
        }
      }
  }
}

module Holder() {
  BoardMount(
    type = Mount_Type,
    size = backerSize,
    sockets = numPeglocks,
    backplate_t = Backplate_Thickness,
    hole_spacing = Hole_Spacing,
    pin_d = Pin_Diameter,
    board_t = Pegboard_Thickness,
    rise = Retention_Hook_Rise
  );
  translate([0, 0, grid_tz]) HolderGrid();
}

rotate([0, 0, 180]) {
  Holder();
}
