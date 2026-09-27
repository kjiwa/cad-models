/**
 * Hose adapter for Makita vacuums and dust extractors.
 *
 * This adapter fits inside tool dust ports and enables them to be connected to
 * Makita vacuums. All dimensions are in millimeters.
 */

/* [Adapter Configuration] */
// Tool dust port inside diameter in millimeters
dust_port_diameter = 34.5;

// Inside diameter of Makita vacuum hose connection in millimeters
makita_dust_extractor_port_diameter = 37;

// Wall thickness of the adapter shell in millimeters
hose_adapter_thickness = 2;

// Height of the cylindrical end sections in millimeters
END_SECTION_HEIGHT = 20;

// Height of the tapered middle section in millimeters
MIDDLE_SECTION_HEIGHT = 10;

/* [Hidden] */
$fn = 64;
EPSILON = 0.02;

module hose_adapter(d1, d2, thickness) {
  module shell(d1, d2) {
    cylinder(h = END_SECTION_HEIGHT, d = d1);
    translate([0, 0, END_SECTION_HEIGHT])
      cylinder(h = MIDDLE_SECTION_HEIGHT, d1 = d1, d2 = d2);
    translate([0, 0, END_SECTION_HEIGHT + MIDDLE_SECTION_HEIGHT])
      cylinder(h = END_SECTION_HEIGHT, d = d2);
  }

  difference() {
    shell(d1, d2);
    translate([0, 0, -EPSILON]) {
      cylinder(h = END_SECTION_HEIGHT + EPSILON, d = d1 - 2 * thickness);
      translate([0, 0, END_SECTION_HEIGHT + EPSILON])
        cylinder(h = MIDDLE_SECTION_HEIGHT, d1 = d1 - 2 * thickness, d2 = d2 - 2 * thickness);
      translate([0, 0, END_SECTION_HEIGHT + EPSILON + MIDDLE_SECTION_HEIGHT])
        cylinder(h = END_SECTION_HEIGHT + EPSILON, d = d2 - 2 * thickness);
    }
  }
}

hose_adapter(
  dust_port_diameter,
  makita_dust_extractor_port_diameter,
  hose_adapter_thickness
);

