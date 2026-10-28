/**
 * Honda CB300R chassis plugs: cosmetic caps for the open frame tubes and the pillion holder
 * tubes, modeled on Puig's finned plugs. Ribs give an interference fit; fins, flat flanges with
 * nothing under them when printed cap down, are for SLA or for experiments. Not load-bearing.
 * Print cap down, as modeled. All dimensions are in millimeters, and the defaults are the
 * chassis frame plug.
 */

/* [Cap] */
// Cap outside diameter
Cap_Diameter = 37;

// Cap thickness
Cap_Thickness = 7.5;

// Radius of the rounded cap edge (at most half the cap thickness)
Cap_Corner_Radius = 3.75;

/* [Stem] */
// Length of the stem, from the cap to the tip
Stem_Length = 16;

// Stem outside diameter, measured over the rib crests
Stem_Diameter = 20;

// Wall thickness of the cap floor and the hollow stem
Wall_Thickness = 3;

// Number of ribs along the stem (0 to disable)
Rib_Count = 10; // [0:1:20]

// Radial height of each rib
Rib_Height = 1;

// Width of the lead-in chamfer at the tip of a stem without ribs
Stem_Chamfer = 1;

/* [Fins] */
// Number of fins along the stem (0 to disable)
Fin_Count = 0; // [0:1:12]

// Fin thickness
Fin_Thickness = 0.3;

// Diameter of the fin nearest the cap
Fin_Large_Diameter = 30;

// Diameter of the fin nearest the tip
Fin_Small_Diameter = 25;

/* [Hidden] */
$fn = 128;

core_diameter = Stem_Diameter - min(1, Rib_Count) * Rib_Height;
bore_diameter = Stem_Diameter - 2 * Wall_Thickness;
fin_step = Fin_Count > 1 ? (Fin_Large_Diameter - Fin_Small_Diameter) / (Fin_Count - 1) : 0;
fin_pitch = Stem_Length / (Fin_Count + 1);
rib_pitch = Stem_Length / (Rib_Count + 1);

module cap() {
  assert(2 * Cap_Corner_Radius <= Cap_Thickness, "Cap_Corner_Radius must be at most half of Cap_Thickness");
  hull() {
    translate([0, 0, Cap_Thickness - Cap_Corner_Radius])
      rotate_extrude() translate([Cap_Diameter / 2 - Cap_Corner_Radius, 0]) circle(r = Cap_Corner_Radius);
    cylinder(d = Cap_Diameter, h = Cap_Thickness - Cap_Corner_Radius);
  }
}

module fin(diameter) {
  scale([diameter, Stem_Diameter, 1]) cylinder(d = 1, h = Fin_Thickness);
  scale([Stem_Diameter, diameter, 1]) cylinder(d = 1, h = Fin_Thickness);
}

module rib() {
  rotate_extrude() translate([(Stem_Diameter - Rib_Height) / 2, 0]) circle(r = Rib_Height / 2);
}

module stem_core() {
  assert(Stem_Chamfer < (core_diameter - bore_diameter) / 2, "Stem_Chamfer must be less than the stem wall");
  chamfer = Rib_Count == 0 ? Stem_Chamfer : 0;
  if (chamfer > 0) cylinder(d1 = core_diameter - 2 * chamfer, d2 = core_diameter, h = chamfer);
  translate([0, 0, chamfer - 0.01]) cylinder(d = core_diameter, h = Stem_Length - chamfer + 0.02);
}

module stem() {
  assert(Fin_Count == 0 || (Fin_Large_Diameter >= Stem_Diameter && Fin_Small_Diameter >= Stem_Diameter), "Fin diameters must be at least Stem_Diameter");
  difference() {
    union() {
      stem_core();
      for (i = [0:1:Fin_Count - 1])
        translate([0, 0, (i + 1) * fin_pitch - Fin_Thickness / 2]) fin(Fin_Small_Diameter + i * fin_step);
      for (i = [0:1:Rib_Count - 1])
        translate([0, 0, (i + 1) * rib_pitch - Rib_Height / 2]) rib();
    }
    translate([0, 0, -1]) cylinder(d = bore_diameter, h = Stem_Length + 2);
  }
}

module plug() {
  difference() {
    union() {
      translate([0, 0, Stem_Length]) cap();
      stem();
    }
    translate([0, 0, Stem_Length - 1]) cylinder(d = bore_diameter, h = Cap_Thickness - Wall_Thickness + 1);
  }
}

translate([0, 0, Stem_Length + Cap_Thickness]) mirror([0, 0, 1]) plug();
