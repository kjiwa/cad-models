/**
 * Ryobi tool adapter for Makita vacuums and dust extractors.
 *
 * This adapter fits inside the dust port of Ryobi 18V ONE+ cordless tools and
 * enables them to be connected to Makita vacuums.
 */

END_SECTION_HEIGHT = 20;
MIDDLE_SECTION_HEIGHT = 10;

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

hose_adapter(31.5, 37, 2);
