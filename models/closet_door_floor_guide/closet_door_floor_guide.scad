include <BOSL2/std.scad>

/**
 * Floor guide for closet doors: a base with a middle guide and an end guide at each side,
 * leaving a channel for each door. Print on its side, as modeled. All dimensions are in
 * millimeters.
 */

/* [Doors] */
// Door thickness (34.925 for 1-3/8")
Door_Thickness = 34.925;

// Gap added beside each door (1.5875 for 1/16")
Door_Clearance = 1.5875;

/* [Base] */
// Base length across all guides (88.9 for 3-1/2")
Base_Length = 88.9;

// Base depth (17.4625 for 11/16")
Base_Depth = 17.4625;

// Base thickness (2.38125 for 3/32")
Base_Thickness = 2.38125;

// Radius of the rounded base corners (1.5875 for 1/16")
Base_Corner_Radius = 1.5875;

/* [Guides] */
// Thickness of each end guide (3.175 for 1/8")
End_Guide_Thickness = 3.175;

// Thickness of the middle guide (9.525 for 3/8")
Middle_Guide_Thickness = 9.525;

// Guide depth (17.4625 for 11/16")
Guide_Depth = 17.4625;

// Guide height above the base (19.05 for 3/4")
Guide_Height = 19.05;

// Radius of the rounded guide tops (1.5875 for 1/16")
Guide_Top_Radius = 1.5875;

/* [Hidden] */
$fn = 128;

end_offset = Door_Thickness + Door_Clearance + (Middle_Guide_Thickness + End_Guide_Thickness) / 2;

assert(Base_Corner_Radius <= min(Base_Length, Base_Depth) / 2, "Base_Corner_Radius must be at most half of the base");
assert(Guide_Top_Radius <= min(End_Guide_Thickness, Guide_Depth) / 2, "Guide_Top_Radius must be at most half of the end guide");
assert(end_offset + End_Guide_Thickness / 2 <= Base_Length / 2 + 0.001, "Base_Length is too short for the guides");

module Base() {
  cuboid(
    [Base_Length, Base_Depth, Base_Thickness], rounding = Base_Corner_Radius,
    edges = [LEFT + FRONT, LEFT + BACK, RIGHT + FRONT, RIGHT + BACK]
  );
}

module Guide(thickness) {
  cuboid(
    [thickness, Guide_Depth, Guide_Height], rounding = Guide_Top_Radius,
    edges = [LEFT + FRONT, LEFT + BACK, RIGHT + FRONT, RIGHT + BACK, TOP]
  );
}

rotate([90, 0, 0]) {
  Base();
  translate([0, 0, (Base_Thickness + Guide_Height) / 2]) {
    Guide(Middle_Guide_Thickness);
    for (side = [-1, 1]) translate([side * end_offset, 0, 0]) Guide(End_Guide_Thickness);
  }
}
