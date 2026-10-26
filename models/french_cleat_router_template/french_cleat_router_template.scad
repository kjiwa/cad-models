include <BOSL2/std.scad>

/**
 * Router template for cutting a French cleat: a fence wall with a cleat-shaped opening in the top
 * plate that a pattern bit with a bearing follows. Print with the top plate on the bed. All
 * dimensions are in millimeters.
 */

/* [Template] */
// Template length along the cleat (171.45 for 6-3/4")
Template_Length = 171.45;

// Template width from the fence wall (76.2 for 3")
Template_Width = 76.2;

// Workpiece thickness under the top plate (19.05 for 3/4")
Template_Overhang_Height = 19.05;

// Fence wall thickness (6.35 for 1/4")
Template_Wall_Thickness = 6.35;

// Radius of the rounded far plate corners (6.35 for 1/4") (0 to disable)
Corner_Radius = 6.35;

// Chamfer on the outer top plate edges (1.5875 for 1/16") (0 to disable)
Edge_Chamfer = 1.5875;

/* [Cleat] */
// Angle of the cleat bevel
Cleat_Angle = 30; // [15:1:45]

// Cleat thickness (19.05 for 3/4")
Cleat_Thickness = 19.05;

// Cleat height (95.25 for 3-3/4")
Cleat_Height = 95.25;

/* [Router Bit] */
// Pattern bit diameter, cuts a dog-bone relief at each closed corner of the opening (22.225 for 7/8") (0 to disable)
Router_Bit_Diameter = 22.225;

// Bit cutter height (31.75 for 1-1/4")
Router_Bit_Cutter_Height = 31.75;

// Bearing height above the cutter (6.35 for 1/4")
Router_Bit_Guide_Bushing_Height = 6.35;

/* [Screw Holes] */
// Screw hole diameter (4.7625 for 3/16")
Screw_Hole_Diameter = 4.7625;

// Screw head diameter (7.9375 for 5/16")
Screw_Head_Diameter = 7.9375;

// Screw head thickness (3.175 for 1/8")
Screw_Head_Thickness = 3.175;

// Screw hole distance from each template end (25.4 for 1")
Screw_Hole_Offset = 25.4;

/* [Hidden] */
$fn = 128;

top_wall_thickness = (Router_Bit_Cutter_Height - Template_Overhang_Height) / 2 + Router_Bit_Guide_Bushing_Height;
template_depth = top_wall_thickness + Template_Overhang_Height;
cleat_start = (Template_Length - Cleat_Height) / 2;
bit_radius = Router_Bit_Diameter / 2;
screw_countersink_diameter = (Screw_Head_Diameter - Screw_Hole_Diameter) * Template_Wall_Thickness / Screw_Head_Thickness + Screw_Hole_Diameter;
cleat_top_slope = Cleat_Thickness * tan(Cleat_Angle);

assert(Cleat_Height <= Template_Length, "Cleat_Height must not exceed Template_Length");
assert(Cleat_Height > cleat_top_slope, "Cleat_Angle is too steep for Cleat_Height");
assert(Router_Bit_Diameter >= 0, "Router_Bit_Diameter must not be negative");
assert(Template_Width > Cleat_Thickness + bit_radius, "Template_Width is too small for the cleat and bit relief");
assert(cleat_start > bit_radius, "Template_Length is too short for the cleat and bit relief");
assert(Screw_Head_Diameter > Screw_Hole_Diameter, "Screw_Head_Diameter must exceed Screw_Hole_Diameter");
assert(Screw_Hole_Offset < cleat_start, "Screw_Hole_Offset must keep the screws clear of the cleat opening");
assert(Router_Bit_Cutter_Height > Template_Overhang_Height, "Router_Bit_Cutter_Height must exceed Template_Overhang_Height");

cleat_outline = [[0, 0], [Cleat_Thickness, 0], [Cleat_Thickness, Cleat_Height], [0, Cleat_Height - cleat_top_slope]];

// Circle of the bit diameter centered on the corner at `index`: it opens into the cleat opening, so the bearing can
// follow it into the corner and the bit cuts the corner square.
module Relief(index) {
  translate(cleat_outline[index]) circle(d = Router_Bit_Diameter);
}

module CleatOpening() {
  polygon(cleat_outline);
  if (Router_Bit_Diameter > 0) {
    Relief(1);
    Relief(2);
  }
}

module TemplateBase() {
  size = [Template_Width + Template_Wall_Thickness, Template_Length, template_depth];
  difference() {
    cuboid(size, anchor = BOTTOM + LEFT + FRONT);
    translate([Template_Wall_Thickness, -1, -top_wall_thickness]) cube([size.x, size.y + 2, template_depth]);
    translate([-Template_Wall_Thickness, cleat_start, 0]) cube([2 * Template_Wall_Thickness, Cleat_Height, 2 * template_depth]);
    translate([0, cleat_start, -Template_Overhang_Height]) cube([2 * Template_Wall_Thickness, Cleat_Height, 2 * Template_Overhang_Height]);
  }
}

module OuterShape() {
  size = [Template_Width + Template_Wall_Thickness, Template_Length, template_depth];
  intersection() {
    cuboid(size, rounding = Corner_Radius, edges = [RIGHT + FRONT, RIGHT + BACK], anchor = BOTTOM + LEFT + FRONT);
    cuboid(size, chamfer = Edge_Chamfer, edges = [TOP + RIGHT, TOP + FRONT, TOP + BACK], anchor = BOTTOM + LEFT + FRONT);
  }
}

module Screw() {
  translate([0, 0, -1]) cylinder(d = Screw_Hole_Diameter, h = 1 + Template_Wall_Thickness);
  cylinder(d1 = Screw_Hole_Diameter, d2 = screw_countersink_diameter, h = Template_Wall_Thickness);
  translate([0, 0, Template_Wall_Thickness]) cylinder(d = screw_countersink_diameter, h = 1);
}

module Template() {
  difference() {
    intersection() {
      TemplateBase();
      OuterShape();
    }
    translate([Template_Wall_Thickness, cleat_start, Template_Overhang_Height - 1])
      linear_extrude(height = top_wall_thickness + 2) CleatOpening();
    for (y = [Screw_Hole_Offset, Template_Length - Screw_Hole_Offset])
      translate([Template_Wall_Thickness, y, Template_Overhang_Height / 2]) rotate([0, -90, 0]) Screw();
  }
}

Template();
