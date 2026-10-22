/**
 * Battery slot cradle assembly and screwdriver access channel.
 */

// Generates the tilted battery interface subassembly: slide bed, resting shelf, and slide rails.
module cradle_tilted_subassembly(is_first_slot) {
  rotate([-Tilt_Angle, 0, 0]) {
    if (is_visible("slide_bed")) {
      color("SteelBlue") slide_bed();
      if (is_first_slot) {
        component_label("Slide Bed", [0, Bed_Thickness + 0.5, Rail_Length * 0.85]);
      }
    }

    if (is_visible("bottom_shelf")) {
      color("SeaGreen") bottom_shelf();
      if (is_first_slot) {
        component_label("Bottom Shelf", [0, Bed_Thickness + Shelf_Depth + 0.5, Shelf_Thickness / 2]);
      }
    }

    if (Include_Rails && is_visible("slide_rails")) {
      color("RoyalBlue") slide_rails();
      if (is_first_slot) {
        component_label("Slide Rails", [0, Bed_Thickness + Shelf_Depth + 0.5, Rail_Length / 2]);
      }
    }
  }
}

// Generates the screwdriver clearance through-hole and front chamfered bezel.
module screwdriver_access_cutter(x_center, z_screw) {
  translate([x_center, -EPSILON, z_screw]) {
    rotate([-90, 0, 0]) {
      cylinder(d = Countersink_Diameter + 3.0, h = w_cradle + Bed_Thickness + 20.0);
      translate([0, 0, Backplate_Thickness + (z_screw - z_shelf) * tan(Tilt_Angle) + (Bed_Thickness / cos(Tilt_Angle)) - 1.0])
        cylinder(d1 = Countersink_Diameter + 3.0, d2 = Countersink_Diameter + 6.0, h = 3.0);
    }
  }
}

// Generates structural gussets and preview inspection label for a battery slot.
module cradle_support_gussets(x_center, is_first_slot) {
  if (is_visible("gussets")) {
    color("DarkOrange") gusset_ribs(x_center);
    if (is_first_slot) {
      component_label("Gussets", [x_center + Hole_Spacing + Gusset_Thickness / 2 + 8, Backplate_Thickness + w_cradle * 0.3, z_shelf + h_cradle * 0.5], [90, 0, -90]);
    }
  }
}

// Orchestrates a single battery cradle slot: tilted interface, base foot, screwdriver cutout, and gussets.
module slot_cradle(x_center, is_first_slot = true) {
  y_shelf = Backplate_Thickness;
  z_screw = z_top_peg - Hole_Spacing;

  difference() {
    union() {
      translate([x_center, y_shelf, z_shelf])
        cradle_tilted_subassembly(is_first_slot);

      if (is_visible("bottom_shelf")) {
        color("SeaGreen") cradle_base_foot(x_center);
      }

      cradle_support_gussets(x_center, is_first_slot);
    }

    if (Include_Screw_Holes) {
      screwdriver_access_cutter(x_center, z_screw);
    }
  }
}
