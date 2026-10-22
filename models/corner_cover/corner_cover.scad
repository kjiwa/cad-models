include <BOSL2/std.scad>

/**
 * L-shaped guard for the sharp outer corner of cabinet trim, such as a plinth. The pocket
 * is open on two sides and the other two walls cover the corner, with a rounded outer
 * edge. All dimensions are in millimeters.
 */

/* [Guard] */
// Guard height, matching the trim (141.3 for 5-9/16")
Height = 141.3;

// Outside width of the square section (38.1 for 1-1/2")
Outer_Width = 38.1;

// Pocket width that fits the trim (31.75 for 1-1/4")
Inner_Width = 31.75;

// Radius of the rounded outer corner (6.35 for 1/4")
Corner_Radius = 6.35;

// Radius of the rounded top and bottom edges (0 to disable)
Edge_Radius = 0.6;

/* [Hidden] */
$fn = 128;

assert(Inner_Width < Outer_Width, "Inner_Width must be less than Outer_Width");
assert(Corner_Radius <= (Outer_Width - Inner_Width), "Corner_Radius must not exceed the wall thickness");
assert(Edge_Radius < (Outer_Width - Inner_Width), "Edge_Radius must be less than the wall thickness");

module Outline() {
  intersection() {
    cuboid(
      [Outer_Width, Outer_Width, Height], rounding = Corner_Radius, anchor = BOTTOM,
      edges = [LEFT + FRONT, LEFT + BACK, RIGHT + FRONT, RIGHT + BACK]
    );
    if (Edge_Radius > 0) cuboid([Outer_Width, Outer_Width, Height], rounding = Edge_Radius, anchor = BOTTOM, edges = [TOP, BOTTOM]);
  }
}

difference() {
  Outline();
  translate([-Outer_Width / 2 - 1, Outer_Width / 2 + 1 - Inner_Width - 1, -1])
    cube([Inner_Width + 1, Inner_Width + 1, Height + 2]);
}
