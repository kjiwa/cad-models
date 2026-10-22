include <BOSL2/std.scad>
include <peglock/peglock.scad>
include <pegboard/mount.scad>

/* [Layout] */
// Number of bits per row
Columns = 10; // [1:1:20]

// Number of stacked tiers
Rows = 2; // [1:1:6]

/* [Pocket] */
// Hex shank width across flats, including clearance (6.75 for 1/4" bits)
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

// Radius of the rounded outer edges of the body (0 to disable)
Corner_Radius = 1;

/* [Backplate] */
// Thickness of the backplate behind the pockets
Backplate_Thickness = 1.5875;

/* [Pegboard] */
// Mounting interface: modular Peglock wedge socket, monolithic integrated pegboard pegs, or countersunk screw holes
Mount_Type = "peglock"; // [peglock: Modular Peglock Socket, monolithic: Integrated Pegboard Pegs, screws: Screw Holes]

// Pegboard hole columns the mount engages (0 = auto)
Hole_Columns = 0;

// Pegboard hole center spacing (25.4 for 1" standard, 15.875 for 5/8" metal)
Hole_Spacing = 25.4;

// Pin diameter (5.7 for standard 1/4" hole fit, 6.0 for original Sy fit)
Pin_Diameter = 5.7;

// Pegboard thickness (6.35 for 1/4" board, 1.5875 for 1/16" thin metal)
Pegboard_Thickness = 6.35;

// Height of the retention hook tab behind the pegboard
Retention_Hook_Rise = 3.5;

// Stabilizing pin rows below the retention hooks (ignored by the Peglock socket mount)
Stabilizing_Pin_Pattern = "all"; // [all: All Rows, top_and_bottom: Top and Bottom Rows, top: Top Row Only, bottom: Bottom Row Only (Lowest Hole), none: Retention Hooks Only]

// Screw hole columns across the backplate (screws mount)
Screw_Hole_Columns = 1;

// Screw hole rows down the backplate (screws mount)
Screw_Hole_Rows = 1;

// Distance from the backplate edge to the outermost screw hole centers (a single column or row sits centered)
Screw_Hole_Inset = 19.05;

// Screw shank hole diameter (4.7625 for 3/16")
Screw_Hole_Diameter = 4.7625;

// Countersink head diameter (9.525 for 3/8") (0 to disable)
Screw_Head_Diameter = 9.525;

/* [Hidden] */
$fn = 128;

assert(Columns >= 1, "Columns must be at least 1");
assert(Rows >= 1, "Rows must be at least 1");
assert(Hole_Columns >= 0, "Hole_Columns must not be negative");
assert(Hole_Columns == floor(Hole_Columns), "Hole_Columns must be an integer");
assert(Hole_Columns <= 10, "Hole_Columns must be at most 10");
assert(Bit_Width > 0, "Bit_Width must be greater than 0");
assert(Pocket_Height > 0, "Pocket_Height must be greater than 0");
assert(Wall_Thickness > 0, "Wall_Thickness must be greater than 0");
assert(Relief_Width >= 0, "Relief_Width must not be negative");
assert(Relief_Width < Bit_Width, "Relief_Width must be less than Bit_Width");
assert(Tilt_Angle > 0, "Tilt_Angle must be greater than 0");
assert(Tilt_Angle <= 45, "Tilt_Angle must not exceed 45");
assert(Entry_Chamfer >= 0, "Entry_Chamfer must not be negative");
assert((Entry_Chamfer + 0.1) * 2 / sqrt(3) < Wall_Thickness, "Entry_Chamfer is too large for Wall_Thickness");
assert(Entry_Chamfer <= Pocket_Height, "Entry_Chamfer must not exceed Pocket_Height");
assert(Corner_Radius >= 0, "Corner_Radius must not be negative");
assert(Corner_Radius <= Wall_Thickness, "Corner_Radius must not exceed Wall_Thickness");

