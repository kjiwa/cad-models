/**
 * Parametric pegboard dispenser for single-edge utility razor blades.
 * Sized for metal and plastic utility blades on standard 1/4" pegboard.
 */

/* [Part] */
// Part to generate
Part = "dispenser"; // [dispenser: Main Dispenser, assembly: Dispenser & Followers, follower_metal: Metal Follower Only, follower_plastic: Plastic Follower Only, followers: Both Followers]

/* [Layout] */
// Slot pattern: M for metal blade, P for plastic scraper blade (e.g. "MP", "M", "P", "MMMMPPMMM")
Slot_Pattern = "MP";

// Number of towers (0 = one per character of Slot_Pattern)
Tower_Count = 0; // [0:1:20]

// Total height of the towers and backplate
Tower_Height = 100.0; // [60:5:200]

// Tower center-to-center spacing in pegboard holes
Slot_Spacing_Holes = 2; // [2:1:4]

/* [Blade Chute] */
// Blade pocket width (fits 39.15 plastic and 39.9 metal blades)
Chute_Width = 41.0;

// Metal blade packaging (sleeved is the standard paper sleeve, bare is an unwrapped blade)
Metal_Blade_Packaging = "sleeved"; // [sleeved: Paper-Sleeved (22.0 depth), bare: Bare Unwrapped (19.5 depth)]

// Blade pocket depth for sleeved metal blades (fits 22.0)
Sleeved_Metal_Chute_Depth = 23.0;

// Blade pocket depth for bare metal blades (fits 19.5)
Bare_Metal_Chute_Depth = 20.5;

// Blade pocket depth for plastic blades (fits 18.7)
Plastic_Chute_Depth = 20.0;

// Bottom exit gate height for metal blades (fits a 1.2 sleeved spine)
Metal_Exit_Height = 1.7;

// Bottom exit gate height for plastic blades (fits a 1.6 blade body)
Plastic_Exit_Height = 2.1;

/* [Tower Body] */
// Thickness of the bottom floor
Floor_Thickness = 3.5;

// Thickness of the rear wall between chute and backplate
Rear_Wall_Thickness = 3.5;

// Thickness of the front wall
Front_Wall_Thickness = 3.5;

// Corner radius of the tower exterior
Tower_Corner_Radius = 4.0;

// Radius of the top left and right shoulders across the full depth
Shoulder_Radius = 4.0;

// Lead-in chamfer depth at the top of the chute
Top_Funnel_Chamfer = 2.5;

/* [Front Access] */
// Forward extension of the front resting shelf
Front_Shelf_Depth = 6.0;

// Width of the bottom finger notch
Finger_Notch_Width = 22.0;

// Depth of the bottom finger notch (0 = full depth to the chute rear wall)
Finger_Notch_Depth = 0;

// Bottom width of the flared opening ramp
Opening_Flare_Width = 26.0; // [20.0:1.0:32.0]

// Height of the flared opening ramp
Opening_Flare_Height = 12.0; // [6.0:1.0:25.0]

// Include front vertical sight slots to see the blade inventory
Include_Sight_Slots = true;

// Width of the front sight slot
Sight_Slot_Width = 20.0;

// Lead-in chamfer at the top of the sight slot
Sight_Slot_Top_Chamfer = 2.0; // [0.5:0.5:4.0]

/* [Badges] */
// Include debossed "METAL" and "PLASTIC" badges on the front face
Include_Badges = true;

// Font size of the badge text
Badge_Text_Size = 3.2;

// Deboss depth of the badge text
Badge_Depth = 0.6;

/* [Follower] */
// Coin used as ballast (sets the cradle size and minimum height)
Coin_Type = "penny"; // [penny: US/Canadian Penny (19.05), nickel: US Nickel (21.21), quarter: US/Canadian Quarter (24.26), custom: Custom Pocket Dimensions]

// Follower height (0 = coin diameter plus 2.5 floor)
Follower_Height = 0; // [0:1:35]

// Perimeter clearance between the follower and chute pocket
Follower_Clearance = 0.5; // [0.2:0.05:1.0]

// Protrusion of the front indicator tab beyond the dispenser front face
Follower_Tab_Protrusion = 1.5; // [0.5:0.5:3.0]

// Include an internal ballast pocket for coins or custom ballast
Include_Ballast_Pocket = true;

// Ballast pocket width (custom only)
Custom_Pocket_Width = 22.0;

