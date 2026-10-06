/**
 * Independent parametric implementation of Sy's Peglock modular pegboard
 * mounting interface (male wedge / female socket, plus the pegboard-facing
 * clip pegs). Geometry re-derived from Sy's published reference files
 * (Printables model 249871): socket/wedge envelope and peg reach measured
 * from "Board Attachment (Universal).stl" and "Template Plate.stl", not
 * ported from any third-party OpenSCAD reimplementation.
 */

include <BOSL2/std.scad>

// Socket/wedge interface envelope, measured from Sy's reference geometry.
SOCKET_WIDTH = 22.0;
SOCKET_HEIGHT = 35.4;
SOCKET_DEPTH = 6.0;
SOCKET_SPACING = 25.4;
SOCKET_ROUNDOVER = 3.175;
SOCKET_WALL = 3.0;          // Flat wall thickness between the socket cutout and the base edge.
SOCKET_CLEARANCE = 0.25;    // Radial fit clearance cut into the female socket.
SOCKET_LEAD_IN = 5.0;       // Depth of the entry chamfer below the socket mouth.

// Clip peg geometry: defaults come from lib/pegboard/pegs.scad, whose
// 5.7 mm/6.35 mm fit is print-tested against 1/4" pegboard; Sy's own
// reference part measures ~6.0 mm and is offered as a preset, not the default.
DEFAULT_PEG_DIAMETER = 5.7;
DEFAULT_PEGBOARD_THICKNESS = 6.35;
DEFAULT_HOOK_RISE = 6.0;

function peglock_base_width(count, width = SOCKET_WIDTH, spacing = SOCKET_SPACING) =
  (count * spacing) - (spacing - width);

// Mirrors children across a plane through the origin, keeping both copies.
module mirrored_pair(axis = [1, 0, 0]) {
  children();
  mirror(axis) children();
}

// A sphere clipped to its z>=0 half, used as a rounded joint that keeps a
// swept path flat-printable (no geometry crosses back below the print bed).
module flat_capped_sphere(r) {
  intersection() {
    sphere(r = r);
    translate([-r - 1, -r - 1, 0])
      cube([2 * r + 2, 2 * r + 2, r + 1]);
  }
}

// Traces a capsule (constant-diameter rounded rod) through a polyline path
// by hulling consecutive flat-capped sphere joints pairwise. The path must
// lie in the z=0 plane so each joint's flat cap stays coplanar with it.
module capsule_path(path, diameter) {
  r = diameter / 2;
  for (i = [0 : len(path) - 2]) {
    hull() {
      translate(path[i]) flat_capped_sphere(r);
      translate(path[i + 1]) flat_capped_sphere(r);
    }
  }
}

// Half of the female socket cutout: a flat entry slot plus a tapered wedge
// pocket, both extended below the mouth by a lead-in chamfer for print-in-place
// insertion tolerance.
module socket_half_cutout(
  width = SOCKET_WIDTH,
  height = SOCKET_HEIGHT,
  depth = SOCKET_DEPTH,
  wall = SOCKET_WALL,
  lead_in = SOCKET_LEAD_IN,
  clearance = SOCKET_CLEARANCE
) {
  wedge_reach = width / 2 - wall;

  translate([0, 0, -lead_in])
    cube([wall, depth + clearance, height + lead_in]);

  translate([wall, 0, 0]) {
    linear_extrude(height, scale = 0)
      polygon([[0, 0], [wedge_reach, 0], [0, depth]]);

    translate([0, 0, -lead_in])
      linear_extrude(lead_in)
      polygon([[0, 0], [wedge_reach, 0], [0, depth]]);
  }
}

// Full female socket cutout (both wall sides) at the origin.
module socket_cutout(width = SOCKET_WIDTH, height = SOCKET_HEIGHT, depth = SOCKET_DEPTH) {
  mirrored_pair() socket_half_cutout(width = width, height = height, depth = depth);
}

// Row of evenly spaced socket cutouts for a multi-position mounting base.
module socket_row(count = 1, width = SOCKET_WIDTH, spacing = SOCKET_SPACING, height = SOCKET_HEIGHT, depth = SOCKET_DEPTH) {
  translate([width / 2, 0, 0])
    for (i = [1 : count]) {
      translate([(i - 1) * spacing, 0, 0])
        mirror([0, 1, 0])
        socket_cutout(width = width, height = height, depth = depth);
    }
}

/**
 * Accessory mounting base block with one or more recessed sockets.
 */
module PeglockBase(
  count = 1,
  width = SOCKET_WIDTH,
  height = SOCKET_HEIGHT,
  depth = SOCKET_DEPTH,
  spacing = SOCKET_SPACING,
  roundover = SOCKET_ROUNDOVER
) {
  x = peglock_base_width(count, width, spacing);
  translate([-x / 2, 0, -height / 2])
    difference() {
      translate([x / 2, -depth / 2, height / 2])
        cuboid([x, depth, height], rounding = roundover, except = [FRONT, BACK]);
      socket_row(count = count, width = width, spacing = spacing, height = height, depth = depth);
    }
}

