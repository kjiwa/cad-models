include <peglock/peglock.scad>
include <pegboard/pegs.scad>

MOUNT_EPSILON = 0.02;

// Sockets that fit across a body of the given width
function peglock_socket_count(content_width) = max(floor(content_width / SOCKET_WIDTH), 1);

// Backer plate size [width, height]: the content size, grown to fit the mount interface.
function board_mount_size(type, content_size, sockets, hole_spacing) = [
  max(content_size[0], type == "peglock"
    ? peglock_base_width(sockets, SOCKET_WIDTH, hole_spacing)
    : hole_spacing),
  max(content_size[1], type == "peglock" ? SOCKET_HEIGHT : hole_spacing + 10)
];

module MonolithicPegs(size, backplate_t, hole_spacing, pin_d, board_t, rise) {
  cols = max(floor((size[0] - pin_d) / hole_spacing) + 1, 1);
  num_peg_intervals = max(floor((size[1] - 10) / hole_spacing), 1);
  z_top = num_peg_intervals * hole_spacing / 2;

  for (c = [0 : cols - 1]) {
    x = (cols == 1) ? 0 : (c - (cols - 1) / 2) * hole_spacing;
    translate([x, -backplate_t, z_top])
      pegboard_upper_hook(pin_d = pin_d, board_t = board_t, rise = rise, backplate_t = backplate_t);
    for (k = [1 : num_peg_intervals]) {
      translate([x, -backplate_t, z_top - k * hole_spacing])
        pegboard_lower_pin(pin_d = pin_d, board_t = board_t, backplate_t = backplate_t);
    }
  }
}

// Backer plate spanning y from -backplate_t to 0, plus Peglock sockets or monolithic pegs behind it.
module BoardMount(type, size, sockets, backplate_t, hole_spacing, pin_d, board_t, rise) {
  if (type == "peglock") {
    translate([0, -backplate_t + MOUNT_EPSILON, 0])
      PeglockBase(
        count = sockets,
        width = SOCKET_WIDTH,
        height = SOCKET_HEIGHT,
        depth = SOCKET_DEPTH,
        spacing = hole_spacing,
        roundover = SOCKET_ROUNDOVER
      );
  } else if (type == "monolithic") {
    MonolithicPegs(size, backplate_t, hole_spacing, pin_d, board_t, rise);
  }
  translate([0, -backplate_t / 2, 0])
    cuboid([size[0], backplate_t, size[1]], rounding = SOCKET_ROUNDOVER, except = [FRONT, BACK]);
}
