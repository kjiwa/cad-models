/**
 * Parametric pegboard dispenser for single-edge utility razor blades.
 * Sized for metal and plastic utility blades on standard 1/4" pegboard.
 */

/* [Component Selection] */
// Component part to generate
part = "dispenser"; // [dispenser: Main Dispenser, assembly: Dispenser & Followers, follower_metal: Metal Follower Only, follower_plastic: Plastic Follower Only, followers: Both Followers]

/* [Dispenser Configuration] */
// Slot configuration pattern: M for Metal blade, P for Plastic scraper blade (e.g. "MP", "M", "P", "MMMMPPMMM")
slot_pattern = "MP";

// Override number of towers (0 automatically uses length of slot_pattern)
dispenser_count = 0; // [0:1:20]

// Total vertical height of dispenser towers in mm
dispenser_height = 100.0; // [60:5:200]

// Center-to-center spacing between towers in pegboard hole increments (1 in / 25.4 mm)
slot_spacing_pegs = 2; // [2:1:4]

/* [Blade Cavity & Exit Gates] */
// Internal blade pocket width in mm (accommodates 39.15mm plastic & 39.9mm metal blades)
chute_width = 41.0;

// Metal blade packaging type: sleeved (standard paper sleeve, 22.0mm depth) or bare (unwrapped blade, 19.5mm depth)
metal_blade_type = "sleeved"; // [sleeved: Paper-Sleeved (22.0mm depth), bare: Bare Unwrapped (19.5mm depth)]

// Internal blade pocket depth for sleeved metal blade slot in mm (accommodates 22.0mm sleeved blades)
metal_chute_depth = 23.0;

// Internal blade pocket depth for bare metal blade slot in mm (accommodates 19.5mm bare blades)
bare_metal_chute_depth = 20.5;

// Internal blade pocket depth for plastic blade slot in mm (accommodates 18.7mm plastic blades)
plastic_chute_depth = 20.0;

// Bottom exit gate height for metal blade slot in mm (sized for 1.2mm sleeved spine)
metal_exit_height = 1.7;

// Bottom exit gate height for plastic blade slot in mm (sized for 1.6mm blade body)
plastic_exit_height = 2.1;

// Legacy global chute depth override (0 uses metal_chute_depth and plastic_chute_depth)
chute_depth = 0;

/* [Grip & Front Features] */
// Width of bottom finger scoop cutout in mm
grip_notch_width = 22.0;

// Depth of bottom finger scoop cutout in mm (0 extends all the way back to chute rear wall)
grip_notch_depth = 0;

// Forward extension of front resting shelf in mm
shelf_extension = 6.0;

// Bottom width of outward flared opening ramp in mm
opening_flare_width = 26.0; // [20.0:1.0:32.0]

// Vertical height of outward flared opening ramp in mm
opening_flare_height = 12.0; // [6.0:1.0:25.0]

// Enable front vertical sight slots for visual blade inventory
enable_sight_slots = true;

// Width of front sight slot in mm
sight_slot_width = 20.0;

// Corner lead-in chamfer for top entry into the front slot in mm
slot_top_chamfer = 2.0; // [0.5:0.5:4.0]

// Enable debossed "METAL" / "PLASTIC" identification badges on front face
enable_badge_labels = true;

// Font size for front debossed text badges in mm
badge_text_size = 3.2;

// Deboss depth for front badges in mm
badge_deboss_depth = 0.6;

/* [Gravity Follower Weight] */
// Vertical thickness of follower weight in mm
follower_height = 12.0; // [8.0:1.0:20.0]

// Perimeter clearance between follower and chute pocket in mm
follower_clearance = 0.5; // [0.2:0.05:1.0]

// Protrusion of front indicator tab beyond dispenser front face in mm
follower_tab_lead = 1.5; // [0.5:0.5:3.0]

// Include internal ballast pocket for standard coins (pennies) or hex nuts
include_ballast_pocket = true;

// Width of internal ballast pocket in mm
ballast_pocket_width = 22.0;

// Depth of internal ballast pocket in mm
ballast_pocket_depth = 12.0;

// Height of internal ballast pocket in mm
ballast_pocket_height = 8.0;

/* [Pegboard & Wall Mounting] */
// Include rear pegboard mounting hooks and pins (false for flush wall mounting)
include_pegs = true;

// Include countersunk screw clearance holes in backplate
include_screw_holes = true;

// Screw shank clearance hole diameter in mm (#8 screw clearance ~4.5mm)
screw_hole_diameter = 4.5; // [3.0:0.5:6.0]

// Screw countersink flathead diameter in mm (#8 flathead ~9.0mm)
countersink_diameter = 9.0; // [6.0:0.5:12.0]

// Pegboard hole center spacing in inches
peg_hole_spacing_in = 1.0;

// Pegboard thickness in inches
pegboard_thickness_in = 0.25;

// Pin diameter in mm (sized for 1/4" holes with print tolerance)
pin_diameter = 5.7;

