include <BOSL2/std.scad>
include <peglock/peglock.scad>

/* [Peglock Attachment] */
// Pin diameter (folded). 5.7mm matches standard 1/4" pegboard; 6.0mm matches Sy original
Peg_Diameter = 5.7;

// Center-to-center hole spacing
Peg_Spacing = 25.4;

// Pegboard thickness
Pegboard_Thickness = 6.35;

// Vertical retention hook rise height
Hook_Rise = 6.0;

/* [Hidden] */
$fn = 64;

PeglockAttachment(
  peg_spacing = Peg_Spacing,
  peg_diameter = Peg_Diameter,
  pegboard_thickness = Pegboard_Thickness,
  hook_rise = Hook_Rise
);
