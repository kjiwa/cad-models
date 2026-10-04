/**
 * Angled battery slide bed with friction-relief channel and debossed text.
 */

// Generates the solid backing bed plate with rounded top corners.
module slide_bed_blank(width = Bed_Width, length = Rail_Length, thickness = Bed_Thickness, corner_radius = Bed_Corner_Radius) {
  r = min(corner_radius, width / 4);

  translate([0, thickness, 0]) {
    rotate([90, 0, 0]) {
      linear_extrude(height = thickness) {
        if (r > 0) {
          hull() {
            translate([-width / 2, 0])
              square([width, length - r]);
            translate([-width / 2 + r, length - r])
              circle(r = r);
            translate([width / 2 - r, length - r])
              circle(r = r);
          }
        } else {
          translate([-width / 2, 0])
            square([width, length]);
        }
      }
    }
  }
}

// Generates the recessed pocket cutting into the bed face to reduce contact friction.
module slide_bed_friction_relief(length = Rail_Length, thickness = Bed_Thickness, shelf_thickness = Shelf_Thickness) {
  relief_w = 30.0;
  relief_d = 1.5;
  relief_r = 4.0;
  relief_z_start = shelf_thickness + 4.0;
  relief_z_end = length - 8.0;
  relief_h = relief_z_end - relief_z_start;

  translate([0, thickness - relief_d, relief_z_start + relief_h / 2]) {
    rotate([-90, 0, 0]) {
      linear_extrude(height = relief_d + EPSILON) {
        hull() {
          for (dx = [-relief_w / 2 + relief_r, relief_w / 2 - relief_r]) {
            for (dz = [-relief_h / 2 + relief_r, relief_h / 2 - relief_r]) {
              translate([dx, dz]) circle(r = relief_r);
            }
          }
        }
      }
    }
  }
}

// Generates debossed model text cutter in the relief pocket.
module slide_bed_debossed_text(text_str = "40V", length = Rail_Length, thickness = Bed_Thickness) {
  relief_d = 1.5;
  relief_z_end = length - 8.0;

  translate([0, thickness - relief_d + EPSILON, relief_z_end - 12.0]) {
    rotate([90, 0, 0]) {
      mirror([1, 0, 0]) {
        linear_extrude(height = 0.6 + EPSILON) {
          text(text_str, size = 9.0, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
        }
      }
    }
  }
}

// Orchestrates the slide bed plate minus friction relief channel and debossed text.
module slide_bed() {
  difference() {
    slide_bed_blank();
    slide_bed_friction_relief();
    slide_bed_debossed_text();
  }
}
