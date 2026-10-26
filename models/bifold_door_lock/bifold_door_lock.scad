include <BOSL2/std.scad>

/**
 * Lock that slips over the top of a bifold door pair to hold the doors together, with a front
 * knob for lifting it off. All dimensions are in millimeters.
 */

/* [Bifold Door] */
// Door thickness (36.5125 for 1-7/16")
Door_Thickness = 36.5125;

// Gap between the door top and the lock floor (3.175 for 1/8")
Door_Top_Gap_Width = 3.175;

/* [Lock] */
// Lock length along the door top (152.4 for 6")
Lock_Width = 152.4;

// Lock depth down the door faces (50.8 for 2")
Lock_Depth = 50.8;

// Thickness of each side wall (6.35 for 1/4")
Lock_Wall_Thickness = 6.35;

// Radius of the rounded lock edges (3.175 for 1/8")
Lock_Corner_Radius = 3.175;

// Width of the lead-in chamfer at the slot mouth (0 to disable)
Lead_In_Chamfer = 2;

/* [Knob] */
// Knob width (19.05 for 3/4")
Knob_Width = 19.05;

// Knob depth from the lock front (4.7625 for 3/16")
Knob_Depth = 4.7625;

/* [Hidden] */
$fn = 128;

body_size = [Lock_Width, Door_Thickness + 2 * Lock_Wall_Thickness, Lock_Depth + Door_Top_Gap_Width];
knob_rounding = min(Knob_Width, Knob_Depth) / 2;
knob_height = body_size.z - 2 * Lock_Corner_Radius;
knob_embed = 1;

assert(Lock_Corner_Radius * 2 <= min(body_size.y, body_size.z), "Lock_Corner_Radius must be at most half of the lock");
assert(Lead_In_Chamfer + Lock_Corner_Radius < Lock_Wall_Thickness, "Lead_In_Chamfer plus Lock_Corner_Radius must be less than Lock_Wall_Thickness");
assert(Door_Top_Gap_Width > 0, "Door_Top_Gap_Width must be positive");
assert(Knob_Width > 2 * knob_rounding, "Knob_Width must exceed Knob_Depth for the front groove");
assert(Knob_Width <= Lock_Width, "Knob_Width must not exceed Lock_Width");

module Lock() {
  slot_floor = -body_size.z / 2 + Door_Top_Gap_Width;
  slot_height = Lock_Depth + 1;
  diff()
    cuboid(body_size, rounding = Lock_Corner_Radius) {
      tag("remove") translate([0, 0, slot_floor + slot_height / 2])
          cuboid([Lock_Width + 2, Door_Thickness, slot_height]);
      tag("remove") translate([0, 0, body_size.z / 2 - Lead_In_Chamfer])
          prismoid(
            size1 = [Lock_Width + 2, Door_Thickness],
            size2 = [Lock_Width + 2, Door_Thickness + 2 * (Lead_In_Chamfer + 1)],
            h = Lead_In_Chamfer + 1, anchor = BOTTOM
          );
    }
}

module Knob() {
  groove_half_width = (Knob_Width - 2 * knob_rounding) / 2;
  groove_half_depth = knob_rounding * sqrt(2) / 2;
  diff()
    cuboid(
      [Knob_Width, Knob_Depth + knob_embed, knob_height],
      rounding = knob_rounding, edges = FRONT
    ) {
      tag("remove") translate([0, -(Knob_Depth + knob_embed) / 2, 0])
          linear_extrude(height = knob_height + 2, center = true)
            polygon([
              [-groove_half_width, 0], [0, -groove_half_depth],
              [groove_half_width, 0], [0, groove_half_depth],
            ]);
    }
}

Lock();
translate([0, -(body_size.y + Knob_Depth - knob_embed) / 2, 0]) Knob();
