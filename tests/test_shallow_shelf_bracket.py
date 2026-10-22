"""Property tests for shallow_shelf_bracket: cove gusset saves material, holes keep their axes, contact faces stay flat."""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

BRACKET_SCAD = os.path.join(REPO_ROOT, "models", "shallow_shelf_bracket", "shallow_shelf_bracket.scad")
HEIGHT = 50.8
DEPTH = 203.2
WIDTH = 19.05
WALL = 6.35
MID = WIDTH / 2
FAST = {"$fn": "48"}

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(
            BRACKET_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}}, openscadpath=os.path.join(REPO_ROOT, "lib")
        )
    return _cache[key]


def hull_volume():
    """Volume of the original: the hull of a wall plate and a shelf plate."""
    pts = [(0, 0), (DEPTH, 0), (DEPTH, WALL), (WALL, HEIGHT), (0, HEIGHT)]
    area = sum(x0 * y1 - x1 * y0 for (x0, y0), (x1, y1) in zip(pts, pts[1:] + pts[:1])) / 2
    return area * WIDTH


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class ShelfBracketTestCase(unittest.TestCase):
    def test_uses_less_material_than_the_straight_hull(self):
        self.assertLess(fingerprint(render())["volume_mm3"], hull_volume())

    def test_bbox_keeps_the_overall_size(self):
        size = fingerprint(render())["bbox_size_mm"]
        for got, want in zip(size, (DEPTH, HEIGHT, WIDTH)):
            self.assertAlmostEqual(got, want, delta=0.05)

    def test_gusset_is_a_cove(self):
        tris = render()
        self.assertTrue(contains(tris, (105, 8, MID)), "arm is missing under the cove")
        self.assertFalse(contains(tris, (105, 20, MID)), "gusset is still the straight hull")
        self.assertTrue(contains(tris, (3, 49, MID)), "wall arm is short")

    def test_wall_screw_hole_keeps_its_axis(self):
        tris = render()
        self.assertFalse(contains(tris, (3, 25.4, MID)), "no hole through the wall arm")
        self.assertTrue(contains(tris, (3, 25.4 + 3.5, MID)), "wall hole is too wide")
        self.assertFalse(contains(tris, (25, 25.4, MID)), "no driver channel beyond the head seat")

    def test_shelf_screw_hole_keeps_its_axis(self):
        tris = render()
        self.assertFalse(contains(tris, (152.4, 3, MID)), "no hole through the shelf arm")
        self.assertTrue(contains(tris, (152.4 + 3.5, 3, MID)), "shelf hole is too wide")
        self.assertFalse(contains(tris, (152.4, 18, MID)), "no driver channel beyond the head seat")

    def test_boss_holds_the_head_seat_where_the_cove_is_thin(self):
        tris = render()
        self.assertTrue(contains(tris, (152.4 + 6.5, 12, MID)), "no boss around the shelf hole")

    def test_contact_faces_are_flat(self):
        tris = render()
        self.assertTrue(contains(tris, (0.3, 40, MID)), "wall face is short")
        self.assertFalse(contains(tris, (-0.3, 40, MID)))
        self.assertTrue(contains(tris, (80, 0.3, MID)), "shelf face is short")
        self.assertTrue(contains(tris, (0.3, 0.3, MID)), "the mounting corner is rounded")

    def test_exposed_corners_and_bed_edge_are_eased(self):
        tris = render()
        self.assertFalse(contains(tris, (0.3, 50.5, MID)), "wall tip is square")
        self.assertFalse(contains(tris, (50, 0.5, 0.2)), "bed-side edge is square")
        self.assertTrue(contains(tris, (50, 3, 0.2)), "bed-side face is too narrow")


if __name__ == "__main__":
    unittest.main()
