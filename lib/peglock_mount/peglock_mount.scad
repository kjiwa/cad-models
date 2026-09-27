include <BOSL2/std.scad>
include <peglock_openscad/peglock_modules.scad>

DEFAULT_PEGLOCK_WIDTH = 22;
DEFAULT_PEGLOCK_HEIGHT = 35.4;
DEFAULT_PEGLOCK_DEPTH = 6;
DEFAULT_PEGLOCK_SPACING = 25.4;
DEFAULT_PEGLOCK_ROUNDOVER = 3.175;

function peglock_base_width(count, width = DEFAULT_PEGLOCK_WIDTH, spacing = DEFAULT_PEGLOCK_SPACING) =
  (count * spacing) - (spacing - width);

module PeglockHolders(count = 1, width = DEFAULT_PEGLOCK_WIDTH, spacing = DEFAULT_PEGLOCK_SPACING) {
  translate([width / 2, 0, 0])
    for (i = [1:count]) {
      translate([(i - 1) * spacing, 0, 0])
        mirror([0, 1, 0])
        holder(is_cutting = true);
    }
}

module PeglockBase(
  count = 1,
  width = DEFAULT_PEGLOCK_WIDTH,
  height = DEFAULT_PEGLOCK_HEIGHT,
  depth = DEFAULT_PEGLOCK_DEPTH,
  spacing = DEFAULT_PEGLOCK_SPACING,
  roundover = DEFAULT_PEGLOCK_ROUNDOVER
) {
  x = peglock_base_width(count, width, spacing);
  translate([-x / 2, 0, -height / 2])
    difference() {
      translate([x / 2, -depth / 2, height / 2])
        cuboid([x, depth, height], rounding = roundover, except = [FRONT, BACK]);
      PeglockHolders(count = count, width = width, spacing = spacing);
    }
}
