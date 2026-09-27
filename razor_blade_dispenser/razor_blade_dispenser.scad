/**
 * Parametric pegboard dual dispenser for single-edge utility razor blades.
 * Sized for metal and plastic utility blades on standard 1/4" pegboard.
 */

/* [Dispenser Configuration] */
// Number of dispenser towers side-by-side
dispenser_count = 2; // [1:1:4]

// Total vertical height of dispenser towers in mm
dispenser_height = 100.0; // [60:5:200]

// Center-to-center spacing between towers in pegboard hole increments (1 in / 25.4 mm)
slot_spacing_pegs = 2; // [2:1:4]

// Blade type for Slot 0 (left slot)
slot_0_type = "metal"; // [metal: Metal Single-Edge Blade, plastic: Plastic Razor Blade]

// Blade type for Slot 1 (right slot)
slot_1_type = "plastic"; // [metal: Metal Single-Edge Blade, plastic: Plastic Razor Blade]

/* [Blade Cavity & Exit Gates] */
// Internal blade pocket width in mm (accommodates ~39.6-40.0 mm blades)
chute_width = 40.8;

// Internal blade pocket depth in mm (accommodates ~19.0-20.0 mm blades)
chute_depth = 20.5;

// Bottom exit gate height for metal blade slot in mm (sized for ~1.1 mm spine)
metal_exit_height = 1.7;

// Bottom exit gate height for plastic blade slot in mm (sized for ~1.5 mm body)
plastic_exit_height = 2.1;

/* [Grip & Front Features] */
// Width of bottom finger scoop cutout in mm
grip_notch_width = 22.0;

// Depth of bottom finger scoop cutout under blade in mm
grip_notch_depth = 12.0;

// Forward extension of front resting shelf in mm
shelf_extension = 6.0;

// Enable front vertical sight slots for visual blade inventory
enable_sight_slots = true;

// Width of front sight slot in mm
sight_slot_width = 10.0;

// Enable debossed "METAL" / "PLASTIC" identification badges on front face
enable_badge_labels = true;

// Font size for front debossed text badges in mm
badge_text_size = 4.0;

// Deboss depth for front badges in mm
badge_deboss_depth = 0.6;

/* [Pegboard Mounting] */
// Pegboard hole center spacing in inches
peg_hole_spacing_in = 1.0;

// Pegboard thickness in inches
pegboard_thickness_in = 0.25;

// Pin diameter in mm (sized for 1/4" holes with print tolerance)
pin_diameter = 5.7;

// Stabilizing peg pattern below upper hooks
stabilizing_peg_pattern = "all"; // [all: All Available Rows (1-in and 2-in), span_2: 2-in Below Only, span_1: 1-in Below Only, none: Upper Hooks Only]

// Height of retention hook tab behind pegboard in mm
hook_rise = 3.5;

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

/* [Structure & Sizing] */
// Thickness of mounting backplate in mm
backplate_thickness = 5.0;

// Thickness of bottom resting floor in mm
floor_thickness = 3.5;

// Thickness of rear wall between chute and backplate in mm
rear_wall_thickness = 2.0;

// Thickness of front wall in mm
front_wall_thickness = 3.5;

// Corner radius for mounting backplate perimeter in mm
backplate_corner_radius = 6.0;

// Corner radius for tower body exterior in mm
tower_corner_radius = 4.0;

// Top funnel lead-in chamfer depth in mm
top_funnel_lead = 2.0;

/* [Component Inspection & Labels] */
// Show 3D text labels for components in preview
show_labels = true;

// Component to inspect (or "all" for full assembly)
view_component = "all"; // [all: All Components, backplate: Backplate, towers: Dispenser Towers, chutes: Negative Chute Space, upper_hooks: Upper Hooks, lower_pins: Lower Pins]

// Label text size in mm
label_size = 4.5;

/* [Hidden] */
$fn = 36;
render_labels = false;

EPSILON = 0.02;
INCH_TO_MM = 25.4;

peg_hole_spacing = peg_hole_spacing_in * INCH_TO_MM;
pegboard_thickness = pegboard_thickness_in * INCH_TO_MM;
slot_spacing = slot_spacing_pegs * peg_hole_spacing;

total_width = dispenser_count * slot_spacing;
tower_depth = rear_wall_thickness + chute_depth + front_wall_thickness;

backplate_height = dispenser_height;
z_plate_bottom = 0;
z_plate_top = backplate_height;
z_top_peg = z_plate_top - peg_top_margin;

badge_z_position = dispenser_height - 12.0;
sight_slot_z_start = floor_thickness;
sight_slot_z_end = badge_z_position - 6.0;

include <components/labels.scad>
include <components/pegs.scad>
include <components/backplate.scad>
include <components/tower_body.scad>
include <components/dispensing_chute.scad>

// Top-level assembly orchestrator.
module razor_blade_dispenser() {
  union() {
    if (is_visible("backplate")) {
      color("SlateGray") backplate();
      component_label("Backplate", [0, backplate_thickness + 0.5, z_plate_top + 6]);
    }

    mounting_pegs();

    if (view_component == "chutes") {
      color("Crimson")
        for (i = [0 : dispenser_count - 1]) {
          x_c = ((dispenser_count - 1) / 2 - i) * slot_spacing;
          slot_cutouts(i, x_c);
        }
    } else if (is_visible("towers") || is_visible("all")) {
      color("SteelBlue")
        difference() {
          union() {
            tower_block_blank();
            tower_front_shelf();
          }

          for (i = [0 : dispenser_count - 1]) {
            x_c = ((dispenser_count - 1) / 2 - i) * slot_spacing;
            slot_cutouts(i, x_c);
          }
        }
    }
  }
}

razor_blade_dispenser();
