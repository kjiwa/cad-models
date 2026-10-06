/**
 * Router template for hanging slots (keyholes) in frames and other workpieces.
 *
 * Two styles share the slot geometry. "three_slot" is a flat plate that lines up with
 * a frame corner and routes a long slot and two short slots, all level. "edge_guide" is
 * a narrow plate with side fences that straddles a workpiece and routes one short slot.
 * Each slot is a guide-bushing channel with a narrower venting slot extending past
 * both ends so chips can escape. All dimensions are in millimeters.
 */

/* [Part] */
// Template layout
Style = "three_slot"; // [three_slot: Three Slots, edge_guide: Single Slot With Side Fences]

/* [Plate] */
// Plate length along the slots (X) (228.6 for 9" three_slot, 152.4 for 6" edge_guide)
Plate_Length = 228.6;

// Plate width across the slots (Y), including the fences for edge_guide (76.2 for 3" three_slot, 38.1 for 1-1/2" edge_guide)
Plate_Width = 76.2;

// Plate thickness, which sets the guide bushing engagement (6.35 for 1/4")
Plate_Thickness = 6.35;

/* [Slots] */
// Guide channel width, the guide bushing diameter plus clearance (16.66875 for 21/32" around a 5/8" bushing)
Guide_Width = 16.66875;

// Center-to-center length of the short slot (31.75 for 1-1/4")
Short_Slot_Length = 31.75;

// Center-to-center length of the long slot, three_slot only (139.7 for 5-1/2")
Long_Slot_Length = 139.7;

/* [Venting Slots] */
// Length the venting slot extends past each end of the guide channel (12.7 for 1/2")
Venting_Slot_Length = 12.7;

// Venting slot width (6.35 for 1/4")
Venting_Slot_Width = 6.35;

/* [Fences] */
// Fence thickness, edge_guide only (3.175 for 1/8")
Fence_Thickness = 3.175;

// Fence height above the plate, edge_guide only (6.35 for 1/4")
Fence_Height = 6.35;

/* [Hidden] */
$fn = 128;

assert(Guide_Width > Venting_Slot_Width, "Guide_Width must exceed Venting_Slot_Width");
assert(Style != "three_slot" || Long_Slot_Length > Short_Slot_Length, "Long_Slot_Length must exceed Short_Slot_Length");
assert(Style != "three_slot" || Plate_Width > 2 * Guide_Width, "Plate_Width must exceed twice Guide_Width so both slot rows stay inside the plate");
assert(Style != "edge_guide" || Plate_Width - 2 * Fence_Thickness > Guide_Width, "Plate_Width minus twice Fence_Thickness must exceed Guide_Width");
assert(
  (Style == "three_slot" ? Long_Slot_Length : Short_Slot_Length) + Guide_Width + Venting_Slot_Width + 2 * Venting_Slot_Length < Plate_Length,
  "Plate_Length must be longer than the slots with their venting slots"
);

module KeyholeSlot(center_to_center) {
  hull() {
    translate([-center_to_center / 2, 0]) circle(d = Guide_Width);
    translate([center_to_center / 2, 0]) circle(d = Guide_Width);
  }

  hull() {
    x = (center_to_center + Guide_Width - Venting_Slot_Width) / 2 + Venting_Slot_Length;
    translate([-x, 0]) circle(d = Venting_Slot_Width);
    translate([x, 0]) circle(d = Venting_Slot_Width);
  }
}

module ThreeSlotPlate() {
  x = (Long_Slot_Length - Short_Slot_Length) / 2;

  difference() {
    square([Plate_Length, Plate_Width], center = true);
    translate([0, Plate_Width / 4]) KeyholeSlot(Long_Slot_Length);
    translate([-x, -Plate_Width / 4]) KeyholeSlot(Short_Slot_Length);
    translate([x, -Plate_Width / 4]) KeyholeSlot(Short_Slot_Length);
  }
}

module EdgeGuidePlate() {
  difference() {
    square([Plate_Length, Plate_Width], center = true);
    KeyholeSlot(Short_Slot_Length);
  }
}

module Fence(side) {
  translate([-Plate_Length / 2, side * (Plate_Width / 2 - Fence_Thickness / 2) - Fence_Thickness / 2, Plate_Thickness])
    cube([Plate_Length, Fence_Thickness, Fence_Height]);
}

if (Style == "three_slot") {
  linear_extrude(height = Plate_Thickness) ThreeSlotPlate();
} else {
  linear_extrude(height = Plate_Thickness) EdgeGuidePlate();
  Fence(1);
  Fence(-1);
}
