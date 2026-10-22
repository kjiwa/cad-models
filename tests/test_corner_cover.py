"""Property tests for corner_cover: the cavity follows the mitered sills, walls close the top and sides, the lip holds the bottom."""

import math
import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

COVER_SCAD = os.path.join(REPO_ROOT, "models", "corner_cover", "corner_cover.scad")
WIDTH = 31.75
HEIGHT = 31.75
WALL = 3.175
FIT = 0.2
FAST = {"$fn": "24"}

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(COVER_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}})
    return _cache[key]


def sill_point(angle, side, t, w, z):
    """Point t along a sill and w inward from its outer line, for a corner of the given interior angle."""
    half = math.radians(angle / 2)
    d = (side * math.sin(half), math.cos(half))
    n = (-side * math.cos(half), math.sin(half))
    return (t * d[0] + w * n[0], t * d[1] + w * n[1], z)


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class CornerCoverTestCase(unittest.TestCase):
    def test_sill_slot_is_empty_along_both_sills(self):
        tris = render()
        for side in (1, -1):
            for t in (15, 35):
                self.assertFalse(contains(tris, sill_point(90, side, t, WIDTH / 2, HEIGHT / 2)), f"slot blocked at t={t}")

    def test_walls_close_the_outer_side_inner_side_and_top(self):
        tris = render()
        mid = WALL / 2 + FIT
        for side in (1, -1):
            self.assertTrue(contains(tris, sill_point(90, side, 25, -mid, HEIGHT / 2)), "outer wall is missing")
            self.assertTrue(contains(tris, sill_point(90, side, 45, WIDTH + mid, HEIGHT / 2)), "inner wall is missing")
            self.assertTrue(contains(tris, sill_point(90, side, 25, WIDTH / 2, HEIGHT + FIT + WALL / 2)), "top wall is missing")

    def test_sill_ends_are_open(self):
        tris = render()
        self.assertFalse(contains(tris, sill_point(90, 1, 50.8 + WALL / 2, WIDTH / 2, HEIGHT / 2)), "sill end is closed")

    def test_outer_corner_is_rounded(self):
        tris = render()
        self.assertTrue(contains(tris, (0, -FIT - WALL / 2, HEIGHT / 2)), "corner wall is missing")
        self.assertFalse(contains(tris, (0, -FIT - WALL * 0.98, HEIGHT / 2 + HEIGHT / 2 + WALL)), "top corner is square")

    def test_lip_holds_the_sill_bottom(self):
        tris = render()
        self.assertTrue(contains(tris, sill_point(90, 1, 25, 1.0, -WALL * 0.9)), "no lip under the sill edge")
        self.assertFalse(contains(tris, sill_point(90, 1, 25, WIDTH / 2, -WALL / 2)), "bottom is closed")

    def test_zero_lip_leaves_the_bottom_open(self):
        tris = render(Lip_Depth=0)
        self.assertFalse(contains(tris, sill_point(90, 1, 25, 1.0, -WALL * 0.9)), "lip remains at Lip_Depth=0")

    def test_wide_corner_keeps_the_slot_empty(self):
        tris = render(Corner_Angle=120)
        for side in (1, -1):
            self.assertFalse(contains(tris, sill_point(120, side, 25, WIDTH / 2, HEIGHT / 2)), "slot blocked at 120 degrees")
            self.assertTrue(contains(tris, sill_point(120, side, 25, -(WALL / 2 + FIT), HEIGHT / 2)), "outer wall is missing")


if __name__ == "__main__":
    unittest.main()
