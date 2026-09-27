/**
 * Internal blade cavities, calibrated exit gates, finger scoop, and sight slots.
 */

// Returns the slot type ("metal" or "plastic") for a given slot index.
function slot_type(index) =
  (index == 0) ? slot_0_type :
  (index == 1) ? slot_1_type :
  ((index % 2 == 0) ? slot_0_type : slot_1_type);

// Returns the calibrated exit gate height for a given slot index.
function slot_exit_height(index) =
  (slot_type(index) == "metal") ? metal_exit_height : plastic_exit_height;

// Returns the debossed front badge text for a given slot index.
function slot_badge_text(index) =
  (slot_type(index) == "metal") ? "METAL" : "PLASTIC";

// Generates the internal vertical chute cavity for a single slot.
module chute_cavity(
  x_center,
  w = chute_width,
  d = chute_depth,
  h = dispenser_height,
  floor_t = floor_thickness,
  back_t = backplate_thickness,
  rear_w = rear_wall_thickness
) {
  y_c = back_t + rear_w + d / 2;
  z_cavity = floor_t;
  h_cavity = h - floor_t + EPSILON;

  translate([x_center, y_c, z_cavity + h_cavity / 2])
    cube([w, d, h_cavity], center = true);
}

// Generates the calibrated bottom exit slot with a 45-degree ceiling bevel for clean bridging.
module exit_gate(
  x_center,
  exit_h,
  w = chute_width + 1.2,
  d = chute_depth,
  floor_t = floor_thickness,
  back_t = backplate_thickness,
  rear_w = rear_wall_thickness,
  front_w = front_wall_thickness,
  shelf_ext = shelf_extension
) {
  y_start = back_t + rear_w;
  total_gate_d = d + front_w + shelf_ext + 10.0;
  chamfer_h = min(1.0, exit_h * 0.4);

  translate([x_center, y_start, floor_t]) {
    // Primary exit gate slot
    translate([-w / 2, 0, 0])
      cube([w, total_gate_d, exit_h]);

    // Ceiling lead-in chamfer to eliminate 90-degree internal overhang drooping
    translate([-w / 2, 0, exit_h])
      rotate([45, 0, 0])
        cube([w, chamfer_h * sqrt(2), chamfer_h * sqrt(2)]);
  }
}

// Generates the rounded finger scoop notch under the bottom blade for pinch-grip extraction.
module finger_scoop(
  x_center,
  scoop_w = grip_notch_width,
  scoop_d = grip_notch_depth,
  floor_t = floor_thickness,
  back_t = backplate_thickness,
  tower_d = tower_depth,
  shelf_ext = shelf_extension
) {
  y_front = back_t + tower_d + shelf_ext + EPSILON;
  r = min(4.0, scoop_w / 4);

  translate([x_center, y_front, -EPSILON]) {
    rotate([0, 0, 180]) {
      linear_extrude(height = floor_t + 2 * EPSILON) {
        hull() {
          translate([-scoop_w / 2, 0])
            square([scoop_w, EPSILON]);
          translate([-scoop_w / 2 + r, scoop_d - r])
            circle(r = r);
          translate([scoop_w / 2 - r, scoop_d - r])
            circle(r = r);
        }
      }
    }
  }
}

// Generates the front vertical sight slot for inventory tracking and downward blade feed.
module sight_slot(
  x_center,
  slot_w = sight_slot_width,
  z_start = sight_slot_z_start,
  z_end = sight_slot_z_end,
  y_start = backplate_thickness + rear_wall_thickness + chute_depth - EPSILON,
  cut_depth = front_wall_thickness + shelf_extension + 10.0
) {
  if (enable_sight_slots && (z_end > z_start + slot_w)) {
    h = z_end - z_start;
    r = slot_w / 2;

    translate([x_center, y_start, z_start + h / 2]) {
      rotate([-90, 0, 0]) {
        linear_extrude(height = cut_depth) {
          hull() {
            translate([0, -h / 2]) square([slot_w, EPSILON], center = true);
            translate([0, h / 2 - r]) circle(r = r);
          }
        }
      }
    }
  }
}

// Generates all internal cutouts, gates, finger notches, and funnels for one dispenser slot.
module slot_cutouts(index, x_center) {
  chute_cavity(x_center);
  exit_gate(x_center, slot_exit_height(index));
  finger_scoop(x_center);
  sight_slot(x_center);
  tower_top_funnel(x_center);

  if (enable_badge_labels) {
    tower_debossed_text(x_center, slot_badge_text(index));
  }
}
