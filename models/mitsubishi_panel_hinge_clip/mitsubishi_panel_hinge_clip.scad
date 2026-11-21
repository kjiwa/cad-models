/**
 * Front panel hinge clip of a Mitsubishi MSZ-GS09NA mini split (molded 312L_P-1 and 312R_P-1).
 * The legs and lugs snap into the unit, and the cradle and barrel carry the panel pivot. Print
 * one of each hand; the right clip mirrors the left across the long centerline. All dimensions
 * are in millimeters.
 *
 * Measure against the real part from one datum: X from the root of the angled plate along the
 * long axis, Y from the long centerline, Z from the bottom face of the base plate (the legs and
 * barrel reach below it). Set Highlight to tint one feature in the preview, then adjust that
 * feature's group.
 */

/* [Part] */
// Part to generate
Part = "left"; // [left: Left (312L), right: Right (312R), pair: Pair]

/* [Base Plate] */
// Thickness of the shoulders
Plate_Thickness = 2.15;

/* [Plate A] */
// Length of the angled plate along its slope
Plate_A_Length = 25;

// Width of the angled plate
Plate_A_Width = 17;

// Thickness of the angled plate
Plate_A_Thickness = 1.8;

// Angle of the plate above the base plate
Plate_A_Angle = 45; // [0:5:90]

/* [Shoulder] */
// Length of the upper shoulder along the long axis
Shoulder_Length = 5;

// Width of the upper shoulder without the lugs
Shoulder_Width = 17;

/* [Neck] */
// Length of the neck, where the original breaks
Neck_Length = 4;

// Width of the neck
Neck_Width = 9.6;

// Thickness of the neck
Neck_Thickness = 1.8;

/* [Barrel] */
// Length of the barrel trough along the long axis
Barrel_Length = 11.5;

// Width of the barrel across the rim
Barrel_Width = 17;

// Depth of the barrel below the top of the base plate
Barrel_Depth = 4;

// Wall thickness of the barrel and its end walls
Barrel_Wall = 2.15;

/* [Lower Shoulder] */
// Length of the lower shoulder along the long axis
Lower_Length = 6.5;

// Width of the lower shoulder without the lugs
Lower_Width = 17;

/* [Tongue] */
// Developed length of the tongue from the lower shoulder to its tip
Tongue_Length = 19.45;

// Width of the tongue
Tongue_Width = 10;

// Thickness of the tongue
Tongue_Thickness = 2.4;

// Length of the first leg of the tongue, which drops below the base plate
Tongue_Drop_Length = 7;

// Angle of the first tongue leg below horizontal
Tongue_Drop_Angle = 70; // [0:5:90]

// Angle of the second tongue leg above horizontal
Tongue_Rise_Angle = 55; // [0:5:90]

/* [Lugs] */
// Length of a lug along the long axis
Lug_Length = 5;

// Height of a lug above the bottom face of the base plate
Lug_Height = 4;

// Distance a lug projects beyond the shoulder
Lug_Projection = 3.5;

/* [Fin] */
// Distance from the root of the angled plate to the front base edge of the fin
Fin_Position = 9;

// Height of the fin above the bottom face of the base plate
Fin_Height = 30;

// Width of the fin at its base along the long axis
Fin_Base_Width = 13.3;

// Width of the fin at its top along the long axis
Fin_Top_Width = 9;

// Thickness of the fin at its base
Fin_Base_Thickness = 3;

// Thickness of the fin at its top
Fin_Top_Thickness = 2.15;

/* [Lip] */
// Length of the lip along the long axis, at the back edge of the fin top
Lip_Length = 6;

// Height of the lip down from the top of the fin
Lip_Height = 2.15;

// Distance the lip overhangs the fin on the cradle side
Lip_Overhang = 1.5;

/* [Cradle] */
// Inside radius of the cradle
Cradle_Radius = 6;

// Wall thickness of the cradle
Cradle_Wall = 2.15;

// Width of the cradle across the part
Cradle_Width = 4;

// Distance from the root of the angled plate to the cradle center
Cradle_Position = 4;

// Distance from the long centerline to the cradle center, on the lip side
Cradle_Offset = 5.5;

// Angle the cradle arc spans
Cradle_Arc_Angle = 120; // [30:5:180]

/* [Legs] */
// Gap between the inside faces of the two legs
Leg_Gap = 6.45;

// Width of a leg along the long axis
Leg_Width = 6;

// Length of a leg below the bottom face of the base plate
Leg_Length = 9.2;

// Wall thickness of a leg
Leg_Thickness = 2.15;

// Distance from the root of the angled plate to the leg center
Leg_Position = 23.75;

// Height of a foot at the leg tip
Foot_Height = 1.5;

// Distance a foot projects past the leg face (0 to disable)
Foot_Projection = 1;

// Face of the leg that carries the foot
Foot_Side = "outward"; // [outward: Outward, inward: Inward]

