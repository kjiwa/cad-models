include <BOSL2/std.scad>

/**
 * One half of a split clamp that holds an optic rail above a blaster rail. Print two; the
 * halves close sideways around both rails and two screws clamp them. The lugs drop into
 * adjacent cross-slots of the blaster rail. Printed on its outer face. All dimensions are in
 * millimeters.
 */

/* [Optic Rail] */
// Width of the wide part of the optic rail
Optic_Rail_Width_Large = 12.7;

// Width of the narrow part of the optic rail
Optic_Rail_Width_Small = 8.8;

// Depth of the wide part of the optic rail
Optic_Rail_Depth_Large = 4.6;

// Depth of the narrow part of the optic rail measured from the top
Optic_Rail_Depth_Small = 2.5;

// Depth of the optic rail
Optic_Rail_Depth = 10;

/* [Blaster Rail] */
// Width of the wide part of the blaster rail
Blaster_Rail_Width_Large = 18;

// Width of the narrow part of the blaster rail
Blaster_Rail_Width_Small = 12.5;

// Depth of the wide part of the blaster rail
Blaster_Rail_Depth_Large = 4.2;

// Depth of the narrow part of the blaster rail measured from the top
Blaster_Rail_Depth_Small = 3.1;

// Depth of the blaster rail
Blaster_Rail_Depth = 7.3;

/* [Rail Slots] */
// Width of a blaster rail cross-slot along the rail
Rail_Slot_Width = 5.3;

// Distance between adjacent cross-slot centers
Rail_Slot_Pitch = 10.1;

// Depth of a cross-slot from the rail top (4.7625 for 3/16")
Rail_Slot_Depth = 4.7625;

// Gap left around each lug in its slot
Lug_Clearance = 0.3;

// Number of lugs (0 to disable)
Lug_Count = 2; // [0:1:4]

/* [Bracket] */
// Length of the bracket along the rails
Bracket_Length = 51.4;

// Wall thickness outside the wider rail
Bracket_Thickness = 5;

// Diameter of the clamping screw holes
Screw_Diameter = 4;

// Distance between the two screw holes
Screw_Spacing = 35.4;

// Offset of the screw axis from the rail seam towards the optic
Screw_Offset = 3.75;

// Size of the chamfer on the two outer long corners
Outer_Chamfer = 2.5;

// Size of the chamfer on the end faces and rail channel mouths
Edge_Chamfer = 0.5;

/* [Hidden] */
$fn = 128;

Half_Width = (max(Optic_Rail_Width_Large, Blaster_Rail_Width_Large) + 2 * Bracket_Thickness) / 2;
Lug_Length = Rail_Slot_Width - Lug_Clearance;
Lug_Floor = Rail_Slot_Depth - Lug_Clearance;
Join_Overlap = 0.01;

assert(Rail_Slot_Depth > Lug_Clearance && Rail_Slot_Width > Lug_Clearance, "Lug_Clearance must be smaller than the slot");
assert(Rail_Slot_Pitch > Rail_Slot_Width, "Rail_Slot_Pitch must exceed Rail_Slot_Width");
assert((Lug_Count - 1) * Rail_Slot_Pitch + Lug_Length <= Bracket_Length, "Lugs must fit within Bracket_Length");
assert(Lug_Floor <= Blaster_Rail_Depth, "Rail_Slot_Depth must not exceed Blaster_Rail_Depth");
assert(Screw_Spacing + Screw_Diameter <= Bracket_Length, "Screws must fit within Bracket_Length");
assert(Outer_Chamfer < Bracket_Thickness + Edge_Chamfer, "Outer_Chamfer is too large");

function RailHalfProfile(width_large, width_small, depth_large, depth_small, depth) = [
  [0, 0],
  [width_large / 2, 0],
  [width_large / 2, depth_large],
  [width_small / 2, depth - depth_small],
  [width_small / 2, depth],
  [0, depth]
];

function BlasterHalfProfile() = [
  for (p = RailHalfProfile(
    Blaster_Rail_Width_Large, Blaster_Rail_Width_Small, Blaster_Rail_Depth_Large, Blaster_Rail_Depth_Small,
    Blaster_Rail_Depth
  )) [p.x, -p.y]
];

function BodyProfile() = [
  [Optic_Rail_Width_Small / 2, Optic_Rail_Depth],
  [Optic_Rail_Width_Small / 2, Optic_Rail_Depth - Optic_Rail_Depth_Small],
  [Optic_Rail_Width_Large / 2, Optic_Rail_Depth_Large],
  [Optic_Rail_Width_Large / 2, 0],
  [Blaster_Rail_Width_Large / 2, 0],
  [Blaster_Rail_Width_Large / 2, -Blaster_Rail_Depth_Large],
  [Blaster_Rail_Width_Small / 2, -(Blaster_Rail_Depth - Blaster_Rail_Depth_Small)],
  [Blaster_Rail_Width_Small / 2, -Blaster_Rail_Depth],
  [Half_Width - Outer_Chamfer, -Blaster_Rail_Depth],
  [Half_Width, -Blaster_Rail_Depth + Outer_Chamfer],
  [Half_Width, Optic_Rail_Depth - Outer_Chamfer],
  [Half_Width - Outer_Chamfer, Optic_Rail_Depth]
];

module Body() {
  offset_sweep(
    BodyProfile(), height = Bracket_Length,
    bottom = os_chamfer(width = Edge_Chamfer), top = os_chamfer(width = Edge_Chamfer)
  );
}

module Lug() {
  translate([0, 0, -Lug_Length / 2]) linear_extrude(Lug_Length) intersection() {
    offset(delta = Join_Overlap) polygon(BlasterHalfProfile());
    translate([Lug_Clearance / 2, -Lug_Floor]) square([Half_Width, Lug_Floor]);
  }
}

module Lugs() {
  for (i = [0:Lug_Count - 1])
    translate([0, 0, Bracket_Length / 2 + (i - (Lug_Count - 1) / 2) * Rail_Slot_Pitch]) Lug();
}

module ScrewHoles() {
  for (side = [-1, 1])
    translate([-1, Screw_Offset, Bracket_Length / 2 + side * Screw_Spacing / 2])
      rotate([0, 90, 0]) cylinder(d = Screw_Diameter, h = Half_Width + 2);
}

module Bracket() {
  difference() {
    union() {
      Body();
      if (Lug_Count > 0) Lugs();
    }
    ScrewHoles();
  }
}

translate([0, 0, Half_Width]) rotate([0, 90, 0]) Bracket();
