include <BOSL2/std.scad>

/**
 * Joint that holds popsicle sticks at an angle, for building frames and structures. Each
 * arm is a pocket that a stick slides into, closed at the hub end. Slot In has a closed
 * top, so sticks hold without glue; Glue Guide leaves the top open for gluing. Print flat,
 * as modeled: each pocket roof is a short flat bridge and nothing else overhangs. All
 * dimensions are in millimeters.
 */

/* [Joint] */
// Closed top holds the sticks in place, open top guides glue
Top = "closed"; // [closed: Slot In, open: Glue Guide]

// Number of sticks
Stick_Count = 2; // [1:1:12]

// Angle between neighboring sticks, with a Stick_Count of 1 for a cap
Joint_Angle = 90; // [0:1:180]

/* [Sticks] */
// Stick width (9.55 for a standard popsicle stick)
Stick_Width = 10;

// Stick thickness (2.15 for a standard popsicle stick)
Stick_Thickness = 2;

/* [Arms] */
// Arm length from the hub
Arm_Length = 14;

// Wall thickness around each stick
Wall_Thickness = 2;

// Radius of the rounded top outer edges
Edge_Radius = 1;

// Chamfer of the bottom outer edges, kept at 45 degrees so it prints without supports
Bottom_Chamfer = 1;

// Width of the lead-in chamfer on each pocket mouth
Mouth_Chamfer = 0.5;

/* [Hidden] */
$fn = 64;

joint_width = Stick_Width + 2 * Wall_Thickness;
joint_thickness = Stick_Thickness + 2 * Wall_Thickness;
hub_distance = Joint_Angle == 0 || Joint_Angle >= 180 ? 0 : joint_width / (2 * tan(Joint_Angle / 2));
join = 0.01;

assert(Stick_Width <= 15, "Stick_Width must be at most 15 so the pocket roof bridges without supports");
assert(Joint_Angle > 0 || Stick_Count == 1, "Joint_Angle of 0 needs Stick_Count of 1");
assert(Joint_Angle == 0 || 360 / Joint_Angle >= Stick_Count, "Stick_Count arms do not fit around Joint_Angle");
assert(Arm_Length > Wall_Thickness, "Arm_Length must exceed Wall_Thickness");
assert(Mouth_Chamfer < Wall_Thickness, "Mouth_Chamfer must be less than Wall_Thickness");
assert(Edge_Radius + Bottom_Chamfer <= joint_thickness, "Edge_Radius and Bottom_Chamfer must fit the arm thickness");
assert(Edge_Radius + Bottom_Chamfer <= joint_width, "Edge_Radius and Bottom_Chamfer must fit the arm width");

// Cross-section across the arm: top corners rounded, bottom corners chamfered at 45 degrees
module Profile() {
  rect([joint_width, joint_thickness], rounding = [Edge_Radius, Edge_Radius, 0, 0], chamfer = [0, 0, Bottom_Chamfer, Bottom_Chamfer]);
}

module Prism(length) {
  rotate([90, 0, 90]) linear_extrude(length) Profile();
}

// The pocket roof stays flat at the top of the stick; only the sides and floor flare at the mouth
module Pocket() {
  c = Mouth_Chamfer;
  translate([Wall_Thickness, -Stick_Width / 2, -Stick_Thickness / 2]) cube([Arm_Length - c - Wall_Thickness + join, Stick_Width, Stick_Thickness]);
  hull() {
    translate([Arm_Length - c, -Stick_Width / 2, -Stick_Thickness / 2]) cube([join, Stick_Width, Stick_Thickness]);
    translate([Arm_Length, -Stick_Width / 2 - c, -Stick_Thickness / 2 - c]) cube([1, Stick_Width + 2 * c, Stick_Thickness + c]);
  }
}

module Arm() {
  difference() {
    Prism(Arm_Length);
    Pocket();
  }
}

module Hub() {
  hull() {
    for (i = [0:Stick_Count - 1]) rotate([0, 0, i * Joint_Angle]) translate([hub_distance, 0, 0]) Prism(Wall_Thickness);
  }
}

module GlueGuideCut() {
  size = 2 * (hub_distance + Arm_Length + 1);
  translate([0, 0, Stick_Thickness / 2 + size / 2]) cube(size, center = true);
}

module Joint() {
  difference() {
    union() {
      for (i = [0:Stick_Count - 1]) rotate([0, 0, i * Joint_Angle]) translate([hub_distance, 0, 0]) Arm();
      Hub();
    }
    if (Top == "open") GlueGuideCut();
  }
}

Joint();
