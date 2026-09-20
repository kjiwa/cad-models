/**
 * Parametric pegboard holder for Ryobi 40V batteries.
 * Designed for 1/4\" pegboard with 1\" hole spacing and 1/4\" wall clearance.
 */

/* [Holder Configuration] */
// Number of battery slots side-by-side
battery_count = 2; // [1:1:6]

// Forward tilt angle from vertical to clear pegboard above
tilt_angle = 15; // [0:5:45]

// Center-to-center spacing between slots in pegboard hole increments
slot_spacing_pegs = 5; // [3:2:9]

/* [Component Inspection & Labels] */
// Show 3D text labels for components in preview
show_labels = true;

// Component to inspect (or "all" for full assembly)
view_component = "all"; // [all: All Components, backplate: Backplate, cradle: Full Cradle, slide_bed: Slide Bed, bottom_shelf: Bottom Shelf, slide_rails: Slide Rails, gussets: Gussets, upper_hooks: Upper Hooks, lower_pins: Lower Pins]

// Label text size in mm
label_size = 4.5; // [2:0.5:10]

/* [Ryobi 40V Battery Interface] */
// Width across outer edges of battery slide rails in mm
rail_width = 68.0;

// Thickness of the rail lip in mm
rail_thickness = 3.5;

// Undercut depth of the rail lip in mm
rail_lip_depth = 4.5;

// Slide rail engagement length in mm
rail_length = 75.0;

// Fit tolerance gap around rails in mm
rail_clearance = 0.5;

// Slide bed and bottom shelf width in mm
bed_width = 76.0;

// Depth of bottom support shelf in mm
bottom_shelf_depth = 7.5;

// Thickness of bottom support shelf in mm
bottom_shelf_thickness = 6.0;

// Include central slide rails
enable_rails = true;

/* [Pegboard Mounting] */
// Pegboard hole center spacing in inches
peg_hole_spacing_in = 1.0;

// Pegboard thickness in inches
pegboard_thickness_in = 0.25;

// Pin diameter in mm (sized for 1/4\" holes with print tolerance)
pin_diameter = 5.7;

// Stabilizing peg pattern below upper hooks
stabilizing_peg_pattern = "all"; // [all: All Available Rows (1-in and 2-in), span_2: 2-in Below Only, span_1: 1-in Below Only]

// Height of retention hook tab behind pegboard in mm
hook_rise = 4.0;

// Top margin above upper hooks in mm
peg_top_margin = 6.35;

// Rear top chamfer size for pegboard insertion clearance in mm
tilt_chamfer = 2.0;

// Include countersunk screw clearance holes
include_screw_holes = true;

// Screw shank clearance hole diameter in mm (#8 screw)
screw_hole_diameter = 4.5;

// Screw countersink head diameter in mm
countersink_diameter = 9.0;

/* [Structure & Reinforcement] */
// Thickness of mounting backplate in mm
backplate_thickness = 5.0;

// Thickness of support gusset ribs in mm
bracket_thickness = 5.0;

// Thickness of angled slide bed in mm
bed_thickness = 5.0;

// Corner radius for mounting backplate perimeter in mm
backplate_corner_radius = 6.0;

// Top corner radius for battery slide bed in mm
bed_corner_radius = 6.0;

// Front corner radius for bottom resting shelf in mm
shelf_corner_radius = 5.0;

// Internal fillet radius for slide rail lips in mm
rail_fillet_radius = 1.4;

// Internal stress-relief fillet radius at slide rail root in mm
rail_root_fillet = 0.6;

// Vertical height of integrated front toe in mm
toe_height = 3.5;

// Bottom front roundover chamfer in mm
toe_roundover = 1.6;

/* [Gusset Styling & Aesthetics] */
// Gusset reinforcement and aesthetic styling
gusset_style = "full_wedge"; // [full_wedge: Full-Width Sculpted Wedge, swept_ribs: Swept Architectural Ribs, buttress_wings: Sculpted Buttress Wings, classic: Classic Flat Wedges]

// Hollow out central monocoque cavity in full-width wedge (false uses slicer infill)
wedge_cored = false;

/* [Hidden] */
$fn = 36;
render_labels = false;

EPSILON = 0.02;
INCH_TO_MM = 25.4;

peg_hole_spacing = peg_hole_spacing_in * INCH_TO_MM;
pegboard_thickness = pegboard_thickness_in * INCH_TO_MM;
slot_spacing = slot_spacing_pegs * peg_hole_spacing;

total_width = (battery_count - 1) * slot_spacing + bed_width;

cradle_drop = (bed_thickness + bottom_shelf_depth) * sin(tilt_angle);
z_plate_bottom = 0;
z_shelf = z_plate_bottom + cradle_drop + toe_height;

h_cradle = rail_length * cos(tilt_angle);
w_cradle = rail_length * sin(tilt_angle);

z_plate_top = z_shelf + h_cradle;
backplate_height = z_plate_top - z_plate_bottom;
z_top_peg = z_plate_top - peg_top_margin;

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
      component_label("Backplate", [0, backplate_thickness + 0.5, z_plate_top + 6]);
    }

    mounting_pegs();

    for (i = [0 : battery_count - 1]) {
      x_center = (i - (battery_count - 1) / 2) * slot_spacing;
      is_first = (i == 0);
      slot_cradle(x_center, is_first);
    }
  }
}

ryobi_40v_battery_holder();
