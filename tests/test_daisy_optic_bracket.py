"""Property tests for daisy_optic_bracket: rail cavities, cross-slot lugs, screw holes and chamfers.

Probe points are given in the half's assembled frame (x from the split plane, y across the rail
stack, z along the bracket); `at` maps them to the printed orientation, outer face down.
"""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains, shell_count  # noqa: E402

BRACKET_SCAD = os.path.join(REPO_ROOT, "models", "daisy_optic_bracket", "daisy_optic_bracket.scad")
HALF_WIDTH = 14
LENGTH = 51.4
OPTIC_TOP, BLASTER_TOP = 10, -7.3
SLOT_WIDTH, SLOT_PITCH, SLOT_DEPTH, CLEARANCE = 5.3, 10.1, 4.7625, 0.3
LUG_LENGTH = SLOT_WIDTH - CLEARANCE
LUG_FLOOR = -(SLOT_DEPTH - CLEARANCE)
SCREW_SPACING, SCREW_Y, SCREW_DIAMETER = 35.4, 3.75, 4
FAST = {"$fn": "32"}
STEP = 0.1
TOL = 0.05

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(
            BRACKET_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}}, openscadpath=os.path.join(REPO_ROOT, "lib")
        )
    return _cache[key]


def at(x, y, z):
    return (z, y, HALF_WIDTH - x)


def runs(tris, x, y, solid):
    """Return (start, end) z spans along the line (x, y) whose occupancy equals `solid`."""
    spans, start = [], None
    for i in range(int(LENGTH / STEP)):
        z = i * STEP
        if contains(tris, at(x, y, z)) == solid:
            start = z if start is None else start
        elif start is not None:
            spans.append((start, z - STEP))
            start = None
    if start is not None:
        spans.append((start, LENGTH - STEP))
    return spans


