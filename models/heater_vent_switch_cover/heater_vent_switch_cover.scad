include <BOSL2/std.scad>

/**
 * Cover for a heater vent switch: a flange with a half-cylinder dome over a rectangular
 * opening. The inside matches the original fit; the outside is rounded where hands and
 * the floor touch. Print flange down. All dimensions are in millimeters.
 */

/* [Cover] */
// Flange thickness
Depth = 9;

// Dome length along the switch
Width = 22;

// Dome outside diameter
Height = 35;

// Dome wall thickness
Wall_Thickness = 2;

// Flange reach beyond the dome on each side
Flange_Overhang = 5;

/* [Finish] */
// Radius of the rounded flange corners
Corner_Radius = 4;

// Radius of the rounded flange top edge and dome ends
Edge_Radius = 1.5;

// Fillet between the dome and the flange (0 to disable)
Fillet_Radius = 1.5;

/* [Hidden] */
$fn = 128;

BED_CHAMFER = 0.6;

flange_size = [Width + 2 * Flange_Overhang, Height + 2 * Flange_Overhang];
cavity = [Width - 2 * Wall_Thickness, Height - 2 * Wall_Thickness];

assert(Wall_Thickness > 0 && 2 * Wall_Thickness < Width && 2 * Wall_Thickness < Height, "Wall_Thickness must be positive and less than half of Width and Height");
assert(Corner_Radius < min(flange_size) / 2, "Corner_Radius must be less than half of the flange");
assert(Edge_Radius > 0 && Edge_Radius < Depth && Edge_Radius < Wall_Thickness, "Edge_Radius must be positive and less than Depth and Wall_Thickness");
assert(BED_CHAMFER < Depth, "Depth is too small");

module Flange() {
  offset_sweep(
    rect(flange_size, rounding = Corner_Radius), height = Depth,
    bottom = os_chamfer(width = BED_CHAMFER),
    top = os_circle(r = Edge_Radius)
  );
}

module Dome() {
  intersection() {
    translate([0, 0, Depth]) cyl(d = Height, l = Width, rounding = Edge_Radius, orient = RIGHT);
    translate([0, 0, Depth]) cuboid([Width + 2, Height + 2, Height], anchor = BOTTOM);
  }
  if (Fillet_Radius > 0) {
    translate([0, 0, Depth])
      offset_sweep(
        rect([Width, Height], rounding = Edge_Radius), height = Fillet_Radius + 0.5,
        bottom = os_circle(r = -Fillet_Radius)
      );
  }
}

module Cavity() {
  translate([0, 0, -1]) cuboid([cavity.x, cavity.y, Depth + 1], anchor = BOTTOM);
  translate([0, 0, Depth]) intersection() {
    cyl(d = cavity.y, l = cavity.x, orient = RIGHT);
    cuboid([cavity.x + 2, cavity.y + 2, cavity.y], anchor = BOTTOM);
  }
}

difference() {
  union() {
    Flange();
    Dome();
  }
  Cavity();
}
