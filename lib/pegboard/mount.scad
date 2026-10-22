include <peglock/peglock.scad>
include <pegs.scad>

EPSILON = 0.02;
include <backplate.scad>

// Hole columns the mount engages: the request, or by default the most that fit within the content width.
// Peglock counts socket bases; monolithic counts pegs, with at least one; screws have no columns.
function board_hole_columns(type, requested, content_width, hole_spacing, pin_d) = type == "screws"
  ? 1
  : requested > 0
  ? requested
  : type == "peglock"
    ? max(floor((content_width + hole_spacing - SOCKET_WIDTH) / hole_spacing), 1)
    : max(floor((max(content_width, hole_spacing) - pin_d) / hole_spacing) + 1, 1);

// Backer plate size [width, height]: the content size, grown to fit the mount interface.
// Monolithic pegs need hole_spacing and the span of their columns; auto columns never exceed it.
// Screws need nothing beyond the content.
function board_mount_size(type, content_size, columns, hole_spacing, pin_d) = type == "screws" ? content_size : [
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

// Clearance a screwdriver needs around a screw head
SCREW_DRIVER_MARGIN = 3;

// Plate extension past the content on each side that carries one screw column: the head plus driver clearance all round
function screw_ear_width(head_d) = head_d + 2 * SCREW_DRIVER_MARGIN;

// Screw hole centers along one axis: evenly spaced between inset from each edge, centered when there is one.
function screw_hole_offsets(extent, count, inset) = count == 1
  ? [0]
  : [for (i = [0 : count - 1]) -extent / 2 + inset + i * (extent - 2 * inset) / (count - 1)];

// Hole through a plate spanning y from -plate_t to 0, countersunk on the +y face when countersink is set and head_d > screw_d; otherwise straight.
module ScrewHole(screw_d, head_d, countersink, plate_t) {
  if (countersink && head_d > screw_d) {
    translate([0, -plate_t, 0]) countersunk_screw_hole(screw_d, head_d, plate_t);
  } else {
    rotate([90, 0, 0]) translate([0, 0, -EPSILON]) cylinder(d = screw_d, h = plate_t + 2 * EPSILON);
  }
}

// Backer plate spanning y from -backplate_t to 0, plus Peglock sockets or monolithic pegs behind it.
// socket_z shifts the Peglock sockets vertically from the plate center; standoff adds a foot at the plate bottom
// once the plate extends below the sockets. Screw columns sit screw_column_inset from the plate sides (default screw_inset).
module BoardMount(type, size, columns, backplate_t, hole_spacing, pin_d, board_t, rise, pin_pattern = "all", socket_z = 0, standoff = false, screw_columns = 1, screw_rows = 1, screw_inset = 0, screw_column_inset = undef, screw_d = 4.7625, head_d = 9.525, countersink = false, plate_rounding = SOCKET_ROUNDOVER) {
  column_inset = is_undef(screw_column_inset) ? screw_inset : screw_column_inset;
  hole_xs = screw_hole_offsets(size[0], screw_columns, column_inset);
  hole_zs = screw_hole_offsets(size[1], screw_rows, screw_inset);
  if (type == "peglock") {
    translate([0, -backplate_t + EPSILON, socket_z])
      PeglockBase(
        count = columns,
        width = SOCKET_WIDTH,
        height = SOCKET_HEIGHT,
        depth = SOCKET_DEPTH,
        spacing = hole_spacing,
        roundover = SOCKET_ROUNDOVER
      );
    if (standoff && size[1] > SOCKET_HEIGHT)
      translate([0, -backplate_t + EPSILON - SOCKET_DEPTH / 2, -size[1] / 2 + SOCKET_ROUNDOVER])
        cuboid(
          [peglock_base_width(columns, SOCKET_WIDTH, hole_spacing), SOCKET_DEPTH, 2 * SOCKET_ROUNDOVER],
          rounding = SOCKET_ROUNDOVER,
          except = [FRONT, BACK]
        );
  } else if (type == "monolithic") {
    MonolithicPegs(size, columns, backplate_t, hole_spacing, pin_d, board_t, rise, pin_pattern);
  }
  if (type == "screws") {
    assert(screw_columns >= 1 && screw_columns == floor(screw_columns), "Screw_Hole_Columns must be a positive integer");
    assert(screw_rows >= 1 && screw_rows == floor(screw_rows), "Screw_Hole_Rows must be a positive integer");
    assert(screw_inset >= 0 && (screw_columns == 1 || 2 * column_inset <= size[0]) && (screw_rows == 1 || 2 * screw_inset <= size[1]),
      "Screw_Hole_Inset must not exceed half the plate");
    assert(len([for (x = hole_xs) if (abs(x) + head_d / 2 > size[0] / 2 + 0.01) 1]) == 0
      && len([for (z = hole_zs) if (abs(z) + head_d / 2 > size[1] / 2 + 0.01) 1]) == 0,
      "Screw heads overhang the backplate: reduce Screw_Hole_Inset or Screw_Head_Diameter");
  }
  difference() {
    translate([0, -backplate_t / 2, 0])
      cuboid([size[0], backplate_t, size[1]], rounding = plate_rounding, except = [FRONT, BACK]);
    if (type == "screws")
      for (x = hole_xs, z = hole_zs)
        translate([x, 0, z]) ScrewHole(screw_d, head_d, countersink, backplate_t);
  }
}
