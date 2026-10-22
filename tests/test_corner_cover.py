"""Property tests for corner_cover: an L-shaped guard open on two sides, with a rounded outer corner."""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

COVER_SCAD = os.path.join(REPO_ROOT, "models", "corner_cover", "corner_cover.scad")
HEIGHT = 141.3
OUTER = 38.1
MID = HEIGHT / 2
FAST = {"$fn": "48"}

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(
            COVER_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}}, openscadpath=os.path.join(REPO_ROOT, "lib")
        )
    return _cache[key]


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class CornerCoverTestCase(unittest.TestCase):
    def test_bbox_matches_the_original_in_millimeters(self):
        size = fingerprint(render())["bbox_size_mm"]
        for got, want in zip(size, (OUTER, OUTER, HEIGHT)):
            self.assertAlmostEqual(got, want, delta=0.05)

    def test_pocket_is_empty_and_open_on_two_sides(self):
        tris = render()
        for point in ((-3, 3, MID), (-18.5, 5, MID), (5, 18.5, MID)):
            self.assertFalse(contains(tris, point), f"pocket is blocked at {point}")

    def test_walls_stand_on_the_other_two_sides(self):
        tris = render()
        for point in ((15.9, 0, MID), (0, -15.9, MID), (15.9, -15.9, MID)):
            self.assertTrue(contains(tris, point), f"wall is missing at {point}")

    def test_outer_corner_is_rounded(self):
        tris = render()
        self.assertFalse(contains(tris, (18.9, -18.9, MID)), "outer corner is square")
        self.assertTrue(contains(tris, (17, -17, MID)), "outer corner is too round")

    def test_top_and_bottom_edges_are_eased_unless_disabled(self):
        self.assertFalse(contains(render(), (19.0, 0, 0.1)), "top edge is square")
        self.assertTrue(contains(render(Edge_Radius=0), (19.0, 0, 0.1)), "edge is rounded at Edge_Radius=0")


if __name__ == "__main__":
    unittest.main()
