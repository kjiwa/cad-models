include <BOSL2/std.scad>

/**
 * Bracket that hangs a shelf from a wall: a wall arm and a shelf arm joined by a cove-curved
 * gusset. Each arm has a screw hole driven from the gusset side, with a pad where the cove is
 * too thin to seat the head. The wall and shelf faces are flat with crisp edges; every
 * exposed edge is rounded. Print on its side, as modeled, so the layers run along both arms.
 * All dimensions are in millimeters.
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

// Radius of the rounded exposed edges
Edge_Radius = 1.5;

// Radius of the rounded outer corners
Corner_Radius = 3;

/* [Screw Holes] */
// Screw shank diameter (4.7625 for 3/16")
Screw_Diameter = 4.7625;

// Screw head diameter (14.2875 for 9/16")
Screw_Head_Diameter = 14.2875;

// Distance from the mounting face to the head seat (12.7 for 1/2")
Screw_Hole_Depth = 12.7;

// Distance from the arm end to the hole (50.8 for 2")
Screw_Hole_Offset = 50.8;

// Cone the head seat for flat head screws, otherwise a flat recess for pan or washer heads
Include_Screw_Countersink = false;

/* [Hidden] */
$fn = 128;

PAD_WALL = 2;
PAD_MARGIN = 3;

assert(Wall_Thickness < Height && Wall_Thickness < Depth, "Wall_Thickness must be less than Height and Depth");
assert(2 * Corner_Radius <= Wall_Thickness, "Corner_Radius must be at most half of Wall_Thickness");
assert(2 * Edge_Radius < Width && Edge_Radius > 0, "Edge_Radius must be positive and less than half of Width");
assert(Screw_Head_Diameter < Width, "Screw_Head_Diameter must be less than Width");
assert(Screw_Diameter < Screw_Head_Diameter, "Screw_Diameter must be less than Screw_Head_Diameter");
assert(!Include_Screw_Countersink || (Screw_Head_Diameter - Screw_Diameter) / 2 <= Screw_Hole_Depth, "Screw_Hole_Depth is too small to seat a countersunk head");

cove = [Depth - Wall_Thickness, Height - Wall_Thickness];
wall_hole_y = max(Height / 2, Height - Screw_Hole_Offset);
shelf_hole_x = max(Depth / 2, Depth - Screw_Hole_Offset);
pad_length = Screw_Head_Diameter + 2 * PAD_MARGIN;
pad_height = Screw_Hole_Depth + PAD_WALL;
countersink = (Screw_Head_Diameter - Screw_Diameter) / 2;

assert(wall_hole_y + pad_length / 2 <= Height && shelf_hole_x + pad_length / 2 <= Depth, "Screw_Hole_Offset leaves the pad past the arm end");

// The profile reaches Edge_Radius past both mounting faces so the roundover stops at the flat faces when cropped
function ExtendedProfile() =
  let(
    e = Edge_Radius,
    web = difference(
      [move([-e, -e], p = rect([Depth + e, Height + e], anchor = [-1, -1]))],
      [move([Depth, Height], p = ellipse(r = cove))]
    ),
    shelf_pad = [move([shelf_hole_x - pad_length / 2, -e], p = rect([pad_length, pad_height + e], anchor = [-1, -1]))],
    wall_pad = [move([-e, wall_hole_y - pad_length / 2], p = rect([pad_height + e, pad_length], anchor = [-1, -1]))],
    joined = union(union(web, shelf_pad), wall_pad)[0]
  ) offset(offset(joined, delta = -Corner_Radius, closed = true), r = Corner_Radius, closed = true);

module Body() {
  intersection() {
    offset_sweep(
      ExtendedProfile(), height = Width,
      bottom = os_chamfer(width = Edge_Radius),
      top = os_circle(r = Edge_Radius)
    );
    translate([0, 0, -1]) cube([Depth + 1, Height + 1, Width + 2]);
  }
}

// Hole along +Y from the mounting face
module ScrewHole() {
  channel = Height + Depth;
  translate([0, -1, 0]) rotate([-90, 0, 0]) cylinder(d = Screw_Diameter, h = Screw_Hole_Depth + 1);
  if (Include_Screw_Countersink)
    translate([0, Screw_Hole_Depth - countersink, 0])
      rotate([-90, 0, 0]) cylinder(d1 = Screw_Diameter, d2 = Screw_Head_Diameter, h = countersink);
  translate([0, Screw_Hole_Depth, 0]) rotate([-90, 0, 0]) cylinder(d = Screw_Head_Diameter, h = channel);
}

module WallFrame() {
  translate([0, wall_hole_y, Width / 2]) rotate([0, 0, -90]) children();
}

module ShelfFrame() {
  translate([shelf_hole_x, 0, Width / 2]) children();
}

difference() {
  Body();
  WallFrame() ScrewHole();
  ShelfFrame() ScrewHole();
}
