/**
 * Parametric entryway table designed for layered plywood construction.
 * All dimensions are in millimeters.
 */

/* [Tabletop] */
// Tabletop length along X
Top_Length = 1219.2;

// Tabletop depth along Y
Top_Depth = 279.4;

// Tabletop overhang beyond the leg outer faces
Top_Overhang = 38.1;

/* [Legs] */
// Leg height from floor to underside of the top
Leg_Height = 914.4;

// Width of each board in the L-shaped leg
Leg_Board_Width = 50.8;

/* [Apron] */
// Height of the apron boards
Apron_Height = 203.2;

// Length of the front and back apron boards (0 = auto: Top_Length - 2 * Top_Overhang - 2 * Leg_Board_Width)
Apron_Length = 0;

// Depth of the side apron boards (0 = auto: Top_Depth - 2 * Top_Overhang - 76.2)
Apron_Depth = 0;

/* [Plywood] */
// Plywood sheet thickness
Board_Thickness = 19.05;

// Number of plies for alternating veneer visualization
Ply_Count = 5;

/* [Hidden] */
apron_length = (Apron_Length > 0) ? Apron_Length : (Top_Length - 2 * Top_Overhang - 2 * Leg_Board_Width);
apron_depth = (Apron_Depth > 0) ? Apron_Depth : (Top_Depth - 2 * Top_Overhang - 76.2);

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
  plywood(length, width, Board_Thickness, Ply_Count);
}

// Generates the tabletop board centered at the origin.
module top() {
  board(Top_Length, Top_Depth);
}

// Assembles an L-shaped corner leg from two perpendicular boards.
module leg() {
  translate([0, 0, Leg_Height / 2]) rotate([0, 90, 90]) {
    translate([0, 0, -Board_Thickness]) board(Leg_Height, Leg_Board_Width);
    board(Leg_Height, Leg_Board_Width);
  }
}

// Applies a 3.75-degree taper cut along the lower inner face of the leg.
module leg_with_angle() {
  difference() {
    leg();

    // Cut from the middle of the bottom of the leg at a 3.75 degree angle
    // towards the inner (left) edge.
    rotate([0, -90 / 24, 0]) translate([-50.8, -38.1, 0]) cube([Leg_Board_Width, 76.2, Leg_Height]);
  }
}

// Rectangular perimeter cutter for decorative accent grooves.
module leg_ring() {
  linear_extrude(height=3.175) difference() {
    square([101.6, 76.2], center=true);
    square([44.45, 31.75], center=true);
  }
}

// Leg with upper and lower decorative accent grooves.
module leg_with_rings() {
  difference() {
    leg();
    translate([0, 0, Leg_Height - Apron_Height - 38.1]) leg_ring();
    translate([0, 0, 114.3]) leg_ring();
  }
}

// Angled leg with upper decorative accent groove below the apron.
module leg_with_angle_and_ring() {
  difference() {
    leg_with_angle();
    translate([0, 0, Leg_Height - Apron_Height - 38.1]) leg_ring();
  }
}

// Front and back apron rail board oriented vertically along the X axis.
module apron_front() {
  color("tan") translate([0, 0, Apron_Height / 2]) rotate([-90, 0, 0]) board(apron_length, Apron_Height);
}

// Side apron rail board oriented vertically along the Y axis.
module apron_side() {
  color("tan") translate([0, 0, Apron_Height / 2]) rotate([-90, 0, -90]) board(apron_depth, Apron_Height);
}

// Full entryway table assembly: tabletop, four angled legs, and apron rails.
module table() {
  // top
  translate([0, 0, Leg_Height]) top();

  // legs
  leg_x_offset = (Top_Length / 2) - Top_Overhang - (Leg_Board_Width / 2);
  leg_y_offset = (Top_Depth / 2) - Top_Overhang - Board_Thickness;
  translate([leg_x_offset, leg_y_offset, 0]) leg_with_angle_and_ring();
  translate([leg_x_offset, -leg_y_offset, 0]) leg_with_angle_and_ring();
  mirror([1, 0, 0]) translate([leg_x_offset, leg_y_offset, 0]) leg_with_angle_and_ring();
  mirror([1, 0, 0]) translate([leg_x_offset, -leg_y_offset, 0]) leg_with_angle_and_ring();

  // apron
  translate([0, 0, Leg_Height - Apron_Height]) {
    apron_x_offset = leg_x_offset - 3.175;
    apron_y_offset = leg_y_offset - 3.175;
    translate([0, apron_y_offset, 0]) apron_front();
    mirror([0, 1, 0]) translate([0, apron_y_offset, 0]) apron_front();
    translate([apron_x_offset, 0, 0]) apron_side();
    mirror([1, 0, 0]) translate([apron_x_offset, 0, 0]) apron_side();
  }
}

table();
