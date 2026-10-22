"""Property tests for heater_vent_switch_cover: the cavity matches the original, the outside is eased and filleted."""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

COVER_SCAD = os.path.join(REPO_ROOT, "models", "heater_vent_switch_cover", "heater_vent_switch_cover.scad")
FLANGE = 9
FAST = {"$fn": "64"}

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(
            COVER_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}}, openscadpath=os.path.join(REPO_ROOT, "lib")
        )
    return _cache[key]


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class HeaterVentSwitchCoverTestCase(unittest.TestCase):
    def test_outer_bbox_matches_the_original(self):
        size = fingerprint(render())["bbox_size_mm"]
        for got, want in zip(size, (32, 45, 26.5)):
            self.assertAlmostEqual(got, want, delta=0.05)

    def test_flange_opening_is_unchanged(self):
        tris = render()
        for point in ((8.8, 0, 4), (-8.8, 0, 4), (0, 15.3, 4), (0, -15.3, 4)):
            self.assertFalse(contains(tris, point), f"opening is short at {point}")
        for point in ((9.3, 0, 4), (-9.3, 0, 4), (0, 15.7, 4), (0, -15.7, 4)):
            self.assertTrue(contains(tris, point), f"opening is oversize at {point}")

    def test_dome_cavity_is_unchanged(self):
        tris = render()
        self.assertFalse(contains(tris, (0, 0, FLANGE + 15.3)), "cavity is short under the crown")
        self.assertTrue(contains(tris, (0, 0, FLANGE + 15.7)), "cavity is oversize under the crown")
        self.assertFalse(contains(tris, (8.7, 0, FLANGE + 6)), "cavity is short at the end wall")
        self.assertTrue(contains(tris, (9.3, 0, FLANGE + 6)), "cavity is oversize at the end wall")
        self.assertFalse(contains(tris, (0, 15.3, FLANGE + 0.5)), "cavity is short at the side wall")
        self.assertTrue(contains(tris, (0, 15.7, FLANGE + 0.5)), "cavity is oversize at the side wall")

    def test_flange_corners_and_top_edge_are_rounded(self):
        tris = render()
        self.assertFalse(contains(tris, (15.8, 22.3, 4)), "flange corner is square")
        self.assertFalse(contains(tris, (15.9, 0, FLANGE - 0.1)), "flange top edge is square")
        self.assertTrue(contains(tris, (14, 0, FLANGE - 0.1)), "flange top is not flat")

    def test_dome_meets_the_flange_with_a_fillet(self):
        tris = render()
        self.assertTrue(contains(tris, (0, 17.7, FLANGE + 0.4)), "no fillet beside the dome")
        self.assertFalse(contains(tris, (0, 20.5, FLANGE + 0.4)), "fillet is too wide")


if __name__ == "__main__":
    unittest.main()
