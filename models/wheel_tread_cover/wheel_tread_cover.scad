include <BOSL2/std.scad>

/**
 * Sleeve with a helical tread that slips over a wheel.
 *
 * The tread is a star profile twisted along the width, mirrored about the middle so
 * the two halves form a herringbone. The top end can wrap around the wheel's rounded
 * edge to form a retaining lip. All dimensions are in millimeters.
 */

/* [Sleeve] */
// Inside diameter, matching the wheel (171.45 for 6.75")
Inner_Diameter = 171.45;

// Sleeve width along the axle (52.3875 for 2-1/16")
Width = 52.3875;

// Sleeve wall thickness (3.175 for 1/8")
Thickness = 3.175;

// Radius of the wheel's rounded outer edge (6.35 for 1/4")
Edge_Radius = 6.35;

// Angle the top end wraps around the wheel edge, 45 or less prints without supports (0 to disable)
Wrap_Angle = 45; // [0:5:90]

/* [Tread] */
// Number of tread ridges around the circumference
Tread_Count = 100; // [4:1:200]

// Ridge height above the sleeve surface (1.5875 for 1/16")
Tread_Depth = 1.5875;

/* [Hidden] */
$fn = 128;

assert(Tread_Depth < Thickness, "Tread_Depth must be less than Thickness");
assert(
  Wrap_Angle == 0 || (Edge_Radius > 0 && Edge_Radius < Width && Edge_Radius < Inner_Diameter / 2),
  "Edge_Radius must be positive and smaller than Width and the inner radius"
);

wheel_radius = Inner_Diameter / 2;
edge_radius = Wrap_Angle > 0 ? Edge_Radius : 0;
corner = [wheel_radius - edge_radius, Width / 2 - edge_radius];

module HalfTread() {
  od = Inner_Diameter + 2 * Thickness;
  id = od - 2 * Tread_Depth;
  height = Width / 2 + Thickness;
  twist = 360 * Width / (2 * Inner_Diameter * PI) * height / (Width / 2);

  linear_extrude(height = height, twist = twist)
    star(n = Tread_Count, d = od, id = id);
}

module Tread() {
  HalfTread();
  mirror([0, 0, 1])
    HalfTread();
}

module WheelProfile() {
  intersection() {
    translate([0, -Width / 2]) square([wheel_radius, Width]);
    hull() {
      translate([0, -Width / 2]) square([wheel_radius, Width - edge_radius]);
      translate([0, -Width / 2]) square([corner.x, Width]);
      if (edge_radius > 0) translate(corner) circle(r = edge_radius);
    }
  }
}

module WrapWedge() {
  reach = 2 * (edge_radius + Thickness);
  translate(corner)
    polygon([[0, 0], [reach, 0], reach * [cos(Wrap_Angle), sin(Wrap_Angle)]]);
}

module Shell() {
  difference() {
    intersection() {
      offset(r = Thickness) WheelProfile();
      translate([0, -Width / 2]) square([wheel_radius + Thickness, Width + Thickness + edge_radius]);
      union() {
        translate([0, -Width / 2]) square([wheel_radius + Thickness, corner.y + Width / 2]);
        if (Wrap_Angle > 0) WrapWedge();
      }
    }
    WheelProfile();
  }
}

intersection() {
  Tread();
  rotate_extrude() Shell();
}
