include <BOSL2/std.scad>
include <peglock/peglock.scad>
include <pegboard/mount.scad>

/* [Layout] */
// Number of bits per row
Columns = 10;

// Number of stacked tiers
Rows = 2;

/* [Pocket] */
// Hex shank width across flats, including clearance
Bit_Width = 6.75;

// Depth of each pocket
Pocket_Height = 15;

// Thickness of the thinnest wall, at the hex corners
Wall_Thickness = 2.68;

// Width of the grip slot along each row (0 to disable)
Relief_Width = 1.5875;

// Forward tilt of each tier in degrees
Tilt_Angle = 15; // [5:5:45]

// Lead-in at each pocket mouth (0 to disable)
Entry_Chamfer = 0.5;

// Radius of the rounded outer edges of the pocket body (0 for square edges)
Corner_Radius = 1;

/* [Backplate] */
// Thickness of the backplate behind the pockets
Backplate_Thickness = 1.5875;

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

assert(Columns >= 1, "Columns must be at least 1");
assert(Rows >= 1, "Rows must be at least 1");
assert(Bit_Width > 0, "Bit_Width must be greater than 0");
assert(Pocket_Height > 0, "Pocket_Height must be greater than 0");
assert(Wall_Thickness > 0, "Wall_Thickness must be greater than 0");
assert(Relief_Width >= 0, "Relief_Width must not be negative");
assert(Relief_Width < Bit_Width, "Relief_Width must be less than Bit_Width");
assert(Tilt_Angle > 0, "Tilt_Angle must be greater than 0");
assert(Tilt_Angle <= 45, "Tilt_Angle must not exceed 45");
assert(Entry_Chamfer >= 0, "Entry_Chamfer must not be negative");
assert((Entry_Chamfer + 0.1) * 2 / sqrt(3) < Wall_Thickness, "Entry_Chamfer is too large for Wall_Thickness");
assert(Corner_Radius >= 0, "Corner_Radius must not be negative");
assert(Corner_Radius <= Wall_Thickness, "Corner_Radius must not exceed Wall_Thickness");

hexCorner = 2 * Bit_Width / sqrt(3);
cellSize = hexCorner + 2 * Wall_Thickness;
cellHeight = Pocket_Height + Wall_Thickness;
rowWidth = Columns * cellSize;
wedgeDepth = cellSize * cos(Tilt_Angle);
wedgeRise = cellSize * sin(Tilt_Angle);
tierPitch = wedgeRise + wedgeDepth / tan(Tilt_Angle);

numPeglocks = peglock_socket_count(rowWidth);
backerSize = board_mount_size(Mount_Type, [rowWidth, SOCKET_HEIGHT], numPeglocks, Hole_Spacing);

function column_x(i) = -rowWidth / 2 + cellSize / 2 + i * cellSize;

module HexOutline(apothem) {
  polygon([for (i = [0:5]) apothem / cos(30) * [cos(60 * i), sin(60 * i)]]);
}

module PocketCutter() {
  linear_extrude(height = cellHeight + 1) HexOutline(Bit_Width / 2);
  if (Entry_Chamfer > 0) {
    reach = Entry_Chamfer + 0.1;
    translate([0, 0, Pocket_Height - Entry_Chamfer])
      linear_extrude(height = reach, scale = (Bit_Width / 2 + reach) / (Bit_Width / 2))
        HexOutline(Bit_Width / 2);
  }
}

module ReliefSlot() {
  translate([-rowWidth / 2 - 0.5, cellSize / 2 - Relief_Width / 2, Wall_Thickness])
    cube([rowWidth + 1, Relief_Width, cellHeight]);
}

// Row of pockets with the back-bottom edge at the origin, opening toward +z
module PocketRow() {
  difference() {
    cuboid([rowWidth, cellSize, cellHeight], rounding = Corner_Radius, except = [FRONT, BOTTOM], anchor = [0, -1, -1]);
    for (i = [0:Columns - 1])
      translate([column_x(i), cellSize / 2, Wall_Thickness]) PocketCutter();
    if (Relief_Width > 0) ReliefSlot();
  }
}

// Extrudes a polygon given in [y, z] across the row width
module ProfileAcrossRow(points) {
  translate([-rowWidth / 2, 0, 0])
    rotate([90, 0, 90]) linear_extrude(height = rowWidth) polygon(points);
}

module Tier(is_top) {
  ProfileAcrossRow([[0, 0], [wedgeDepth, 0], [0, wedgeRise]]);
  translate([0, 0, wedgeRise]) rotate([-Tilt_Angle, 0, 0]) PocketRow();
  if (!is_top) ProfileAcrossRow([[0, wedgeRise], [0, tierPitch], [wedgeDepth, tierPitch]]);
}

module BitTiers() {
  for (i = [0:Rows - 1])
    translate([0, 0, (i - (Rows - 1)) * tierPitch]) Tier(i == Rows - 1);
}

module BitHolder() {
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
  BitTiers();
}

rotate([0, 0, 180]) BitHolder();
