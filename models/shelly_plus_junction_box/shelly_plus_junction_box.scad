include <BOSL2/std.scad>
include <pegboard/backplate.scad>

/**
 * Junction box that holds a Shelly Plus module and Wago connectors, with a screw-down lid and a
 * wall mount. All dimensions are in millimeters.
 */

/* [Part] */
// Part to print
Part = "box"; // [box: Box, lid: Lid, mount: Mount]

/* [Wago Connectors] */
// Connector depth
Wago_Connector_Depth = 8.4;

// Connector length along the wire axis
Wago_Connector_Height = 18.6;

// Connector width across the wire axis
Wago_Connector_Width = 18.8;

// Housing wall height behind each connector
Wago_Connector_Housing_Height = 5;

// Connectors on the left side
Wago_Connector_Left_Count = 2; // [0:4]

// Connectors on the right side
Wago_Connector_Right_Count = 2; // [0:4]

// Space for wires beside the connectors
Wago_Wire_Space = 5;

/* [Shelly] */
// Module width
Shelly_Width = 42;

// Module height
Shelly_Height = 37;

// Module depth
Shelly_Depth = 16;

// Depth of the front pocket that holds the module face
Shelly_Housing_Front_Depth = 4;

// Space for wires around the module
Shelly_Wire_Space = 5;

// Diameter of the hole under the module for its button
Shelly_Access_Hole_Diameter = 10;

/* [Box] */
// Thickness of the housing walls
Inner_Wall_Thickness = 2;

// Thickness of the outer walls, floor, and lid
Outer_Wall_Thickness = 2;

// Diameter of the wire entry hole
Wire_Hole_Diameter = 10;

// Radius of the rounded vertical corners (3 for about 1/8")
Corner_Radius = 3;

/* [Lid] */
// Diameter of each corner screw post
Post_Diameter = 7;

// Diameter of the pilot hole in each post
Screw_Pilot_Diameter = 2.5;

// Diameter of the lid screw clearance hole
Screw_Hole_Diameter = 3.5;

// Diameter of the lid screw head countersink
Screw_Head_Diameter = 7;

// Gap on each side between the lid plug and the box opening
Lid_Clearance = 0.2;

/* [Mount] */
// Diameter of the mount tab screw holes
Mount_Screw_Hole_Diameter = 5;

// Length of each mount tab (19.05 for 3/4")
Mount_Tab_Length = 19.05;

// Width of the mount (19.05 for 3/4")
Mount_Width = 19.05;

/* [Hidden] */
$fn = 128;
EPSILON = 0.02;

wago_housing_x = Wago_Connector_Width + 2 * Inner_Wall_Thickness;
shelly_housing_x = Shelly_Width + 2 * Inner_Wall_Thickness;
inner_x = 2 * (Wago_Connector_Height + Wago_Wire_Space) + Shelly_Width + 2 * Inner_Wall_Thickness;
inner_y = max(
  Wago_Connector_Left_Count * (Wago_Connector_Width + Inner_Wall_Thickness),
  Wago_Connector_Right_Count * (Wago_Connector_Width + Inner_Wall_Thickness),
  Shelly_Height + Shelly_Wire_Space
) + Inner_Wall_Thickness;
inner_z = max(Wago_Connector_Depth, Shelly_Depth + Shelly_Wire_Space);
outer_x = inner_x + 2 * Outer_Wall_Thickness;
outer_y = inner_y + 2 * Outer_Wall_Thickness;
outer_z = inner_z + Outer_Wall_Thickness;
wago_housing_edge_x = Outer_Wall_Thickness + Wago_Connector_Height + Wago_Wire_Space - Wago_Connector_Housing_Height;
post_height = inner_z - Outer_Wall_Thickness;
lid_thickness = 2 * Outer_Wall_Thickness;
post_centers = [
  for (x = [Outer_Wall_Thickness + Post_Diameter / 2, outer_x - Outer_Wall_Thickness - Post_Diameter / 2])
    for (y = [Outer_Wall_Thickness + Post_Diameter / 2, outer_y - Outer_Wall_Thickness - Post_Diameter / 2])
      [x, y],
];

assert(Post_Diameter > Screw_Pilot_Diameter, "Post_Diameter must exceed Screw_Pilot_Diameter");
assert(Screw_Hole_Diameter > Screw_Pilot_Diameter, "Screw_Hole_Diameter must exceed Screw_Pilot_Diameter");
assert(Screw_Head_Diameter > Screw_Hole_Diameter, "Screw_Head_Diameter must exceed Screw_Hole_Diameter");
assert(
  Outer_Wall_Thickness + Post_Diameter < wago_housing_edge_x,
  "Posts must clear the Wago housings: reduce Post_Diameter or increase Wago_Wire_Space"
);
assert(Lid_Clearance >= 0, "Lid_Clearance must not be negative");
assert(Corner_Radius * 2 <= min(outer_x, outer_y), "Corner_Radius must be at most half of the box");