/* [Preview] */
// Feature to tint in the preview
Highlight = "none"; // [none: None, plate_a: Plate A, shoulder: Shoulder, neck: Neck, barrel: Barrel, lower: Lower Shoulder, tongue: Tongue, lugs: Lugs, fin: Fin, lip: Lip, cradle: Cradle, legs: Legs]

/* [Hidden] */
$fn = 96;

Join_Overlap = 0.01;
Pair_Gap = 5;
Highlight_Color = "tomato";

Neck_Start = Shoulder_Length;
Barrel_Start = Neck_Start + Neck_Length;
Lower_Start = Barrel_Start + Barrel_Length;
Base_End = Lower_Start + Lower_Length;

Barrel_Radius = (pow(Barrel_Width / 2, 2) + pow(Barrel_Depth, 2)) / (2 * Barrel_Depth);
Barrel_Center_Z = Plate_Thickness - Barrel_Depth + Barrel_Radius;
Cradle_Outer_Radius = Cradle_Radius + Cradle_Wall;
Cradle_Center_Z = Plate_Thickness + Cradle_Outer_Radius;
Fin_Top_End = Fin_Position + (Fin_Base_Width + Fin_Top_Width) / 2;
Tongue_Rise_Length = Tongue_Length - Tongue_Drop_Length;
Pair_Offset = (max(Shoulder_Width, Lower_Width) + 2 * Lug_Projection + Pair_Gap) / 2;

assert(Neck_Thickness <= Plate_Thickness, "Neck_Thickness must not exceed Plate_Thickness");
assert(Neck_Width < min(Shoulder_Width, Barrel_Width), "Neck_Width must be less than Shoulder_Width and Barrel_Width");
assert(Barrel_Depth <= Barrel_Width / 2, "Barrel_Depth must be at most half of Barrel_Width");
assert(Barrel_Wall < Barrel_Depth, "Barrel_Wall must be less than Barrel_Depth");
assert(Barrel_Length > 2 * Barrel_Wall, "Barrel_Length must exceed twice Barrel_Wall");
assert(Tongue_Drop_Length < Tongue_Length, "Tongue_Drop_Length must be less than Tongue_Length");
assert(Tongue_Width <= Lower_Width, "Tongue_Width must not exceed Lower_Width");
assert(Fin_Top_Width <= Fin_Base_Width, "Fin_Top_Width must not exceed Fin_Base_Width");
assert(Fin_Top_Thickness <= Fin_Base_Thickness, "Fin_Top_Thickness must not exceed Fin_Base_Thickness");
assert(Lip_Length <= Fin_Top_Width, "Lip_Length must not exceed Fin_Top_Width");
assert(Lip_Height < Fin_Height, "Lip_Height must be less than Fin_Height");
assert(Fin_Position >= 0 && Fin_Position + Fin_Base_Width <= Base_End, "The fin must stand on the base plate");
assert(Cradle_Offset + Cradle_Width / 2 <= Shoulder_Width / 2, "The cradle must stay within Shoulder_Width");
assert(Leg_Gap + 2 * Leg_Thickness <= Lower_Width, "The legs must fit within Lower_Width");
assert(Leg_Position - Leg_Width / 2 >= 0 && Leg_Position + Leg_Width / 2 <= Base_End, "The legs must sit under the base plate");
assert(Foot_Height <= Leg_Length, "Foot_Height must not exceed Leg_Length");
assert(Foot_Side == "outward" || 2 * Foot_Projection < Leg_Gap, "Inward feet must leave a gap between the legs");

module Feature(name) {
  if ($preview && Highlight == name) color(Highlight_Color) children();
  else children();
}

module Sweep(start, length) {
  translate([start, 0, 0]) rotate([90, 0, 90]) linear_extrude(length) children();
}

function ArcSteps(from, to) = ceil($fn * abs(to - from) / 360);

function ArcPoints(radius, from, to) = [
  for (i = [0:ArcSteps(from, to)])
    let (angle = from + (to - from) * i / ArcSteps(from, to)) radius * [cos(angle), sin(angle)]
];

module PlateA() {
  translate([Plate_A_Thickness, 0, Plate_Thickness / 2]) mirror([1, 0, 0]) rotate([0, -Plate_A_Angle, 0])
    translate([0, -Plate_A_Width / 2, -Plate_A_Thickness / 2]) cube([Plate_A_Length, Plate_A_Width, Plate_A_Thickness]);
}

module Shoulder() {
  translate([0, -Shoulder_Width / 2, 0]) cube([Shoulder_Length + Join_Overlap, Shoulder_Width, Plate_Thickness]);
}

module Neck() {
  translate([Neck_Start, -Neck_Width / 2, 0]) cube([Neck_Length + 2 * Join_Overlap, Neck_Width, Neck_Thickness]);
}

