/**
 * Adapter that holds 1.75" (44.45 mm) 12 gauge mini shells in a Mossberg 12 gauge
 * shotgun. Compatible with the commercial OPSol Mini-Clip fit. All dimensions are in
 * millimeters.
 *
 * Fit-critical: every dimension below is tuned to the receiver and the shell, so
 * change them only with a test print. Print in flexible filament (TPU).
 */

/* [Overall Dimensions] */
// Adapter length along the barrel (X)
Length = 35;

// Adapter width across the receiver (Y)
Width = 26;

// Adapter height (Z)
Height = 20.5;

/* [Rear Cutout] */
// Height of the notch across the rear
Rear_Cutout_Height = 9.5;

// Depth of the notch into the rear face
Rear_Cutout_Depth = 2;

/* [Front Cutout] */
// Depth of the square notch across the front
Front_Cutout_Depth = 7;

// Angle of the sloped front cut from vertical
Front_Angled_Cutout_Angle = 45;

// Height at which the sloped front cut starts, below the base
Front_Angled_Cutout_Offset_Z = 4;

/* [Top Side Cutouts] */
// Depth of the relief cut into each side of the top
Top_Side_Cutout_Depth = 4.75;

// Position along X where the side slope starts
Top_Side_Cutout_Slope_Offset_X = -2.5;

// Rise of the side slope over its run
Top_Side_Cutout_Slope_Rise = 2.5;

// Run of the side slope over its rise
Top_Side_Cutout_Slope_Run = 11;

/* [Top Cylindrical Cutout] */
// Diameter of the shell bore (12.7 for 1/2")
Top_Cylindrical_Cutout_Diameter = 12.7;

// Depth of the shell bore
Top_Cylindrical_Cutout_Depth = 18.35;

// Distance from the rear face to the bore edge along X
Top_Cylindrical_Cutout_Offset_X = 2.5;

/* [Top Rectangular Cutout] */
// Corner radius of the slot ahead of the bore
Top_Rectangular_Cutout_Corner_Radius = 1.5;

// Width of the slot (Y)
Top_Rectangular_Cutout_Width = 9.9;

// Depth of the slot
Top_Rectangular_Cutout_Depth = 12.5;

// Gap between the bore and the slot along X
Top_Rectangular_Cutout_Offset_From_Cylinder = 1;

/* [Hidden] */
$fn = 128;

module roundedCube(x, y, z, r) {
  hull() {
    translate([r, r, 0]) cylinder(r=r, h=z);
    translate([x - r, r, 0]) cylinder(r=r, h=z);
    translate([r, y - r, 0]) cylinder(r=r, h=z);
    translate([x - r, y - r, 0]) cylinder(r=r, h=z);
  }
}

module body() {
  translate([0, 0, Height / 2])
    cube([Length, Width, Height], center=true);
}

module frontCutout() {
  x = Front_Cutout_Depth + 1;
  y = Width + 2;
  z = Height + 1;
  translate([(Length / 2) - Front_Cutout_Depth, -y / 2, 0])
    cube([x, y , z]);
}

module frontAngledCutout() {
  x = Height * sqrt(2) / 2 + 1;
  y = Width + 1;
  z = Height * sqrt(2) + 1;

  translate([(Length / 2) - Height, 0, -Front_Angled_Cutout_Offset_Z])
    rotate([0, 90 - Front_Angled_Cutout_Angle, 0])
    translate([x / 2, 0, z / 2])
    cube([x, y, z], center=true);
}

module rearCutout() {
  x = Rear_Cutout_Depth + 1;
  y = Width + 1;
  z = Rear_Cutout_Height + 1;

  translate([-(Length / 2) - 1, -y / 2, -1])
    cube([x, y, z]);
}

module topSideAngledCutouts() {
  a = atan(Top_Side_Cutout_Slope_Rise / Top_Side_Cutout_Slope_Run);
  x = Length;
  y = Width + 1;
  z = Height;

  translate([Top_Side_Cutout_Slope_Offset_X, 0, Rear_Cutout_Height]) {
    translate([0, -y - (Width / 2) + Top_Side_Cutout_Depth, 0]) rotate([0, a, 0]) cube([x, y, z]);
    translate([0, (Width / 2) - Top_Side_Cutout_Depth, 0]) rotate([0, a, 0]) cube([x, y, z]);
  }
}

module topSideCutouts() {
  x = Length + 1;
  y = Top_Side_Cutout_Depth + 1;
  z = Height - Rear_Cutout_Height + 1;

  topSideAngledCutouts();
  translate([-(Length + 1) / 2, 0, Rear_Cutout_Height]) {
    translate([0, -(Width / 2) - 1, 0]) cube([x, y, z]);
    translate([0, (Width / 2) - Top_Side_Cutout_Depth, 0]) cube([x, y, z]);
  }
}

module topCylindricalCutout() {
  dx = ((Top_Cylindrical_Cutout_Diameter - Length) / 2) + Top_Cylindrical_Cutout_Offset_X;
  dz = Height - Top_Cylindrical_Cutout_Depth;
  translate([dx, 0, dz])
    cylinder(d=Top_Cylindrical_Cutout_Diameter, h=Height);
}

module topRectangularCutout() {
  x = Length;
  dx = -Length / 2 + Top_Cylindrical_Cutout_Offset_X + Top_Cylindrical_Cutout_Diameter + Top_Rectangular_Cutout_Offset_From_Cylinder;

  translate([dx, -Top_Rectangular_Cutout_Width / 2, Height - Top_Rectangular_Cutout_Depth])
    roundedCube(x, Top_Rectangular_Cutout_Width, Top_Rectangular_Cutout_Depth + 1, Top_Rectangular_Cutout_Corner_Radius);
}

module frontAngledLip() {
  y = Width - 2 * Top_Side_Cutout_Depth;

  translate([-Height + Length / 2, -y / 2, 0])
    difference() {
      intersection() {
        cube([Height, y, Height]);
        rotate([0, Front_Angled_Cutout_Angle, 0])
          cube([Height * sqrt(2), y, Height * sqrt(2)]);
      }

      translate([Front_Angled_Cutout_Offset_Z, -1, 0])
        rotate([0, Front_Angled_Cutout_Angle, 0])
        cube([Height * sqrt(2), y + 2, Height * sqrt(2)]);
    }
}

module MiniClip() {
  difference() {
    body();
    frontCutout();
    frontAngledCutout();
    rearCutout();
    topSideCutouts();
    topCylindricalCutout();
    topRectangularCutout();
  }

  frontAngledLip();
}

MiniClip();
