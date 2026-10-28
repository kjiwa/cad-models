include <BOSL2/std.scad>

/**
 * SW-Motech T-Lock MOLLE adapter: a clone of the adapter that locks into the SW-Motech T-Lock
 * holder and carries MOLLE webbing through four strap slots. The ring and its two notches seat
 * in the holder; Fit_Clearance trims them for a printed fit. Print plate down. All dimensions
 * are in millimeters.
 */

/* [Lock Cylinder] */
// Ring outer diameter (before Fit_Clearance)
Lock_Outer_Diameter = 34;

// Radius of the rounded ring top edge
Lock_Outer_Corner_Radius = 1;

// Long diameter of the bayonet opening
Lock_Inner_Diameter_Long = 25;

// Short diameter of the bayonet opening
Lock_Inner_Diameter_Short = 20;

// Length of the opening's tab (along the long diameter)
Lock_Inner_Tab_Length = 20;

// Width of the opening's tab (along the short diameter)
Lock_Inner_Tab_Width = 15;

// Height of the wide inner recess, measured from the plate
Lock_Top_Thickness = 3;

// Ring height above the plate
Lock_Depth = 5;

// Radial depth of each notch beyond the ring (before Fit_Clearance)
Lock_Notch_Depth = 1;

// Notch width (before Fit_Clearance)
Lock_Notch_Width = 3;

// Radius of the notch corners
Lock_Notch_Corner_Radius = 1;

/* [Fit] */
// Gap per side on the ring's outside and the notches, trimmed from the nominal size
Fit_Clearance = 0.3;

/* [Strap Plate] */
// Plate length
Strap_Plate_Length = 80;

// Plate width, not counting the tabs
Strap_Plate_Width = 50;

// Plate thickness
Strap_Plate_Thickness = 3;

// Radius of the plate's rounded corners
Strap_Plate_Corner_Radius = 5;

// Radius of the rounded top edge around the plate
Strap_Plate_Edge_Radius = 0.8;

// Length of each tab
Strap_Plate_Tab_Length = 30;

// Width of each tab beyond the plate
Strap_Plate_Tab_Width = 10;

// Radius of the tab's outer corners
Strap_Plate_Tab_Corner_Radius = 5;

/* [Strap Slots] */
// Slot width
Strap_Hole_Width = 5;

// Slot length
Strap_Hole_Length = 26;

// Radius of the slot ends
Strap_Hole_Corner_Radius = 2.5;

// Radius of the rounded slot edges on both faces, where the webbing bears
Strap_Hole_Edge_Radius = 0.8;

/* [Hidden] */
$fn = 128;

join = 1;
slot_x = Strap_Plate_Length / 4;
slot_y = (Lock_Outer_Diameter + Strap_Hole_Width) / 2;
tab_y = (Strap_Plate_Width + Strap_Plate_Tab_Width) / 2;
notch_width = Lock_Notch_Width - 2 * Fit_Clearance;

assert(Fit_Clearance >= 0, "Fit_Clearance must not be negative");
assert(2 * Strap_Hole_Corner_Radius <= Strap_Hole_Width, "Strap_Hole_Corner_Radius must be at most half of Strap_Hole_Width");
assert(2 * Strap_Hole_Edge_Radius < Strap_Plate_Thickness, "Strap_Hole_Edge_Radius must be less than half of Strap_Plate_Thickness");
assert(Strap_Plate_Edge_Radius < Strap_Plate_Thickness, "Strap_Plate_Edge_Radius must be less than Strap_Plate_Thickness");
assert(Strap_Plate_Edge_Radius < Strap_Plate_Corner_Radius, "Strap_Plate_Edge_Radius must be less than Strap_Plate_Corner_Radius");
assert(2 * Strap_Plate_Corner_Radius <= Strap_Plate_Width, "Strap_Plate_Corner_Radius must be at most half of Strap_Plate_Width");
assert(2 * Strap_Plate_Tab_Corner_Radius <= Strap_Plate_Tab_Width, "Strap_Plate_Tab_Corner_Radius must be at most half of Strap_Plate_Tab_Width");
assert(2 * Lock_Notch_Corner_Radius <= notch_width, "Fit_Clearance leaves the notch narrower than its corner rounding");
assert(Lock_Inner_Diameter_Long < Lock_Outer_Diameter - 2 * Fit_Clearance, "Lock_Inner_Diameter_Long must be less than the ring outer diameter");
assert(Lock_Top_Thickness < Lock_Depth, "Lock_Top_Thickness must be less than Lock_Depth");

