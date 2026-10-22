/**
 * Mounting backplate with screw holes and weight-relief windows.
 */

include <pegboard/backplate.scad>

// Generates the solid rectangular backplate slab with rounded top corners.
module backplate_blank(width = total_width, height = backplate_height, thickness = Backplate_Thickness, corner_radius = Backplate_Corner_Radius) {
  z_center = (z_plate_top + z_plate_bottom) / 2;
  r = min(corner_radius, height / 4, width / 4);

  translate([0, thickness, z_center]) {
    rotate([90, 0, 0]) {
      linear_extrude(height = thickness) {
        if (r > 0) {
          hull() {
            translate([-width / 2, -height / 2])
              square([width, EPSILON]);
            translate([-width / 2 + r, height / 2 - r])
              circle(r = r);
            translate([width / 2 - r, height / 2 - r])
              circle(r = r);
          }
        } else {
          square([width, height], center = true);
        }
      }
    }
  }
}

// Generates countersunk screw clearance holes centered above each battery slot.
module backplate_screw_holes(count = Battery_Count, spacing = slot_spacing, screw_z = z_top_peg - Hole_Spacing, screw_d = Screw_Hole_Diameter, cs_d = Countersink_Diameter, thickness = Backplate_Thickness) {
  for (i = [0 : count - 1]) {
    x_c = (i - (count - 1) / 2) * spacing;
    translate([x_c, 0, screw_z])
      countersunk_screw_hole(screw_d, cs_d, thickness);
  }
}

// Generates stadium-shaped weight-relief through-holes between adjacent battery slots.
module backplate_relief_windows(count = Battery_Count, spacing = slot_spacing, z_center = (z_plate_top + z_plate_bottom) / 2, thickness = Backplate_Thickness, height = backplate_height) {
  if (count > 1) {
    win_w = 14.0;
    win_h = height - 24.0;

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

// Orchestrates the backplate perimeter slab minus tilt chamfer, screw holes, and relief windows.
module backplate() {
  difference() {
    backplate_blank();
    backplate_tilt_chamfer(total_width, Insertion_Chamfer, z_plate_top);

    if (Include_Screw_Holes) {
      backplate_screw_holes();
    }

    backplate_relief_windows();
  }
}
