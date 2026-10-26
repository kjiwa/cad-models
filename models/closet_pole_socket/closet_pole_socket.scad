include <BOSL2/std.scad>

/**
 * Closet pole socket: a round base with a socket that holds the end of a closet pole. The
 * open socket has a slot, so the pole drops in from the side. Derived from the AtHome Pole
 * Socket by William A. Adams (https://www.printables.com/model/78232-athome-pole-socket),
 * licensed CC BY 4.0. Print base down. All dimensions are in millimeters, and the defaults
 * fit a 1-3/8" pole (Prime Line N 6568).
 */

/* [Part] */
// Part to print
Part = "closed"; // [closed: Closed Socket, open: Open Socket]

/* [Base] */
// Base diameter
Base_Diameter = 55.6;

// Base thickness
Base_Thickness = 3.5;

// Width of the chamfer on the base rim
Base_Chamfer = 1;

/* [Socket] */
// Socket outer diameter
Socket_Outer_Diameter = 41;

// Socket inner diameter (35 for a 1-3/8" pole)
Socket_Inner_Diameter = 35;

// Socket height above the base
Socket_Height = 19;

// Radius of the rounded socket lip
Socket_Lip_Radius = 1;

// Width of the chamfer at the open slot entry
Slot_Chamfer = 1.5;

/* [Screw] */
// Screw shank diameter (4 for a #8 wood screw)
Screw_Diameter = 4;

// Screw head diameter (8.75 for a #8 wood screw)
Screw_Head_Diameter = 8.75;

/* [Hidden] */
$fn = 128;

join = 0.125;
slot_corner_y = sqrt(pow(Socket_Outer_Diameter / 2, 2) - pow(Socket_Inner_Diameter / 2, 2));

assert(Base_Diameter > Socket_Outer_Diameter, "Base_Diameter must exceed Socket_Outer_Diameter");
assert(Base_Thickness > 0, "Base_Thickness must be positive");
assert(Base_Chamfer < Base_Thickness, "Base_Chamfer must be less than Base_Thickness");
assert(Screw_Diameter < Screw_Head_Diameter, "Screw_Diameter must be less than Screw_Head_Diameter");
assert(Screw_Head_Diameter < Socket_Inner_Diameter, "Screw_Head_Diameter must be less than Socket_Inner_Diameter");
assert(Socket_Inner_Diameter < Socket_Outer_Diameter, "Socket_Inner_Diameter must be less than Socket_Outer_Diameter");
assert(Socket_Height > 0, "Socket_Height must be positive");
assert(Socket_Lip_Radius < (Socket_Outer_Diameter - Socket_Inner_Diameter) / 2, "Socket_Lip_Radius must be less than the socket wall");
assert(Slot_Chamfer < slot_corner_y, "Slot_Chamfer must be less than the slot depth");

module ClosedSocket() {
  difference() {
    union() {
      cyl(d = Base_Diameter, h = Base_Thickness, chamfer2 = Base_Chamfer, anchor = BOTTOM);
      up(Base_Thickness - join) cyl(d = Socket_Outer_Diameter, h = Socket_Height + join, rounding2 = Socket_Lip_Radius, anchor = BOTTOM);
    }
    down(join) cyl(d1 = Screw_Diameter, d2 = Screw_Head_Diameter, h = Base_Thickness + 2 * join, anchor = BOTTOM);
    up(Base_Thickness) cyl(d = Socket_Inner_Diameter, h = Socket_Height + join, anchor = BOTTOM);
  }
}

module SlotCutout() {
  half = Socket_Inner_Diameter / 2;
  reach = Slot_Chamfer + Socket_Outer_Diameter;
  y0 = slot_corner_y - Slot_Chamfer;
  up(Base_Thickness) linear_extrude(Socket_Height + join) polygon([
    [-half, 0], [half, 0], [half, y0], [half + reach, y0 + reach], [-half - reach, y0 + reach], [-half, y0]
  ]);
}

module OpenSocket() {
  difference() {
    ClosedSocket();
    SlotCutout();
  }
}

if (Part == "open") OpenSocket();
else ClosedSocket();
