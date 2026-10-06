include <BOSL2/std.scad>

/**
 * Sleeve with a helical tread that slips over a wheel.
 *
 * The tread is a star profile twisted along the width, mirrored about the middle so
 * the two halves form a herringbone. All dimensions are in millimeters.
 */

/* [Sleeve] */
// Inside diameter, matching the wheel (171.45 for 6.75")
Inner_Diameter = 171.45;

// Sleeve width along the axle (52.3875 for 2-1/16")
Width = 52.3875;

// Sleeve wall thickness (3.175 for 1/8")
Thickness = 3.175;

/* [Tread] */
// Number of tread ridges around the circumference
Tread_Count = 100; // [4:1:200]

// Ridge height above the sleeve surface (1.5875 for 1/16")
Tread_Depth = 1.5875;

/* [Hidden] */
$fn = 128;

assert(Tread_Depth < Thickness, "Tread_Depth must be less than Thickness");

module HalfTread() {
  od = Inner_Diameter + 2 * Thickness;
  id = od - 2 * Tread_Depth;
  twist = 360 * Width / (2 * Inner_Diameter * PI);

  linear_extrude(height = Width / 2, twist = twist)
    star(n = Tread_Count, d = od, id = id);
}

module Tread() {
  HalfTread();
  mirror([0, 0, 1])
    HalfTread();
}

difference() {
  Tread();
  cylinder(d = Inner_Diameter, h = Width * 2, center = true);
}
