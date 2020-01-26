/**
 * Kreg pocket hole jig adapter for Makita vacuums and dust extractors.
 *
 * This adapter fits inside the dust port of Kreg pocket hole jigs and enables
 * them to be connected to Makita vacuums.
 */

/**
 * The height of the adapter's end sections. These sections fit into the dust
 * port and vacuum hose.
 */
END_SECTION_HEIGHT = 20;

/**
 * The height of the adapter's middle section. This section connects the two end
 * sections.
 */
MIDDLE_SECTION_HEIGHT = 10;

/**
 * Creates a hose adapter.
 *
 * @param d1 The inside diameter of the dust port.
 * @param d2 The inside diameter of the vacuum hose.
 * @param thickness The adapter thickness.
 */
module hose_adapter(d1, d2, thickness) {
  module shell(d1, d2) {
    cylinder(h=END_SECTION_HEIGHT, d=d1, $fn=32);
    translate([0, 0, END_SECTION_HEIGHT])
      cylinder(h=MIDDLE_SECTION_HEIGHT, d1=d1, d2=d2, $fn=32);
    translate([0, 0, END_SECTION_HEIGHT + MIDDLE_SECTION_HEIGHT])
      cylinder(h=END_SECTION_HEIGHT, d=d2, $fn=32);
  }
    
  difference() {
    shell(d1, d2);
    shell(d1 - 2 * thickness, d2 - 2 * thickness);
  }
}

hose_adapter(30.5, 37, 2);
