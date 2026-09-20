/**
 * Battery resting shelf and build-plate transition base foot.
 */

// Generates the bottom resting shelf with rounded front corners supporting battery weight.
module bottom_shelf(width = bed_width, depth = bottom_shelf_depth, thickness = bottom_shelf_thickness, bed_thick = bed_thickness, corner_radius = shelf_corner_radius) {
  r = min(corner_radius, depth / 2, width / 4);

  translate([0, bed_thick, 0]) {
    linear_extrude(height = thickness) {
      if (r > 0) {
        hull() {
          translate([-width / 2, 0])
            square([width, depth - r]);
          translate([-width / 2 + r, depth - r])
            circle(r = r);
          translate([width / 2 - r, depth - r])
            circle(r = r);
        }
      } else {
        translate([-width / 2, 0])
          square([width, depth]);
      }
    }
  }
}

// Generates the lofted transition volume connecting the tilted cradle to the build plate.
module cradle_base_foot_hull(w, r, bt, d, y_front) {
  hull() {
    translate([0, backplate_thickness, z_shelf]) {
      rotate([-tilt_angle, 0, 0]) {
        linear_extrude(height = 0.2) {
          hull() {
            translate([-w / 2 + r, 0]) circle(r = r);
            translate([w / 2 - r, 0]) circle(r = r);
            translate([-w / 2 + r, bt + d - r]) circle(r = r);
            translate([w / 2 - r, bt + d - r]) circle(r = r);
          }
        }
      }
    }

    translate([0, 0, 0]) {
      linear_extrude(height = 0.2) {
        hull() {
          translate([-w / 2 + r, backplate_thickness]) circle(r = r);
          translate([w / 2 - r, backplate_thickness]) circle(r = r);
          translate([-w / 2 + r, y_front - r]) circle(r = r);
          translate([w / 2 - r, y_front - r]) circle(r = r);
        }
      }
    }
  }
}

// Generates the front bottom chamfer cutter at the build plate edge.
module cradle_base_foot_roundover(w, y_front, roundover) {
  if (roundover > 0) {
    translate([0, y_front, 0]) {
      rotate([45, 0, 0])
        cube([w + 2 * EPSILON, roundover * sqrt(2), roundover * sqrt(2)], center = true);
    }
  }
}

// Generates the solid base foot supporting the cradle flush with the build plate and backplate.
module cradle_base_foot(x_center) {
  w = bed_width;
  r = min(shelf_corner_radius, bottom_shelf_depth / 2, bed_width / 4);
  d = bottom_shelf_depth;
  bt = bed_thickness;
  y_front = backplate_thickness + (bt + d) * cos(tilt_angle);

  translate([x_center, 0, 0]) {
    difference() {
      cradle_base_foot_hull(w, r, bt, d, y_front);
      cradle_base_foot_roundover(w, y_front, toe_roundover);

      // Clean cuts to ensure exact bounds
      translate([-w, -20, -50])
        cube([2 * w, 100, 50]);
      translate([-w, -50, -10])
        cube([2 * w, 50 + backplate_thickness, 100]);
    }
  }
}
