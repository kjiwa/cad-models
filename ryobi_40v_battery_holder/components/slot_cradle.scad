/**
 * Battery slot cradle assembly and screwdriver access channel.
 */

// Generates the tilted battery interface subassembly: slide bed, resting shelf, and slide rails.
module cradle_tilted_subassembly(is_first_slot) {
  rotate([-tilt_angle, 0, 0]) {
    if (is_visible("slide_bed")) {
      color("SteelBlue") slide_bed();
      if (is_first_slot) {
        component_label("Slide Bed", [0, bed_thickness + 0.5, rail_length * 0.85]);
      }
    }

    if (is_visible("bottom_shelf")) {
      color("SeaGreen") bottom_shelf();
      if (is_first_slot) {
        component_label("Bottom Shelf", [0, bed_thickness + bottom_shelf_depth + 0.5, bottom_shelf_thickness / 2]);
      }
    }

    if (enable_rails && is_visible("slide_rails")) {
      color("RoyalBlue") slide_rails();
      if (is_first_slot) {
        component_label("Slide Rails", [0, bed_thickness + rail_thickness * 2 + rail_clearance + 0.5, rail_length / 2]);
      }
    }
  }
}

// Generates the screwdriver clearance through-hole and front chamfered bezel.
module screwdriver_access_cutter(x_center, z_screw) {
  translate([x_center, -EPSILON, z_screw]) {
    rotate([-90, 0, 0]) {
      cylinder(d = countersink_diameter + 3.0, h = w_cradle + bed_thickness + 20.0);
      translate([0, 0, backplate_thickness + (z_screw - z_shelf) * tan(tilt_angle) + (bed_thickness / cos(tilt_angle)) - 1.0])
        cylinder(d1 = countersink_diameter + 3.0, d2 = countersink_diameter + 6.0, h = 3.0);
    }
  }
}

// Generates structural gussets and preview inspection label for a battery slot.
module cradle_support_gussets(x_center, is_first_slot) {
  if (is_visible("gussets")) {
    color("DarkOrange") gusset_ribs(x_center);
    if (is_first_slot) {
      component_label("Gussets", [x_center + peg_hole_spacing + bracket_thickness / 2 + 8, backplate_thickness + w_cradle * 0.3, z_shelf + h_cradle * 0.5], [90, 0, -90]);
    }
  }
}

// Orchestrates a single battery cradle slot: tilted interface, base foot, screwdriver cutout, and gussets.
module slot_cradle(x_center, is_first_slot = true) {
  y_shelf = backplate_thickness;
  z_screw = z_top_peg - peg_hole_spacing;

  difference() {
    union() {
      translate([x_center, y_shelf, z_shelf])
        cradle_tilted_subassembly(is_first_slot);

      if (is_visible("bottom_shelf")) {
        color("SeaGreen") cradle_base_foot(x_center);
      }

      cradle_support_gussets(x_center, is_first_slot);
    }

    if (include_screw_holes) {
      screwdriver_access_cutter(x_center, z_screw);
    }
  }
}
