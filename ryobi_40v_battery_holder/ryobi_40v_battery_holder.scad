/**
 * Parametric pegboard holder for Ryobi 40V batteries.
 * Designed for 1/4" pegboard with 1" hole spacing and 1/4" wall clearance.
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

// Pin diameter in mm (sized for 1/4" holes with print tolerance)
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

// Backplate width matches outer edge of battery rails
total_width = (battery_count - 1) * slot_spacing + bed_width;

// Pegboard vertical coordinates (Z = 0 is the flat print bed base)
cradle_drop = (bed_thickness + bottom_shelf_depth) * sin(tilt_angle);
z_plate_bottom = 0;
z_shelf = z_plate_bottom + cradle_drop + toe_height;

h_cradle = rail_length * cos(tilt_angle);
w_cradle = rail_length * sin(tilt_angle);

z_plate_top = z_shelf + h_cradle;
backplate_height = z_plate_top - z_plate_bottom;
z_top_peg = z_plate_top - peg_top_margin;

function is_visible(comp) =
  (view_component == "all") ||
  (view_component == comp) ||
  (view_component == "cradle" && (comp == "slide_bed" || comp == "bottom_shelf" || comp == "slide_rails" || comp == "gussets"));

module component_label(txt, pos, rot = [90, 0, 180]) {
  if (show_labels && ($preview || render_labels)) {
    translate(pos) rotate(rot) {
      color("Black")
        linear_extrude(height = 0.6)
          text(txt, size = label_size, halign = "center", valign = "center");
    }
  }
}

module pegboard_upper_hook(pin_d = pin_diameter, board_t = pegboard_thickness, rise = hook_rise) {
  shank_len = board_t + 0.8;
  hook_t = 3.2;
  root_chamfer = 0.35;

  rotate([90, 0, 0]) {
    translate([0, 0, -backplate_thickness])
      cylinder(d = pin_d, h = backplate_thickness + EPSILON);
    cylinder(d1 = pin_d + 2 * root_chamfer, d2 = pin_d, h = root_chamfer);
    cylinder(d = pin_d, h = shank_len);
  }

  translate([0, -shank_len, 0]) {
    hull() {
      rotate([90, 0, 0])
        cylinder(d = pin_d, h = hook_t);
      translate([0, -hook_t / 2, rise])
        rotate([0, 90, 0])
          cylinder(d = hook_t, h = pin_d * 0.8, center = true);
    }
    // Reinforcing spine on the back of the hook tab
    translate([0, -hook_t, 0]) {
      rotate([90, 0, 90]) {
        linear_extrude(height = pin_d * 0.7, center = true) {
          polygon(points = [
            [0, 0],
            [0, rise * 0.75],
            [-rise * 0.5, 0]
          ]);
        }
      }
    }
  }
}

module pegboard_lower_pin(pin_d = pin_diameter, board_t = pegboard_thickness, chamfer = 1.2) {
  len = board_t - 0.8;
  body_len = max(len - chamfer, 1.0);
  root_chamfer = 0.35;

  rotate([90, 0, 0]) {
    translate([0, 0, -backplate_thickness])
      cylinder(d = pin_d, h = backplate_thickness + EPSILON);
    cylinder(d1 = pin_d + 2 * root_chamfer, d2 = pin_d, h = root_chamfer);
    cylinder(d = pin_d, h = body_len);
    translate([0, 0, body_len])
      cylinder(d1 = pin_d, d2 = pin_d - 2 * chamfer, h = chamfer);
  }
}

module backplate() {
  z_center = (z_plate_top + z_plate_bottom) / 2;
  r = min(backplate_corner_radius, backplate_height / 4, total_width / 4);

  difference() {
    translate([0, backplate_thickness, z_center]) {
      rotate([90, 0, 0]) {
        linear_extrude(height = backplate_thickness) {
          if (r > 0) {
            hull() {
              translate([-total_width / 2, -backplate_height / 2])
                square([total_width, EPSILON]);
              translate([-total_width / 2 + r, backplate_height / 2 - r])
                circle(r = r);
              translate([total_width / 2 - r, backplate_height / 2 - r])
                circle(r = r);
            }
          } else {
            square([total_width, backplate_height], center = true);
          }
        }
      }
    }

    // Chamfer along top-rear edge for tilt clearance during pegboard insertion
    translate([0, 0, z_plate_top])
      rotate([45, 0, 0])
        cube([total_width + 2 * EPSILON, tilt_chamfer * sqrt(2), tilt_chamfer * sqrt(2)], center = true);

    if (include_screw_holes) {
      for (i = [0 : battery_count - 1]) {
        x_c = (i - (battery_count - 1) / 2) * slot_spacing;
        z_screw = z_top_peg - peg_hole_spacing;
        translate([x_c, -EPSILON, z_screw]) {
          rotate([-90, 0, 0]) {
            cylinder(d = screw_hole_diameter, h = backplate_thickness + 2 * EPSILON);
            translate([0, 0, backplate_thickness - (countersink_diameter - screw_hole_diameter) / 2])
              cylinder(d1 = screw_hole_diameter, d2 = countersink_diameter, h = (countersink_diameter - screw_hole_diameter) / 2 + EPSILON);
          }
        }
      }
    }

    // Center backplate weight-relief window between slots
    if (battery_count > 1) {
      for (i = [0 : battery_count - 2]) {
        x_win = (i + 0.5 - (battery_count - 1) / 2) * slot_spacing;
        win_w = 14.0;
        win_h = backplate_height - 24.0;
        win_r = win_w / 2;
        translate([x_win, -EPSILON, z_center]) {
          rotate([-90, 0, 0]) {
            linear_extrude(height = backplate_thickness + 2 * EPSILON) {
              hull() {
                translate([0, -win_h / 2 + win_r]) circle(r = win_r);
                translate([0, win_h / 2 - win_r]) circle(r = win_r);
              }
            }
          }
        }
      }
    }
  }
}

module slide_bed() {
  r = min(bed_corner_radius, bed_width / 4);

  difference() {
    translate([0, bed_thickness, 0]) {
      rotate([90, 0, 0]) {
        linear_extrude(height = bed_thickness) {
          if (r > 0) {
            hull() {
              translate([-bed_width / 2, 0])
                square([bed_width, rail_length - r]);
              translate([-bed_width / 2 + r, rail_length - r])
                circle(r = r);
              translate([bed_width / 2 - r, rail_length - r])
                circle(r = r);
            }
          } else {
            translate([-bed_width / 2, 0])
              square([bed_width, rail_length]);
          }
        }
      }
    }

    // Central relief channel to reduce friction and save filament
    relief_w = 30.0;
    relief_d = 1.5;
    relief_r = 4.0;
    relief_z_start = bottom_shelf_thickness + 4.0;
    relief_z_end = rail_length - 8.0;
    relief_h = relief_z_end - relief_z_start;

    translate([0, bed_thickness - relief_d, relief_z_start + relief_h / 2]) {
      rotate([-90, 0, 0]) {
        linear_extrude(height = relief_d + EPSILON) {
          hull() {
            for (dx = [-relief_w / 2 + relief_r, relief_w / 2 - relief_r]) {
              for (dz = [-relief_h / 2 + relief_r, relief_h / 2 - relief_r]) {
                translate([dx, dz]) circle(r = relief_r);
              }
            }
          }
        }
      }
    }

    // Debossed 40V identification
    translate([0, bed_thickness - relief_d + EPSILON, relief_z_end - 12.0]) {
      rotate([90, 0, 0]) {
        mirror([1, 0, 0]) {
          linear_extrude(height = 0.6 + EPSILON) {
            text("40V", size = 9.0, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
          }
        }
      }
    }
  }
}

module bottom_shelf() {
  r = min(shelf_corner_radius, bottom_shelf_depth / 2, bed_width / 4);
  d = bottom_shelf_depth;
  t = bottom_shelf_thickness;
  w = bed_width;

  translate([0, bed_thickness, 0]) {
    linear_extrude(height = t) {
      if (r > 0) {
        hull() {
          translate([-w / 2, 0])
            square([w, d - r]);
          translate([-w / 2 + r, d - r])
            circle(r = r);
          translate([w / 2 - r, d - r])
            circle(r = r);
        }
      } else {
        translate([-w / 2, 0])
          square([w, d]);
      }
    }
  }
}

module corner_cut_2d(r) {
  difference() {
    square([r + EPSILON, r + EPSILON]);
    circle(r = r);
  }
}

module single_rail() {
  w_pocket = rail_width + 2 * rail_clearance;
  h_slot = rail_thickness + rail_clearance;
  t_lip = rail_thickness;
  d_lip = rail_lip_depth;

  x_outer = bed_width / 2;
  x_wall = w_pocket / 2;
  x_lip = w_pocket / 2 - d_lip;
  lead_in = 12.0;
  chamfer_d = 2.5;
  r_bed = min(bed_corner_radius, bed_width / 4);
  r_shelf = min(shelf_corner_radius, bottom_shelf_depth / 2, bed_width / 4);
  r_fillet = min(rail_fillet_radius, d_lip * 0.45, h_slot * 0.45);
  r_root = min(rail_root_fillet, 0.6);
  c_lead = 0.8;

  difference() {
    translate([0, bed_thickness, bottom_shelf_thickness]) {
      linear_extrude(height = rail_length - bottom_shelf_thickness) {
        polygon(points = concat(
          [
            [x_lip, h_slot + t_lip],
            [x_outer, h_slot + t_lip],
            [x_outer, 0],
            (r_root > 0) ? [x_wall - r_root, 0] : [x_wall, 0],
            (r_root > 0) ? [x_wall, r_root] : [x_wall, 0],
            [x_wall, h_slot - r_fillet]
          ],
          (r_fillet > 0) ? [
            for (a = [6 : -1 : 0]) [
              (x_wall - r_fillet) + r_fillet * sin(a * 90 / 6),
              (h_slot - r_fillet) + r_fillet * cos(a * 90 / 6)
            ]
          ] : [[x_wall, h_slot]],
          [
            [x_lip + c_lead, h_slot],
            [x_lip, h_slot + c_lead]
          ]
        ));
      }
    }

    // Compound lead-in flare at top entrance (width funnel)
    translate([x_lip, bed_thickness + h_slot - EPSILON, rail_length]) {
      rotate([0, atan2(chamfer_d, lead_in), 0])
        translate([-chamfer_d, -EPSILON, -lead_in])
          cube([chamfer_d * 2, t_lip + 2 * EPSILON, lead_in * 2]);
    }

    // Top face lead-in chamfer
    translate([x_lip, bed_thickness + h_slot + t_lip, rail_length]) {
      rotate([0, 45, 0])
        cube([chamfer_d * 1.5, t_lip * 3, chamfer_d * 1.5], center = true);
    }

    // Top outer corner roundover matching bed top curvature
    translate([x_outer - r_bed, (h_slot + t_lip) + bed_thickness + EPSILON, rail_length - r_bed]) {
      rotate([90, 0, 0]) {
        linear_extrude(height = (h_slot + t_lip) + 2 * EPSILON) {
          corner_cut_2d(r_bed);
        }
      }
    }

    // Front outer vertical edge roundover matching bottom shelf
    translate([x_outer - r_shelf, bed_thickness + (h_slot + t_lip) - r_shelf, bottom_shelf_thickness - EPSILON]) {
      difference() {
        translate([0, 0, 0])
          cube([r_shelf + EPSILON, r_shelf + EPSILON, rail_length]);
        cylinder(r = r_shelf, h = rail_length * 2);
      }
    }
  }
}

module slide_rails() {
  single_rail();
  mirror([1, 0, 0]) single_rail();
}

/**
 * Solid base foot supporting cradle flush with build plate and backplate.
 * Transitions smoothly into the build plate (Z=0) with rounded corners and a
 * durable vertical toe, completely eliminating the fragile acute knife-edge.
 */
