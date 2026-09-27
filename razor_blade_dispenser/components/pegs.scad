/**
 * Pegboard mounting hooks and stabilizing pins for razor blade dispenser.
 */

include <pegboard/pegs.scad>

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

// Generates all pegboard hooks and pins across columns for a single dispenser slot.
module slot_pegs(x_center, max_x) {
  for (k = [-(slot_spacing_pegs - 1) / 2 : (slot_spacing_pegs - 1) / 2]) {
    slot_pegs_column(x_center + k * peg_hole_spacing, (k == 0), max_x);
  }
}

// Orchestrates mounting hooks and pins across all slots and positions inspection labels.
module mounting_pegs() {
  max_x_peg = total_width / 2 - pin_diameter / 2 - 1.0;

  for (i = [0 : dispenser_count - 1]) {
    x_c = ((dispenser_count - 1) / 2 - i) * slot_spacing;
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
