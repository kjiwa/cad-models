/**
 * Standalone parametric implementation of Sy's Peglock modular pegboard system.
 */

include <BOSL2/std.scad>

DEFAULT_PEGLOCK_WIDTH = 22.0;
DEFAULT_PEGLOCK_HEIGHT = 35.4;
DEFAULT_PEGLOCK_DEPTH = 6.0;
DEFAULT_PEGLOCK_SPACING = 25.4;
DEFAULT_PEGLOCK_ROUNDOVER = 3.175;

DEFAULT_PEG_DIAMETER = 5.7;
DEFAULT_PEGBOARD_THICKNESS = 6.35;
DEFAULT_HOOK_RISE = 6.0;

function peglock_base_width(count, width = DEFAULT_PEGLOCK_WIDTH, spacing = DEFAULT_PEGLOCK_SPACING) =
  (count * spacing) - (spacing - width);

module half_sphere(r) {
  intersection() {
    sphere(r = r);
    translate([-r - 1, -r - 1, 0])
      cube([2 * r + 2, 2 * r + 2, r + 1]);
  }
}

module double(v = [1, 0, 0]) {
  children();
  mirror(v) children();
}

/**
 * Female wedge socket cutter.
 */
module PeglockHolderCutout(
  width = DEFAULT_PEGLOCK_WIDTH,
  height = DEFAULT_PEGLOCK_HEIGHT,
  depth = DEFAULT_PEGLOCK_DEPTH,
  lead_in_depth = 5.0,
  clearance = 0.25
) {
  wing_width = width / 2 - 3.0;

  double([1, 0, 0]) {
    translate([0, 0, -lead_in_depth])
      cube([3.0, depth + clearance, height + lead_in_depth]);

    translate([3.0, 0, 0]) {
      linear_extrude(height, scale = 0)
        polygon([[0, 0], [wing_width, 0], [0, depth]]);

      translate([0, 0, -lead_in_depth])
        linear_extrude(lead_in_depth)
        polygon([[0, 0], [wing_width, 0], [0, depth]]);
    }
  }
}

// Compatibility wrapper for legacy holder module
module holder(is_cutting = true) {
  if (is_cutting) {
    PeglockHolderCutout();
  } else {
    PeglockHolderCutout(lead_in_depth = 0, clearance = 0);
  }
}

/**
 * Multi-position socket array for mounting bases.
 */
module PeglockHolders(count = 1, width = DEFAULT_PEGLOCK_WIDTH, spacing = DEFAULT_PEGLOCK_SPACING) {
  translate([width / 2, 0, 0])
    for (i = [1:count]) {
      translate([(i - 1) * spacing, 0, 0])
        mirror([0, 1, 0])
        PeglockHolderCutout();
    }
}

/**
 * Accessory mounting base block with recessed Peglock wedge socket(s).
 */
module PeglockBase(
  count = 1,
  width = DEFAULT_PEGLOCK_WIDTH,
  height = DEFAULT_PEGLOCK_HEIGHT,
  depth = DEFAULT_PEGLOCK_DEPTH,
  spacing = DEFAULT_PEGLOCK_SPACING,
  roundover = DEFAULT_PEGLOCK_ROUNDOVER
) {
  x = peglock_base_width(count, width, spacing);
  translate([-x / 2, 0, -height / 2])
    difference() {
      translate([x / 2, -depth / 2, height / 2])
        cuboid([x, depth, height], rounding = roundover, except = [FRONT, BACK]);
      PeglockHolders(count = count, width = width, spacing = spacing);
    }
}


/**
 * Lower stabilizing pin printed flat (half-cylinder with hemispherical tip).
 */
module PeglockLowerPeg(diameter = DEFAULT_PEG_DIAMETER, stickout = 8.0) {
  r = diameter / 2;
  p0 = [0, 0, 0];
  p1 = [stickout, 0, 0];
  hull() {
    translate(p0) half_sphere(r);
    translate(p1) half_sphere(r);
  }
}

/**
 * Upper retention hook printed flat (straight shank, 45° elbow, vertical hook tab).
 */
module PeglockUpperPeg(diameter = DEFAULT_PEG_DIAMETER, stickout = 4.6, angle_run = 8.0, rise = DEFAULT_HOOK_RISE) {
  r = diameter / 2;
  p0 = [0, 0, 0];
  p1 = [stickout, 0, 0];
  p2 = [stickout + angle_run, angle_run, 0];
  p3 = [stickout + angle_run, angle_run + rise, 0];