module WagoConnectorHousing() {
  y = Wago_Connector_Housing_Height + Inner_Wall_Thickness;
  z = Wago_Connector_Depth + Inner_Wall_Thickness;
  difference() {
    cube([wago_housing_x, y, z]);
    translate([Inner_Wall_Thickness, Inner_Wall_Thickness, 0])
      cube([Wago_Connector_Width, y, Wago_Connector_Depth]);
  }
}

module ShellyHousing() {
  y = Shelly_Height + 2 * Inner_Wall_Thickness;
  z = Shelly_Depth;
  difference() {
    cube([shelly_housing_x, y, z]);
    translate([Inner_Wall_Thickness, Inner_Wall_Thickness, -1])
      cube([Shelly_Width, Shelly_Height, z + 2]);
    translate([Inner_Wall_Thickness, Inner_Wall_Thickness, Shelly_Housing_Front_Depth])
      cube([Shelly_Width, y, z]);
  }
}

module WagoRow(count) {
  for (i = [0:count - 1]) {
    translate([i * wago_housing_x, 0, 0]) WagoConnectorHousing();
  }
}

module BoxInside() {
  ShellyHousing();
  if (Wago_Connector_Left_Count > 0) {
    translate([Inner_Wall_Thickness, 0, 0]) rotate([0, 0, 90]) WagoRow(Wago_Connector_Left_Count);
  }
  if (Wago_Connector_Right_Count > 0) {
    translate([shelly_housing_x - Inner_Wall_Thickness, 0, 0]) mirror([1, 0, 0]) rotate([0, 0, 90])
      WagoRow(Wago_Connector_Right_Count);
  }
}

module BoxShell() {
  difference() {
    cuboid([outer_x, outer_y, outer_z], rounding = Corner_Radius, edges = "Z", anchor = [-1, -1, -1]);
    translate([Outer_Wall_Thickness, Outer_Wall_Thickness, Outer_Wall_Thickness])
      cube([inner_x, inner_y, outer_z]);
    translate([-1, outer_y / 2, outer_z / 2])
      rotate([0, 90, 0]) cylinder(d = Wire_Hole_Diameter, h = Outer_Wall_Thickness + 2);
    translate([outer_x / 2, outer_y / 2, -1])
      cylinder(d = Shelly_Access_Hole_Diameter, h = Outer_Wall_Thickness + 2);
  }
}

module Posts() {
  for (c = post_centers) {
    translate([c.x, c.y, Outer_Wall_Thickness - EPSILON])
      cylinder(d = Post_Diameter, h = post_height + EPSILON);
  }
}

module PilotHoles() {
  for (c = post_centers) {
    translate([c.x, c.y, Outer_Wall_Thickness])
      cylinder(d = Screw_Pilot_Diameter, h = post_height + EPSILON);
  }
}

module Box() {
  difference() {
    union() {
      BoxShell();
      translate([Outer_Wall_Thickness + Wago_Connector_Height + Wago_Wire_Space, 0, Outer_Wall_Thickness])
        BoxInside();
      Posts();
    }
    PilotHoles();
  }
}

module Lid() {
  difference() {
    union() {
      translate([outer_x / 2, outer_y / 2, 0])
        offset_sweep(
          rect([outer_x, outer_y], rounding = Corner_Radius),
          height = Outer_Wall_Thickness, top = os_circle(r = Outer_Wall_Thickness / 2)
        );
      translate([Outer_Wall_Thickness + Lid_Clearance, Outer_Wall_Thickness + Lid_Clearance, Outer_Wall_Thickness - EPSILON])
        cube([inner_x - 2 * Lid_Clearance, inner_y - 2 * Lid_Clearance, Outer_Wall_Thickness + EPSILON]);
    }
    for (c = post_centers) {
      translate([c.x, c.y, lid_thickness])
        rotate([-90, 0, 0]) countersunk_screw_hole(Screw_Hole_Diameter, Screw_Head_Diameter, lid_thickness);
    }
  }
}

module MountTab() {
  difference() {
    cube([Mount_Width, Mount_Tab_Length, Outer_Wall_Thickness]);
    translate([Mount_Tab_Length / 2, Mount_Width / 2, -1])
      cylinder(d = Mount_Screw_Hole_Diameter, h = Outer_Wall_Thickness + 2);
  }
}

module Mount() {
  iy = outer_y;
  iz = inner_z + 2 * Outer_Wall_Thickness;
  oy = iy + 2 * Outer_Wall_Thickness;
  oz = iz + Outer_Wall_Thickness;
  difference() {
    cube([Mount_Width, oy, oz]);
    translate([-1, Outer_Wall_Thickness, -1]) cube([Mount_Width + 2, iy, iz + 1]);
  }
  translate([0, -Mount_Tab_Length, 0]) MountTab();
  translate([0, oy, 0]) MountTab();
}

if (Part == "box") {
  Box();
} else if (Part == "lid") {
  Lid();
} else if (Part == "mount") {
  Mount();
}