/**
 * Lower stabilizing peg: a straight capsule normal to the board.
 */
module PeglockLowerPeg(diameter = DEFAULT_PEG_DIAMETER, stickout = 8.0) {
  capsule_path([[0, 0, 0], [stickout, 0, 0]], diameter);
}

/**
 * Upper retention peg: straight shank, 45-degree elbow, then a vertical hook
 * tab that catches behind the pegboard.
 */
module PeglockUpperPeg(diameter = DEFAULT_PEG_DIAMETER, stickout = 4.6, angle_run = 8.0, rise = DEFAULT_HOOK_RISE) {
  path = [
    [0, 0, 0],
    [stickout, 0, 0],
    [stickout + angle_run, angle_run, 0],
    [stickout + angle_run, angle_run + rise, 0],
  ];
  capsule_path(path, diameter);
}

/**
 * Half of the male dovetail wedge: a flat wall plus a tapered wing, with a
 * 45-degree lead-in chamfer cut across the nose for socket entry.
 */
module wedge_half(width = SOCKET_WIDTH, height = SOCKET_HEIGHT, depth = SOCKET_DEPTH, wall = SOCKET_WALL) {
  wedge_reach = width / 2 - wall;

  difference() {
    union() {
      translate([0, -height / 2, 0])
        cube([depth, height, wall]);

      translate([0, -height / 2, 0])
        rotate([-90, 0, 0])
        rotate([0, 0, -90])
        translate([wall, 0, 0])
        linear_extrude(height, scale = 0)
        polygon([[0, 0], [wedge_reach, 0], [0, depth]]);
    }

    translate([depth / 2, -height / 2, width / 2])
      rotate([45, 0, 0])
      cube([depth * 2, 2.5, 2.5], center = true);
  }
}

/**
 * One printed half of the board attachment: wedge plus its lower and upper
 * pegs, all coplanar for flat printing.
 */
module PeglockHalfAttachment(
  peg_spacing = SOCKET_SPACING,
  peg_diameter = DEFAULT_PEG_DIAMETER,
  lower_stickout = 8.0,
  upper_stickout = 4.6,
  angle_run = 8.0,
  hook_rise = DEFAULT_HOOK_RISE,
  width = SOCKET_WIDTH,
  height = SOCKET_HEIGHT,
  depth = SOCKET_DEPTH
) {
  wedge_half(width = width, height = height, depth = depth);

  translate([depth, -peg_spacing / 2, 0])
    PeglockLowerPeg(diameter = peg_diameter, stickout = lower_stickout);

  translate([depth, peg_spacing / 2, 0])
    PeglockUpperPeg(diameter = peg_diameter, stickout = upper_stickout, angle_run = angle_run, rise = hook_rise);
}

// Scales peg reach down for thinner pegboard so the folded pegs don't overshoot the back face.
function scaled_lower_stickout(pegboard_thickness) =
  (pegboard_thickness >= 6.0) ? 8.0 : max(pegboard_thickness + 1.65, 0);

function scaled_upper_stickout(pegboard_thickness) =
  (pegboard_thickness >= 6.0) ? 4.6 : max(pegboard_thickness + 0.8, 0);

/**
 * Complete printable board attachment clip: two mirrored wedge+peg halves
 * joined by a living hinge, with a center relief cutout so the folded part
 * clears the pegboard's front face.
 */
module PeglockAttachment(
  peg_spacing = SOCKET_SPACING,
  peg_diameter = DEFAULT_PEG_DIAMETER,
  pegboard_thickness = DEFAULT_PEGBOARD_THICKNESS,
  hook_rise = DEFAULT_HOOK_RISE,
  width = SOCKET_WIDTH,
  height = SOCKET_HEIGHT,
  depth = SOCKET_DEPTH,
  hinge_gap = 0.5,
  hinge_thickness = 0.2
) {
  low_stick = scaled_lower_stickout(pegboard_thickness);
  up_stick = scaled_upper_stickout(pegboard_thickness);

  y_min = min(-height / 2, -peg_spacing / 2 - peg_diameter / 2);
  y_max = max(height / 2, peg_spacing / 2 + 8.0 + hook_rise + peg_diameter / 2);
  y_offset = -(y_min + y_max) / 2;

  translate([0, y_offset, 0])
    difference() {
      union() {
        translate([hinge_gap / 2, 0, 0]) PeglockHalfAttachment(
          peg_spacing = peg_spacing, peg_diameter = peg_diameter,
          lower_stickout = low_stick, upper_stickout = up_stick,
          hook_rise = hook_rise, width = width, height = height, depth = depth
        );

        mirror([1, 0, 0]) translate([hinge_gap / 2, 0, 0]) PeglockHalfAttachment(
          peg_spacing = peg_spacing, peg_diameter = peg_diameter,
          lower_stickout = low_stick, upper_stickout = up_stick,
          hook_rise = hook_rise, width = width, height = height, depth = depth
        );

        translate([0, 0, hinge_thickness / 2])
          cube([hinge_gap, height, hinge_thickness], center = true);
      }

      translate([0, 0, -1])
        cube([6.5, 14.0, width + 2], center = true);
    }
}
