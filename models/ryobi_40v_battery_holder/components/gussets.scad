/**
 * Structural reinforcement gussets supporting the tilted cradle against the backplate.
 */

// Generates the 2D cross-section profile for classic triangular or swept architectural ribs.
module gusset_rib_profile_2d(h_plate, h_bed, w_bed, style) {
  if (style == "classic") {
    polygon(points = [
      [0, 0],
      [0, h_plate],
      [w_bed, h_plate]
    ]);
  } else {
    polygon(points = concat(
      [[0, 0], [0, h_plate]],
      [for (t = [0 : 0.08 : 1])
        let(
          p0 = [0, h_plate],
          p1 = [w_bed * 0.18, h_plate * 0.92],
          p2 = [w_bed, h_bed],
          u = (1 - t) * (1 - t) * p0[0] + 2 * (1 - t) * t * p1[0] + t * t * p2[0],
          v = (1 - t) * (1 - t) * p0[1] + 2 * (1 - t) * t * p1[1] + t * t * p2[1]
        ) [u, v]
      ],
      [[w_bed, h_bed]]
    ));
  }
}

// Generates the 2D weight-relief truss slot cutout for discrete gusset ribs.
module gusset_truss_window_2d(h_plate_attach) {
  v_bot = 35.0;
  v_top = h_plate_attach - 8.0;
  u_bot = 0.5 * v_bot * tan(Tilt_Angle);
  u_top = 0.5 * v_top * tan(Tilt_Angle);

  hull() {
    translate([u_bot, v_bot]) circle(d = 4.0);
    translate([u_top, v_top]) circle(d = 4.0);
  }
}

// Generates a full-width continuous monolithic cradle wedge with optional cored cavity.
module gusset_full_wedge(x_center, w, z_bot, h_plate_attach, h_contact, w_contact, cored) {
  translate([x_center, 0, 0]) {
    difference() {
      translate([0, Backplate_Thickness - EPSILON, z_bot]) {
        rotate([90, 0, 90]) {
          linear_extrude(height = w, center = true) {
            gusset_rib_profile_2d(h_plate_attach, h_contact, w_contact, "swept");
          }
        }
      }

      if (cored) {
        wall_t = 6.5;
        core_w = w - 2 * wall_t;
        translate([0, Backplate_Thickness + 2.5, z_bot + 4.0]) {
          rotate([90, 0, 90]) {
            linear_extrude(height = core_w, center = true) {
              polygon(points = [
                [0, 0],
                [0, h_plate_attach - 10.0],
                [(w_contact - 3.5) * 0.25, h_plate_attach - 10.0],
                [w_contact - 3.5, h_contact - 8.0],
                [w_contact - 3.5, 0]
              ]);
            }
          }
        }
      }
    }
  }
}

// Generates monolithic flared buttress wings connecting peg hooks to slide rails.
module gusset_buttress_wings(x_center, span, w, z_bot, h_plate_attach, h_contact, w_contact) {
  for (side = [-1, 1]) {
    x_inner = x_center + side * (span / 2);
    x_outer = x_center + side * (w / 2);

    hull() {
      translate([x_inner, Backplate_Thickness - EPSILON, z_bot]) {
        rotate([90, 0, 90]) {
          linear_extrude(height = Gusset_Thickness, center = true) {
            gusset_rib_profile_2d(h_plate_attach, h_contact, w_contact, "swept");
          }
        }
      }

      translate([x_outer - side * (Gusset_Thickness / 2), Backplate_Thickness - EPSILON, z_bot]) {
        rotate([90, 0, 90]) {
          linear_extrude(height = Gusset_Thickness, center = true) {
            gusset_rib_profile_2d(h_plate_attach * 0.90, h_contact * 0.90, w_contact * 0.90, "swept");
          }
        }
      }
    }
  }
}

// Generates a pair of discrete structural ribs aligned with mounting hooks.
module gusset_rib_pair(x_center, span, z_bot, h_plate_attach, h_contact, w_contact, h_gusset, w_gusset, style) {
  for (side = [-1, 1]) {
    x_rib = x_center + side * (span / 2);
    translate([x_rib, Backplate_Thickness - EPSILON, z_bot]) {
      rotate([90, 0, 90]) {
        linear_extrude(height = Gusset_Thickness, center = true) {
          difference() {
            gusset_rib_profile_2d(h_plate_attach, h_contact, w_contact, style);

            if (h_gusset > 35 && w_gusset > 9) {
              gusset_truss_window_2d(h_plate_attach);
            }
          }
        }
      }
    }
  }
}

// Orchestrates structural cradle reinforcement gussets based on the configured style.
module gusset_ribs(x_center) {
  w = Bed_Width;
  gusset_span = (Slot_Spacing_Count % 2 == 0) ? Hole_Spacing : 2 * Hole_Spacing;
  z_gusset_bot = z_shelf;
  h_gusset = z_plate_top - z_gusset_bot;
  w_gusset = h_gusset * tan(Tilt_Angle);

  h_plate_attach = (Gusset_Style == "classic") ? h_gusset : (h_gusset - 4.5);
  contact_ratio = (Gusset_Style == "classic") ? 1.0 : 0.86;
  h_contact = h_gusset * contact_ratio;
  w_contact = w_gusset * contact_ratio;

  if (Tilt_Angle > 0) {
    if (Gusset_Style == "full_wedge") {
      gusset_full_wedge(x_center, w, z_gusset_bot, h_plate_attach, h_contact, w_contact, Include_Hollow_Wedge);
    } else if (Gusset_Style == "buttress_wings") {
      gusset_buttress_wings(x_center, gusset_span, w, z_gusset_bot, h_plate_attach, h_contact, w_contact);
    } else {
      gusset_rib_pair(x_center, gusset_span, z_gusset_bot, h_plate_attach, h_contact, w_contact, h_gusset, w_gusset, Gusset_Style);
    }
  }
}
