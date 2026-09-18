/**
 * Hose adapter for Makita vacuums and dust extractors.
 *
 * This adapter fits inside tool dust ports and enables them to be connected to
 * Makita vacuums. All dimensions are in millimeters.
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
  // Generates the solid adapter profile consisting of two cylindrical ends
  // connected by a conical transition loft.
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

// Wall thickness of the adapter shell in millimeters.
hose_adapter_thickness = 2;

// Inside diameter of the Makita vacuum hose connection in millimeters.
makita_dust_extractor_port_diameter = 37;

// Tool dust port inside diameter in millimeters.
// dust_port_diameter = 30.5;  // Kreg pocket hole jig K4
// dust_port_diameter = 31.5;  // Ryobi P411 cordless random orbit sander
dust_port_diameter = 34.5;  // DeWalt DW618 router plunge base

hose_adapter(
    dust_port_diameter,
    makita_dust_extractor_port_diameter,
    hose_adapter_thickness);
