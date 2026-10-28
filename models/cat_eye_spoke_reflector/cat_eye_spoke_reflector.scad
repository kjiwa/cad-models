include <BOSL2/std.scad>

/**
 * Cat Eye RR-250-WU style spoke reflector: a faceted disc faced with 3M 3432 microprismatic
 * tape, clamped to two spokes by M4 screws into the printed spoke nuts. Each face is flat
 * near the middle and slopes toward the rim, so each facet points at its own side and the tape
 * keeps its return at wide entrance angles. Print the reflector with supports under the mount
 * arms; print the nut and the template as modeled. All dimensions are in millimeters.
 */

/* [Part] */
// Part to print
Part = "reflector"; // [reflector: Reflector, nut: Spoke Nut, template: Tape Template]

/* [Reflector] */
// Reflector disc diameter
Reflector_Diameter = 66;

// Reflector thickness at the center
Reflector_Thickness = 18;

/* [Mount] */
// Mount plate length
Mount_Length = 120;

// Mount plate width
Mount_Width = 15;

// Mount plate thickness
Mount_Thickness = 3;

// Length of the screw slots
Mount_Slot_Length = 15;

// Width of the screw slots
Mount_Slot_Width = 4.5;

/* [Nut] */
// Nut length
Nut_Length = 10.7;

// Nut width
Nut_Width = 8.75;

// Nut height
Nut_Height = 5;

// Spoke diameter
Spoke_Diameter = 2;

// Screw hole diameter (3.5 for an M4 tap)
Screw_Diameter = 3.5;

// Radius of the rounded nut top edge
Nut_Edge_Radius = 0.5;

/* [Template] */
// Tape template thickness
Template_Thickness = 1.5;

/* [Hidden] */
$fn = 128;

join = 0.01;
facet_start = Reflector_Diameter / 6;
facet_angle = atan(0.75 * Reflector_Thickness / Reflector_Diameter);
slot_offset = (Mount_Length - Mount_Slot_Length - Mount_Width + Mount_Slot_Width) / 2;
nut_groove_x = (Nut_Length - (Nut_Width - Screw_Diameter) / 2) / 2;
template_steps = 64;

assert(Reflector_Diameter > 0 && Reflector_Thickness > 0, "Reflector_Diameter and Reflector_Thickness must be positive");
assert(Mount_Length > Reflector_Diameter, "Mount_Length must exceed Reflector_Diameter");
assert(Mount_Thickness < Reflector_Thickness / 2, "Mount_Thickness must be less than half of Reflector_Thickness");
assert(Mount_Slot_Width < Mount_Width, "Mount_Slot_Width must be less than Mount_Width");
assert(Spoke_Diameter < Nut_Height, "Spoke_Diameter must be less than Nut_Height");
assert(Screw_Diameter < Nut_Width - 2 * Nut_Edge_Radius, "Screw_Diameter must be less than the nut width");
assert(Nut_Edge_Radius < Nut_Height - Spoke_Diameter, "Nut_Edge_Radius must be less than the nut top above the groove");
assert(Template_Thickness > 0, "Template_Thickness must be positive");

module FacetCutout() {
  translate([facet_start, -Reflector_Diameter / 2, Reflector_Thickness / 2])
    rotate([0, facet_angle, 0])
      cube([Reflector_Diameter, Reflector_Diameter, Reflector_Thickness]);
}

module Disc() {
  difference() {
    cyl(d = Reflector_Diameter, h = Reflector_Thickness, anchor = CENTER);
    FacetCutout();
    zflip() FacetCutout();
    zrot(180) FacetCutout();
    zrot(180) zflip() FacetCutout();
  }
}

module Mount() {
  half_arm = (Mount_Length - Mount_Width) / 2;
  difference() {
    union() {
      cuboid([Mount_Length, Mount_Width, Mount_Thickness], rounding = Mount_Width / 2, edges = "Z");
      difference() {
        translate([0, -Reflector_Diameter / 4, 0])
          cube([Mount_Length - Mount_Width, Reflector_Diameter / 2 - Mount_Width, Mount_Thickness], center = true);
        for (side = [-1, 1])
          translate([side * half_arm, (-Reflector_Diameter + Mount_Width) / 2, 0])
            scale([Mount_Length - Mount_Width - Reflector_Diameter, Reflector_Diameter - 2 * Mount_Width, 1])
              cylinder(d = 1, h = Mount_Thickness + 2, center = true);
      }
    }
    for (side = [-1, 1])
      translate([side * slot_offset, 0, 0])
        cuboid([Mount_Slot_Length, Mount_Slot_Width, Mount_Thickness + 2], rounding = Mount_Slot_Width / 2, edges = "Z");
  }
}

module Reflector() {
  up(Reflector_Thickness / 2) {
    Disc();
    translate([0, (Reflector_Diameter - Mount_Width) / 2, 0]) Mount();
  }
}

function unfolded_x(x) =
  abs(x) <= facet_start ? x : sign(x) * (facet_start + (abs(x) - facet_start) / cos(facet_angle));

module Template() {
  radius = Reflector_Diameter / 2;
  xs = [for (i = [0:template_steps]) -radius + i * Reflector_Diameter / template_steps];
  xs_with_creases = [for (x = xs) x, -facet_start, facet_start];
  sorted = sort(xs_with_creases);
  upper = [for (x = sorted) [unfolded_x(x), sqrt(max(0, radius * radius - x * x))]];
  lower = [for (i = [len(upper) - 2:-1:1]) [upper[i][0], -upper[i][1]]];
  linear_extrude(Template_Thickness) polygon(concat(upper, lower));
}

module NutBody() {
  straight = Nut_Length - Nut_Width / 2;
  outline = concat(
    arc(n = 32, r = Nut_Width / 2, angle = [90, 270], endpoints = true),
    [[straight, -Nut_Width / 2], [straight, Nut_Width / 2]]
  );
  offset_sweep(outline, height = Nut_Height, top = os_circle(r = Nut_Edge_Radius));
}

module SpokeGroove() {
  translate([nut_groove_x, 0, Nut_Height])
    hull()
      for (dz = [-Spoke_Diameter / 2, Spoke_Diameter / 2])
        translate([0, 0, dz])
          rotate([90, 0, 0]) cylinder(d = Spoke_Diameter, h = Nut_Width + 2, center = true);
}

module Nut() {
  difference() {
    NutBody();
    SpokeGroove();
    down(join) cyl(d = Screw_Diameter, h = Nut_Height + 2 * join, anchor = BOTTOM);
  }
}

if (Part == "nut") Nut();
else if (Part == "template") Template();
else Reflector();
