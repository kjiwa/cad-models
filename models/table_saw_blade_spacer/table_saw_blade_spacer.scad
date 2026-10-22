/**
 * Spacers for a table saw arbor, printed one part at a time. The bottom and top parts are
 * flat discs, the middle part adds a hub over the small bore, and the ring is the hub
 * alone, which centers the large-bore disc on the arbor. All dimensions are in millimeters.
 */

/* [Part] */
// Part to print
Part = "bottom"; // [bottom: Bottom, middle: Middle, top: Top, ring: Ring]

/* [Disc] */
// Disc outside diameter (50.8 for 2")
Outer_Diameter = 50.8;

// Disc thickness (2.38125 for 3/32")
Thickness = 2.38125;

// Bore of the bottom disc
Bottom_Bore_Diameter = 15.5;

// Bore of the other parts
Bore_Diameter = 13;

/* [Hub] */
// Gap between the hub and the bottom bore
Hub_Clearance = 0.2;

// Hub thickness (2.38125 for 3/32")
Hub_Thickness = 2.38125;

/* [Finish] */
// Chamfer on every circular edge (0 to disable)
Edge_Chamfer = 0.4;

/* [Hidden] */
$fn = 128;

hub_diameter = Bottom_Bore_Diameter - Hub_Clearance;

assert(Bore_Diameter < hub_diameter, "Bore_Diameter must be less than Bottom_Bore_Diameter minus Hub_Clearance");
assert(Bottom_Bore_Diameter < Outer_Diameter, "Bottom_Bore_Diameter must be less than Outer_Diameter");
assert(2 * Edge_Chamfer < (hub_diameter - Bore_Diameter) / 2, "Edge_Chamfer is too large for the hub wall");
assert(2 * Edge_Chamfer < min(Thickness, Hub_Thickness), "Edge_Chamfer is too large for the thickness");

module Section(inner, outer, height, z = 0) {
  translate([inner / 2, z]) square([(outer - inner) / 2, height]);
}

module Profile() {
  if (Part == "bottom") {
    Section(Bottom_Bore_Diameter, Outer_Diameter, Thickness);
  } else if (Part == "top") {
    Section(Bore_Diameter, Outer_Diameter, Thickness);
  } else if (Part == "ring") {
    Section(Bore_Diameter, hub_diameter, Hub_Thickness);
  } else {
    Section(Bore_Diameter, Outer_Diameter, Thickness);
    Section(Bore_Diameter, hub_diameter, Hub_Thickness + 0.01, Thickness - 0.01);
  }
}

module Chamfered() {
  if (Edge_Chamfer > 0) {
    offset(delta = Edge_Chamfer, chamfer = true) offset(delta = -Edge_Chamfer) children();
  } else {
    children();
  }
}

rotate_extrude() Chamfered() Profile();
