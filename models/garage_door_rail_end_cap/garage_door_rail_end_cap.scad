include <BOSL2/std.scad>

/**
 * Bumper cap for the end of a garage door rail, so cabinet doors stay off the cut rail end.
 * Print closed end down, in TPU. The pocket follows the rail profile: a curved bottom, one
 * straight side, and a flange across the top. All dimensions are in millimeters.
 */

/* [Rail] */
// Overall rail height (55 for about 2-11/64")
Rail_Outer_Height = 55;

// Overall rail width (25.4 for 1")
Rail_Outer_Width = 25.4;

// Rail sheet thickness (3.175 for 1/8")
Rail_Thickness = 3.175;

// Outer radius of the curved rail bottom (11.1125 for 7/16")
Rail_Bottom_Outer_Radius = 11.1125;

/* [End Cap] */
// Wall thickness around the rail (3.175 for 1/8")
End_Cap_Wall_Thickness = 3.175;

// Cap length along the rail (12.7 for 1/2")
End_Cap_Depth = 12.7;

// Thickness of the closed end that faces the cabinet door (3.175 for 1/8")
Bumper_Thickness = 3.175;

// Extra pocket width around the rail, about 0.2 for PETG (0 to disable)
Fit_Clearance = 0;

// Radius of the rounded outer edges and bumper face (1.5875 for 1/16")
Edge_Radius = 1.5875;

// Width of the chamfer at the pocket mouth (0.79375 for 1/32")
Mouth_Chamfer = 0.79375;

/* [Hidden] */
$fn = 128;

shell_thickness = Rail_Thickness + 2 * End_Cap_Wall_Thickness;
shell_radius = Rail_Bottom_Outer_Radius + End_Cap_Wall_Thickness;
shell_height = Rail_Outer_Height + 2 * End_Cap_Wall_Thickness;
shell_width = Rail_Outer_Width + 2 * End_Cap_Wall_Thickness;
chamfer_extra = 1;

assert(End_Cap_Wall_Thickness > 0, "End_Cap_Wall_Thickness must be positive");
assert(Rail_Bottom_Outer_Radius > Rail_Thickness + End_Cap_Wall_Thickness, "Rail_Bottom_Outer_Radius must exceed Rail_Thickness plus End_Cap_Wall_Thickness");
assert(Rail_Outer_Width >= 2 * Rail_Bottom_Outer_Radius, "Rail_Outer_Width must be at least twice Rail_Bottom_Outer_Radius");
assert(Bumper_Thickness > 0 && Bumper_Thickness < End_Cap_Depth, "Bumper_Thickness must be positive and less than End_Cap_Depth");
assert(Fit_Clearance >= 0 && Fit_Clearance < End_Cap_Wall_Thickness, "Fit_Clearance must be at least 0 and less than End_Cap_Wall_Thickness");
assert(Edge_Radius >= 0 && Mouth_Chamfer >= 0, "Edge_Radius and Mouth_Chamfer must not be negative");
assert(Edge_Radius + Mouth_Chamfer + Fit_Clearance / 2 < End_Cap_Wall_Thickness, "Edge_Radius plus Mouth_Chamfer must be less than End_Cap_Wall_Thickness");
assert(Edge_Radius < Bumper_Thickness, "Edge_Radius must be less than Bumper_Thickness");

// Closed outline of the rail strip, centered on the origin: flange on top, straight side on the right, curved bottom.
function rail_path(thickness, radius, height, width) =
  let(
    cx = width / 2 - radius, cy = -height / 2 + radius, top = height / 2,
    inner = arc(r = radius - thickness, cp = [cx, cy], start = 0, angle = -180),
    outer = arc(r = radius, cp = [cx, cy], start = 180, angle = 180)
  )
  concat([[-width / 2, top], [-width / 2, top - thickness], [width / 2 - thickness, top - thickness]], inner, outer, [[width / 2, top]]);

function round_convex_corners(path, radius) =
  radius > 0 ? offset(offset(path, delta = -radius, closed = true), r = radius, closed = true) : path;

module Shell() {
  path = round_convex_corners(rail_path(shell_thickness, shell_radius, shell_height, shell_width), Edge_Radius);
  offset_sweep(
    path, height = End_Cap_Depth,
    bottom = os_circle(r = Edge_Radius), top = os_circle(r = Edge_Radius)
  );
}

module Pocket() {
  path = rail_path(Rail_Thickness, Rail_Bottom_Outer_Radius, Rail_Outer_Height, Rail_Outer_Width);
  offset_sweep(
    offset(path, delta = Fit_Clearance / 2, closed = true), height = End_Cap_Depth - Bumper_Thickness,
    top = os_chamfer(width = -Mouth_Chamfer, extra = chamfer_extra)
  );
}

difference() {
  Shell();
  up(Bumper_Thickness) Pocket();
}
