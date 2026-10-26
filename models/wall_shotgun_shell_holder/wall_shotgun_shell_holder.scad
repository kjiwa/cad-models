include <BOSL2/std.scad>
include <peglock/peglock.scad>
include <pegboard/mount.scad>

/* [Layout] */
// Number of shell columns
Columns = 2; // [1:1:6]

// Number of shells per column
Rows = 5; // [1:1:10]

/* [Shell] */
// Rim diameter, including clearance (23 for 0.906")
Rim_Diameter = 23;

// Thickness of the rim slot (2 for 0.079")
Rim_Thickness = 2;

// Shell body diameter, including clearance (20.5 for 0.807")
Shell_Diameter = 20.5;

// Height of the walls holding each shell (10 for 0.394")
Holder_Depth = 10;

// Thickness of the walls around and behind each shell (4 for 0.157")
Wall_Thickness = 4;

// Lead-in flaring each column's top entry (0 to disable)
Entry_Chamfer = 1;

// Radius of the rounded outer edges of the body, except along the back (0 to disable)
Corner_Radius = 1;

/* [Backplate] */
// Thickness of the backplate behind the columns
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
assert(Shell_Diameter > 0, "Shell_Diameter must be greater than 0");
assert(Rim_Diameter > Shell_Diameter, "Rim_Diameter must be greater than Shell_Diameter");
assert(Rim_Thickness > 0, "Rim_Thickness must be greater than 0");
assert(Holder_Depth > Rim_Thickness, "Holder_Depth must be greater than Rim_Thickness");
assert(Wall_Thickness > 0, "Wall_Thickness must be greater than 0");
assert(Entry_Chamfer >= 0, "Entry_Chamfer must not be negative");
assert(2 * Entry_Chamfer < Wall_Thickness, "Entry_Chamfer is too large for Wall_Thickness");
assert(Corner_Radius >= 0, "Corner_Radius must not be negative");
assert(Corner_Radius <= Wall_Thickness, "Corner_Radius must not exceed Wall_Thickness");

columnPitch = Rim_Diameter + Wall_Thickness;
bodyWidth = Columns * columnPitch + Wall_Thickness;
bodyHeight = Rows * Rim_Diameter + Wall_Thickness;
bodyDepth = Holder_Depth + Wall_Thickness;

plateWidth = bodyWidth;
screwEar = Mount_Type == "screws" ? screw_ear_width(Screw_Head_Diameter) : 0;

holeColumns = board_hole_columns(Mount_Type, Hole_Columns, plateWidth, Hole_Spacing, Pin_Diameter);
backerSize = board_mount_size(Mount_Type, [Mount_Type == "screws" ? bodyWidth + 2 * screwEar : plateWidth, bodyHeight], holeColumns, Hole_Spacing, Pin_Diameter);

function column_x(i) = -bodyWidth / 2 + Wall_Thickness + Rim_Diameter / 2 + i * columnPitch;

// Slot profile cut along the column: the shell channel up to the front face, and the rim slot behind it.
// Each rectangle flares by Entry_Chamfer across its width at the column top.
module ChannelCutter(width, from, to) {
  length = bodyHeight - Wall_Thickness + 1;
  translate([0, 0, Wall_Thickness]) {
    translate([-width / 2, from, 0]) cube([width, to - from, length]);
    if (Entry_Chamfer > 0)
      hull() {
        translate([-width / 2, from, length - Entry_Chamfer - 1]) cube([width, to - from, 0.01]);
        translate([-width / 2 - Entry_Chamfer - 1, from, length]) cube([width + 2 * Entry_Chamfer + 2, to - from, 0.01]);
      }
  }
}

// The two rounded wedges that cradle a shell's lower end above the rim slot
module ShellSeat() {
  translate([0, Wall_Thickness + Rim_Thickness, Wall_Thickness])
    difference() {
      translate([-Shell_Diameter / 2, 0, 0]) cube([Shell_Diameter, Holder_Depth - Rim_Thickness, Shell_Diameter / 2]);
      translate([0, -1, Shell_Diameter / 2]) rotate([-90, 0, 0]) cylinder(d = Shell_Diameter, h = Holder_Depth + 1);
    }
}

module BodyBlock() {
  if (Corner_Radius > 0)
    cuboid([bodyWidth, bodyDepth, bodyHeight], rounding = Corner_Radius, except = FRONT, anchor = FRONT + BOTTOM);
  else
    translate([-bodyWidth / 2, 0, 0]) cube([bodyWidth, bodyDepth, bodyHeight]);
}

module ShellColumns() {
  difference() {
    BodyBlock();
    for (i = [0:Columns - 1])
      translate([column_x(i), 0, 0]) {
        ChannelCutter(Shell_Diameter, Wall_Thickness + Rim_Thickness, bodyDepth + 1);
        ChannelCutter(Rim_Diameter, Wall_Thickness, Wall_Thickness + Rim_Thickness);
      }
  }
  for (i = [0:Columns - 1])
    translate([column_x(i), 0, 0]) ShellSeat();
}

module ShellHolder() {
  translate([0, 0, bodyHeight - backerSize[1] / 2]) BoardMount(
    type = Mount_Type,
    size = backerSize,
    columns = holeColumns,
    backplate_t = Backplate_Thickness,
    hole_spacing = Hole_Spacing,
    pin_d = Pin_Diameter,
    board_t = Pegboard_Thickness,
    rise = Retention_Hook_Rise,
    pin_pattern = Stabilizing_Pin_Pattern,
    screw_columns = 2,
    screw_rows = Screw_Hole_Rows,
    screw_inset = Screw_Hole_Inset,
    screw_column_inset = screwEar / 2,
    screw_d = Screw_Hole_Diameter,
    head_d = Screw_Head_Diameter,
    countersink = Include_Screw_Countersink,
    socket_z = (backerSize[1] - SOCKET_HEIGHT) / 2,
    standoff = true,
    plate_rounding = (backerSize[0] - bodyWidth) / 2 >= SOCKET_ROUNDOVER ? SOCKET_ROUNDOVER : 0
  );
  ShellColumns();
}

rotate([0, 0, 180]) ShellHolder();
