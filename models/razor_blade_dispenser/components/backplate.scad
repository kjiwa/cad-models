/**
 * Mounting backplate with weight-relief windows and tilt insertion chamfer.
 */

include <pegboard/backplate.scad>

// Generates the solid rectangular backplate slab with flush side flanks matching the tower body.
module backplate_blank(width = total_width, height = backplate_height, thickness = Backplate_Thickness) {
  z_center = (z_plate_top + z_plate_bottom) / 2;

  translate([0, thickness, z_center]) {
    rotate([90, 0, 0]) {
      linear_extrude(height = thickness) {
        square([width, height], center = true);
      }
    }
  }
}

// Generates countersunk screw clearance holes in backplate inter-tower columns.
module backplate_screw_holes(
  count = actual_dispenser_count,
  spacing = slot_spacing,
  thickness = Backplate_Thickness,
  screw_d = Screw_Hole_Diameter,
  cs_d = Countersink_Diameter,
  z_top = z_plate_top,
  z_bottom = z_plate_bottom
) {
  if (Include_Screw_Holes && count > 1) {
    for (i = [0 : count - 2]) {
      x_win = (i + 0.5 - (count - 1) / 2) * spacing;
      translate([x_win, 0, z_top - 10.0])
        countersunk_screw_hole(screw_d, cs_d, thickness);
      translate([x_win, 0, z_bottom + 15.0])
        countersunk_screw_hole(screw_d, cs_d, thickness);
    }
  }
}

// Generates stadium-shaped weight-relief through-holes between adjacent dispenser slots.
module backplate_relief_windows(count = actual_dispenser_count, spacing = slot_spacing, thickness = Backplate_Thickness, height = backplate_height) {
  if (count > 1) {
    win_w = 12.0;
    margin_top = Include_Screw_Holes ? 20.0 : 15.0;
    margin_bot = Include_Screw_Holes ? 24.0 : 15.0;
    win_h = max(height - margin_top - margin_bot, 10.0);
    z_win_center = (height - margin_top + margin_bot) / 2;

    for (i = [0 : count - 2]) {
      x_win = (i + 0.5 - (count - 1) / 2) * spacing;
      translate([x_win, -EPSILON, z_win_center]) {
        rotate([-90, 0, 0]) {
          linear_extrude(height = thickness + 2 * EPSILON) {
            stadium_cutout_2d(win_w, win_h);
          }
        }
      }
    }
  }
}

// Orchestrates the backplate slab minus tilt chamfer, relief windows, and screw holes.
module backplate() {
  difference() {
    backplate_blank();
    backplate_tilt_chamfer(total_width, Insertion_Chamfer, z_plate_top);
    backplate_relief_windows();
    backplate_screw_holes();
  }
}

