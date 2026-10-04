/**
 * Parametric pegboard holder for Ryobi 40V batteries.
 * Designed for 1/4\" pegboard with 1\" hole spacing and 1/4\" wall clearance.
 */

/* [Layout] */
// Number of battery slots side by side
Battery_Count = 2; // [1:1:6]

// Slot center-to-center spacing in pegboard holes
Slot_Spacing_Holes = 4; // [3:1:8]

// Forward tilt from vertical in degrees
Tilt_Angle = 15; // [0:5:45]

/* [Battery Rails] */
// Width across the outer edges of the battery slide rails
Rail_Width = 62.0;

// Length of rail engagement along the slide bed
Rail_Length = 80.0;

// Thickness of the battery slide flange
Rail_Thickness = 5.5;

// Thickness of the retaining lip
Rail_Lip_Thickness = 2.0;

// Undercut depth of the retaining lip
Rail_Lip_Depth = 4.5;

// Fit gap around the rails
Rail_Clearance = 0.5;

// Fillet radius on the rail lips
Rail_Lip_Radius = 1.4;

// Stress-relief fillet radius at the rail root
Rail_Root_Radius = 0.6;

// Include the central slide rails
Include_Rails = true;

/* [Slide Bed & Shelf] */
// Width of the slide bed and bottom shelf
Bed_Width = 76.0;

// Thickness of the angled slide bed
Bed_Thickness = 5.0;

// Top corner radius of the slide bed
Bed_Corner_Radius = 6.0;

// Depth of the bottom support shelf
Shelf_Depth = 8.0;

// Thickness of the bottom support shelf
Shelf_Thickness = 6.0;

// Front corner radius of the bottom shelf
Shelf_Corner_Radius = 5.0;

// Height of the integrated front toe
Toe_Height = 3.5;

// Bottom front edge radius of the toe
Toe_Radius = 1.6;

/* [Gussets] */
// Gusset style
Gusset_Style = "full_wedge"; // [full_wedge: Full-Width Sculpted Wedge, swept_ribs: Swept Architectural Ribs, buttress_wings: Sculpted Buttress Wings, classic: Classic Flat Wedges]

// Thickness of the gusset ribs
Gusset_Thickness = 5.0;

// Hollow out the wedge cavity, otherwise slicer infill fills it (full_wedge only)
Hollow_Wedge = false;

/* [Backplate] */
// Thickness of the mounting backplate
Backplate_Thickness = 5.0;

// Corner radius of the backplate perimeter
Backplate_Corner_Radius = 6.0;

// Rear top chamfer that clears the pegboard during insertion
Insertion_Chamfer = 2.0;

/* [Pegboard] */
// Pegboard hole center spacing (25.4 for 1" standard, 15.875 for 5/8" metal)
Hole_Spacing = 25.4;

// Pin diameter (5.7 for standard 1/4" hole fit, 6.0 for original Sy fit)
Pin_Diameter = 5.7;

// Pegboard thickness (6.35 for 1/4" board, 1.5875 for 1/16" thin metal)
Pegboard_Thickness = 6.35;

// Height of the retention hook tab behind the pegboard
Retention_Hook_Rise = 3.5;

// Distance from the backplate top to the retention hooks
Retention_Hook_Margin = 6.35;

// Stabilizing pins below the retention hooks
Stabilizing_Pin_Pattern = "all"; // [all: All Available Rows (1-in and 2-in), span_2: 2-in Below Only, span_1: 1-in Below Only]

/* [Screw Holes] */
// Include countersunk screw clearance holes
Include_Screw_Holes = true;

// Screw shank clearance hole diameter (#8 screw)
Screw_Hole_Diameter = 4.5;

// Screw countersink head diameter
Countersink_Diameter = 9.0;

/* [Preview] */
// Component to show, or all for the full assembly
Show_Component = "all"; // [all: All Components, backplate: Backplate, cradle: Full Cradle, slide_bed: Slide Bed, bottom_shelf: Bottom Shelf, slide_rails: Slide Rails, gussets: Gussets, retention_hooks: Retention Hooks, stabilizing_pins: Stabilizing Pins]

// Show 3D component labels in preview
Show_Labels = true;

// Label text size
Label_Size = 4.5; // [2:0.5:10]

/* [Hidden] */
$fn = 36;
render_labels = false;

EPSILON = 0.02;

slot_spacing = Slot_Spacing_Holes * Hole_Spacing;

total_width = (Battery_Count - 1) * slot_spacing + Bed_Width;

cradle_drop = (Bed_Thickness + Shelf_Depth) * sin(Tilt_Angle);
z_plate_bottom = 0;
z_shelf = z_plate_bottom + cradle_drop + Toe_Height;

h_cradle = Rail_Length * cos(Tilt_Angle);
w_cradle = Rail_Length * sin(Tilt_Angle);

z_plate_top = z_shelf + h_cradle;
backplate_height = z_plate_top - z_plate_bottom;
z_top_peg = z_plate_top - Retention_Hook_Margin;

include <components/labels.scad>
include <components/pegs.scad>
include <components/backplate.scad>
include <components/slide_bed.scad>
include <components/bottom_shelf.scad>
include <components/slide_rails.scad>
include <components/gussets.scad>
include <components/slot_cradle.scad>

// Top-level assembly orchestrator.
module ryobi_40v_battery_holder() {
  union() {
    if (is_visible("backplate")) {
      color("SlateGray") backplate();
      component_label("Backplate", [0, Backplate_Thickness + 0.5, z_plate_top + 6]);
    }

    mounting_pegs();

    for (i = [0 : Battery_Count - 1]) {
      x_center = (i - (Battery_Count - 1) / 2) * slot_spacing;
      is_first = (i == 0);
      slot_cradle(x_center, is_first);
    }
  }
}

ryobi_40v_battery_holder();
