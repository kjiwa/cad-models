/**
 * Internal blade cavities, calibrated exit gates, finger scoop, and sight slots.
 */

// Returns true if the slot at index (0-based) is configured for plastic blades.
function slot_is_plastic(index) =
  (index < len(slot_pattern)) ? (slot_pattern[index] == "P" || slot_pattern[index] == "p") : false;

// Returns the slot type ("metal" or "plastic") for a given slot index.
function slot_type(index) =
  slot_is_plastic(index) ? "plastic" : "metal";

// Returns the calibrated exit gate height for a given slot index.
function slot_exit_height(index) =
  slot_is_plastic(index) ? plastic_exit_height : metal_exit_height;

// Returns the calibrated internal cavity depth for a given slot index.
function slot_chute_depth(index) =
  slot_is_plastic(index) ? effective_plastic_depth : effective_metal_depth;

// Returns the debossed front badge text for a given slot index.
function slot_badge_text(index) =
  slot_is_plastic(index) ? "PLASTIC" : "METAL";

// Generates the internal vertical chute cavity for a single slot.
module chute_cavity(
  x_center,
  w = chute_width,
  d = effective_metal_depth,
  h = dispenser_height,
  floor_t = floor_thickness,
  back_t = backplate_thickness,
  tower_d = tower_depth,
  front_w = front_wall_thickness
) {
  y_front_inner = back_t + tower_d - front_w;
  y_c = y_front_inner - d / 2;
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
  d = effective_metal_depth,
  floor_t = floor_thickness,
  back_t = backplate_thickness,
  tower_d = tower_depth,
  front_w = front_wall_thickness,
  shelf_ext = shelf_extension
) {
  y_front_inner = back_t + tower_d - front_w;
  y_start = y_front_inner - d;
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

// Generates the rounded finger scoop notch under the bottom blade for slide-out extraction.
module finger_scoop(
  x_center,
  chute_d = effective_metal_depth,
  scoop_w = grip_notch_width,
  scoop_d = grip_notch_depth,
  floor_t = floor_thickness,
  back_t = backplate_thickness,
  tower_d = tower_depth,
  front_w = front_wall_thickness,
  shelf_ext = shelf_extension
) {
  y_front = back_t + tower_d + shelf_ext + EPSILON;
  y_back = back_t + tower_d - front_w - chute_d;
  full_d = y_front - y_back;
  actual_scoop_d = (scoop_d > 0) ? scoop_d : full_d;
  r = min(3.0, scoop_w / 4);
  h_cut = floor_t + 2 * EPSILON;

  translate([x_center, y_front, -EPSILON]) {
    rotate([0, 0, 180]) {
      linear_extrude(height = h_cut) {
        hull() {
          translate([-scoop_w / 2, 0])
            square([scoop_w, EPSILON]);
          translate([-scoop_w / 2 + r, actual_scoop_d - r])
            circle(r = r);
          translate([scoop_w / 2 - r, actual_scoop_d - r])
            circle(r = r);
        }
      }
    }
  }
}

// Generates the front vertical sight slot with smooth bellmouth flared opening.
module sight_slot(
  x_center,
  slot_w = sight_slot_width,
  z_bottom = floor_thickness + metal_exit_height,
  z_end = sight_slot_z_end,
  flare_w = opening_flare_width,
  flare_h = opening_flare_height,
  back_t = backplate_thickness,
  tower_d = tower_depth,
  front_w = front_wall_thickness,
  shelf_ext = shelf_extension
) {
  if (enable_sight_slots && (z_end > z_bottom + slot_w)) {
    top_r = slot_w / 2;
    actual_flare_w = max(flare_w, slot_w + 2.0);
    actual_flare_h = max(flare_h, 4.0);
    y_start = back_t + tower_d - front_w - EPSILON;
    cut_depth = front_w + shelf_ext + 10.0;
    delta_w = (actual_flare_w - slot_w) / 2;
    steps = 40;

    translate([x_center, y_start, 0]) {
      rotate([-90, 0, 0]) {
        linear_extrude(height = cut_depth) {
          // Continuous 2D profile (in 2D space, Y corresponds to -Z in 3D):
          // 1. Right curve: tangent to horizontal ceiling at bottom, tangent to vertical slot at top
          pts_r_curve = [
            for (i = [0 : steps])
              let(
                a = (i / steps) * 90,
                x = (actual_flare_w / 2) - delta_w * sin(a),
                z = z_bottom + actual_flare_h * (1 - cos(a))
              )
              [x, -z]
          ];
          pts_r_straight = [[slot_w / 2, -(z_end - top_r)]];
          // 2. Top semi-circular arch
          pts_top = [
            for (a = [0 : 6 : 180])
              [top_r * cos(a), -((z_end - top_r) + top_r * sin(a))]
          ];
          pts_l_straight = [[-slot_w / 2, -(z_bottom + actual_flare_h)]];
          // 3. Left curve: tangent to vertical slot at top, tangent to horizontal ceiling at bottom
          pts_l_curve = [
            for (i = [steps : -1 : 0])
              let(
                a = (i / steps) * 90,
                x = (actual_flare_w / 2) - delta_w * sin(a),
                z = z_bottom + actual_flare_h * (1 - cos(a))
              )
              [-x, -z]
          ];
          // Extend cut down into exit gate to eliminate zero-thickness boundary facet
          pts_bottom_ext = [
            [-actual_flare_w / 2, -(floor_thickness - 1.0)],
            [actual_flare_w / 2, -(floor_thickness - 1.0)]
          ];

          polygon(points = concat(pts_r_curve, pts_r_straight, pts_top, pts_l_straight, pts_l_curve, pts_bottom_ext));
        }
      }
    }
  }
}

// Generates all internal cutouts, gates, finger notches, and funnels for one dispenser slot.
module slot_cutouts(index, x_center) {
  d = slot_chute_depth(index);
  exit_h = slot_exit_height(index);
  chute_cavity(x_center, d = d);
  exit_gate(x_center, exit_h, d = d);
  finger_scoop(x_center, chute_d = d);
  sight_slot(x_center, z_bottom = floor_thickness + exit_h);
  tower_top_funnel(x_center, chute_d = d);

  if (enable_badge_labels) {
    tower_debossed_text(x_center, slot_badge_text(index));
  }
}