def lug_spans(tris):
    return runs(tris, 3, -2, True)


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class DaisyOpticBracketTestCase(unittest.TestCase):
    def assertSolid(self, tris, x, y, z, msg):
        self.assertTrue(contains(tris, at(x, y, z)), msg)

    def assertEmpty(self, tris, x, y, z, msg):
        self.assertFalse(contains(tris, at(x, y, z)), msg)

    def test_lug_count_length_pitch_and_centering(self):
        for count in range(5):
            with self.subTest(count=count):
                spans = lug_spans(render(Lug_Count=count))
                self.assertEqual(len(spans), count)
                centers = [(a + b) / 2 for a, b in spans]
                for a, b in spans:
                    self.assertAlmostEqual(b - a, LUG_LENGTH, delta=2 * STEP)
                for c0, c1 in zip(centers, centers[1:]):
                    self.assertAlmostEqual(c1 - c0, SLOT_PITCH, delta=2 * STEP)
                if centers:
                    self.assertAlmostEqual(sum(centers) / count, LENGTH / 2, delta=2 * STEP)

    def test_lug_depth_and_split_clearance(self):
        tris = render()
        for a, b in lug_spans(tris):
            z = (a + b) / 2
            self.assertSolid(tris, 3, LUG_FLOOR + TOL, z, "lug is short of the slot depth")
            self.assertEmpty(tris, 3, LUG_FLOOR - TOL, z, "lug is deeper than the slot clearance allows")
            self.assertSolid(tris, 3, -TOL, z, "lug does not reach the rail top")
            self.assertEmpty(tris, CLEARANCE / 2 - TOL, -2, z, "lug crosses the half clearance at the split")
            self.assertSolid(tris, CLEARANCE / 2 + TOL, -2, z, "lug stops short of the half clearance")
            self.assertSolid(tris, 8.5, -2, z, "lug does not reach the rail flange wall")

    def test_zero_lugs_is_one_clean_shell_with_no_lugs(self):
        tris = render(Lug_Count=0)
        self.assertEqual(shell_count(tris), 1)
        self.assertEqual(lug_spans(tris), [])

    def test_lugs_join_the_body_in_one_shell(self):
        self.assertEqual(shell_count(render()), 1)

    def test_screw_holes_are_source_sized_and_spaced(self):
        tris = render()
        holes = runs(tris, 10, SCREW_Y, False)
        self.assertEqual(len(holes), 2)
        centers = [(a + b) / 2 for a, b in holes]
        self.assertAlmostEqual(centers[1] - centers[0], SCREW_SPACING, delta=2 * STEP)
        self.assertAlmostEqual(sum(centers) / 2, LENGTH / 2, delta=2 * STEP)
        for z in centers:
            r = SCREW_DIAMETER / 2
            self.assertEmpty(tris, 10, SCREW_Y + r - TOL, z, "hole is undersize")
            self.assertEmpty(tris, 10, SCREW_Y - r + TOL, z, "hole is undersize")
            self.assertSolid(tris, 10, SCREW_Y + r + TOL, z, "hole is oversize")
            self.assertSolid(tris, 10, SCREW_Y - r - TOL, z, "hole is oversize")

    def test_rail_cavities_match_the_source_profile(self):
        tris = render()
        z = 10
        pairs = (
            (6.35, 2), (6.35, 3.5),
            (4.4, 9), (4.4, 8),
            (9, -2), (9, -3.5),
            (6.25, -6), (6.25, -7),
        )
        for x, y in pairs:
            self.assertEmpty(tris, x - TOL, y, z, f"cavity is short at ({x}, {y})")
            self.assertSolid(tris, x + TOL, y, z, f"cavity is oversize at ({x}, {y})")
        slant_x = 6.35 - (6.35 - 4.4) * (6 - 4.6) / (7.5 - 4.6)
        self.assertEmpty(tris, slant_x - 0.07, 6, z, "optic rail slope is short")
        self.assertSolid(tris, slant_x + 0.07, 6, z, "optic rail slope is oversize")
        self.assertEmpty(tris, 8, -4.2 + TOL, z, "blaster rail ledge is short")
        self.assertSolid(tris, 8, -4.2 - TOL, z, "blaster rail ledge is oversize")
        self.assertSolid(tris, 8, 0 + TOL, z, "optic rail base is missing")

    def test_outer_bbox(self):
        size = fingerprint(render(Lug_Count=0))["bbox_size_mm"]
        for got, want in zip(size, (LENGTH, OPTIC_TOP - BLASTER_TOP, HALF_WIDTH - 4.4)):
            self.assertAlmostEqual(got, want, delta=TOL)

    def test_outer_long_corners_are_chamfered_and_outer_face_is_flat(self):
        tris = render()
        z = 10
        self.assertEmpty(tris, 13, BLASTER_TOP + TOL, z, "blaster side corner is square")
        self.assertSolid(tris, 11, BLASTER_TOP + TOL, z, "blaster side chamfer is oversize")
        self.assertEmpty(tris, 13, OPTIC_TOP - TOL, z, "optic side corner is square")
        self.assertSolid(tris, 11, OPTIC_TOP - TOL, z, "optic side chamfer is oversize")
        for y in (-4, 0, SCREW_Y + 2, 7):
            self.assertSolid(tris, HALF_WIDTH - TOL, y, z, f"outer face is not flat at y = {y}")

    def test_end_faces_and_channel_mouths_are_chamfered(self):
        tris = render()
        self.assertEmpty(tris, HALF_WIDTH - TOL, 0, TOL, "end face outer edge is square")
        self.assertSolid(tris, 13, 0, TOL, "end face chamfer is oversize")
        self.assertEmpty(tris, 4.5, 9, TOL, "optic channel mouth is square")
        self.assertSolid(tris, 4.5, 9, 1, "optic channel mouth chamfer is oversize")
        self.assertEmpty(tris, 9.05, -2, LENGTH - TOL, "blaster channel mouth is square")
        self.assertSolid(tris, 9.05, -2, LENGTH - 1, "blaster channel mouth chamfer is oversize")

    def test_invalid_parameters_fail_their_asserts(self):
        cases = [
            ({"Outer_Chamfer": "4.8"}, "Outer_Chamfer must leave the rail walls wider than Edge_Chamfer"),
            (
                {"Bracket_Thickness": "20", "Outer_Chamfer": "10"},
                "Outer_Chamfer must be less than half the rail stack depth",
            ),
            ({"Screw_Offset": "-6"}, "Screw holes must stay within the rail stack depth"),
            ({"Screw_Offset": "9"}, "Screw holes must stay within the rail stack depth"),
        ]
        for params, message in cases:
            with self.subTest(params=params):
                with self.assertRaises(RuntimeError) as ctx:
                    render_triangles(BRACKET_SCAD, {**FAST, **params}, openscadpath=os.path.join(REPO_ROOT, "lib"))
                self.assertIn(message, str(ctx.exception))


if __name__ == "__main__":
    unittest.main()
