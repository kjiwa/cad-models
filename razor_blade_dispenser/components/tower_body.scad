/**
 * Dispenser tower body outer solid geometry and debossed identification text.
 */

// Generates the main solid dispenser body with filleted exterior front corners.
module tower_block_blank(
  width = total_width,
  depth = tower_depth,
  height = dispenser_height,
  back_t = backplate_thickness,
  corner_r = tower_corner_radius
) {
  r = min(corner_r, depth / 4, width / 4);

  translate([0, back_t, 0]) {
    linear_extrude(height = height) {
      if (r > 0) {
        hull() {
          translate([-width / 2, 0])
            square([width, EPSILON]);
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

// Generates the extended front retrieval shelf with rounded front corners.
module tower_front_shelf(
  width = total_width,
  depth = tower_depth,
  shelf_ext = shelf_extension,
  shelf_h = floor_thickness,
  back_t = backplate_thickness,
  corner_r = tower_corner_radius
) {
  if (shelf_ext > 0) {
    r = min(corner_r, shelf_ext, width / 4);
    total_d = depth + shelf_ext;

    translate([0, back_t, 0]) {
      linear_extrude(height = shelf_h) {
        if (r > 0) {
          hull() {
            translate([-width / 2, 0])
              square([width, EPSILON]);
            translate([-width / 2 + r, total_d - r])
              circle(r = r);
            translate([width / 2 - r, total_d - r])
              circle(r = r);
          }
        } else {
          translate([-width / 2, 0])
            square([width, total_d]);
        }
      }
    }
  }
}

// Generates the top lead-in funnel bevel cutter for drop-in loading.
module tower_top_funnel(x_center, chute_w = chute_width, chute_d = chute_depth, back_t = backplate_thickness, rear_w = rear_wall_thickness, lead = top_funnel_lead) {
  y_c = back_t + rear_w + chute_d / 2;
  z_top = dispenser_height;

  translate([x_center, y_c, z_top - lead + EPSILON]) {
    hull() {
      translate([0, 0, lead])
        cube([chute_w + 2 * lead, chute_d + 2 * lead, 2 * EPSILON], center = true);
      translate([0, 0, 0])
        cube([chute_w, chute_d, 2 * EPSILON], center = true);
    }
  }
}

// Generates debossed identification text on the front face above the exit gate.
module tower_debossed_text(
  x_center,
  label_text,
  y_front = backplate_thickness + tower_depth,
  z_pos = badge_z_position,
  text_sz = badge_text_size,
  deboss_d = badge_deboss_depth
) {
  translate([x_center, y_front + EPSILON, z_pos]) {
    rotate([90, 0, 0]) {
      mirror([1, 0, 0]) {
        linear_extrude(height = deboss_d + 2 * EPSILON) {
          text(label_text, size = text_sz, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
        }
      }
    }
  }
}
