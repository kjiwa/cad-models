include <BOSL2/std.scad>
include <peglock/peglock.scad>

/* [Pegboard] */
// Pegboard hole center spacing (25.4 for 1" standard, 15.875 for 5/8" metal)
Hole_Spacing = 25.4;

// Pin diameter (5.7 for standard 1/4" hole fit, 6.0 for original Sy fit)
Pin_Diameter = 5.7;

// Pegboard thickness (6.35 for 1/4" board, 1.5875 for 1/16" thin metal)
Pegboard_Thickness = 6.35;

// Height of the retention hook tab behind the pegboard
Retention_Hook_Rise = 6.0;

/* [Hidden] */
$fn = 64;

PeglockAttachment(
  peg_spacing = Hole_Spacing,
  peg_diameter = Pin_Diameter,
  pegboard_thickness = Pegboard_Thickness,
  hook_rise = Retention_Hook_Rise
);
