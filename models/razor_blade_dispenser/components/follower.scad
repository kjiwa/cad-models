/**
 * Parametric gravity follower weight for razor blade dispenser.
 * Downward pressure on blade stack with front indicator tab and optional ballast pocket.
 */

function follower_width() =
  Chute_Width - 2 * Follower_Clearance;

function follower_chute_depth(type) =
  (type == "plastic") ?
    (effective_plastic_depth - 2 * Follower_Clearance) :
    (effective_metal_depth - 2 * Follower_Clearance);

function follower_badge_label(type) =
  (type == "plastic") ? "PLASTIC" : "METAL";

function follower_badge_letter(type) =
  (type == "plastic") ? "P" : "M";

function coin_diameter(c) =
  (c == "quarter") ? 24.26 :
  ((c == "nickel") ? 21.21 : 19.05);

function coin_thickness(c) =
  (c == "quarter") ? 1.75 :
  ((c == "nickel") ? 1.95 : 1.52);

function coin_capacity(c, type) =
  (type == "plastic") ?
    ((c == "quarter") ? 7 : ((c == "nickel") ? 6 : 8)) :
    ((c == "quarter") ? 8 : ((c == "nickel") ? 7 : 10));

function follower_effective_height(c_type, h_override) =
  (h_override > 0) ? h_override :
  ((c_type == "custom") ? 12.0 : (2.5 + coin_diameter(c_type) + 0.45));

module follower_body_blank(w, d, h, r = 1.5, b_chamfer = 0.8) {
  c_r = max(r - b_chamfer, 0.4);
  hull() {
    translate([0, 0, 0])
      linear_extrude(height = EPSILON)
        hull() {
          translate([-w / 2 + b_chamfer + c_r, -d / 2 + b_chamfer + c_r]) circle(r = c_r);
          translate([w / 2 - b_chamfer - c_r, -d / 2 + b_chamfer + c_r]) circle(r = c_r);
          translate([-w / 2 + b_chamfer + c_r, d / 2 - b_chamfer - c_r]) circle(r = c_r);
          translate([w / 2 - b_chamfer - c_r, d / 2 - b_chamfer - c_r]) circle(r = c_r);
        }

    translate([0, 0, b_chamfer])
      linear_extrude(height = h - b_chamfer)
        hull() {
          translate([-w / 2 + r, -d / 2 + r]) circle(r = r);
          translate([w / 2 - r, -d / 2 + r]) circle(r = r);
          translate([-w / 2 + r, d / 2 - r]) circle(r = r);
          translate([w / 2 - r, d / 2 - r]) circle(r = r);
        }
  }
}

module follower_indicator_tab(tab_w, tab_ext, d, h, r = 1.2, b_chamfer = 0.8) {
  y_start = d / 2 - 1.0;
  total_ext = tab_ext + 1.0;

  translate([0, y_start, 0]) {
    hull() {
      linear_extrude(height = EPSILON)
        hull() {
          translate([-tab_w / 2 + b_chamfer + r, b_chamfer]) circle(r = r);
          translate([tab_w / 2 - b_chamfer - r, b_chamfer]) circle(r = r);
          translate([-tab_w / 2 + b_chamfer + r, total_ext - b_chamfer - r]) circle(r = r);
          translate([tab_w / 2 - b_chamfer - r, total_ext - b_chamfer - r]) circle(r = r);
        }

      translate([0, 0, b_chamfer])
        linear_extrude(height = h - b_chamfer)
          hull() {
            translate([-tab_w / 2 + r, 0]) circle(r = r);
            translate([tab_w / 2 - r, 0]) circle(r = r);
            translate([-tab_w / 2 + r, total_ext - r]) circle(r = r);
            translate([tab_w / 2 - r, total_ext - r]) circle(r = r);
          }
    }
  }
}

module follower_top_pull_ridge(fin_w = 20.0, fin_d = 3.2, fin_h = 4.0, y_pos = 0, z_base = 12.0) {
  r = fin_d / 2;

  translate([0, y_pos, z_base]) {
    rotate([0, 90, 0]) {
      linear_extrude(height = fin_w, center = true) {
        hull() {
          translate([0, -fin_d / 2]) square([EPSILON, fin_d]);
          translate([-fin_h + r, 0]) circle(r = r);
        }
      }
    }
  }
}

