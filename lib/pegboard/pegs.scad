/**
 * Shared pegboard mounting primitives for standard 1/4" pegboard.
 */

DEFAULT_PIN_DIAMETER = 5.7;
DEFAULT_PEGBOARD_THICKNESS = 6.35;
DEFAULT_HOOK_RISE = 3.5;
DEFAULT_BACKPLATE_THICKNESS = 5.0;

// Generates an upper retention hook with contoured bend, heel relief, and lead-in chamfer.
module pegboard_upper_hook(
  pin_d = DEFAULT_PIN_DIAMETER,
  board_t = DEFAULT_PEGBOARD_THICKNESS,
  rise = DEFAULT_HOOK_RISE,
  backplate_t = DEFAULT_BACKPLATE_THICKNESS,
  eps = 0.02
) {
  shank_len = board_t + 0.8;
  hook_t = 3.0;
  root_chamfer = 0.35;
  heel_chamfer = 2.4;
  tab_lead = 1.2;

  rotate([90, 0, 0]) {
    translate([0, 0, -backplate_t])
      cylinder(d = pin_d, h = backplate_t + eps);
    cylinder(d1 = pin_d + 2 * root_chamfer, d2 = pin_d, h = root_chamfer);
    cylinder(d = pin_d, h = shank_len);
  }

  translate([0, -shank_len, 0]) {
    difference() {
      hull() {
        rotate([90, 0, 0])
          cylinder(d = pin_d, h = hook_t);
        translate([0, -hook_t / 2, rise])
          rotate([0, 90, 0])
            cylinder(d = hook_t, h = pin_d * 0.85, center = true);
      }

      // Bottom-rear heel relief: eliminates diagonal bulk that binds when tilted
      translate([0, -hook_t, -pin_d / 2])
        rotate([-45, 0, 0])
          cube([pin_d + 2, heel_chamfer * sqrt(2), heel_chamfer * sqrt(2)], center = true);

      // Tab front lead-in: guides the tab smoothly into the hole during tilted entry
      translate([0, 0, rise + hook_t / 2])
        rotate([45, 0, 0])
          cube([pin_d + 2, tab_lead * sqrt(2), tab_lead * sqrt(2)], center = true);
    }
  }
}

// Generates a lower stabilizing pin with a lead-in insertion chamfer.
module pegboard_lower_pin(
  pin_d = DEFAULT_PIN_DIAMETER,
  board_t = DEFAULT_PEGBOARD_THICKNESS,
  chamfer = 1.2,
  backplate_t = DEFAULT_BACKPLATE_THICKNESS,
  eps = 0.02
) {
  len = board_t - 0.8;
  body_len = max(len - chamfer, 1.0);
  root_chamfer = 0.35;

  rotate([90, 0, 0]) {
    translate([0, 0, -backplate_t])
      cylinder(d = pin_d, h = backplate_t + eps);
    cylinder(d1 = pin_d + 2 * root_chamfer, d2 = pin_d, h = root_chamfer);
    cylinder(d = pin_d, h = body_len);
    translate([0, 0, body_len])
      cylinder(d1 = pin_d, d2 = pin_d - 2 * chamfer, h = chamfer);
  }
}
