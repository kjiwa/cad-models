include <BOSL2/std.scad>
use <threads-scad/threads.scad>;

/**
 * Motorcycle mirror extension: a riser that moves the mirror up and out. The lower socket bolts
 * to the mirror boss with a socket-head screw (M10x1.25, 34 Nm on a Honda); the mirror stem
 * threads into the upper socket. Print upright, as modeled; the underside of the arm runs at
 * 45 degrees, so it needs no support. The default thread takes an E-Z LOK 650-10F 9/16"-12
 * insert, because printed threads are weaker than metal; the M10_Bolt preset cuts the M10x1.25
 * stem thread directly. All dimensions are in millimeters.
 */

/* [Arm] */
// Height from the boss to the top of the upper socket
Extension_Height = 36;

// Horizontal distance from the screw axis to the thread axis
Extension_Length = 40.5;

/* [Lower Socket] */
// Outside diameter of the lower socket
Lower_Socket_Diameter = 19.5;

// Mounting screw clearance diameter (M10)
Screw_Diameter = 10.5;

// Thickness of the shoulder under the screw head
Screw_Depth = 6;

// Counterbore diameter for the screw head
Screw_Head_Diameter = 16.5;

// Counterbore depth above the shoulder
Screw_Head_Depth = 7;

/* [Upper Socket] */
// Outside diameter of the upper socket
Upper_Socket_Diameter = 19.5;

// Depth of the threaded bore
Thread_Depth = 16;

// Outside diameter of the thread (14.2875 for a 9/16" insert, 10 for M10)
Thread_Diameter = 14.2875;

// Thread pitch (2.116667 for 9/16"-12, 1.25 for M10)
Thread_Pitch = 2.116667;

/* [Finish] */
// Radius of the rounded outer edges
Edge_Radius = 1;

// Width of the lead-in chamfer at the thread mouth
Thread_Chamfer = 1;

// Width of the lead-in chamfer at the counterbore mouth
Counterbore_Chamfer = 0.5;

/* [Hidden] */
$fn = 128;

join = 0.125;
lower_height = Screw_Depth + Screw_Head_Depth;
thread_base = Extension_Height - Thread_Depth;
foot_x = max(0, Extension_Length - thread_base);

assert(Screw_Diameter < Screw_Head_Diameter, "Screw_Diameter must be less than Screw_Head_Diameter");
assert(Screw_Head_Diameter + 2 * Counterbore_Chamfer <= Lower_Socket_Diameter - 2 * Edge_Radius, "Screw_Head_Diameter must leave a wall under the counterbore chamfer");
assert(Thread_Diameter + 2 * Thread_Chamfer < Upper_Socket_Diameter - 2 * Edge_Radius, "Thread_Diameter must leave a wall under the thread chamfer");
assert(Thread_Depth > 0 && Thread_Depth < Extension_Height, "Thread_Depth must be positive and less than Extension_Height");
assert(Screw_Depth > 0 && Screw_Head_Depth > 0, "Screw_Depth and Screw_Head_Depth must be positive");
assert(lower_height <= Extension_Height, "the lower socket must not exceed Extension_Height");
assert(Edge_Radius > 0, "Edge_Radius must be positive");

module Socket(diameter, height) {
  cyl(d = diameter, h = height, rounding = Edge_Radius, anchor = BOTTOM);
}

module Body() {
  hull() {
    Socket(Lower_Socket_Diameter, lower_height);
    right(foot_x) Socket(Upper_Socket_Diameter, 2 * Edge_Radius);
    translate([Extension_Length, 0, thread_base]) Socket(Upper_Socket_Diameter, Thread_Depth);
  }
}

module ScrewBore() {
  down(join) cyl(d = Screw_Diameter, h = Extension_Height + 2 * join, anchor = BOTTOM);
  up(Screw_Depth) cyl(d = Screw_Head_Diameter, h = Extension_Height, anchor = BOTTOM);
  up(lower_height - Counterbore_Chamfer) cyl(d1 = Screw_Head_Diameter, d2 = Screw_Head_Diameter + 2 * Counterbore_Chamfer + 2 * join, h = Counterbore_Chamfer + join, anchor = BOTTOM);
}

module ThreadMouth() {
  translate([Extension_Length, 0, Extension_Height - Thread_Chamfer])
    cyl(d1 = Thread_Diameter, d2 = Thread_Diameter + 2 * Thread_Chamfer + 2 * join, h = Thread_Chamfer + join, anchor = BOTTOM);
}

module MirrorExtension() {
  ScrewHole(outer_diam = Thread_Diameter, height = Thread_Depth, position = [Extension_Length, 0, thread_base], pitch = Thread_Pitch)
    difference() {
      Body();
      ScrewBore();
      ThreadMouth();
    }
}

MirrorExtension();