module follower_coin_cradle(coin_dia, slot_d, h, floor_thick = 2.5, clearance = 0.4) {
  r = coin_dia / 2 + clearance;
  slot_w = 2 * r;
  z_center = floor_thick + r;

  rotate([90, 0, 0]) {
    linear_extrude(height = slot_d, center = true) {
      hull() {
        translate([0, z_center]) circle(r = r, $fn = 48);
        translate([-r, z_center]) square([slot_w, h - z_center + EPSILON]);
      }
    }
  }
}

module follower_ballast_cutout(w, d, h, pocket_w, pocket_d, pocket_h, r = 1.5) {
  actual_w = min(pocket_w, w - 6.0);
  actual_d = min(pocket_d, d - 6.0);
  actual_h = min(pocket_h, h - 3.0);

  translate([0, 0, h - actual_h]) {
    linear_extrude(height = actual_h + 2 * EPSILON) {
      hull() {
        translate([-actual_w / 2 + r, -actual_d / 2 + r]) circle(r = r);
        translate([actual_w / 2 - r, -actual_d / 2 + r]) circle(r = r);
        translate([-actual_w / 2 + r, actual_d / 2 - r]) circle(r = r);
        translate([actual_w / 2 - r, actual_d / 2 - r]) circle(r = r);
      }
    }
  }
}

module follower_tab_letter(letter, d, tab_ext, h, deboss_d = 0.6) {
  y_face = d / 2 + tab_ext;

  translate([0, y_face + EPSILON, h / 2]) {
    rotate([90, 0, 0]) {
      mirror([1, 0, 0]) {
        linear_extrude(height = deboss_d + 2 * EPSILON) {
          text(letter, size = 4.5, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
        }
      }
    }
  }
}

module follower_top_text(label_text, w, d, h, deboss_d = 0.6) {
  translate([0, -d / 4, h - deboss_d + EPSILON]) {
    linear_extrude(height = deboss_d + EPSILON) {
      text(label_text, size = 3.2, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
    }
  }
}

module blade_follower(type = "metal", ballast = Include_Ballast_Pocket) {
  w = follower_width();
  d = follower_chute_depth(type);
  h = follower_effective_height(Coin_Type, Follower_Height);
  tab_w = min(Sight_Slot_Width - 1.5, w - 4.0);
  tab_ext = Front_Wall_Thickness + Follower_Tab_Protrusion;
  fin_d = 3.0;
  fin_y = d / 2 - fin_d / 2 - 0.5;

  c_d = coin_diameter(Coin_Type);
  c_t = coin_thickness(Coin_Type);
  n_coins = coin_capacity(Coin_Type, type);
  slot_d = n_coins * c_t + 0.6;
  slot_y = fin_y - fin_d / 2 - slot_d / 2 - 1.0;
  pocket_y = -d / 2 + Custom_Pocket_Depth / 2 + 3.0;

  color("DarkOrange") {
    difference() {
      union() {
        follower_body_blank(w, d, h);
        follower_indicator_tab(tab_w, tab_ext, d, h);
        follower_top_pull_ridge(fin_w = min(22.0, w - 8.0), fin_d = fin_d, fin_h = 4.0, y_pos = fin_y, z_base = h);
      }

      if (ballast) {
        if (Coin_Type == "custom") {
          translate([0, pocket_y, 0])
            follower_ballast_cutout(w, d, h, Custom_Pocket_Width, Custom_Pocket_Depth, Custom_Pocket_Height);
        } else {
          translate([0, slot_y, 0])
            follower_coin_cradle(c_d, slot_d, h);
        }
      }

      follower_tab_letter(follower_badge_letter(type), d, tab_ext, h);

      if (!ballast) {
        follower_top_text(follower_badge_label(type), w, d, h);
      }
    }
  }
}

module chute_follower_instance(index, x_center, z_pos) {
  type = slot_type(index);
  chute_d = slot_chute_depth(index);
  y_front_inner = Backplate_Thickness + tower_depth - Front_Wall_Thickness;
  y_c = y_front_inner - chute_d / 2;

  translate([x_center, y_c, z_pos])
    blade_follower(type);
}