module cradle_base_foot(x_center) {
  w = bed_width;
  r = min(shelf_corner_radius, bottom_shelf_depth / 2, bed_width / 4);
  d = bottom_shelf_depth;
  bt = bed_thickness;
  y_front = backplate_thickness + (bt + d) * cos(tilt_angle);

  translate([x_center, 0, 0]) {
    difference() {
      hull() {
        // Top boundary: matches underside of tilted cradle at z_local = 0
        translate([0, backplate_thickness, z_shelf]) {
          rotate([-tilt_angle, 0, 0]) {
            linear_extrude(height = 0.2) {
              hull() {
                translate([-w / 2 + r, 0]) circle(r = r);
                translate([w / 2 - r, 0]) circle(r = r);
                translate([-w / 2 + r, bt + d - r]) circle(r = r);
                translate([w / 2 - r, bt + d - r]) circle(r = r);
              }
            }
          }
        }
        // Bottom boundary: flat on build plate at Z=0
        translate([0, 0, 0]) {
          linear_extrude(height = 0.2) {
            hull() {
              translate([-w / 2 + r, backplate_thickness]) circle(r = r);
              translate([w / 2 - r, backplate_thickness]) circle(r = r);
              translate([-w / 2 + r, y_front - r]) circle(r = r);
              translate([w / 2 - r, y_front - r]) circle(r = r);
            }
          }
        }
      }

      // Smooth front-bottom roundover at Z=0
      if (toe_roundover > 0) {
        translate([0, y_front, 0]) {
          rotate([45, 0, 0])
            cube([w + 2 * EPSILON, toe_roundover * sqrt(2), toe_roundover * sqrt(2)], center = true);
        }
      }

      // Clean cuts to ensure exact bounds
      translate([-w, -20, -50])
        cube([2 * w, 100, 50]);
      translate([-w, -50, -10])
        cube([2 * w, 50 + backplate_thickness, 100]);
    }
  }
}