// Stabilizing peg pattern below upper hooks
stabilizing_peg_pattern = "bottom"; // [bottom: Bottom Row Only (Lowest Hole), top_and_bottom: Top and Bottom Rows, all: All Available Rows, none: Upper Hooks Only, span_2: 2-in Below Only, span_1: 1-in Below Only]

// Height of retention hook tab behind pegboard in mm
hook_rise = 3.5;

// Top margin above upper hooks in mm
peg_top_margin = 6.35;

// Rear top chamfer size for pegboard insertion clearance in mm
tilt_chamfer = 2.0;

/* [Structure & Sizing] */
// Thickness of mounting backplate in mm
backplate_thickness = 5.0;

// Thickness of bottom resting floor in mm
floor_thickness = 3.5;

// Thickness of rear wall between chute and backplate in mm
rear_wall_thickness = 3.5;

// Thickness of front wall in mm
front_wall_thickness = 3.5;

// Corner radius for tower body exterior in mm
tower_corner_radius = 4.0;

// Radius for softening top-left and top-right shoulders across full depth in mm
top_corner_radius = 4.0;

// Top funnel lead-in chamfer depth in mm
top_funnel_lead = 2.5;

/* [Component Inspection & Labels] */
// Show 3D text labels for components in preview
show_labels = true;

// Component to inspect (or "all" for full assembly)
view_component = "all"; // [all: All Components, backplate: Backplate, towers: Dispenser Towers, chutes: Negative Chute Space, upper_hooks: Upper Hooks, lower_pins: Lower Pins, followers: Gravity Followers]

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

actual_dispenser_count = (dispenser_count > 0) ? dispenser_count : max(len(slot_pattern), 1);
total_width = actual_dispenser_count * slot_spacing;

calibrated_metal_depth = (metal_blade_type == "bare") ? bare_metal_chute_depth : metal_chute_depth;
effective_metal_depth = (chute_depth > 0) ? chute_depth : calibrated_metal_depth;
effective_plastic_depth = (chute_depth > 0) ? chute_depth : plastic_chute_depth;
max_chute_depth = max(effective_metal_depth, effective_plastic_depth);
tower_depth = rear_wall_thickness + max_chute_depth + front_wall_thickness;

backplate_height = dispenser_height;
z_plate_bottom = 0;
z_plate_top = backplate_height;
z_top_peg = z_plate_top - peg_top_margin;
lowest_peg_k = max(floor((z_top_peg - pin_diameter / 2 - 2.0) / peg_hole_spacing), 1);

badge_z_position = dispenser_height - 18.0;
sight_slot_z_start = floor_thickness;
sight_slot_z_end = dispenser_height + EPSILON;

include <components/labels.scad>
include <components/pegs.scad>
include <components/backplate.scad>
include <components/tower_body.scad>
include <components/dispensing_chute.scad>
include <components/follower.scad>

// Top-level dispenser body assembly.
module razor_blade_dispenser_body() {
  union() {
    difference() {
      union() {
        if (is_visible("backplate")) {
          color("SlateGray") backplate();
          component_label("Backplate", [0, -0.5, z_plate_top + 6], [90, 0, 0]);
        }

        if (view_component == "chutes") {
          color("Crimson")
            for (i = [0 : actual_dispenser_count - 1]) {
              x_c = ((actual_dispenser_count - 1) / 2 - i) * slot_spacing;
              slot_cutouts(i, x_c);
            }
        } else if (is_visible("towers") || is_visible("all")) {
          color("SteelBlue")
            difference() {
              union() {
                tower_block_blank();
                tower_front_shelf();
              }

              for (i = [0 : actual_dispenser_count - 1]) {
                x_c = ((actual_dispenser_count - 1) / 2 - i) * slot_spacing;
                slot_cutouts(i, x_c);
              }

              tower_screw_access_holes();
            }
        }
      }

      // Soften top-left and top-right corners continuously across both backplate and towers
      top_corner_cutter();
    }

    mounting_pegs();
  }
}

// Top-level assembly orchestrator with follower rendering support.
module razor_blade_dispenser() {
  if (part == "follower_metal") {
    blade_follower("metal");
  } else if (part == "follower_plastic") {
    blade_follower("plastic");
  } else if (part == "followers") {
    sep = follower_width() / 2 + 4.0;
    translate([-sep, 0, 0]) blade_follower("metal");
    translate([sep, 0, 0]) blade_follower("plastic");
  } else if (part == "assembly") {
    if (view_component != "followers") {
      razor_blade_dispenser_body();
    }
    if (is_visible("all") || is_visible("followers")) {
      for (i = [0 : actual_dispenser_count - 1]) {
        x_c = ((actual_dispenser_count - 1) / 2 - i) * slot_spacing;
        chute_follower_instance(i, x_c, dispenser_height - follower_height - 6.0);
      }
    }
  } else {
    razor_blade_dispenser_body();
  }
}

razor_blade_dispenser();