// Ballast pocket depth (custom only)
Custom_Pocket_Depth = 12.0;

// Ballast pocket height (custom only)
Custom_Pocket_Height = 8.0;

/* [Backplate] */
// Thickness of the mounting backplate
Backplate_Thickness = 5.0;

// Rear top chamfer that clears the pegboard during insertion
Insertion_Chamfer = 2.0;

/* [Pegboard] */
// Include rear pegboard retention hooks and stabilizing pins (off for flush wall mounting)
Include_Pegs = true;

// Pegboard hole center spacing (25.4 for 1" standard, 15.875 for 5/8" metal)
Hole_Spacing = 25.4;

// Pin diameter (5.7 for standard 1/4" hole fit, 6.0 for original Sy fit)
Pin_Diameter = 5.7;

// Pegboard thickness (6.35 for 1/4" board, 1.5875 for 1/16" thin metal)
Pegboard_Thickness = 6.35;

// Height of the retention hook tab behind the pegboard
Retention_Hook_Rise = 3.5;

// Stabilizing pin rows below the retention hooks (ignored by the Peglock socket mount)
Stabilizing_Pin_Pattern = "bottom"; // [all: All Rows, top_and_bottom: Top and Bottom Rows, top: Top Row Only, bottom: Bottom Row Only (Lowest Hole), none: Retention Hooks Only]

// Distance from the backplate top to the retention hooks
Retention_Hook_Margin = 6.35;

/* [Screw Holes] */
// Include countersunk screw clearance holes
Include_Screw_Holes = true;

// Screw shank clearance hole diameter (#8 screw)
Screw_Hole_Diameter = 4.5; // [3.0:0.5:6.0]

// Screw countersink head diameter
Countersink_Diameter = 9.0; // [6.0:0.5:12.0]

/* [Preview] */
// Component to show, or all for the full assembly
Show_Component = "all"; // [all: All Components, backplate: Backplate, towers: Dispenser Towers, chutes: Negative Chute Space, retention_hooks: Retention Hooks, stabilizing_pins: Stabilizing Pins, followers: Gravity Followers]

// Show 3D component labels in preview
Show_Labels = true;

// Label text size
Label_Size = 4.5;

/* [Hidden] */
$fn = 36;
render_labels = false;

EPSILON = 0.02;

slot_spacing = Slot_Spacing_Holes * Hole_Spacing;

actual_dispenser_count = (Tower_Count > 0) ? Tower_Count : max(len(Slot_Pattern), 1);
total_width = actual_dispenser_count * slot_spacing;

effective_metal_depth = (Metal_Blade_Packaging == "bare") ? Bare_Metal_Chute_Depth : Sleeved_Metal_Chute_Depth;
effective_plastic_depth = Plastic_Chute_Depth;
max_chute_depth = max(effective_metal_depth, effective_plastic_depth);
tower_depth = Rear_Wall_Thickness + max_chute_depth + Front_Wall_Thickness;

backplate_height = Tower_Height;
z_plate_bottom = 0;
z_plate_top = backplate_height;
z_top_peg = z_plate_top - Retention_Hook_Margin;
lowest_peg_k = max(floor((z_top_peg - Pin_Diameter / 2 - 2.0) / Hole_Spacing), 1);

badge_z_position = Tower_Height - 18.0;
sight_slot_z_start = Floor_Thickness;
sight_slot_z_end = Tower_Height + EPSILON;

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

        if (Show_Component == "chutes") {
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
  if (Part == "follower_metal") {
    blade_follower("metal");
  } else if (Part == "follower_plastic") {
    blade_follower("plastic");
  } else if (Part == "followers") {
    sep = follower_width() / 2 + 4.0;
    translate([-sep, 0, 0]) blade_follower("metal");
    translate([sep, 0, 0]) blade_follower("plastic");
  } else if (Part == "assembly") {
    if (Show_Component != "followers") {
      razor_blade_dispenser_body();
    }
    if (is_visible("all") || is_visible("followers")) {
      for (i = [0 : actual_dispenser_count - 1]) {
        x_c = ((actual_dispenser_count - 1) / 2 - i) * slot_spacing;
        chute_follower_instance(i, x_c, Tower_Height - follower_effective_height(Coin_Type, Follower_Height) - 6.0);
      }
    }
  } else {
    razor_blade_dispenser_body();
  }
}

razor_blade_dispenser();

