/**
 * Router template for hanging slots (keyholes) in frames and other workpieces.
 *
 * Two styles share the slot geometry. "three_slot" is a flat plate that lines up with
 * a frame corner and routes a long slot and two short slots, all level. "edge_guide" is
 * a narrow plate with side fences that straddles a workpiece and routes one slot, short
 * or long. Each slot is a guide-bushing channel with a narrower venting slot extending
 * past both ends so chips can escape. V-notches in the plate edge mark each slot's
 * centre and both bushing-stop ends for alignment with pencil marks. All dimensions are
 * in millimeters.
 */

/* [Style] */
// Template layout
Style = "three_slot"; // [three_slot: Three Slots, edge_guide: Single Slot With Side Fences]

/* [Plate] */
// Plate width along the slots (X) (228.6 for 9" three_slot, 152.4 for 6" edge_guide)
Plate_Width = 228.6;

// Plate depth across the slots (Y), three_slot only (76.2 for 3")
Plate_Depth = 76.2;

// Plate thickness, which sets the guide bushing engagement (6.35 for 1/4")
Plate_Thickness = 6.35;

// Depth of the 90 degree alignment notches at each slot center and bushing-stop end (0 to disable)
Mark_Depth = 2.38125;

/* [Slots] */
// Guide channel width, the guide bushing diameter plus clearance (16.66875 for 21/32" around a 5/8" bushing)
Guide_Width = 16.66875;

// Center-to-center length of the short slot (31.75 for 1-1/4")
Short_Slot_Length = 31.75;

// Center-to-center length of the long slot (139.7 for 5-1/2")
Long_Slot_Length = 139.7;

// Slot routed by edge_guide
Fenced_Slot = "short"; // [short: Short Slot, long: Long Slot]

/* [Venting Slots] */
// Length the venting slot extends past each end of the guide channel (12.7 for 1/2")
Venting_Slot_Length = 12.7;

// Venting slot width (6.35 for 1/4")
Venting_Slot_Width = 6.35;

/* [Fences] */
// Width of the workpiece the fences straddle plus clearance, edge_guide only (31.75 for 1-1/4")
Workpiece_Width = 31.75;

// Fence thickness, edge_guide only (3.175 for 1/8")
Fence_Thickness = 3.175;

// Fence height above the plate, edge_guide only (6.35 for 1/4")
Fence_Height = 6.35;

/* [Hidden] */
$fn = 128;

corner_radius = 3.175;
epsilon = 0.01;
fenced_length = Fenced_Slot == "long" ? Long_Slot_Length : Short_Slot_Length;
plate_depth = Style == "three_slot" ? Plate_Depth : Workpiece_Width + 2 * Fence_Thickness;
slot_row_offset = Style == "three_slot" ? plate_depth / 4 : 0;
mark_limit = plate_depth / 2 - slot_row_offset - Guide_Width / 2;

assert(Style == "three_slot" || Style == "edge_guide", "Style must be three_slot or edge_guide");
assert(Fenced_Slot == "short" || Fenced_Slot == "long", "Fenced_Slot must be short or long");
assert(Guide_Width > Venting_Slot_Width, "Guide_Width must exceed Venting_Slot_Width");
assert(Long_Slot_Length > Short_Slot_Length, "Long_Slot_Length must exceed Short_Slot_Length");
assert(Style != "three_slot" || Plate_Depth > 2 * Guide_Width, "Plate_Depth must exceed twice Guide_Width so both slot rows stay inside the plate");
assert(Style != "edge_guide" || Workpiece_Width > Guide_Width, "Workpiece_Width must exceed Guide_Width");
assert(Mark_Depth >= 0 && Mark_Depth < mark_limit, "Mark_Depth must be under the distance from the plate edge to the nearest guide channel");
assert(Style != "edge_guide" || Mark_Depth < Fence_Thickness, "Mark_Depth must be less than Fence_Thickness so each notch stops inside the fence");
assert(2 * corner_radius < plate_depth, "Plate depth must exceed twice the corner radius");
assert(
  (Style == "three_slot" ? Long_Slot_Length : fenced_length) + Guide_Width + Venting_Slot_Width + 2 * Venting_Slot_Length < Plate_Width,
  "Plate_Width must be longer than the slots with their venting slots"
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

// 90 degree V-notch in the plate edge at side (+1 or -1), apex pointing at the plate center
module EdgeNotch(x, side) {
  e = epsilon;
  y = side * plate_depth / 2;
  polygon([[x - Mark_Depth - e, y + side * e], [x + Mark_Depth + e, y + side * e], [x, y - side * Mark_Depth]]);
}

module SlotMarks(center_x, length, sides) {
  for (side = sides, x = [-length / 2, 0, length / 2]) EdgeNotch(center_x + x, side);
}

module Outline() {
  offset(r = corner_radius) square([Plate_Width - 2 * corner_radius, plate_depth - 2 * corner_radius], center = true);
}

module ThreeSlotPlate() {
  x = (Long_Slot_Length - Short_Slot_Length) / 2;

  difference() {
    Outline();
    translate([0, plate_depth / 4]) KeyholeSlot(Long_Slot_Length);
    translate([-x, -plate_depth / 4]) KeyholeSlot(Short_Slot_Length);
    translate([x, -plate_depth / 4]) KeyholeSlot(Short_Slot_Length);
    if (Mark_Depth > 0) {
      SlotMarks(0, Long_Slot_Length, [1]);
      SlotMarks(-x, Short_Slot_Length, [-1]);
      SlotMarks(x, Short_Slot_Length, [-1]);
    }
  }
}

module EdgeGuidePlate() {
  difference() {
    Outline();
    KeyholeSlot(fenced_length);
    if (Mark_Depth > 0) SlotMarks(0, fenced_length, [1, -1]);
  }
}

module FenceStrips() {
  difference() {
    square([Plate_Width, plate_depth], center = true);
    square([Plate_Width + 2 * epsilon, Workpiece_Width], center = true);
  }
}

if (Style == "three_slot") {
  linear_extrude(height = Plate_Thickness) ThreeSlotPlate();
} else {
  linear_extrude(height = Plate_Thickness) EdgeGuidePlate();
  linear_extrude(height = Plate_Thickness + Fence_Height) intersection() {
    EdgeGuidePlate();
    FenceStrips();
  }
}
