/**
 * Cap for the outside corner of a mitered sill, such as a deck sill, whose sharp butt
 * joint snags. It slips over both sills near the corner from above, rounds every outer
 * edge, and holds on with a lip under the sill. The defaults are placeholders for a
 * 1-1/4" square sill; measure yours before printing. All dimensions are in millimeters.
 */

/* [Sill] */
// Sill width across the top (31.75 for 1-1/4")
Sill_Width = 31.75;

// Sill height (31.75 for 1-1/4")
Sill_Height = 31.75;

// Interior angle between the two sills at the corner
Corner_Angle = 90; // [60:5:180]

/* [Cover] */
// Reach of the cover along each sill from the corner (50.8 for 2")
Cover_Length = 50.8;

// Cover wall thickness, also the radius of the rounded outer edges (3.175 for 1/8")
Wall_Thickness = 3.175;

// Gap between the sill and the cover
Fit_Clearance = 0.2;

// How far the lip reaches under the sill (0 to disable)
Lip_Depth = 3.175;

/* [Hidden] */
$fn = 64;

LIP_STEPS = 6;

half_angle = Corner_Angle / 2;
sill_dir = [sin(half_angle), cos(half_angle)];
sill_normal = [-cos(half_angle), sin(half_angle)];
cavity_height = Sill_Height + Fit_Clearance;

assert(Corner_Angle >= 60 && Corner_Angle <= 180, "Corner_Angle must be between 60 and 180");
assert(Lip_Depth <= Wall_Thickness, "Lip_Depth must be at most Wall_Thickness");
assert(Lip_Depth < Sill_Width / 2, "Lip_Depth must be less than half of Sill_Width");
assert(Fit_Clearance >= 0 && Fit_Clearance < Wall_Thickness, "Fit_Clearance must be non-negative and less than Wall_Thickness");

function MirrorX(p) = [-p.x, p.y];

// Outline of both sills out to the given reach, with the outer corner at the origin
function SillOutline(reach) =
  let(
    end = reach * sill_dir,
    inner_end = end + Sill_Width * sill_normal,
    inner_corner = [0, Sill_Width / sin(half_angle)]
  ) [[0, 0], end, inner_end, inner_corner, MirrorX(inner_end), MirrorX(end)];

module Footprint(reach) {
  offset(delta = Fit_Clearance) polygon(SillOutline(reach));
}

module Shell() {
  minkowski() {
    linear_extrude(height = cavity_height) Footprint(Cover_Length);
    sphere(r = Wall_Thickness, $fn = 32);
  }
}

module Cavity() {
  translate([0, 0, -0.001]) linear_extrude(height = cavity_height + 0.001) Footprint(Cover_Length + Wall_Thickness + 2);
}

// Opening under the sill that narrows toward the bottom face, leaving a lip with a 45 degree top
module LipOpening() {
  step = Wall_Thickness / LIP_STEPS;
  for (i = [0:LIP_STEPS - 1])
    translate([0, 0, -Wall_Thickness + i * step - 0.001])
      linear_extrude(height = step + 0.002)
        offset(delta = -Lip_Depth * (1 - (i + 0.5) / LIP_STEPS))
          Footprint(Cover_Length + Wall_Thickness + 2);
}

difference() {
  Shell();
  Cavity();
  LipOpening();
}
