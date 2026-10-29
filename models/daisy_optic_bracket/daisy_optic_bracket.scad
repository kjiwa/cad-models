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

// Shift of the lugs from the bracket center, positive away from the origin end
Lug_Offset = 0;

/* [Bracket] */
// Length of the bracket along the rails
Bracket_Length = 51.4;

// Wall thickness outside the wider rail
Bracket_Thickness = 5;

// Size of the chamfer on the two outer long corners
Outer_Chamfer = 2.5;

// Size of the chamfer on the end faces and rail channel mouths
Edge_Chamfer = 0.5;

/* [Screw] */
// Diameter of the clamping screw holes
Screw_Diameter = 4.4;

// Distance between the two screw holes
Screw_Spacing = 35.4;

// Offset of the screw axis from the rail seam towards the optic
Screw_Offset = 3.75;

// Diameter of the screw head
Screw_Head_Diameter = 7;

// Height of the screw head
Screw_Head_Height = 4;

// Length of the screw under the head, widening the bracket to fit
Screw_Length = 22;

// Nut across the flats
Nut_Across_Flats = 7;

// Nut thickness
Nut_Thickness = 3.2;

// Gap added around the screw head and the nut
Pocket_Clearance = 0.3;

/* [Hidden] */
$fn = 128;

Counterbore_Depth = Screw_Head_Height + 0.5;
Half_Width = max(
  (max(Optic_Rail_Width_Large, Blaster_Rail_Width_Large) + 2 * Bracket_Thickness) / 2,
  (Counterbore_Depth + Screw_Length + 0.5) / 2
);
Lug_Length = Rail_Slot_Width - Lug_Clearance;
Lug_Floor = Rail_Slot_Depth - Lug_Clearance;
Join_Overlap = 0.01;
Wall_Min = 2.5;
End_Wall_Min = 1.2;
Nut_Seat_Gap = 0.3;

Clamp_Width = 2 * Half_Width;
Counterbore_Diameter = Screw_Head_Diameter + Pocket_Clearance;
Screw_End = Counterbore_Depth + Screw_Length;
Nut_Pocket_Depth = max(Clamp_Width - Screw_End + Nut_Thickness + Nut_Seat_Gap, Nut_Thickness + Nut_Seat_Gap);
Nut_Pocket_Flats = Nut_Across_Flats + Pocket_Clearance;
Nut_Pocket_Corners = 2 * Nut_Pocket_Flats / sqrt(3);

function CavityHalfWidth(y) = y >= 0
  ? lookup(y, [
    [0, Optic_Rail_Width_Large / 2], [Optic_Rail_Depth_Large, Optic_Rail_Width_Large / 2],
    [Optic_Rail_Depth - Optic_Rail_Depth_Small, Optic_Rail_Width_Small / 2], [Optic_Rail_Depth, Optic_Rail_Width_Small / 2]
  ])
  : lookup(-y, [
    [0, Blaster_Rail_Width_Large / 2], [Blaster_Rail_Depth_Large, Blaster_Rail_Width_Large / 2],
    [Blaster_Rail_Depth - Blaster_Rail_Depth_Small, Blaster_Rail_Width_Small / 2], [Blaster_Rail_Depth, Blaster_Rail_Width_Small / 2]
  ]);

Pocket_Wall = Half_Width - CavityHalfWidth(Screw_Offset);

assert(Rail_Slot_Depth > Lug_Clearance && Rail_Slot_Width > Lug_Clearance, "Lug_Clearance must be smaller than the slot");
assert(Rail_Slot_Pitch > Rail_Slot_Width, "Rail_Slot_Pitch must exceed Rail_Slot_Width");
assert(
  abs(Lug_Offset) + ((Lug_Count - 1) * Rail_Slot_Pitch + Lug_Length) / 2 <= Bracket_Length / 2,
  "Lugs must fit within Bracket_Length"
);
assert(Lug_Floor <= Blaster_Rail_Depth, "Rail_Slot_Depth must not exceed Blaster_Rail_Depth");
assert(
  (Bracket_Length - Screw_Spacing - Nut_Pocket_Corners) / 2 >= End_Wall_Min,
  "Bracket_Length must leave at least 1.2 mm of wall between the screw pockets and the end faces"
);
assert(
  Half_Width - Outer_Chamfer > max(Optic_Rail_Width_Large, Blaster_Rail_Width_Large) / 2 + Edge_Chamfer,
  "Outer_Chamfer must leave the rail walls wider than Edge_Chamfer"
);
assert(2 * Outer_Chamfer < Optic_Rail_Depth + Blaster_Rail_Depth, "Outer_Chamfer must be less than half the rail stack depth");
assert(
  Screw_Offset - Screw_Diameter / 2 > -Blaster_Rail_Depth && Screw_Offset + Screw_Diameter / 2 < Optic_Rail_Depth,
  "Screw holes must stay within the rail stack depth"
);
assert(
  Pocket_Wall - max(Counterbore_Depth, Nut_Pocket_Depth) >= Wall_Min,
  "Pockets must leave at least 2.5 mm of wall; use a longer screw or a larger Bracket_Thickness"
);

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
    translate([0, 0, Bracket_Length / 2 + Lug_Offset + (i - (Lug_Count - 1) / 2) * Rail_Slot_Pitch]) Lug();
}

module ScrewHole(z) {
  translate([-1, Screw_Offset, z]) rotate([0, 90, 0]) cylinder(d = Screw_Diameter, h = Half_Width + 2);
}

module Counterbore(z) {
  translate([Half_Width - Counterbore_Depth, Screw_Offset, z]) rotate([0, 90, 0])
    cylinder(d = Counterbore_Diameter, h = Counterbore_Depth + 1);
}

module NutPocket(z) {
  translate([Half_Width - Nut_Pocket_Depth, Screw_Offset, z]) rotate([0, 90, 0])
    cylinder(d = Nut_Pocket_Corners, h = Nut_Pocket_Depth + 1, $fn = 6);
}

module ScrewHoles() {
  head_z = Bracket_Length / 2 - Screw_Spacing / 2;
  nut_z = Bracket_Length / 2 + Screw_Spacing / 2;
  ScrewHole(head_z);
  ScrewHole(nut_z);
  Counterbore(head_z);
  NutPocket(nut_z);
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
