"""Property tests for table_saw_blade_spacer: each Part's height, bore, and hub."""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

SPACER_SCAD = os.path.join(REPO_ROOT, "models", "table_saw_blade_spacer", "table_saw_blade_spacer.scad")
THICKNESS = 2.38125
OUTER = 50.8
BOTTOM_BORE = 15.5
BORE = 13
HUB = 15.5
FAST = {"$fn": "64"}

_cache = {}


def render(part, **extra):
    key = (part, tuple(sorted(extra.items())))
    if key not in _cache:
        _cache[key] = render_triangles(SPACER_SCAD, {**FAST, "Part": f'"{part}"', **extra})
    return _cache[key]


def assert_size(test, tris, expected):
    for got, want in zip(fingerprint(tris)["bbox_size_mm"], expected):
        test.assertAlmostEqual(got, want, delta=0.01)


def solid_between(tris, inner, outer, z):
    return not contains(tris, (inner - 0.2, 0, z)) and contains(tris, (inner + 0.2, 0, z)) and contains(tris, (outer - 0.2, 0, z)) and not contains(tris, (outer + 0.2, 0, z))


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class BladeSpacerTestCase(unittest.TestCase):
    def test_bottom_is_a_disc_with_the_large_bore(self):
        tris = render("bottom")
        assert_size(self, tris, [OUTER, OUTER, THICKNESS])
        self.assertTrue(solid_between(tris, BOTTOM_BORE / 2, OUTER / 2, THICKNESS / 2))

    def test_top_is_a_disc_with_the_small_bore(self):
        tris = render("top")
        assert_size(self, tris, [OUTER, OUTER, THICKNESS])
        self.assertTrue(solid_between(tris, BORE / 2, OUTER / 2, THICKNESS / 2))

    def test_middle_adds_a_hub_over_the_small_bore(self):
        tris = render("middle")
        assert_size(self, tris, [OUTER, OUTER, 2 * THICKNESS])
        self.assertTrue(solid_between(tris, BORE / 2, HUB / 2, 1.5 * THICKNESS))
        self.assertTrue(solid_between(tris, BORE / 2, OUTER / 2, 0.5 * THICKNESS))

    def test_ring_is_the_hub_alone(self):
        tris = render("ring")
        assert_size(self, tris, [HUB, HUB, THICKNESS])
        self.assertTrue(solid_between(tris, BORE / 2, HUB / 2, THICKNESS / 2))

    def test_edges_are_chamfered_but_faces_stay_flat(self):
        tris = render("top")
        self.assertFalse(contains(tris, (OUTER / 2 - 0.05, 0, 0.05)), "outer bottom edge is square")
        self.assertFalse(contains(tris, (BORE / 2 + 0.05, 0, THICKNESS - 0.05)), "bore top edge is square")
        self.assertTrue(contains(tris, (OUTER / 2 - 1, 0, 0.05)), "bottom face is not flat")
        self.assertTrue(contains(tris, (OUTER / 2 - 1, 0, THICKNESS - 0.05)), "top face is not flat")

    def test_zero_chamfer_leaves_square_edges(self):
        tris = render("top", Edge_Chamfer=0)
        self.assertTrue(contains(tris, (OUTER / 2 - 0.05, 0, 0.05)))


if __name__ == "__main__":
    unittest.main()
