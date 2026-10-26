"""Property tests for miter_clamp_spacer: frame slot, overhang step, and the chamfered outer corner."""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

SPACER_SCAD = os.path.join(REPO_ROOT, "models", "miter_clamp_spacer", "miter_clamp_spacer.scad")
FRAME = 19.84375
OVERHANG = 3.175
HOLDER = 28.575
WALL = (HOLDER - FRAME) / 2
FAST = {"$fn": "32"}

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(
            SPACER_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}}, openscadpath=os.path.join(REPO_ROOT, "lib")
        )
    return _cache[key]


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class MiterClampSpacerTestCase(unittest.TestCase):
    def test_overall_size_is_unchanged_by_the_chamfer(self):
        for chamfer in (0, 1.5875):
            size = fingerprint(render(Edge_Chamfer=chamfer))["bbox_size_mm"]
            for got in size:
                self.assertAlmostEqual(got, HOLDER, delta=0.05)

    def test_frame_slot_height_equals_frame_thickness(self):
        tris = render()
        point = (6, 12)
        self.assertTrue(contains(tris, (*point, WALL - 0.3)), "bottom wall is too thin")
        self.assertFalse(contains(tris, (*point, WALL + 0.3)), "slot starts too high")
        self.assertFalse(contains(tris, (*point, WALL + FRAME - 0.3)), "slot ends too low")
        self.assertTrue(contains(tris, (*point, WALL + FRAME + 0.3)), "top wall is too thin")

    def test_overhang_step_equals_frame_overhang(self):
        tris = render()
        x = WALL + OVERHANG
        self.assertTrue(contains(tris, (x - 0.3, 12, 1)), "overhang step is too narrow")
        self.assertFalse(contains(tris, (x + 0.3, 12, 1)), "overhang step is too wide")

    def test_outer_corner_is_chamfered(self):
        self.assertFalse(contains(render(), (0.3, 0.3, HOLDER / 2)), "outer corner is square")
        self.assertTrue(contains(render(Edge_Chamfer=0), (0.3, 0.3, HOLDER / 2)), "zero chamfer cuts the corner")

    def test_outer_leg_edges_are_chamfered(self):
        self.assertFalse(contains(render(), (5, 0.3, HOLDER - 0.3)), "top leg edge is square")
        self.assertTrue(contains(render(Edge_Chamfer=0), (5, 0.3, HOLDER - 0.3)), "zero chamfer cuts the edge")


if __name__ == "__main__":
    unittest.main()
