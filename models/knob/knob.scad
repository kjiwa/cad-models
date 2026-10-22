include <BOSL2/std.scad>

/**
 * Knob with a through bolt bore and a hex pocket that captures a nut or bolt head, in a
 * fluted or knurled grip. The fluted grip gives the most torque; the knurled grip suits
 * a long handle. The cap plugs a pocket that opens at the top. All dimensions are in
 * millimeters, and the defaults are the stop block knob.
 */

/* [Part] */
// Part to print
Part = "knob"; // [knob: Knob, cap: Cap]

/* [Grip] */
// Rim style
Grip = "fluted"; // [fluted: Fluted, knurled: Knurled]

// Knob diameter
Diameter = 19;

// Knob height
Height = 12;

// Number of flutes around the rim
Flute_Count = 5; // [3:1:12]

// Diamond size of the knurled grip
Texture_Size = 2;

// Radius of the rounded top edge
Top_Rounding = 2;

// Chamfer of the bottom edge
Bottom_Chamfer = 1;

/* [Hardware] */
// Bolt diameter
Bolt_Diameter = 7;

// Nut or bolt head across the flats
Nut_Width = 10.825;

// Nut or bolt head thickness
Nut_Thickness = 5.5;

// End of the knob where the hex pocket opens
Pocket_End = "bottom"; // [bottom: Bottom, top: Top]

// Depth of the hex pocket (0 = auto)
Pocket_Depth = 0;

// Gap around the cap in the pocket
Cap_Clearance = 0.15;

/* [Hidden] */
$fn = 128;

FLUTE_DEPTH_RATIO = 0.1;
FLUTE_WEB = 0.85;
BORE_CHAMFER = 0.6;
CAP_CHAMFER = 0.6;
WALL_MIN = 1.2;
KNURL_DEPTH = 1;

radius = Diameter / 2;
pocket_depth = Pocket_Depth > 0 ? Pocket_Depth : Nut_Thickness;
hex_diameter = 2 * Nut_Width / sqrt(3);
flute_depth = FLUTE_DEPTH_RATIO * Diameter;
flute_sin = sin(180 / Flute_Count);
flute_center = (radius - flute_depth) / (1 - FLUTE_WEB * flute_sin);
flute_radius = FLUTE_WEB * flute_center * flute_sin;
lobe_radius = max(0.6, Diameter / 25);
cap_length = pocket_depth - Nut_Thickness;
grip_depth = Grip == "fluted" ? flute_depth : KNURL_DEPTH;

assert(Part == "knob" || Pocket_End == "top", "Part cap needs Pocket_End set to Top");
assert(Part == "knob" || cap_length > 0, "Pocket_Depth must exceed Nut_Thickness for a cap");
assert(pocket_depth < Height, "Pocket_Depth must be less than Height");
assert(Top_Rounding < Height / 2 && Bottom_Chamfer < Height / 2, "Top_Rounding and Bottom_Chamfer must be less than half of Height");
assert(Bolt_Diameter < Nut_Width, "Bolt_Diameter must be less than Nut_Width");
assert(Height - pocket_depth >= WALL_MIN, "Pocket_Depth leaves too thin a floor");
assert(
  radius - grip_depth - hex_diameter / 2 >= WALL_MIN,
  "Diameter is too small for the nut pocket"
);

function FlutedPath() =
  let(
    rough = difference(
      [circle(r = radius)],
      [for (i = [0:Flute_Count - 1]) move(flute_center * [cos(i * 360 / Flute_Count), sin(i * 360 / Flute_Count)], p = circle(r = flute_radius))]
    ),
    web = offset(rough[0], delta = -lobe_radius, closed = true)
  ) offset(web, r = lobe_radius, closed = true);

module Grip() {
  if (Grip == "fluted") {
    offset_sweep(
      FlutedPath(), height = Height,
      top = Top_Rounding > 0 ? os_circle(r = Top_Rounding) : os_profile([[0, 0]]),
      bottom = Bottom_Chamfer > 0 ? os_chamfer(width = Bottom_Chamfer) : os_profile([[0, 0]])
    );
  } else {
    cyl(
      d = Diameter, h = Height, anchor = BOTTOM,
      texture = "diamonds", tex_inset = true, tex_size = [Texture_Size, Texture_Size],
      rounding2 = Top_Rounding, chamfer1 = Bottom_Chamfer
    );
  }
}

module Bore() {
  translate([0, 0, -1]) cylinder(d = Bolt_Diameter, h = Height + 2);
  for (z = [0, Height])
    translate([0, 0, z]) mirror([0, 0, z > 0 ? 1 : 0])
      translate([0, 0, -1]) cylinder(d1 = Bolt_Diameter + 2 * BORE_CHAMFER + 2, d2 = Bolt_Diameter, h = BORE_CHAMFER + 1);
}

module Pocket() {
  z = Pocket_End == "bottom" ? -1 : Height - pocket_depth;
  translate([0, 0, z]) cylinder(d = hex_diameter, h = pocket_depth + 1, $fn = 6);
}

module Knob() {
  difference() {
    Grip();
    Bore();
    Pocket();
  }
}

module Cap() {
  d = 2 * (Nut_Width - 2 * Cap_Clearance) / sqrt(3);
  cylinder(d = d, h = cap_length - CAP_CHAMFER, $fn = 6);
  translate([0, 0, cap_length - CAP_CHAMFER])
    cylinder(d1 = d, d2 = d - 2 * CAP_CHAMFER, h = CAP_CHAMFER, $fn = 6);
}

if (Part == "knob") {
  Knob();
} else {
  Cap();
}
