/**
 * Component visibility filtering and 3D preview inspection labels.
 */

// Determines if a named component should be rendered based on active view selection.
function is_visible(comp) =
  (Show_Component == "all") ||
  (Show_Component == comp) ||
  (Show_Component == "towers" && (comp == "tower_body" || comp == "dispenser")) ||
  (Show_Component == "pegs" && (comp == "retention_hooks" || comp == "stabilizing_pins")) ||
  (Show_Component == "followers" && comp == "followers");

// Renders an oriented 3D text label during OpenSCAD preview inspection.
module component_label(txt, pos, rot = [90, 0, 180]) {
  if (Show_Labels && ($preview || render_labels)) {
    translate(pos) rotate(rot) {
      color("Black")
        linear_extrude(height = 0.6)
          text(txt, size = Label_Size, halign = "center", valign = "center");
    }
  }
}
