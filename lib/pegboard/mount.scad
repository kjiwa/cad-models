include <peglock/peglock.scad>
include <pegs.scad>

MOUNT_EPSILON = 0.02;

// Hole columns the mount engages: the request, or by default the most that fit within the content width.
// Peglock counts socket bases; monolithic counts pegs, with at least one.
function board_hole_columns(type, requested, content_width, hole_spacing, pin_d) = requested > 0
  ? requested
  : type == "peglock"
    ? max(floor((content_width + hole_spacing - SOCKET_WIDTH) / hole_spacing), 1)
    : max(floor((max(content_width, hole_spacing) - pin_d) / hole_spacing) + 1, 1);

// Backer plate size [width, height]: the content size, grown to fit the mount interface.
// Monolithic pegs need hole_spacing and the span of their columns; auto columns never exceed it.
function board_mount_size(type, content_size, columns, hole_spacing, pin_d) = [
  max(content_size[0], type == "peglock"
    ? peglock_base_width(columns, SOCKET_WIDTH, hole_spacing)
    : max(hole_spacing, (columns - 1) * hole_spacing + pin_d)),
  max(content_size[1], type == "peglock" ? SOCKET_HEIGHT : hole_spacing + 10)
];

module MonolithicPegs(size, cols, backplate_t, hole_spacing, pin_d, board_t, rise, pin_pattern) {
  num_peg_intervals = max(floor((size[1] - 10) / hole_spacing), 1);
  z_top = num_peg_intervals * hole_spacing / 2;

  for (c = [0 : cols - 1]) {
    x = (cols == 1) ? 0 : (c - (cols - 1) / 2) * hole_spacing;
    translate([x, -backplate_t, z_top])
      pegboard_upper_hook(pin_d = pin_d, board_t = board_t, rise = rise, backplate_t = backplate_t);
    for (k = pegboard_pin_rows(pin_pattern, num_peg_intervals)) {
      translate([x, -backplate_t, z_top - k * hole_spacing])
        pegboard_lower_pin(pin_d = pin_d, board_t = board_t, backplate_t = backplate_t);
    }
  }
}

// Backer plate spanning y from -backplate_t to 0, plus Peglock sockets or monolithic pegs behind it.
// socket_z shifts the Peglock sockets vertically from the plate center; standoff adds a foot at the plate bottom
// once the plate extends below the sockets.
module BoardMount(type, size, columns, backplate_t, hole_spacing, pin_d, board_t, rise, pin_pattern = "all", socket_z = 0, standoff = false) {
  if (type == "peglock") {
    translate([0, -backplate_t + MOUNT_EPSILON, socket_z])
      PeglockBase(
        count = columns,
        width = SOCKET_WIDTH,
        height = SOCKET_HEIGHT,
        depth = SOCKET_DEPTH,
        spacing = hole_spacing,
        roundover = SOCKET_ROUNDOVER
      );
    if (standoff && size[1] > SOCKET_HEIGHT)
      translate([0, -backplate_t + MOUNT_EPSILON - SOCKET_DEPTH / 2, -size[1] / 2 + SOCKET_ROUNDOVER])
        cuboid(
          [peglock_base_width(columns, SOCKET_WIDTH, hole_spacing), SOCKET_DEPTH, 2 * SOCKET_ROUNDOVER],
          rounding = SOCKET_ROUNDOVER,
          except = [FRONT, BACK]
        );
  } else if (type == "monolithic") {
    MonolithicPegs(size, columns, backplate_t, hole_spacing, pin_d, board_t, rise, pin_pattern);
  }
  translate([0, -backplate_t / 2, 0])
    cuboid([size[0], backplate_t, size[1]], rounding = SOCKET_ROUNDOVER, except = [FRONT, BACK]);
}