module ring() {
  difference() {
    cyl(d=Lock_Outer_Diameter - 2 * Fit_Clearance, h=Lock_Depth, rounding2=Lock_Outer_Corner_Radius, anchor=BOTTOM);
    translate([0, 0, -join]) hull() {
      scale([Lock_Inner_Diameter_Short, Lock_Inner_Diameter_Long, Lock_Depth + 2 * join]) cylinder(d=1, h=1);
      cuboid([Lock_Inner_Tab_Width, Lock_Inner_Tab_Length, Lock_Depth + 2 * join], anchor=BOTTOM);
    }
    translate([0, 0, -join]) cylinder(d=Lock_Inner_Diameter_Long, h=Lock_Top_Thickness + join);
  }
}

module notches() {
  difference() {
    cuboid(
      [Lock_Outer_Diameter + 2 * Lock_Notch_Depth - 2 * Fit_Clearance, notch_width, Lock_Depth],
      rounding=Lock_Notch_Corner_Radius, edges="Z", anchor=BOTTOM
    );
    translate([0, 0, -join]) cylinder(d=Lock_Inner_Diameter_Long, h=Lock_Depth + 2 * join);
  }
}

module lock() {
  ring();
  notches();
}

function tab_outline(side) = move(
  [0, side * (tab_y - join / 2)],
  rect([Strap_Plate_Tab_Length, Strap_Plate_Tab_Width + join], rounding=side > 0 ? [Strap_Plate_Tab_Corner_Radius, Strap_Plate_Tab_Corner_Radius, 0, 0] : [0, 0, Strap_Plate_Tab_Corner_Radius, Strap_Plate_Tab_Corner_Radius])
);

function plate_outline() = union([
  rect([Strap_Plate_Length, Strap_Plate_Width], rounding=Strap_Plate_Corner_Radius),
  for (sx = [-1, 1], side = [-1, 1]) move([sx * Strap_Plate_Length / 4, 0], tab_outline(side)),
])[0];

module strap_slot_cutter() {
  flare = rect(
    [Strap_Hole_Length + 2 * Strap_Hole_Edge_Radius, Strap_Hole_Width + 2 * Strap_Hole_Edge_Radius],
    rounding=Strap_Hole_Corner_Radius + Strap_Hole_Edge_Radius
  );
  offset_sweep(
    rect([Strap_Hole_Length, Strap_Hole_Width], rounding=Strap_Hole_Corner_Radius),
    height=Strap_Plate_Thickness,
    bottom=os_circle(r=-Strap_Hole_Edge_Radius),
    top=os_circle(r=-Strap_Hole_Edge_Radius)
  );
  translate([0, 0, -1]) linear_extrude(1.01) polygon(flare);
  translate([0, 0, Strap_Plate_Thickness - 0.01]) linear_extrude(1.01) polygon(flare);
}

module strap_plate() {
  difference() {
    offset_sweep(plate_outline(), height=Strap_Plate_Thickness, top=os_circle(r=Strap_Plate_Edge_Radius));
    for (sx = [-1, 1], sy = [-1, 1]) translate([sx * slot_x, sy * slot_y, 0]) strap_slot_cutter();
  }
}

strap_plate();
translate([0, 0, Strap_Plate_Thickness]) lock();
