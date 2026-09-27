/**
 * Mounting backplate with weight-relief windows and tilt insertion chamfer.
 */

// Generates the solid rectangular backplate slab with flush side flanks matching the tower body.
module backplate_blank(width = total_width, height = backplate_height, thickness = backplate_thickness) {
  z_center = (z_plate_top + z_plate_bottom) / 2;

  translate([0, thickness, z_center]) {
    rotate([90, 0, 0]) {
      linear_extrude(height = thickness) {
        square([width, height], center = true);
      }
    }
  }
}

// Generates the 45-degree top-rear chamfer cutter for pegboard swing-in clearance.
module backplate_tilt_chamfer(width = total_width, chamfer = tilt_chamfer) {
  translate([0, 0, z_plate_top])
    rotate([45, 0, 0])
      cube([width + 2 * EPSILON, chamfer * sqrt(2), chamfer * sqrt(2)], center = true);
}

// Generates a 2D rounded stadium profile centered at the origin.
module stadium_cutout_2d(width, height) {
  r = width / 2;
  hull() {
    translate([0, -height / 2 + r]) circle(r = r);
    translate([0, height / 2 - r]) circle(r = r);
  }
}

// Generates stadium-shaped weight-relief through-holes between adjacent dispenser slots.
module backplate_relief_windows(count = actual_dispenser_count, spacing = slot_spacing, z_center = (z_plate_top + z_plate_bottom) / 2, thickness = backplate_thickness, height = backplate_height) {
  if (count > 1) {
    win_w = 12.0;
    win_h = max(height - 30.0, 10.0);

    for (i = [0 : count - 2]) {
      x_win = (i + 0.5 - (count - 1) / 2) * spacing;
      translate([x_win, -EPSILON, z_center]) {
        rotate([-90, 0, 0]) {
          linear_extrude(height = thickness + 2 * EPSILON) {
            stadium_cutout_2d(win_w, win_h);
          }
        }
      }
    }
  }
}

// Orchestrates the backplate slab minus tilt chamfer and relief windows.
module backplate() {
  difference() {
    backplate_blank();
    backplate_tilt_chamfer();
    backplate_relief_windows();
  }
}