module BarrelSegment(radius) {
  intersection() {
    translate([0, Barrel_Center_Z]) circle(radius);
    translate([-Barrel_Width / 2, Plate_Thickness - Barrel_Depth - 1]) square([Barrel_Width, Barrel_Depth + 1]);
  }
}

module Barrel() {
  difference() {
    Sweep(Barrel_Start, Barrel_Length) BarrelSegment(Barrel_Radius);
    Sweep(Barrel_Start + Barrel_Wall, Barrel_Length - 2 * Barrel_Wall) intersection() {
      translate([0, Barrel_Center_Z]) circle(Barrel_Radius - Barrel_Wall);
      translate([-Barrel_Width / 2, -Barrel_Depth]) square([Barrel_Width, Plate_Thickness + Barrel_Depth + 1]);
    }
  }
}

module Lower() {
  translate([Lower_Start, -Lower_Width / 2, 0]) cube([Lower_Length + Join_Overlap, Lower_Width, Plate_Thickness]);
}

module TongueStrip(from, angle, length) {
  translate(from) rotate(angle) translate([0, -Tongue_Thickness / 2]) square([length, Tongue_Thickness]);
}

module Tongue() {
  start = [Base_End, Plate_Thickness / 2];
  bend = start + Tongue_Drop_Length * [cos(-Tongue_Drop_Angle), sin(-Tongue_Drop_Angle)];
  rotate([90, 0, 0]) linear_extrude(Tongue_Width, center = true) {
    TongueStrip(start, -Tongue_Drop_Angle, Tongue_Drop_Length);
    TongueStrip(bend, Tongue_Rise_Angle, Tongue_Rise_Length);
    translate(start) circle(d = Tongue_Thickness);
    translate(bend) circle(d = Tongue_Thickness);
  }
}

module Lugs() {
  for (x = [Shoulder_Length / 2, Lower_Start + Lower_Length / 2], side = [-1, 1]) {
    width = x < Neck_Start ? Shoulder_Width : Lower_Width;
    translate([x, side * (width / 2 + (Lug_Projection - Join_Overlap) / 2), Lug_Height / 2])
      cube([Lug_Length, Lug_Projection + Join_Overlap, Lug_Height], center = true);
  }
}

module Fin() {
  hull() {
    translate([Fin_Position, -Fin_Base_Thickness / 2, 0]) cube([Fin_Base_Width, Fin_Base_Thickness, Join_Overlap]);
    translate([Fin_Position + (Fin_Base_Width - Fin_Top_Width) / 2, -Fin_Top_Thickness / 2, Fin_Height - Join_Overlap])
      cube([Fin_Top_Width, Fin_Top_Thickness, Join_Overlap]);
  }
}

module Lip() {
  translate([Fin_Top_End - Lip_Length, -Fin_Top_Thickness / 2, Fin_Height - Lip_Height])
    cube([Lip_Length, Fin_Top_Thickness + Lip_Overhang, Lip_Height]);
}

module Cradle() {
  half_arc = Cradle_Arc_Angle / 2;
  translate([Cradle_Position, Cradle_Offset + Cradle_Width / 2, Cradle_Center_Z]) rotate([90, 0, 0])
    linear_extrude(Cradle_Width) polygon(concat(
      ArcPoints(Cradle_Outer_Radius, 270 - half_arc, 270 + half_arc),
      ArcPoints(Cradle_Radius, 270 + half_arc, 270 - half_arc)
    ));
}

module Foot(side) {
  face = Foot_Side == "outward" ? Leg_Gap / 2 + Leg_Thickness : Leg_Gap / 2;
  reach = Foot_Side == "outward" ? 1 : -1;
  translate([Leg_Position, side * (face + reach * (Foot_Projection - Join_Overlap) / 2), -Leg_Length + Foot_Height / 2])
    cube([Leg_Width, Foot_Projection + Join_Overlap, Foot_Height], center = true);
}

module Legs() {
  for (side = [-1, 1]) {
    translate([Leg_Position - Leg_Width / 2, side * (Leg_Gap / 2 + Leg_Thickness / 2) - Leg_Thickness / 2, -Leg_Length])
      cube([Leg_Width, Leg_Thickness, Leg_Length + Plate_Thickness / 2]);
    if (Foot_Projection > 0) Foot(side);
  }
}

module Clip() {
  Feature("plate_a") PlateA();
  Feature("shoulder") Shoulder();
  Feature("neck") Neck();
  Feature("barrel") Barrel();
  Feature("lower") Lower();
  Feature("tongue") Tongue();
  Feature("lugs") Lugs();
  Feature("fin") Fin();
  Feature("lip") Lip();
  Feature("cradle") Cradle();
  Feature("legs") Legs();
}

if (Part == "left") Clip();
else if (Part == "right") mirror([0, 1, 0]) Clip();
else {
  translate([0, -Pair_Offset, 0]) Clip();
  translate([0, Pair_Offset, 0]) mirror([0, 1, 0]) Clip();
}
