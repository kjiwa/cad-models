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
module tower_top_funnel(
  x_center,
  chute_w = chute_width,
  chute_d = effective_metal_depth,
  back_t = backplate_thickness,
  tower_d = tower_depth,
  front_w = front_wall_thickness,
  lead = top_funnel_lead
) {
  y_front_inner = back_t + tower_d - front_w;
  y_c = y_front_inner - chute_d / 2;
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

// Generates debossed identification text on the front face.
module tower_debossed_text(
  x_center,
  label_text,
  y_front = backplate_thickness + tower_depth,
  z_pos = badge_z_position,
  text_sz = badge_text_size,
  deboss_d = badge_deboss_depth,
  slot_w = sight_slot_width,
  chute_w = chute_width,
  is_open = (sight_slot_z_end >= dispenser_height - EPSILON)
) {
  if (is_open || slot_w >= 14.0) {
    x_flank = x_center + (slot_w / 2 + chute_w / 2) / 2;
    z_flank = dispenser_height - 18.0;
    actual_sz = min(text_sz, 3.2);

    translate([x_flank, y_front + EPSILON, z_flank]) {
      rotate([90, 0, 0]) {
        mirror([1, 0, 0]) {
          rotate([0, 0, -90]) {
            linear_extrude(height = deboss_d + 2 * EPSILON) {
              text(label_text, size = actual_sz, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
            }
          }
        }
      }
    }
  } else {
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
}

// Generates cylindrical front driver access tunnels through the inter-tower columns to the rear countersunk screw holes.
module tower_screw_access_holes(
  count = actual_dispenser_count,
  spacing = slot_spacing,
  hole_d = countersink_diameter,
  back_t = backplate_thickness,
  tower_d = tower_depth,
  shelf_ext = shelf_extension,
  z_top = z_plate_top,
  z_bottom = z_plate_bottom
) {
  if (include_screw_holes && count > 1) {
    cut_len = tower_d + shelf_ext + 10.0;
    for (i = [0 : count - 2]) {
      x_win = (i + 0.5 - (count - 1) / 2) * spacing;
      translate([x_win, back_t - EPSILON, z_top - 10.0])
        rotate([-90, 0, 0])
          cylinder(d = hole_d, h = cut_len);
      translate([x_win, back_t - EPSILON, z_bottom + 15.0])
        rotate([-90, 0, 0])
          cylinder(d = hole_d, h = cut_len);
    }
  }
}


// Generates a continuous cylindrical fillet cutter rounding the top-left and top-right shoulders across the full Y-depth.
module top_corner_cutter(
  width = total_width,
  height = dispenser_height,
  depth = backplate_thickness + tower_depth + 20.0,
  r = top_corner_radius
) {
  if (r > 0) {
    box_sz = r + 2.0;

    // Cut top-left corner
    translate([-width / 2, -10.0, height]) {
      difference() {
        translate([-box_sz, 0, -r])
          cube([box_sz + EPSILON, depth, r + EPSILON]);
        translate([r, 0, -r])
          rotate([-90, 0, 0])
            cylinder(r = r, h = depth);
      }
    }

    // Cut top-right corner
    translate([width / 2, -10.0, height]) {
      difference() {
        translate([-EPSILON, 0, -r])
          cube([box_sz + EPSILON, depth, r + EPSILON]);
        translate([-r, 0, -r])
          rotate([-90, 0, 0])
            cylinder(r = r, h = depth);
      }
    }
  }
}

