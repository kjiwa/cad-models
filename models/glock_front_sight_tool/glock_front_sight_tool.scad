include <BOSL2/std.scad>

/**
 * Alignment tool for drifting a Glock front sight: a cap that slips over the slide with a slot
 * for the sight. Print with the cavity facing down, as modeled. All dimensions are in
 * millimeters.
 */

/* [Slide] */
// Slide size: compact 21 mm, slimline 22 mm, standard 25.5 mm, wide 28.5 mm
Slide_Size = "standard"; // [compact: Compact G42, slimline: Slimline G43X G43 G48, standard: Standard G17 G19 G45 G24, wide: Wide G21 G29]

// Total clearance added to the cavity width
Slide_Clearance = 0.2;

/* [Sight] */
// Width of the sight slot
Sight_Width = 3.5;

// Length of the sight slot from the open end
Sight_Length = 10;

/* [Tool] */
// Tool height
Tool_Height = 15;

// Tool length
Tool_Length = 20;

// Wall thickness around the slide and over the sight
Wall_Thickness = 3;

// Size of the entry chamfers on the cavity and the sight slot
Entry_Chamfer = 1;

// Radius of the rounded outer edges
Edge_Radius = 1.5;

/* [Hidden] */
$fn = 128;

SLIDE_WIDTHS = [["compact", 21], ["slimline", 22], ["standard", 25.5], ["wide", 28.5]];

slide_width = SLIDE_WIDTHS[search([Slide_Size], SLIDE_WIDTHS)[0]][1];
outer_width = slide_width + 2 * Wall_Thickness;
cavity_width = slide_width + Slide_Clearance;
cavity_height = Tool_Height - Wall_Thickness;

assert(Edge_Radius <= min(Wall_Thickness, Tool_Length) / 2, "Edge_Radius must be at most half of Wall_Thickness and Tool_Length");
assert(Entry_Chamfer < Wall_Thickness, "Entry_Chamfer must be less than Wall_Thickness");
assert(Sight_Length <= Tool_Length, "Sight_Length must not exceed Tool_Length");
assert(Sight_Width + 2 * Entry_Chamfer < cavity_width, "Sight_Width plus twice Entry_Chamfer must be less than the cavity width");
assert(Sight_Length > Entry_Chamfer, "Sight_Length must exceed Entry_Chamfer");
assert(cavity_height > Entry_Chamfer, "Tool_Height must exceed Wall_Thickness plus Entry_Chamfer");

module Body() {
  cuboid(
    [Tool_Length, outer_width, Tool_Height], rounding = Edge_Radius, edges = [TOP, "Z"],
    anchor = BOTTOM + LEFT
  );
}

module Cavity() {
  half = cavity_width / 2;
  c = Entry_Chamfer;
  translate([-1, 0, 0])
    rotate([90, 0, 90])
      linear_extrude(Tool_Length + 2)
        polygon([
          [-half - c - 1, -1], [half + c + 1, -1], [half, c],
          [half, cavity_height], [-half, cavity_height], [-half, c],
        ]);
}

module SightSlot() {
  half = Sight_Width / 2;
  c = Entry_Chamfer;
  translate([0, 0, cavity_height - 1])
    linear_extrude(Wall_Thickness + 2)
      polygon([
        [-1, -half - c - 1], [c, -half], [Sight_Length, -half],
        [Sight_Length, half], [c, half], [-1, half + c + 1],
      ]);
}

difference() {
  Body();
  Cavity();
  SightSlot();
}
