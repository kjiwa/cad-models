include <BOSL2/std.scad>

/**
 * Bracket that hangs a shelf from a wall: a wall arm and a shelf arm joined by a cove-curved
 * gusset. Each arm has a countersunk screw hole driven from the gusset side, with a boss
 * where the cove is too thin to seat the head. Print on its side, as modeled, so the layers
 * run along both arms; holes are teardrops so they print without supports. All dimensions
 * are in millimeters.
 */

/* [Bracket] */
// Wall arm height (50.8 for 2")
Height = 50.8;

// Shelf arm depth (203.2 for 8")
Depth = 203.2;

// Bracket width (19.05 for 3/4")
Width = 19.05;

// Arm thickness (6.35 for 1/4")
Wall_Thickness = 6.35;

// Radius of the rounded face edges
Edge_Radius = 1.5;

// Radius of the rounded outer corners
Corner_Radius = 3;

/* [Screw Holes] */
// Screw shank diameter (4.7625 for 3/16")
Screw_Diameter = 4.7625;

// Screw head diameter (9.525 for 3/8")
Screw_Head_Diameter = 9.525;

// Distance from the mounting face to the head seat (12.7 for 1/2")
Screw_Hole_Depth = 12.7;

// Distance from the arm end to the hole (50.8 for 2")
Screw_Hole_Offset = 50.8;

/* [Hidden] */
$fn = 128;

BOSS_WALL = 2;
BOSS_ROUNDING = 2;

assert(Wall_Thickness < Height && Wall_Thickness < Depth, "Wall_Thickness must be less than Height and Depth");
assert(2 * Corner_Radius <= Wall_Thickness, "Corner_Radius must be at most half of Wall_Thickness");
assert(2 * Edge_Radius < Width && Edge_Radius > 0, "Edge_Radius must be positive and less than half of Width");
assert(Screw_Head_Diameter < Width, "Screw_Head_Diameter must be less than Width");
assert(Screw_Diameter < Screw_Head_Diameter, "Screw_Diameter must be less than Screw_Head_Diameter");
assert((Screw_Head_Diameter - Screw_Diameter) / 2 <= Screw_Hole_Depth, "Screw_Hole_Depth is too small to seat the head");

cove = [Depth - Wall_Thickness, Height - Wall_Thickness];
wall_hole_y = max(Height / 2, Height - Screw_Hole_Offset);
shelf_hole_x = max(Depth / 2, Depth - Screw_Hole_Offset);
countersink = (Screw_Head_Diameter - Screw_Diameter) / 2;
boss_length = Screw_Hole_Depth + BOSS_WALL;

function RoundedProfile() =
  let(
    web = difference(
      [rect([Depth, Height], anchor = [-1, -1])],
      [move([Depth, Height], p = ellipse(r = cove))]
    )[0],
    rounded = offset(offset(web, delta = -Corner_Radius, closed = true), r = Corner_Radius, closed = true)
  ) union([rounded], [rect(Corner_Radius, anchor = [-1, -1])]);

module Body() {
  offset_sweep(
    RoundedProfile()[0], height = Width,
    bottom = os_chamfer(width = Edge_Radius),
    top = os_circle(r = Edge_Radius)
  );
}

// Hole along +Y from the mounting face, apex up so a side print needs no supports
module ScrewHole() {
  channel = Height + Depth;
  translate([0, (Screw_Hole_Depth - 1) / 2, 0]) teardrop(d = Screw_Diameter, l = Screw_Hole_Depth + 1);
  translate([0, Screw_Hole_Depth - countersink / 2, 0])
    teardrop(d1 = Screw_Diameter, d2 = Screw_Head_Diameter, l = countersink);
  translate([0, Screw_Hole_Depth + channel / 2, 0]) teardrop(d = Screw_Head_Diameter, l = channel);
}

module WallFrame() {
  translate([0, wall_hole_y, Width / 2]) rotate([0, 0, -90]) children();
}

module ShelfFrame() {
  translate([shelf_hole_x, 0, Width / 2]) children();
}

module Boss() {
  cyl(d = Width, h = boss_length, rounding2 = BOSS_ROUNDING, anchor = BOTTOM, orient = BACK);
}

difference() {
  union() {
    Body();
    WallFrame() Boss();
    ShelfFrame() Boss();
  }
  WallFrame() ScrewHole();
  ShelfFrame() ScrewHole();
}
