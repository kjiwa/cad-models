/**
 * Battery resting shelf and build-plate transition base foot.
 */

// Generates the bottom resting shelf with rounded front corners supporting battery weight.
module bottom_shelf(width = Bed_Width, depth = Shelf_Depth, thickness = Shelf_Thickness, bed_thick = Bed_Thickness, corner_radius = Shelf_Corner_Radius) {
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
    translate([0, Backplate_Thickness, z_shelf]) {
      rotate([-Tilt_Angle, 0, 0]) {
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
          translate([-w / 2 + r, Backplate_Thickness]) circle(r = r);
          translate([w / 2 - r, Backplate_Thickness]) circle(r = r);
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
  w = Bed_Width;
  r = min(Shelf_Corner_Radius, Shelf_Depth / 2, Bed_Width / 4);
  d = Shelf_Depth;
  bt = Bed_Thickness;
  y_front = Backplate_Thickness + (bt + d) * cos(Tilt_Angle);

  translate([x_center, 0, 0]) {
    difference() {
      cradle_base_foot_hull(w, r, bt, d, y_front);
      cradle_base_foot_roundover(w, y_front, Toe_Radius);

      // Clean cuts to ensure exact bounds
      translate([-w, -20, -50])
        cube([2 * w, 100, 50]);
      translate([-w, -50, -10])
        cube([2 * w, 50 + Backplate_Thickness, 100]);
    }
  }
}
