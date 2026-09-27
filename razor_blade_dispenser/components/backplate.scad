/**
 * Mounting backplate with screw holes and weight-relief windows.
 */

// Generates the solid rectangular backplate slab with rounded top corners.
module backplate_blank(width = total_width, height = backplate_height, thickness = backplate_thickness, corner_radius = backplate_corner_radius) {
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

// Generates the 45-degree top-rear chamfer cutter for pegboard swing-in clearance.
module backplate_tilt_chamfer(width = total_width, chamfer = tilt_chamfer) {
  translate([0, 0, z_plate_top])
    rotate([45, 0, 0])
      cube([width + 2 * EPSILON, chamfer * sqrt(2), chamfer * sqrt(2)], center = true);
}

// Generates a single countersunk screw clearance through-hole.
module countersunk_screw_hole(screw_d = screw_hole_diameter, cs_d = countersink_diameter, thickness = backplate_thickness) {
  rotate([-90, 0, 0]) {
    cylinder(d = screw_d, h = thickness + 2 * EPSILON);
    translate([0, 0, thickness - (cs_d - screw_d) / 2])
      cylinder(d1 = screw_d, d2 = cs_d, h = (cs_d - screw_d) / 2 + EPSILON);
  }
}

// Generates countersunk screw clearance holes centered above each dispenser slot.
module backplate_screw_holes(count = dispenser_count, spacing = slot_spacing, screw_z = z_top_peg - peg_hole_spacing, screw_d = screw_hole_diameter, cs_d = countersink_diameter, thickness = backplate_thickness) {
  for (i = [0 : count - 1]) {
    x_c = (i - (count - 1) / 2) * spacing;
    translate([x_c, -EPSILON, screw_z])
      countersunk_screw_hole(screw_d, cs_d, thickness);
  }
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
module backplate_relief_windows(count = dispenser_count, spacing = slot_spacing, z_center = (z_plate_top + z_plate_bottom) / 2, thickness = backplate_thickness, height = backplate_height) {
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

// Orchestrates the backplate slab minus tilt chamfer, screw holes, and relief windows.
module backplate() {
  difference() {
    backplate_blank();
    backplate_tilt_chamfer();

    if (include_screw_holes) {
      backplate_screw_holes();
    }

    backplate_relief_windows();
  }
}
