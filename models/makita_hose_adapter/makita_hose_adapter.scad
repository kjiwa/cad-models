/**
 * Hose adapter for Makita vacuums and dust extractors.
 *
 * This adapter fits inside tool dust ports and enables them to be connected to
 * Makita vacuums. All dimensions are in millimeters.
 */

/* [Adapter] */
// Inside diameter of the tool dust port (the default fits the DeWalt DW618)
Tool_Port_Diameter = 34.5;

// Inside diameter of the Makita vacuum hose connection
Hose_Port_Diameter = 37;

// Wall thickness of the adapter shell
Wall_Thickness = 2;

// Length of each cylindrical end section
End_Length = 20;

// Length of the tapered middle section
Taper_Length = 10;

/* [Hidden] */
$fn = 64;
EPSILON = 0.02;

assert(Wall_Thickness > 0, "Wall_Thickness must be positive");
assert(2 * Wall_Thickness < Tool_Port_Diameter, "Wall_Thickness must be less than half Tool_Port_Diameter");
assert(2 * Wall_Thickness < Hose_Port_Diameter, "Wall_Thickness must be less than half Hose_Port_Diameter");

module hose_adapter(d1, d2, thickness) {
  module shell(d1, d2) {
    cylinder(h = End_Length, d = d1);
    translate([0, 0, End_Length])
      cylinder(h = Taper_Length, d1 = d1, d2 = d2);
    translate([0, 0, End_Length + Taper_Length])
      cylinder(h = End_Length, d = d2);
  }

  difference() {
    shell(d1, d2);
    translate([0, 0, -EPSILON]) {
      cylinder(h = End_Length + EPSILON, d = d1 - 2 * thickness);
      translate([0, 0, End_Length + EPSILON])
        cylinder(h = Taper_Length, d1 = d1 - 2 * thickness, d2 = d2 - 2 * thickness);
      translate([0, 0, End_Length + EPSILON + Taper_Length])
        cylinder(h = End_Length + EPSILON, d = d2 - 2 * thickness);
    }
  }
}

hose_adapter(
  Tool_Port_Diameter,
  Hose_Port_Diameter,
  Wall_Thickness
);

