/**
 * Adapter that holds 1.75" (44.45 mm) 12 gauge mini shells in a Mossberg 12 gauge
 * shotgun. Compatible with the commercial OPSol Mini-Clip fit. All dimensions are in
 * millimeters.
 *
 * Fit-critical: every dimension below is tuned to the receiver and the shell, so
 * change them only with a test print. Print in flexible filament (TPU).
 */

/* [Overall Dimensions] */
// Adapter width along the barrel (X)
Width = 35;

// Adapter depth across the receiver (Y)
Depth = 26;

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
Front_Cutout_Angle = 45; // [15:5:75]

// Distance below the base where the sloped front cut starts
Front_Cutout_Drop = 4;

/* [Side Relief] */
// Depth of the relief cut into each side of the top
Side_Relief_Depth = 4.75;

// Position along X where the side slope starts
Side_Slope_Start = -2.5;

// Rise of the side slope over its run
Side_Slope_Rise = 2.5;

// Run of the side slope over its rise
Side_Slope_Run = 11;

/* [Bore] */
// Diameter of the shell bore (12.7 for 1/2")
Bore_Diameter = 12.7;

// Depth of the shell bore
Bore_Depth = 18.35;

// Distance from the rear face to the bore edge along X
Bore_Setback = 2.5;

/* [Slot] */
// Width of the slot (Y)
Slot_Width = 9.9;

// Depth of the slot
Slot_Depth = 12.5;

// Gap between the bore and the slot along X
Slot_Gap = 1;

// Corner radius of the slot ahead of the bore
Slot_Corner_Radius = 1.5;

/* [Hidden] */
$fn = 128;

assert(2 * Side_Relief_Depth < Depth, "Side_Relief_Depth must be less than half of Depth");
assert(Bore_Setback + Bore_Diameter + Slot_Gap < Width, "Bore_Setback + Bore_Diameter + Slot_Gap must be less than Width");
assert(Bore_Depth < Height, "Bore_Depth must be less than Height");
assert(Rear_Cutout_Height < Height, "Rear_Cutout_Height must be less than Height");

module RoundedCube(x, y, z, r) {
  hull() {
    translate([r, r, 0]) cylinder(r=r, h=z);
    translate([x - r, r, 0]) cylinder(r=r, h=z);
    translate([r, y - r, 0]) cylinder(r=r, h=z);
    translate([x - r, y - r, 0]) cylinder(r=r, h=z);
  }
}

module Body() {
  translate([0, 0, Height / 2])
    cube([Width, Depth, Height], center=true);
}

module FrontCutout() {
  x = Front_Cutout_Depth + 1;
  y = Depth + 2;
  z = Height + 1;
  translate([(Width / 2) - Front_Cutout_Depth, -y / 2, 0])
    cube([x, y , z]);
}

module FrontAngledCutout() {
  x = Height + 1;
  y = Depth + 1;
  z = 2 * Height + Front_Cutout_Drop + 1;

  translate([(Width / 2) - Height, 0, -Front_Cutout_Drop])
    rotate([0, Front_Cutout_Angle, 0])
    translate([x / 2, 0, z / 2])
    cube([x, y, z], center=true);
}

module RearCutout() {
  x = Rear_Cutout_Depth + 1;
  y = Depth + 1;
  z = Rear_Cutout_Height + 1;

  translate([-(Width / 2) - 1, -y / 2, -1])
    cube([x, y, z]);
}

module TopSideAngledCutouts() {
  a = atan(Side_Slope_Rise / Side_Slope_Run);
  x = Width;
  y = Depth + 1;
  z = Height;

  translate([Side_Slope_Start, 0, Rear_Cutout_Height]) {
    translate([0, -y - (Depth / 2) + Side_Relief_Depth, 0]) rotate([0, a, 0]) cube([x, y, z]);
    translate([0, (Depth / 2) - Side_Relief_Depth, 0]) rotate([0, a, 0]) cube([x, y, z]);
  }
}

module TopSideCutouts() {
  x = Width + 1;
  y = Side_Relief_Depth + 1;
  z = Height - Rear_Cutout_Height + 1;

  TopSideAngledCutouts();
  translate([-(Width + 1) / 2, 0, Rear_Cutout_Height]) {
    translate([0, -(Depth / 2) - 1, 0]) cube([x, y, z]);
    translate([0, (Depth / 2) - Side_Relief_Depth, 0]) cube([x, y, z]);
  }
}

module TopCylindricalCutout() {
  dx = ((Bore_Diameter - Width) / 2) + Bore_Setback;
  dz = Height - Bore_Depth;
  translate([dx, 0, dz])
    cylinder(d=Bore_Diameter, h=Height);
}

module TopRectangularCutout() {
  x = Width;
  dx = -Width / 2 + Bore_Setback + Bore_Diameter + Slot_Gap;

  translate([dx, -Slot_Width / 2, Height - Slot_Depth])
    RoundedCube(x, Slot_Width, Slot_Depth + 1, Slot_Corner_Radius);
}

module FrontAngledLip() {
  y = Depth - 2 * Side_Relief_Depth;
  t = tan(Front_Cutout_Angle);
  outer_base = Front_Cutout_Drop * t;

  translate([-Height + Width / 2, 0, 0])
    rotate([90, 0, 0])
    linear_extrude(height=y, center=true)
    intersection() {
      square([Height, Height]);
      polygon([
        [outer_base - Front_Cutout_Drop, 0],
        [outer_base, 0],
        [outer_base + Height * t, Height],
        [outer_base + Height * t - Front_Cutout_Drop, Height],
      ]);
    }
}

module MiniClip() {
  difference() {
    Body();
    FrontCutout();
    FrontAngledCutout();
    RearCutout();
    TopSideCutouts();
    TopCylindricalCutout();
    TopRectangularCutout();
  }

  FrontAngledLip();
}

MiniClip();
