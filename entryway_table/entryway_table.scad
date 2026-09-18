/**
 * Parametric entryway table designed for layered plywood construction.
 * All dimensions are in inches.
 */

board_thickness = 0.75;  // Plywood sheet thickness in inches
board_layers = 5;        // Number of plies for alternating veneer visualization
leg_height = 36;         // Leg height from floor to underside of top in inches
leg_width = 2;           // Width of each board in the L-shaped leg in inches
top_length = 48;         // Tabletop length along X axis in inches
top_width = 11;          // Tabletop width along Y axis in inches
top_overhang = 1.5;      // Tabletop overhang beyond leg outer faces in inches
apron_length = 41;       // top_length - 2 * top_overhang - 2 * leg_width
apron_width = 8;         // Apron vertical board width (height) in inches
apron_depth = 5;         // top_width - 2 * top_overhang - 2 * 1.5

// Generates a rectangular board with alternating colored veneer layers.
module plywood(length, width, thickness, layers) {
  scale([length, width, thickness]) {
    layer_thickness = 1 / layers;
    translate([-0.5, -0.5, 0]) {
      for (i = [0:layers - 1]) {
        color(i % 2 == 0 ? "burlywood" : "wheat") translate([0, 0, layer_thickness * i]) cube([1, 1, layer_thickness]);
      }
    }
  }
}

// Convenience wrapper for a plywood board using default thickness and ply count.
module board(length, width) {
  plywood(length, width, board_thickness, board_layers);
}

// Generates the tabletop board centered at the origin.
module top() {
  board(top_length, top_width);
}

// Assembles an L-shaped corner leg from two perpendicular boards.
module leg() {
  translate([0, 0, leg_height / 2]) rotate([0, 90, 90]) {
    translate([0, 0, -board_thickness]) board(leg_height, leg_width);
    board(leg_height, leg_width);
  }
}

// Applies a 3.75-degree taper cut along the lower inner face of the leg.
module leg_with_angle() {
  difference() {
    leg();

    // Cut from the middle of the bottom of the leg at a 3.75 degree angle
    // towards the inner (left) edge.
    rotate([0, -90 / 24, 0]) translate([-2, -1.5, 0]) cube([leg_width, 3, leg_height]);
  }
}

// Rectangular perimeter cutter for decorative accent grooves.
module leg_ring() {
  linear_extrude(height=0.125) difference() {
    square([4, 3], center=true);
    square([2 - 0.25, 1.5 - 0.25], center=true);
  }
}

// Leg with upper and lower decorative accent grooves.
module leg_with_rings() {
  difference() {
    leg();
    translate([0, 0, leg_height - apron_width - 1.5]) leg_ring();
    translate([0, 0, 4.5]) leg_ring();
  }
}

// Angled leg with upper decorative accent groove below the apron.
module leg_with_angle_and_ring() {
  difference() {
    leg_with_angle();
    translate([0, 0, leg_height - apron_width - 1.5]) leg_ring();
  }
}

// Front and back apron rail board oriented vertically along the X axis.
module apron_front() {
  color("tan") translate([0, 0, apron_width / 2]) rotate([-90, 0, 0]) board(apron_length, apron_width);
}

// Side apron rail board oriented vertically along the Y axis.
module apron_side() {
  color("tan") translate([0, 0, apron_width / 2]) rotate([-90, 0, -90]) board(apron_depth, apron_width);
}

// Full entryway table assembly: tabletop, four angled legs, and apron rails.
module table() {
  // top
  translate([0, 0, leg_height]) top();

  // legs
  leg_x_offset = (top_length / 2) - top_overhang - (leg_width / 2);
  leg_y_offset = (top_width / 2) - top_overhang - board_thickness;
  translate([leg_x_offset, leg_y_offset, 0]) leg_with_angle_and_ring();
  translate([leg_x_offset, -leg_y_offset, 0]) leg_with_angle_and_ring();
  mirror([1, 0, 0]) translate([leg_x_offset, leg_y_offset, 0]) leg_with_angle_and_ring();
  mirror([1, 0, 0]) translate([leg_x_offset, -leg_y_offset, 0]) leg_with_angle_and_ring();

  // apron
  translate([0, 0, leg_height - apron_width]) {
    apron_x_offset = leg_x_offset - 0.125;
    apron_y_offset = leg_y_offset - 0.125;
    translate([0, apron_y_offset, 0]) apron_front();
    mirror([0, 1, 0]) translate([0, apron_y_offset, 0]) apron_front();
    translate([apron_x_offset, 0, 0]) apron_side();
    mirror([1, 0, 0]) translate([apron_x_offset, 0, 0]) apron_side();
  }
}

table();
