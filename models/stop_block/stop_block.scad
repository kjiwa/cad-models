/**
 * Stop block that clamps over a fence with a bolt through each leg's slot, to index
 * workpieces against a ruler. The two faces on the fence and both end faces stay flat and
 * square; every other corner is rounded, and the fence corners are relieved so sawdust
 * cannot hold the block off. All dimensions are in millimeters.
 */

/* [Fence] */
// Fence height the block sits over
Fence_Height = 66;

// Fence depth the block sits against
Fence_Depth = 35;

/* [Block] */
// Block width along the fence
Width = 19;

// Thickness of the leg over the top of the fence
Top_Thickness = 10;

// Thickness of the leg against the front of the fence
Front_Thickness = 19;

// Radius of the rounded outer corners
Edge_Radius = 4;

// Size of the dust relief at both fence corners (0 to disable)
Dust_Relief = 2;

/* [Hardware] */
// Bolt diameter, also the slot width
Bolt_Diameter = 7;

// Distance from the fence edges to the slot ends
Bolt_Hole_Offset = 10;

/* [Hidden] */
$fn = 128;

CHAMFER = 0.5;
total_depth = Fence_Depth + Front_Thickness;
total_height = Fence_Height + Top_Thickness;
foot_radius = Edge_Radius / 2;

assert(Edge_Radius > 0 && Edge_Radius < Top_Thickness, "Edge_Radius must be positive and less than Top_Thickness");
assert(Bolt_Diameter < Width, "Bolt_Diameter must be less than Width");
assert(Bolt_Diameter < Top_Thickness + Front_Thickness, "Bolt_Diameter is too large for the block");

module Outline() {
  hull() {
    square(0.01);
    translate([total_depth - foot_radius, foot_radius]) circle(r = foot_radius);
    translate([total_depth - Edge_Radius, total_height - Edge_Radius]) circle(r = Edge_Radius);
    translate([Edge_Radius, total_height - Edge_Radius]) circle(r = Edge_Radius);
  }
}

module Relief() {
  if (Dust_Relief > 0) {
    translate([Fence_Depth, Fence_Height]) circle(r = Dust_Relief);
    translate([Fence_Depth, 0])
      polygon([[-1, -1], [Dust_Relief + 1, -1], [-1, Dust_Relief + 1]]);
  }
}

module Profile() {
  difference() {
    Outline();
    translate([-1, -1]) square([Fence_Depth + 1, Fence_Height + 1]);
    Relief();
  }
}

// Slot from the outer face inward along +Z, running along +X, with an entry chamfer
module Slot(length, depth) {
  layers = [
    [-1, Bolt_Diameter + 2 * CHAMFER, Bolt_Diameter + 2 * CHAMFER, 1],
    [0, Bolt_Diameter + 2 * CHAMFER, Bolt_Diameter, CHAMFER],
    [CHAMFER, Bolt_Diameter, Bolt_Diameter, depth],
  ];
  for (layer = layers)
    hull()
      for (x = [0, length])
        translate([x, 0, layer[0]]) cylinder(d1 = layer[1], d2 = layer[2], h = layer[3] + 0.001);
}

module TopSlot() {
  translate([0, total_height, Width / 2])
    rotate([90, 0, 0])
    Slot(Fence_Depth - Bolt_Hole_Offset - Bolt_Diameter / 2, Top_Thickness + 1);
}

module FrontSlot() {
  length = Fence_Height - 2 * Bolt_Hole_Offset - Bolt_Diameter;
  translate([total_depth, Bolt_Hole_Offset + Bolt_Diameter / 2 + length, Width / 2])
    rotate([90, 0, -90])
    Slot(length, Front_Thickness + 1);
}

difference() {
  linear_extrude(height = Width) Profile();
  TopSlot();
  FrontSlot();
}
