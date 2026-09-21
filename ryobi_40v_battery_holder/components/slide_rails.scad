/**
 * Battery slide retention rails with lead-in flares and fillet transitions.
 */

// Generates an inverted 2D rounded corner cutter for exterior edge roundovers.
module corner_cut_2d(r) {
  difference() {
    square([r + EPSILON, r + EPSILON]);
    circle(r = r);
  }
}

// Generates the 2D cross-sectional profile of one slide rail with root and lip fillets.
module rail_profile_2d(x_outer, x_wall, x_lip, h_slot, t_lip, r_root, r_fillet, c_lead) {
  polygon(points = concat(
    [
      [x_lip, h_slot + t_lip],
      [x_outer, h_slot + t_lip],
      [x_outer, 0],
      (r_root > 0) ? [x_wall - r_root, 0] : [x_wall, 0],
      (r_root > 0) ? [x_wall, r_root] : [x_wall, 0],
      [x_wall, h_slot - r_fillet]
    ],
    (r_fillet > 0) ? [
      for (a = [6 : -1 : 0]) [
        (x_wall - r_fillet) + r_fillet * sin(a * 90 / 6),
        (h_slot - r_fillet) + r_fillet * cos(a * 90 / 6)
      ]
    ] : [[x_wall, h_slot]],
    [
      [x_lip + c_lead, h_slot],
      [x_lip, h_slot + c_lead]
    ]
  ));
}

// Generates the compound angled lead-in flare cutter at the rail top opening.
module rail_lead_in_flare(x_lip, h_slot, t_lip, chamfer_d, lead_in) {
  translate([x_lip, bed_thickness + h_slot - EPSILON, rail_length]) {
    rotate([0, atan2(chamfer_d, lead_in), 0])
      translate([-chamfer_d, -EPSILON, -lead_in])
        cube([chamfer_d * 2, t_lip + 2 * EPSILON, lead_in * 2]);
  }
}

// Generates the 45-degree chamfer cutter along the rail top entrance face.
module rail_top_face_chamfer(x_lip, h_slot, t_lip, chamfer_d) {
  translate([x_lip, bed_thickness + h_slot + t_lip, rail_length]) {
    rotate([0, 45, 0])
      cube([chamfer_d * 1.5, t_lip * 3, chamfer_d * 1.5], center = true);
  }
}

// Generates the top outer corner roundover cutter matching slide bed curvature.
module rail_outer_corner_roundover(x_outer, h_slot, t_lip, r_bed) {
  translate([x_outer - r_bed, (h_slot + t_lip) + bed_thickness + EPSILON, rail_length - r_bed]) {
    rotate([90, 0, 0]) {
      linear_extrude(height = (h_slot + t_lip) + 2 * EPSILON) {
        corner_cut_2d(r_bed);
      }
    }
  }
}

// Generates the front outer vertical roundover cutter matching bottom shelf curvature.
module rail_front_edge_roundover(x_outer, h_slot, t_lip, r_shelf) {
  translate([x_outer - r_shelf, bed_thickness + (h_slot + t_lip) - r_shelf, bottom_shelf_thickness - EPSILON]) {
    difference() {
      translate([0, 0, 0])
        cube([r_shelf + EPSILON, r_shelf + EPSILON, rail_length]);
      cylinder(r = r_shelf, h = rail_length * 2);
    }
  }
}

// Generates a single battery slide retention rail with lead-in and roundovers.
module single_rail() {
  w_pocket = rail_width + 2 * rail_clearance;
  h_slot = rail_thickness + rail_clearance;
  t_lip = rail_lip_thickness;
  d_lip = rail_lip_depth;

  x_outer = bed_width / 2;
  x_wall = w_pocket / 2;
  x_lip = w_pocket / 2 - d_lip;
  lead_in = 12.0;
  chamfer_d = 2.5;
  r_bed = min(bed_corner_radius, bed_width / 4);
  r_shelf = min(shelf_corner_radius, bottom_shelf_depth / 2, bed_width / 4);
  r_fillet = min(rail_fillet_radius, d_lip * 0.45, h_slot * 0.45);
  r_root = min(rail_root_fillet, 0.6);
  c_lead = 0.8;

  difference() {
    translate([0, bed_thickness, bottom_shelf_thickness]) {
      linear_extrude(height = rail_length - bottom_shelf_thickness) {
        rail_profile_2d(x_outer, x_wall, x_lip, h_slot, t_lip, r_root, r_fillet, c_lead);
      }
    }

    rail_lead_in_flare(x_lip, h_slot, t_lip, chamfer_d, lead_in);
    rail_top_face_chamfer(x_lip, h_slot, t_lip, chamfer_d);
    rail_outer_corner_roundover(x_outer, h_slot, t_lip, r_bed);
    rail_front_edge_roundover(x_outer, h_slot, t_lip, r_shelf);
  }
}

// Orchestrates the pair of left and right battery slide rails.
module slide_rails() {
  single_rail();
  mirror([1, 0, 0]) single_rail();
}
