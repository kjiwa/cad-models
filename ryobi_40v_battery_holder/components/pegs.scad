/**
 * Pegboard mounting hooks and stabilizing pins.
 */

// Generates an upper retention hook with an internal chamfered root and rear spine.
module pegboard_upper_hook(pin_d = pin_diameter, board_t = pegboard_thickness, rise = hook_rise) {
  shank_len = board_t + 0.8;
  hook_t = 3.2;
  root_chamfer = 0.35;

  rotate([90, 0, 0]) {
    translate([0, 0, -backplate_thickness])
      cylinder(d = pin_d, h = backplate_thickness + EPSILON);
    cylinder(d1 = pin_d + 2 * root_chamfer, d2 = pin_d, h = root_chamfer);
    cylinder(d = pin_d, h = shank_len);
  }

  translate([0, -shank_len, 0]) {
    hull() {
      rotate([90, 0, 0])
        cylinder(d = pin_d, h = hook_t);
      translate([0, -hook_t / 2, rise])
        rotate([0, 90, 0])
          cylinder(d = hook_t, h = pin_d * 0.8, center = true);
    }
    // Reinforcing spine on the back of the hook tab
    translate([0, -hook_t, 0]) {
      rotate([90, 0, 90]) {
        linear_extrude(height = pin_d * 0.7, center = true) {
          polygon(points = [
            [0, 0],
            [0, rise * 0.75],
            [-rise * 0.5, 0]
          ]);
        }
      }
    }
  }
}

// Generates a lower stabilizing pin with a lead-in insertion chamfer.
module pegboard_lower_pin(pin_d = pin_diameter, board_t = pegboard_thickness, chamfer = 1.2) {
  len = board_t - 0.8;
  body_len = max(len - chamfer, 1.0);
  root_chamfer = 0.35;

  rotate([90, 0, 0]) {
    translate([0, 0, -backplate_thickness])
      cylinder(d = pin_d, h = backplate_thickness + EPSILON);
    cylinder(d1 = pin_d + 2 * root_chamfer, d2 = pin_d, h = root_chamfer);
    cylinder(d = pin_d, h = body_len);
    translate([0, 0, body_len])
      cylinder(d1 = pin_d, d2 = pin_d - 2 * chamfer, h = chamfer);
  }
}

// Generates stabilizing pins at a single column position according to the selected pattern.
module lower_pins_at_pos(x_pos, is_center_col) {
  if (stabilizing_peg_pattern == "all" || stabilizing_peg_pattern == "span_1") {
    if (!include_screw_holes || !is_center_col) {
      translate([x_pos, 0, z_top_peg - peg_hole_spacing])
        pegboard_lower_pin();
    }
  }
  if (stabilizing_peg_pattern == "all" || stabilizing_peg_pattern == "span_2") {
    translate([x_pos, 0, z_top_peg - 2 * peg_hole_spacing])
      pegboard_lower_pin();
  }
}

// Generates upper hook and lower pins for one pegboard column if within plate bounds.
module slot_pegs_column(x_pos, is_center_col, max_x) {
  if (abs(x_pos) <= max_x) {
    if (is_visible("upper_hooks")) {
      color("Crimson")
        translate([x_pos, 0, z_top_peg])
          pegboard_upper_hook();
    }

    if (is_visible("lower_pins")) {
      color("Tomato")
        lower_pins_at_pos(x_pos, is_center_col);
    }
  }
}

// Generates all pegboard hooks and pins across columns for a single battery slot.
module slot_pegs(x_center, max_x) {
  for (k = [-(slot_spacing_pegs - 1) / 2 : (slot_spacing_pegs - 1) / 2]) {
    slot_pegs_column(x_center + k * peg_hole_spacing, (k == 0), max_x);
  }
}

// Orchestrates mounting hooks and pins across all slots and positions inspection labels.
module mounting_pegs() {
  max_x_peg = total_width / 2 - pin_diameter / 2 - 2.0;

  for (i = [0 : battery_count - 1]) {
    x_c = (i - (battery_count - 1) / 2) * slot_spacing;
    slot_pegs(x_c, max_x_peg);
  }

  if (is_visible("upper_hooks")) {
    component_label("Upper Hooks", [0, -pegboard_thickness - 6, z_top_peg + hook_rise + 4], [90, 0, 0]);
  }
  if (is_visible("lower_pins")) {
    z_label_pin = (stabilizing_peg_pattern == "span_1") ? (z_top_peg - peg_hole_spacing - 4) : (z_top_peg - 2 * peg_hole_spacing - 4);
    component_label("Lower Pins", [0, -pegboard_thickness - 6, z_label_pin], [90, 0, 0]);
  }
}
