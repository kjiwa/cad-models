"""Property tests for french_cleat_router_template: cleat opening, dog-bone corner reliefs, and screw holes."""

import math
import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

TEMPLATE_SCAD = os.path.join(
    REPO_ROOT, "models", "french_cleat_router_template", "french_cleat_router_template.scad"
)
WALL = 6.35
CLEAT_THICKNESS = 19.05
CLEAT_HEIGHT = 95.25
CLEAT_ANGLE = 30
CLEAT_Y0 = (171.45 - CLEAT_HEIGHT) / 2
PLATE_Z = 25.4
HOLE_Z = 9.525
FAST = {"$fn": "32"}

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(
            TEMPLATE_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}}, openscadpath=os.path.join(REPO_ROOT, "lib")
        )
    return _cache[key]


def _plate(x, y):
    return (WALL + x, CLEAT_Y0 + y, PLATE_Z)


BIT_RADIUS = 22.225 / 2
OUTSIDE = 0.3


def _relief_probes():
    """Points in the plate material just outside each closed corner's walls, half a bit radius from the corner.

    The corner relief is only usable if it opens into the cleat opening along both walls, so a bearing can
    enter it. Each pair is one probe beside each wall that meets at the corner.
    """
    a = math.radians(CLEAT_ANGLE)
    along = BIT_RADIUS / 2
    bottom = (CLEAT_THICKNESS, 0)
    top = (CLEAT_THICKNESS, CLEAT_HEIGHT)
    return [
        _plate(bottom[0] + OUTSIDE, bottom[1] + along),
        _plate(bottom[0] - along, bottom[1] - OUTSIDE),
        _plate(top[0] + OUTSIDE, top[1] - along),
        _plate(top[0] - along * math.cos(a) - OUTSIDE * math.sin(a), top[1] - along * math.sin(a) + OUTSIDE * math.cos(a)),
    ]


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class FrenchCleatRouterTemplateTestCase(unittest.TestCase):
    def test_overall_size_matches_the_original_in_millimeters(self):
        size = fingerprint(render())["bbox_size_mm"]
        for got, want in zip(size, (82.55, 171.45, 31.75)):
            self.assertAlmostEqual(got, want, delta=0.05)

    def test_cleat_opening_matches_the_original_in_millimeters(self):
        tris = render()
        self.assertFalse(contains(tris, _plate(10, 1)), "opening is missing above its bottom edge")
        self.assertTrue(contains(tris, _plate(1, -1)), "opening extends below the cleat")
        self.assertFalse(contains(tris, _plate(CLEAT_THICKNESS - 1, 40)), "opening is thinner than the cleat")
        self.assertTrue(contains(tris, _plate(CLEAT_THICKNESS + 1, 40)), "opening is wider than the cleat")
        slope = CLEAT_HEIGHT - (CLEAT_THICKNESS - 2) * math.tan(math.radians(CLEAT_ANGLE))
        self.assertFalse(contains(tris, _plate(2, slope - 0.5)), "sloped edge is too low")
        self.assertTrue(contains(tris, _plate(2, slope + 0.5)), "sloped edge is too high")

    def test_closed_corners_are_relieved_for_the_router_bit(self):
        tris = render()
        for probe in _relief_probes():
            self.assertFalse(contains(tris, probe), f"dog-bone relief does not open into the cleat opening at {probe}")

    def test_relief_stays_within_one_bit_radius_of_the_corner(self):
        tris = render()
        self.assertTrue(contains(tris, _plate(CLEAT_THICKNESS + BIT_RADIUS + 1, 0)), "relief reaches past the bit radius")
        self.assertTrue(contains(tris, _plate(CLEAT_THICKNESS, -BIT_RADIUS - 1)), "relief reaches past the bit radius")

    def test_zero_bit_diameter_leaves_the_corners_closed(self):
        tris = render(Router_Bit_Diameter=0)
        for probe in _relief_probes():
            self.assertTrue(contains(tris, probe), f"corner is relieved with no router bit at {probe}")

    def test_screw_holes_match_the_original_in_millimeters(self):
        tris = render()
        for y in (25.4, 171.45 - 25.4):
            self.assertFalse(contains(tris, (3, y, HOLE_Z)), "screw hole is missing")
            self.assertFalse(contains(tris, (3, y + 3.5, HOLE_Z)), "countersink is too narrow")
            self.assertTrue(contains(tris, (3, y + 4.5, HOLE_Z)), "countersink is too wide")


if __name__ == "__main__":
    unittest.main()
