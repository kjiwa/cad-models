"""Property tests for garage_door_rail_end_cap: overall size, rail pocket, bumper, rounding, and fit clearance."""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

CAP_SCAD = os.path.join(REPO_ROOT, "models", "garage_door_rail_end_cap", "garage_door_rail_end_cap.scad")
RAIL_HEIGHT = 55
RAIL_WIDTH = 25.4
RAIL_THICKNESS = 3.175
WALL = 3.175
DEPTH = 12.7
BUMPER = 3.175
FAST = {"$fn": "32"}

WALL_MID_X = RAIL_WIDTH / 2 - RAIL_THICKNESS / 2
WALL_INNER_X = RAIL_WIDTH / 2 - RAIL_THICKNESS
WALL_OUTER_X = RAIL_WIDTH / 2
CAP_OUTER_X = RAIL_WIDTH / 2 + WALL
CAP_TOP_Y = RAIL_HEIGHT / 2 + WALL

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(
            CAP_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}}, openscadpath=os.path.join(REPO_ROOT, "lib")
        )
    return _cache[key]


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class GarageDoorRailEndCapTestCase(unittest.TestCase):
    def test_overall_size_is_the_rail_plus_two_walls_by_the_depth(self):
        size = fingerprint(render())["bbox_size_mm"]
        want = (RAIL_WIDTH + 2 * WALL, RAIL_HEIGHT + 2 * WALL, DEPTH)
        for got, expected in zip(size, want):
            self.assertAlmostEqual(got, expected, delta=0.05)

    def test_pocket_is_open_to_the_rail_thickness(self):
        tris = render()
        z = DEPTH / 2
        self.assertFalse(contains(tris, (WALL_INNER_X + 0.3, 0, z)), "pocket is narrower than the rail")
        self.assertFalse(contains(tris, (WALL_OUTER_X - 0.3, 0, z)), "pocket is narrower than the rail")
        self.assertTrue(contains(tris, (WALL_INNER_X - 0.3, 0, z)), "inner cap wall is missing")
        self.assertTrue(contains(tris, (WALL_OUTER_X + 0.3, 0, z)), "outer cap wall is missing")

    def test_closed_end_is_the_bumper_thickness(self):
        tris = render(Bumper_Thickness=5)
        self.assertTrue(contains(tris, (WALL_MID_X, 0, 4.7)), "bumper is thinner than Bumper_Thickness")
        self.assertFalse(contains(tris, (WALL_MID_X, 0, 5.3)), "bumper is thicker than Bumper_Thickness")

    def test_default_bumper_matches_the_side_walls(self):
        tris = render()
        self.assertTrue(contains(tris, (WALL_MID_X, 0, BUMPER - 0.3)), "bumper is thin")
        self.assertFalse(contains(tris, (WALL_MID_X, 0, BUMPER + 0.3)), "bumper is thick")

    def test_fit_clearance_widens_the_pocket(self):
        tris = render(Fit_Clearance=0.4)
        self.assertFalse(contains(tris, (WALL_OUTER_X + 0.1, 0, DEPTH / 2)), "pocket ignores Fit_Clearance")
        self.assertTrue(contains(tris, (WALL_OUTER_X + 0.3, 0, DEPTH / 2)), "pocket grew past Fit_Clearance")

    def test_bumper_face_edge_is_rounded(self):
        tris = render()
        self.assertFalse(contains(tris, (CAP_OUTER_X - 0.1, 0, 0.1)), "bumper face edge is square")
        self.assertTrue(contains(tris, (WALL_OUTER_X - 1, 0, 0.1)), "bumper face is not flat")

    def test_outer_corner_is_rounded(self):
        self.assertFalse(contains(render(), (CAP_OUTER_X - 0.1, CAP_TOP_Y - 0.1, DEPTH / 2)), "outer corner is square")

    def test_pocket_mouth_is_chamfered(self):
        tris = render()
        self.assertFalse(contains(tris, (WALL_OUTER_X + 0.5, 0, DEPTH - 0.1)), "pocket mouth has no chamfer")
        self.assertTrue(contains(tris, (WALL_OUTER_X + 0.5, 0, DEPTH - 2)), "chamfer cuts too deep")


if __name__ == "__main__":
    unittest.main()
