/**
 * Component visibility filtering and 3D preview inspection labels.
 */

// Determines if a named component should be rendered based on active view selection.
function is_visible(comp) =
  (view_component == "all") ||
  (view_component == comp) ||
  (view_component == "towers" && (comp == "tower_body" || comp == "dispenser")) ||
  (view_component == "pegs" && (comp == "upper_hooks" || comp == "lower_pins"));

// Renders an oriented 3D text label during OpenSCAD preview inspection.
module component_label(txt, pos, rot = [90, 0, 180]) {
  if (show_labels && ($preview || render_labels)) {
    translate(pos) rotate(rot) {
      color("Black")
        linear_extrude(height = 0.6)
          text(txt, size = label_size, halign = "center", valign = "center");
    }
  }
}