module gusset_rib_profile_2d(h_plate, h_bed, w_bed, style) {
  if (style == "classic") {
    polygon(points = [
      [0, 0],
      [0, h_plate],
      [w_bed, h_plate]
    ]);
  } else {
    // Swept architectural concave arch
    polygon(points = concat(
      [[0, 0], [0, h_plate]],
      [for (t = [0 : 0.08 : 1])
        let(
          p0 = [0, h_plate],
          p1 = [w_bed * 0.18, h_plate * 0.92],
          p2 = [w_bed, h_bed],
          u = (1 - t) * (1 - t) * p0[0] + 2 * (1 - t) * t * p1[0] + t * t * p2[0],
          v = (1 - t) * (1 - t) * p0[1] + 2 * (1 - t) * t * p1[1] + t * t * p2[1]
        ) [u, v]
      ],
      [[w_bed, h_bed]]
    ));
  }
}

module gusset_ribs(x_center) {
  w = bed_width;
  r = min(bed_corner_radius, bed_width / 4);
  gusset_span = 2 * peg_hole_spacing;
  z_gusset_bot = z_shelf;
  h_gusset = z_plate_top - z_gusset_bot;
  w_gusset = h_gusset * tan(tilt_angle);

  h_plate_attach = (gusset_style == "classic") ? h_gusset : (h_gusset - 4.5);
  contact_ratio = (gusset_style == "classic") ? 1.0 : 0.86;
  h_contact = h_gusset * contact_ratio;
  w_contact = w_gusset * contact_ratio;

