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
  translate([x_lip, Bed_Thickness + h_slot - EPSILON, Rail_Length]) {
    rotate([0, atan2(chamfer_d, lead_in), 0])
      translate([-chamfer_d, -EPSILON, -lead_in])
        cube([chamfer_d * 2, t_lip + 2 * EPSILON, lead_in * 2]);
  }
}

// Generates the 45-degree chamfer cutter along the rail top entrance face.
module rail_top_face_chamfer(x_lip, h_slot, t_lip, chamfer_d) {
  translate([x_lip, Bed_Thickness + h_slot + t_lip, Rail_Length]) {
    rotate([0, 45, 0])
      cube([chamfer_d * 1.5, t_lip * 3, chamfer_d * 1.5], center = true);
  }
}

// Generates the top outer corner roundover cutter matching slide bed curvature.
module rail_outer_corner_roundover(x_outer, h_slot, t_lip, r_bed) {
  translate([x_outer - r_bed, (h_slot + t_lip) + Bed_Thickness + EPSILON, Rail_Length - r_bed]) {
    rotate([90, 0, 0]) {
      linear_extrude(height = (h_slot + t_lip) + 2 * EPSILON) {
        corner_cut_2d(r_bed);
      }
    }
  }
}

// Generates the front outer vertical roundover cutter matching bottom shelf curvature.
module rail_front_edge_roundover(x_outer, h_slot, t_lip, r_shelf) {
  translate([x_outer - r_shelf, Bed_Thickness + (h_slot + t_lip) - r_shelf, Shelf_Thickness - EPSILON]) {
    difference() {
      translate([0, 0, 0])
        cube([r_shelf + EPSILON, r_shelf + EPSILON, Rail_Length]);
      cylinder(r = r_shelf, h = Rail_Length * 2);
    }
  }
}

// Generates a single battery slide retention rail with lead-in and roundovers.
module single_rail() {
  w_pocket = Rail_Width + 2 * Rail_Clearance;
  h_slot = Rail_Thickness + Rail_Clearance;
  t_lip = Rail_Lip_Thickness;
  d_lip = Rail_Lip_Depth;

  x_outer = Bed_Width / 2;
  x_wall = w_pocket / 2;
  x_lip = w_pocket / 2 - d_lip;
  lead_in = 12.0;
  chamfer_d = 2.5;
  r_bed = min(Bed_Corner_Radius, Bed_Width / 4);
  r_shelf = min(Shelf_Corner_Radius, Shelf_Depth / 2, Bed_Width / 4);
  r_fillet = min(Rail_Lip_Radius, d_lip * 0.45, h_slot * 0.45);
  r_root = min(Rail_Root_Radius, 0.6);
  c_lead = 0.8;

  difference() {
    translate([0, Bed_Thickness, Shelf_Thickness]) {
      linear_extrude(height = Rail_Length - Shelf_Thickness) {
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
