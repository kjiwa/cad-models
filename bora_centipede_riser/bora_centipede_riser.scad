use <threads-scad/threads.scad>;

/* [General] */
Riser_Or_Nut = "Riser";  // [Riser, Nut]

/* [Riser] */
Riser_Height = 152.4;
Riser_Diameter = 66;

/* [Riser Top Cap] */
Riser_Top_Thickness = 3;
Riser_Top_Thread_Platform_Diameter = 15;
Riser_Top_Thread_Platform_Height = 6;
Riser_Top_Thread_Pitch = 2;
Riser_Top_Thread_Height = 10;
Riser_Top_Thread_Width = 12.5;

/* [Riser Bottom Cap] */
Riser_Bottom_Thickness = 6;
Riser_Bottom_Screw_Cutout_Diameter = 16;
Riser_Bottom_Nut_Cutout_Diameter = 27;
Riser_Bottom_Nut_Cutout_Height = 32.75;
Riser_Bottom_Nut_Cutout_Corner_Radius = 6.25;

/* [Supports] */
Riser_Support_Thickness = 3;
Riser_Support_Inner_Diameter = 46;
Riser_Support_Inner_Cutout_Offset = 4;

/* [Nut] */
Nut_Diameter = 22;
Nut_Height = 6.35;
Nut_Thread_Width = 13.5;
Nut_Knurl_Count = 15;
Nut_Knurl_Diameter = 1;

/* [Hidden] */
$fn = 128;

supportHeight = Riser_Height - Riser_Top_Thickness - Riser_Bottom_Thickness;
supportCutoutHeight = supportHeight - Riser_Bottom_Nut_Cutout_Height - 2 * (Riser_Support_Inner_Cutout_Offset);

module centeredRoundedCylinderEnd(d, h, cr) {
  cylinder(d=d - (2 * cr), h=2 * cr, center=true);
  rotate_extrude(angle=360) translate([(d / 2) - cr, 0]) circle(r=cr);
}

module roundedCylinder(d, h, cr, center=false) {
  translate([0, 0, center ? 0 : h / 2]) {
    innerHeight = h - 2 * cr;
    cylinder(d=d, h=innerHeight, center=true);
    translate([0, 0, -innerHeight / 2]) centeredRoundedCylinderEnd(d, h, cr);
    translate([0, 0, innerHeight / 2]) centeredRoundedCylinderEnd(d, h, cr);
  }
}

module supportCutoutHalf(segments=$fn) {
  dx = 1e-6;
  dy = Riser_Support_Thickness + 1;
  dz = 1e-6;

  a = (Riser_Diameter - Riser_Support_Inner_Diameter) / 2;
  wl = supportHeight - (2 * Riser_Support_Inner_Cutout_Offset) - Riser_Bottom_Nut_Cutout_Height;
  k = 180 / wl;
  step = wl / segments;

  translate([-wl / 2, 0, 0]) {
    hull() {
      for (x = [0:step:wl - step]) {
        z0 = a * sin(x * k);
        z1 = a * sin((x + step) * k);
        hull() {
          translate([x, 0, z0]) rotate([90, 0, 0]) cylinder(d=dx, h=dy, center=true);
          translate([x + step, 0, z1]) rotate([90, 0, 0]) cylinder(d=dx, h=dy, center=true);
        }
      }
    }
  }

  translate([0, 0, -0.5]) cube([wl, dy, 1], center=true);
}

module supportCutout(segments=$fn) {
  translate([Riser_Diameter / 2, 0, Riser_Bottom_Nut_Cutout_Height / 2])
    rotate([0, -90, 0]) {
      supportCutoutHalf(segments);
    }
}

module supports() {
  difference() {
    union() {
      cube([Riser_Support_Thickness, Riser_Diameter, supportHeight], center=true);
      cube([Riser_Diameter, Riser_Support_Thickness, supportHeight], center=true);
    }

    supportCutout();
    rotate([0, 0, 90]) supportCutout();
    rotate([0, 0, 180]) supportCutout();
    rotate([0, 0, 270]) supportCutout();
  }
}

module topCap() {
  translate([0, 0, supportHeight / 2]) {
    cylinder(d=Riser_Diameter, h=Riser_Top_Thickness);
    translate([0, 0, Riser_Top_Thickness]) cylinder(d=Riser_Top_Thread_Platform_Diameter, h=Riser_Top_Thread_Platform_Height);
    translate([0, 0, Riser_Top_Thickness + Riser_Top_Thread_Platform_Height])
      ScrewThread(outer_diam=Riser_Top_Thread_Width, height=Riser_Top_Thread_Height, pitch=Riser_Top_Thread_Pitch);
  }
}

module bottomCap() {
  translate([0, 0, -Riser_Bottom_Thickness - supportHeight / 2])
    cylinder(d= Riser_Diameter, h=Riser_Bottom_Thickness);
}

module bottomCutout() {
  // Screw cutout
  translate([0, 0, -supportHeight / 2 - Riser_Bottom_Thickness - 1])
    cylinder(d=Riser_Bottom_Screw_Cutout_Diameter, h=Riser_Bottom_Thickness + 1);

  // Nut cutout
  translate([0, 0, -Riser_Bottom_Nut_Cutout_Corner_Radius - supportHeight / 2])
    difference() {
      roundedCylinder(
        d=Riser_Bottom_Nut_Cutout_Diameter,
        h=Riser_Bottom_Nut_Cutout_Height + Riser_Bottom_Nut_Cutout_Corner_Radius,
        cr=Riser_Bottom_Nut_Cutout_Corner_Radius);
      cylinder(d=Riser_Bottom_Nut_Cutout_Diameter + 1, h=Riser_Bottom_Nut_Cutout_Corner_Radius);
    }
}

module Riser() {
  difference() {
    union() {
      supports();
      topCap();
      bottomCap();
    }

    bottomCutout();
  }
}

module Nut() {
  difference() {
    ScrewHole(outer_diam=Nut_Thread_Width, height=Nut_Height, pitch=Riser_Top_Thread_Pitch)
      cylinder(d=Nut_Diameter, h=Nut_Height);

    for (i = [0:Nut_Knurl_Count - 1]) {
      rotate([0, 0, 360 * i / Nut_Knurl_Count])
        translate([Nut_Diameter / 2, 0, -0.5])
        cylinder(d=Nut_Knurl_Diameter, h=Nut_Height + 1);
    }
  }
}

if (Riser_Or_Nut == "Riser") {
  Riser();
} else if (Riser_Or_Nut == "Nut" || Model == "Nut") {
  Nut();
}