  if (tilt_angle > 0) {
    if (gusset_style == "full_wedge") {
      // Full-width continuous monolithic cradle wedge flush with slide bed
      translate([x_center, 0, 0]) {
        difference() {
          translate([0, backplate_thickness - EPSILON, z_gusset_bot]) {
            rotate([90, 0, 90]) {
              linear_extrude(height = w, center = true) {
                gusset_rib_profile_2d(h_plate_attach, h_contact, w_contact, "swept");
              }
            }
          }

          // Optional weight-relief core (cored monocoque cavity)
          if (wedge_cored) {
            wall_t = 6.5;
            core_w = w - 2 * wall_t;
            translate([0, backplate_thickness + 2.5, z_gusset_bot + 4.0]) {
              rotate([90, 0, 90]) {
                linear_extrude(height = core_w, center = true) {
                  polygon(points = [
                    [0, 0],
                    [0, h_plate_attach - 10.0],
                    [(w_contact - 3.5) * 0.25, h_plate_attach - 10.0],
                    [w_contact - 3.5, h_contact - 8.0],
                    [w_contact - 3.5, 0]
                  ]);
                }
              }
            }
          }
        }
      }
    } else if (gusset_style == "buttress_wings") {
      // Integrated monolithic flared buttress wings connecting hooks to rails
      for (side = [-1, 1]) {
        x_inner = x_center + side * (gusset_span / 2);
        x_outer = x_center + side * (bed_width / 2);

        hull() {
          // Inner hook-aligned rib
          translate([x_inner, backplate_thickness - EPSILON, z_gusset_bot]) {
            rotate([90, 0, 90]) {
              linear_extrude(height = bracket_thickness, center = true) {
                gusset_rib_profile_2d(h_plate_attach, h_contact, w_contact, "swept");
              }
            }
          }

          // Outer rail-aligned buttress cheek (backs up slide rail)
          translate([x_outer - side * (bracket_thickness / 2), backplate_thickness - EPSILON, z_gusset_bot]) {
            rotate([90, 0, 90]) {
              linear_extrude(height = bracket_thickness, center = true) {
                gusset_rib_profile_2d(h_plate_attach * 0.90, h_contact * 0.90, w_contact * 0.90, "swept");
              }
            }
          }
        }
      }
    } else {
      // Swept or Classic ribs at hook locations
      for (side = [-1, 1]) {
        x_rib = x_center + side * (gusset_span / 2);
        translate([x_rib, backplate_thickness - EPSILON, z_gusset_bot]) {
          rotate([90, 0, 90]) {
            linear_extrude(height = bracket_thickness, center = true) {
              difference() {
                gusset_rib_profile_2d(h_plate_attach, h_contact, w_contact, gusset_style);

                // Proportional weight-relief truss window with guaranteed 3.5mm wall margins
                if (h_gusset > 35 && w_gusset > 9) {
                  v_bot = 35.0;
                  v_top = h_plate_attach - 8.0;
                  u_bot = 0.5 * v_bot * tan(tilt_angle);
                  u_top = 0.5 * v_top * tan(tilt_angle);
                  hull() {
                    translate([u_bot, v_bot]) circle(d = 4.0);
                    translate([u_top, v_top]) circle(d = 4.0);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

module mounting_pegs() {
  max_x_peg = total_width / 2 - pin_diameter / 2 - 2.0;

  for (i = [0 : battery_count - 1]) {
    x_c = (i - (battery_count - 1) / 2) * slot_spacing;
    for (k = [-(slot_spacing_pegs - 1) / 2 : (slot_spacing_pegs - 1) / 2]) {
      x_pos = x_c + k * peg_hole_spacing;

      if (abs(x_pos) <= max_x_peg) {
        if (is_visible("upper_hooks")) {
          color("Crimson")
            translate([x_pos, 0, z_top_peg])
              pegboard_upper_hook();
        }

        if (is_visible("lower_pins")) {
          color("Tomato") {
            if (stabilizing_peg_pattern == "all" || stabilizing_peg_pattern == "span_1") {
              if (!include_screw_holes || k != 0) {
                translate([x_pos, 0, z_top_peg - peg_hole_spacing])
                  pegboard_lower_pin();
              }
            }
            if (stabilizing_peg_pattern == "all" || stabilizing_peg_pattern == "span_2") {
              translate([x_pos, 0, z_top_peg - 2 * peg_hole_spacing])
                pegboard_lower_pin();
            }
          }
        }
      }
    }
  }

  if (is_visible("upper_hooks")) {
    component_label("Upper Hooks", [0, -pegboard_thickness - 6, z_top_peg + hook_rise + 4], [90, 0, 0]);
  }
  if (is_visible("lower_pins")) {
    z_label_pin = (stabilizing_peg_pattern == "span_1") ? (z_top_peg - peg_hole_spacing - 4) : (z_top_peg - 2 * peg_hole_spacing - 4);
    component_label("Lower Pins", [0, -pegboard_thickness - 6, z_label_pin], [90, 0, 0]);
  }
}

module slot_cradle(x_center, is_first_slot = true) {
  y_shelf = backplate_thickness;
  z_screw = z_top_peg - peg_hole_spacing;

  difference() {
    union() {
      translate([x_center, y_shelf, z_shelf]) {
        rotate([-tilt_angle, 0, 0]) {
          if (is_visible("slide_bed")) {
            color("SteelBlue") slide_bed();
            if (is_first_slot) {
              component_label("Slide Bed", [0, bed_thickness + 0.5, rail_length * 0.85]);
            }
          }

          if (is_visible("bottom_shelf")) {
            color("SeaGreen") bottom_shelf();
            if (is_first_slot) {
              component_label("Bottom Shelf", [0, bed_thickness + bottom_shelf_depth + 0.5, bottom_shelf_thickness / 2]);
            }
          }

          if (enable_rails && is_visible("slide_rails")) {
            color("RoyalBlue") slide_rails();
            if (is_first_slot) {
              component_label("Slide Rails", [0, bed_thickness + rail_thickness * 2 + rail_clearance + 0.5, rail_length / 2]);
            }
          }
        }
      }

      // Flat base foot supporting cradle flush with build plate and backplate
      if (is_visible("bottom_shelf")) {
        color("SeaGreen") cradle_base_foot(x_center);
      }
    }

    // Screwdriver access through-hole aligned with countersunk mounting screw
    if (include_screw_holes) {
      translate([x_center, -EPSILON, z_screw]) {
        rotate([-90, 0, 0]) {
          cylinder(d = countersink_diameter + 3.0, h = w_cradle + bed_thickness + 20.0);
          // Chamfered bezel at the front access entrance
          translate([0, 0, backplate_thickness + (z_screw - z_shelf) * tan(tilt_angle) + (bed_thickness / cos(tilt_angle)) - 1.0])
            cylinder(d1 = countersink_diameter + 3.0, d2 = countersink_diameter + 6.0, h = 3.0);
        }
      }
    }
  }

  if (is_visible("gussets")) {
    color("DarkOrange") gusset_ribs(x_center);
    if (is_first_slot) {
      component_label("Gussets", [x_center + peg_hole_spacing + bracket_thickness / 2 + 8, backplate_thickness + w_cradle * 0.3, z_shelf + h_cradle * 0.5], [90, 0, -90]);
    }
  }
}

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
