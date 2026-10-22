use <threads-scad/threads.scad>;

/* [Part] */
// Component to render
Part = "riser"; // [riser: Riser, nut: Nut]

/* [Body] */
// Overall riser height (152.4 for 6", 133.35 for 5.25")
Height = 152.4;

// Outside diameter of the riser body
Diameter = 66;

/* [Top] */
// Thickness of the top plate
Top_Thickness = 4;

// Diameter of the raised boss under the threaded stud
Stud_Base_Diameter = 15;

// Height of the raised boss under the threaded stud
Stud_Base_Height = 6;

/* [Bottom] */
// Thickness of the bottom plate
Bottom_Thickness = 6;

// Diameter of the mounting bolt clearance hole
Bolt_Hole_Diameter = 16;

// Diameter of the stand nut recess
Nut_Recess_Diameter = 27;

// Depth of the stand nut recess
Nut_Recess_Height = 32.75;

// Corner radius of the stand nut recess
Nut_Recess_Radius = 6.25;

/* [Reinforcement] */
// Reinforcement between the top and bottom plates
Reinforcement_Style = "flared_ribs"; // [flared_ribs: Flared Ribs, conical_vault: Conical Vault, none: Straight Webs]

// Thickness of the crossed vertical webs
Web_Thickness = 3.6;

// Diameter of the arched cutouts between the webs
Arch_Inner_Diameter = 46;

// Distance from each plate to the ends of the arched cutouts
Arch_End_Margin = 4;

// Sideways flare added to each web at the plates (flared_ribs only)
Rib_Flare_Width = 4.0;

// Height of the web flare transition (flared_ribs only)
Rib_Flare_Height = 10.0;

// Height of the top and bottom cones (conical_vault only)
Cone_Height = 8.0;

// Narrow end diameter of the top cone (conical_vault only)
Cone_Top_Diameter = 36.0;

// Narrow end diameter of the bottom cone (conical_vault only)
Cone_Bottom_Diameter = 40.0;

/* [Thread] */
// Thread pitch shared by the stud and the nut
Thread_Pitch = 2;

// Outer diameter of the threaded stud
Stud_Thread_Diameter = 12.5;

// Length of the threaded stud
Stud_Thread_Length = 10;

// Nominal diameter of the nut thread, including clearance
Nut_Thread_Diameter = 13.5;

/* [Nut] */
// Outside diameter of the locking nut
Nut_Diameter = 22;

// Thickness of the locking nut
Nut_Height = 6.35;

// Number of grip notches around the perimeter
Knurl_Count = 15; // [3:1:40]

// Diameter of each grip notch
Knurl_Diameter = 1;

/* [Hidden] */
$fn = 128;

supportHeight = Height - Top_Thickness - Bottom_Thickness;
supportCutoutHeight = supportHeight - Nut_Recess_Height - 2 * Arch_End_Margin;

module centeredRoundedCylinderEnd(d, cr) {
  cylinder(d=d - (2 * cr), h=2 * cr, center=true);
  rotate_extrude(angle=360) translate([(d / 2) - cr, 0]) circle(r=cr);
}

module roundedCylinder(d, h, cr, center=false) {
  translate([0, 0, center ? 0 : h / 2]) {
    innerHeight = h - 2 * cr;
    cylinder(d=d, h=innerHeight, center=true);
    translate([0, 0, -innerHeight / 2]) centeredRoundedCylinderEnd(d, cr);
    translate([0, 0, innerHeight / 2]) centeredRoundedCylinderEnd(d, cr);
  }
}

module supportCutoutHalf(segments=$fn) {
  a = (Diameter - Arch_Inner_Diameter) / 2;
  wl = supportCutoutHeight;
  dy = Diameter + 10;
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
  translate([Diameter / 2, 0, Nut_Recess_Height / 2])
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
  translate([0, 0, z_top - Cone_Height])
    cylinder(d1=Cone_Top_Diameter, d2=Diameter, h=Cone_Height);
}

module bottomBase() {
  z_bot = -supportHeight / 2;
  translate([0, 0, z_bot])
    cylinder(d1=Diameter, d2=Cone_Bottom_Diameter, h=Cone_Height);
}

module supports() {
  difference() {
    union() {
      if (Reinforcement_Style == "flared_ribs") {
        intersection() {
          cylinder(d=Diameter, h=supportHeight, center=true);
          singleFlaredRib(Diameter, Web_Thickness, supportHeight, Rib_Flare_Width, Rib_Flare_Height);
        }
        intersection() {
          cylinder(d=Diameter, h=supportHeight, center=true);
          rotate([0, 0, 90])
            singleFlaredRib(Diameter, Web_Thickness, supportHeight, Rib_Flare_Width, Rib_Flare_Height);
        }
      } else if (Reinforcement_Style == "conical_vault") {
        cube([Web_Thickness, Diameter, supportHeight], center=true);
        cube([Diameter, Web_Thickness, supportHeight], center=true);
        topCapital();
        bottomBase();
      } else {
        cube([Web_Thickness, Diameter, supportHeight], center=true);
        cube([Diameter, Web_Thickness, supportHeight], center=true);
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
    cylinder(d=Diameter, h=Top_Thickness);
    translate([0, 0, Top_Thickness]) cylinder(d=Stud_Base_Diameter, h=Stud_Base_Height);
    translate([0, 0, Top_Thickness + Stud_Base_Height])
      ScrewThread(outer_diam=Stud_Thread_Diameter, height=Stud_Thread_Length, pitch=Thread_Pitch);
  }
}

module bottomCap() {
  translate([0, 0, -Bottom_Thickness - supportHeight / 2])
    cylinder(d= Diameter, h=Bottom_Thickness);
}

module bottomCutout() {
  // Screw cutout
  translate([0, 0, -supportHeight / 2 - Bottom_Thickness - 1])
    cylinder(d=Bolt_Hole_Diameter, h=Bottom_Thickness + 1.2);

  // Nut cutout
  translate([0, 0, -Nut_Recess_Radius - supportHeight / 2])
    difference() {
      roundedCylinder(
        d=Nut_Recess_Diameter,
        h=Nut_Recess_Height + Nut_Recess_Radius,
        cr=Nut_Recess_Radius);
      cylinder(d=Nut_Recess_Diameter + 1, h=Nut_Recess_Radius);
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
    ScrewHole(outer_diam=Nut_Thread_Diameter, height=Nut_Height, pitch=Thread_Pitch)
      cylinder(d=Nut_Diameter, h=Nut_Height);

    for (i = [0:Knurl_Count - 1]) {
      rotate([0, 0, 360 * i / Knurl_Count])
        translate([Nut_Diameter / 2, 0, -0.5])
        cylinder(d=Knurl_Diameter, h=Nut_Height + 1);
    }
  }
}

if (Part == "riser") {
  Riser();
} else if (Part == "nut") {
  Nut();
}
