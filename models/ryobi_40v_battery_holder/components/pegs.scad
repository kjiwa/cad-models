/**
 * Pegboard mounting hooks and stabilizing pins.
 */

include <pegboard/pegs.scad>

// Lowest pin row that still fits on the plate.
function lowest_pin_row() = max(floor((z_top_peg - Pin_Diameter / 2 - 2.0) / Hole_Spacing), 1);

// Generates stabilizing pins at a single column position according to the selected pattern.
module lower_pins_at_pos(x_pos, is_center_col) {
  skip = (Include_Screw_Holes && is_center_col) ? [1] : [];
  for (k = pegboard_pin_rows(Stabilizing_Pin_Pattern, lowest_pin_row(), skip)) {
    translate([x_pos, 0, z_top_peg - k * Hole_Spacing])
      pegboard_lower_pin(pin_d = Pin_Diameter, board_t = Pegboard_Thickness, backplate_t = Backplate_Thickness);
  }
}

// Generates upper hook and lower pins for one pegboard column if within plate bounds.
module slot_pegs_column(x_pos, is_center_col, max_x) {
  if (abs(x_pos) <= max_x) {
    if (is_visible("retention_hooks")) {
      color("Crimson")
        translate([x_pos, 0, z_top_peg])
          pegboard_upper_hook(pin_d = Pin_Diameter, board_t = Pegboard_Thickness, rise = Retention_Hook_Rise, backplate_t = Backplate_Thickness);
    }

    if (is_visible("stabilizing_pins")) {
      color("Tomato")
        lower_pins_at_pos(x_pos, is_center_col);
    }
  }
}

// Generates all pegboard hooks and pins across columns for a single battery slot.
module slot_pegs(x_center, max_x) {
  for (k = [-(Slot_Spacing_Count - 1) / 2 : (Slot_Spacing_Count - 1) / 2]) {
    slot_pegs_column(x_center + k * Hole_Spacing, (k == 0), max_x);
  }
}

// Orchestrates mounting hooks and pins across all slots and positions inspection labels.
module mounting_pegs() {
  max_x_peg = total_width / 2 - Pin_Diameter / 2 - 2.0;

  for (i = [0 : Battery_Count - 1]) {
    x_c = (i - (Battery_Count - 1) / 2) * slot_spacing;
    slot_pegs(x_c, max_x_peg);
  }

  if (is_visible("retention_hooks")) {
    component_label("Retention Hooks", [0, -Pegboard_Thickness - 6, z_top_peg + Retention_Hook_Rise + 4], [90, 0, 0]);
  }
  pin_rows = pegboard_pin_rows(Stabilizing_Pin_Pattern, lowest_pin_row());
  if (is_visible("stabilizing_pins") && len(pin_rows) > 0) {
    z_label_pin = z_top_peg - max(pin_rows) * Hole_Spacing - 4;
    component_label("Stabilizing Pins", [0, -Pegboard_Thickness - 6, z_label_pin], [90, 0, 0]);
  }
}