hexCorner = 2 * Bit_Width / sqrt(3);
cellSize = hexCorner + 2 * Wall_Thickness;
cellHeight = Pocket_Height + Wall_Thickness;
rowWidth = Columns * cellSize;
wedgeDepth = cellSize * cos(Tilt_Angle);
wedgeRise = cellSize * sin(Tilt_Angle);
tierPitch = wedgeRise + wedgeDepth / tan(Tilt_Angle);

plateWidth = rowWidth - 2 * Corner_Radius;

holeColumns = board_hole_columns(Mount_Type, Hole_Columns, plateWidth, Hole_Spacing, Pin_Diameter);
backHeight = wedgeRise - tier_base(0);
backerSize = board_mount_size(Mount_Type, [plateWidth, backHeight], holeColumns, Hole_Spacing, Pin_Diameter);
plateBottom = wedgeRise - backerSize[1];

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

module TierCuts() {
  for (i = [0:Columns - 1])
    translate([column_x(i), cellSize / 2, Wall_Thickness]) PocketCutter();
  if (Relief_Width > 0) ReliefSlot();
}

// Tier 0 is the lowest; the top tier's base sits at z = 0
function tier_base(i) = (i - (Rows - 1)) * tierPitch;

function tier_front_top(i) = [wedgeDepth + cellHeight * sin(Tilt_Angle), tier_base(i) + cellHeight * cos(Tilt_Angle)];

function tier_back_top(i) = [cellHeight * sin(Tilt_Angle), tier_base(i) + wedgeRise + cellHeight * cos(Tilt_Angle)];

// Side silhouette of all tiers in [y, z]. Each tier's back face is collinear with the next tier's front face.
// The closing edge slopes from the plate bottom up to the lowest tier's base.
function body_profile() = concat(
  [[wedgeDepth, tier_base(0)]],
  [for (i = [0:Rows - 1]) each [tier_front_top(i), tier_back_top(i)]],
  [[0, wedgeRise], [0, plateBottom]]
);

// Corner_Radius on every outer corner; sharp where the body meets the plate and in the notches between tiers
function body_radii() = concat(
  [Corner_Radius],
  [for (i = [0:Rows - 1]) each [Corner_Radius, i == Rows - 1 ? Corner_Radius : 0]],
  [0, 0]
);

// Side profile swept across the row, rounded along the profile and around both end faces
module BodyBlock() {
  translate([-rowWidth / 2, 0, 0]) rotate([90, 0, 90]) {
    if (Corner_Radius > 0)
      offset_sweep(
        round_corners(body_profile(), method = "circle", radius = body_radii()),
        height = rowWidth,
        top = os_circle(r = Corner_Radius),
        bottom = os_circle(r = Corner_Radius)
      );
    else
      linear_extrude(height = rowWidth) polygon(body_profile());
  }
}

module BitTiers() {
  difference() {
    BodyBlock();
    for (i = [0:Rows - 1])
      translate([0, 0, tier_base(i) + wedgeRise]) rotate([-Tilt_Angle, 0, 0]) TierCuts();
  }
}

module BitHolder() {
  translate([0, 0, wedgeRise - backerSize[1] / 2]) BoardMount(
    type = Mount_Type,
    size = backerSize,
    columns = holeColumns,
    backplate_t = Backplate_Thickness,
    hole_spacing = Hole_Spacing,
    pin_d = Pin_Diameter,
    board_t = Pegboard_Thickness,
    rise = Retention_Hook_Rise,
    pin_pattern = Stabilizing_Pin_Pattern,
    screw_columns = Screw_Hole_Columns,
    screw_rows = Screw_Hole_Rows,
    screw_inset = Screw_Hole_Inset,
    screw_d = Screw_Hole_Diameter,
    head_d = Screw_Head_Diameter,
    socket_z = (backerSize[1] - SOCKET_HEIGHT) / 2,
    standoff = true
  );
  BitTiers();
}

rotate([0, 0, 180]) BitHolder();
