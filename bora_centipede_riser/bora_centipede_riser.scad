use <threads-scad/threads.scad>;

/* [General] */
Riser_Or_Nut = "Riser";  // [Riser, Nut]

/* [Riser] */
Riser_Height = 152.4;
Riser_Diameter = 66;

/* [Riser Top Cap] */
Riser_Top_Thickness = 4;
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
Riser_Reinforcement_Style = "Flared_Ribs"; // [Flared_Ribs: Open Truss, Conical_Vault: Architectural Column, None: Unreinforced]
Riser_Support_Thickness = 3.6;
Riser_Support_Inner_Diameter = 46;
Riser_Support_Inner_Cutout_Offset = 4;
Riser_Rib_Flare_Width = 4.0;
Riser_Rib_Flare_Height = 10.0;
Riser_Cone_Height = 8.0;
Riser_Cone_Top_Diameter = 36.0;
Riser_Cone_Bottom_Diameter = 40.0;

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
  a = (Riser_Diameter - Riser_Support_Inner_Diameter) / 2;
  wl = supportCutoutHeight;
  dy = Riser_Diameter + 10;
  seg = segments > 0 ? segments : 64;

  pts = concat(
    [for (i = [0:seg])
      let(
        u = i / seg,
        x = -wl / 2 + u * wl,
        z = a * sin(u * 180)
      )
      [x, z]],
    [[wl / 2, -10], [-wl / 2, -10]]
  );

  rotate([90, 0, 0])
    linear_extrude(height=dy, center=true)
      polygon(pts);
}

module supportCutout(segments=$fn) {
  translate([Riser_Diameter / 2, 0, Riser_Bottom_Nut_Cutout_Height / 2])
    rotate([0, -90, 0]) {
      supportCutoutHalf(segments);
    }
}

module singleFlaredRib(len, th, h, f_w, f_h) {
  z_top = h / 2;
  z_bot = -h / 2;
  union() {
    cube([len, th, h], center=true);
    hull() {
      translate([0, 0, z_top - 0.05]) cube([len, th + 2 * f_w, 0.1], center=true);
      translate([0, 0, z_top - f_h]) cube([len, th, 0.1], center=true);
    }
    hull() {
      translate([0, 0, z_bot + 0.05]) cube([len, th + 2 * f_w, 0.1], center=true);
      translate([0, 0, z_bot + f_h]) cube([len, th, 0.1], center=true);
    }
  }
}

module topCapital() {
  z_top = supportHeight / 2;
  translate([0, 0, z_top - Riser_Cone_Height])
    cylinder(d1=Riser_Cone_Top_Diameter, d2=Riser_Diameter, h=Riser_Cone_Height);
}

module bottomBase() {
  z_bot = -supportHeight / 2;
  translate([0, 0, z_bot])
    cylinder(d1=Riser_Diameter, d2=Riser_Cone_Bottom_Diameter, h=Riser_Cone_Height);
}

module supports() {
  difference() {
    union() {
      if (Riser_Reinforcement_Style == "Flared_Ribs") {
        intersection() {
          cylinder(d=Riser_Diameter, h=supportHeight, center=true);
          singleFlaredRib(Riser_Diameter, Riser_Support_Thickness, supportHeight, Riser_Rib_Flare_Width, Riser_Rib_Flare_Height);
        }
        intersection() {
          cylinder(d=Riser_Diameter, h=supportHeight, center=true);
          rotate([0, 0, 90])
            singleFlaredRib(Riser_Diameter, Riser_Support_Thickness, supportHeight, Riser_Rib_Flare_Width, Riser_Rib_Flare_Height);
        }
      } else if (Riser_Reinforcement_Style == "Conical_Vault") {
        cube([Riser_Support_Thickness, Riser_Diameter, supportHeight], center=true);
        cube([Riser_Diameter, Riser_Support_Thickness, supportHeight], center=true);
        topCapital();
        bottomBase();
      } else {
        cube([Riser_Support_Thickness, Riser_Diameter, supportHeight], center=true);
        cube([Riser_Diameter, Riser_Support_Thickness, supportHeight], center=true);
      }
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
    cylinder(d=Riser_Bottom_Screw_Cutout_Diameter, h=Riser_Bottom_Thickness + 1.2);

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