  union() {
    hull() {
      translate(p0) half_sphere(r);
      translate(p1) half_sphere(r);
    }
    hull() {
      translate(p1) half_sphere(r);
      translate(p2) half_sphere(r);
    }
    hull() {
      translate(p2) half_sphere(r);
      translate(p3) half_sphere(r);
    }
  }
}

/**
 * Half of the male dovetail wedge with lead-in nose chamfer.
 */
module PeglockHalfWedge(width = DEFAULT_PEGLOCK_WIDTH, height = DEFAULT_PEGLOCK_HEIGHT, depth = DEFAULT_PEGLOCK_DEPTH) {
  wing_width = width / 2 - 3.0;

  difference() {
    union() {
      translate([0, -height / 2, 0])
        cube([depth, height, 3.0]);

      translate([0, -height / 2, 0])
        rotate([-90, 0, 0])
        rotate([0, 0, -90])
        translate([3.0, 0, 0])
        linear_extrude(height, scale = 0)
        polygon([[0, 0], [wing_width, 0], [0, depth]]);
    }

    translate([depth / 2, -height / 2, width / 2])
      rotate([45, 0, 0])
      cube([depth * 2, 2.5, 2.5], center = true);
  }
}

/**
 * Assembled half of the board attachment clip.
 */
module PeglockHalfAttachment(
  peg_spacing = DEFAULT_PEGLOCK_SPACING,
  peg_diameter = DEFAULT_PEG_DIAMETER,
  lower_stickout = 8.0,
  upper_stickout = 4.6,
  angle_run = 8.0,
  hook_rise = DEFAULT_HOOK_RISE,
  width = DEFAULT_PEGLOCK_WIDTH,
  height = DEFAULT_PEGLOCK_HEIGHT,
  depth = DEFAULT_PEGLOCK_DEPTH
) {
  union() {
    PeglockHalfWedge(width = width, height = height, depth = depth);

    translate([depth, -peg_spacing / 2, 0])
      PeglockLowerPeg(diameter = peg_diameter, stickout = lower_stickout);

    translate([depth, peg_spacing / 2, 0])
      PeglockUpperPeg(diameter = peg_diameter, stickout = upper_stickout, angle_run = angle_run, rise = hook_rise);
  }
}

/**
 * Complete printable board attachment clip with living hinge and center cutout.
 */
module PeglockAttachment(
  peg_spacing = DEFAULT_PEGLOCK_SPACING,
  peg_diameter = DEFAULT_PEG_DIAMETER,
  pegboard_thickness = DEFAULT_PEGBOARD_THICKNESS,
  hook_rise = DEFAULT_HOOK_RISE,
  width = DEFAULT_PEGLOCK_WIDTH,
  height = DEFAULT_PEGLOCK_HEIGHT,
  depth = DEFAULT_PEGLOCK_DEPTH,
  hinge_gap = 0.5,
  hinge_thickness = 0.2
) {
  low_stick = (pegboard_thickness >= 6.0) ? 8.0 : max(pegboard_thickness + 1.65, 3.0);
  up_stick = (pegboard_thickness >= 6.0) ? 4.6 : max(pegboard_thickness + 0.8, 2.0);

  y_min = min(-height / 2, -peg_spacing / 2 - peg_diameter / 2);
  y_max = max(height / 2, peg_spacing / 2 + 8.0 + hook_rise + peg_diameter / 2);
  y_offset = -(y_min + y_max) / 2;

  translate([0, y_offset, 0])
    difference() {
      union() {
        translate([hinge_gap / 2, 0, 0])
          PeglockHalfAttachment(
            peg_spacing = peg_spacing,
            peg_diameter = peg_diameter,
            lower_stickout = low_stick,
            upper_stickout = up_stick,
            hook_rise = hook_rise,
            width = width,
            height = height,
            depth = depth
          );

        mirror([1, 0, 0])
          translate([hinge_gap / 2, 0, 0])
          PeglockHalfAttachment(
            peg_spacing = peg_spacing,
            peg_diameter = peg_diameter,
            lower_stickout = low_stick,
            upper_stickout = up_stick,
            hook_rise = hook_rise,
            width = width,
            height = height,
            depth = depth
          );

        translate([0, 0, hinge_thickness / 2])
          cube([hinge_gap, height, hinge_thickness], center = true);
      }

      translate([0, 0, -1])
        cube([6.5, 14.0, width + 2], center = true);
    }
}
