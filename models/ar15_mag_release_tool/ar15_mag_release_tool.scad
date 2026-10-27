include <BOSL2/std.scad>

/**
 * Tool for pressing the magazine release of an AR-15 when the button is recessed: a plunger
 * on a textured thumb head. Print head down, as modeled. All dimensions are in millimeters.
 */

/* [Plunger] */
// Plunger width (7.9375 for 5/16")
Plunger_Width = 7.9375;

// Plunger length (12.7 for 1/2")
Plunger_Length = 12.7;

// Plunger height above the head (9.525 for 3/8")
Plunger_Height = 9.525;

// Radius of the rounded plunger tip
Tip_Radius = 1.5;

/* [Head] */
// Head width (11.1125 for 7/16")
Head_Width = 11.1125;

// Head length (15.875 for 5/8")
Head_Length = 15.875;

// Head thickness (6.35 for 1/4")
Head_Thickness = 6.35;

// Radius of the rounded thumb face perimeter
Thumb_Radius = 1;

/* [Grip] */
// Size of one diamond in the grip texture
Texture_Size = 2.5;

// Depth of the grip texture recesses
Texture_Depth = 0.5;

/* [Hidden] */
$fn = 128;

assert(Plunger_Width <= Head_Width && Plunger_Length <= Head_Length, "Plunger must fit within the head");
assert(Tip_Radius > 0 && Thumb_Radius > 0, "Tip_Radius and Thumb_Radius must be positive");
assert(Tip_Radius <= Plunger_Width / 2, "Tip_Radius must be at most half of Plunger_Width");
assert(Thumb_Radius <= Head_Thickness / 2, "Thumb_Radius must be at most half of Head_Thickness");
assert(Texture_Depth < Thumb_Radius + Head_Width / 4, "Texture_Depth is too deep for the head");

function Stadium(width, length) = rect([width, length], rounding = width / 2);

module Head() {
  path = Stadium(Head_Width, Head_Length);
  intersection() {
    offset_sweep(path, height = Head_Thickness, bottom = os_circle(r = Thumb_Radius));
    linear_sweep(
      path, height = Head_Thickness,
      texture = "diamonds", tex_inset = true, tex_size = [Texture_Size, Texture_Size], tex_depth = Texture_Depth
    );
  }
}

module Plunger() {
  translate([0, 0, Head_Thickness - 0.01])
    offset_sweep(Stadium(Plunger_Width, Plunger_Length), height = Plunger_Height + 0.01, top = os_circle(r = Tip_Radius));
}

Head();
Plunger();
