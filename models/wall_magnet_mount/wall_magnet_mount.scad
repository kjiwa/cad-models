include <BOSL2/std.scad>
include <peglock/peglock.scad>
include <pegboard/mount.scad>

/* [Layout] */
// Number of magnet columns
Columns = 1; // [1:1:10]

// Number of magnet rows
Rows = 1; // [1:1:6]

// Spacing between magnets and around the grid edge
Magnet_Spacing = 2;

/* [Magnet] */
// Magnet pocket diameter (12 for a 12 mm disc)
Magnet_Diameter = 12;

// Magnet pocket depth, which is also the slab thickness
Magnet_Depth = 3.5;

// Radius of the rounded slab edges (0 to disable)
Corner_Radius = 1.5875;

/* [Backplate] */
// Thickness of the backplate behind the magnet slab
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

// Screw head or washer outer diameter (9.525 for 3/8")
Screw_Head_Diameter = 9.525;

// Include a countersink cone for the screw head instead of a straight hole
Include_Screw_Countersink = false;

/* [Hidden] */
$fn = 128;

assert(Columns >= 1, "Columns must be at least 1");
assert(Rows >= 1, "Rows must be at least 1");
assert(Hole_Columns >= 0, "Hole_Columns must not be negative");
assert(Hole_Columns == floor(Hole_Columns), "Hole_Columns must be an integer");
assert(Hole_Columns <= 10, "Hole_Columns must be at most 10");
assert(Magnet_Diameter > 0, "Magnet_Diameter must be greater than 0");
assert(Magnet_Depth > 0, "Magnet_Depth must be greater than 0");
assert(Magnet_Spacing >= 0, "Magnet_Spacing must not be negative");
assert(Backplate_Thickness > 0, "Backplate_Thickness must be greater than 0");
assert(Corner_Radius >= 0, "Corner_Radius must not be negative");

pitch = Magnet_Diameter + Magnet_Spacing;
gridWidth = Columns * pitch + Magnet_Spacing;
gridHeight = Rows * pitch + Magnet_Spacing;
assert(2 * Corner_Radius <= min(gridWidth, gridHeight), "Corner_Radius is too large for the magnet slab");

holeColumns = board_hole_columns(Mount_Type, Hole_Columns, gridWidth, Hole_Spacing, Pin_Diameter);
backerSize = board_mount_size(Mount_Type, [gridWidth, gridHeight + 2 * SOCKET_ROUNDOVER], holeColumns, Hole_Spacing, Pin_Diameter);

function pocket_offset(i, count) = -(count * pitch + Magnet_Spacing) / 2 + Magnet_Diameter / 2 + Magnet_Spacing + i * pitch;

module MagnetGrid() {
  translate([0, Magnet_Depth / 2, 0]) difference() {
    cuboid([gridWidth, Magnet_Depth, gridHeight], rounding=Corner_Radius, except=[FRONT, BACK]);
    for (i = [0:Rows - 1], j = [0:Columns - 1])
      translate([pocket_offset(j, Columns), 0, pocket_offset(i, Rows)])
        rotate([90, 0, 0]) cyl(d=Magnet_Diameter, h=Magnet_Depth * 2);
  }
}

module MagnetMount() {
  BoardMount(
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
    countersink = Include_Screw_Countersink
  );
  MagnetGrid();
}

rotate([0, 0, 180]) MagnetMount();
