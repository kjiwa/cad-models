"""Property tests for stop_block: bearing faces stay flat, outer corners round, relief and slots are cut."""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

STOP_SCAD = os.path.join(REPO_ROOT, "models", "stop_block", "stop_block.scad")
FAST = {"$fn": "32"}
FENCE_DEPTH = 35
FENCE_HEIGHT = 66
WIDTH = 19
EDGE = 2

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(STOP_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}})
    return _cache[key]


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class StopBlockTestCase(unittest.TestCase):
    def test_bbox_matches_the_original(self):
        self.assertEqual(fingerprint(render())["bbox_size_mm"], [54, 76, 19])

    def test_fence_face_is_flat(self):
        tris = render()
        for y in (EDGE + 2, 30, FENCE_HEIGHT - 3):
            self.assertTrue(contains(tris, (FENCE_DEPTH + 0.3, y, EDGE)), f"fence face short at y={y}")
            self.assertFalse(contains(tris, (FENCE_DEPTH - 0.3, y, EDGE)), f"fence face proud at y={y}")

    def test_top_face_is_flat(self):
        tris = render()
        for x in (3, 20, FENCE_DEPTH - 3):
            self.assertTrue(contains(tris, (x, FENCE_HEIGHT + 0.3, EDGE)), f"top face short at x={x}")
            self.assertFalse(contains(tris, (x, FENCE_HEIGHT - 0.3, EDGE)), f"top face proud at x={x}")

    def test_end_faces_are_flat(self):
        tris = render()
        for x, y in ((50, 20), (40, 70), (20, 71)):
            self.assertTrue(contains(tris, (x, y, 0.3)), f"bottom face short at {x},{y}")
            self.assertTrue(contains(tris, (x, y, WIDTH - 0.3)), f"top face short at {x},{y}")

    def test_outer_corners_are_rounded(self):
        tris = render()
        for corner in ((53.8, 75.8), (0.2, 75.8), (53.8, 0.2)):
            self.assertFalse(contains(tris, (*corner, EDGE)), f"square corner at {corner}")
        for inside in ((52, 74), (2, 74), (53, 1)):
            self.assertTrue(contains(tris, (*inside, EDGE)), f"corner too deep at {inside}")

    def test_dust_relief_clears_both_fence_corners(self):
        tris = render()
        self.assertFalse(contains(tris, (FENCE_DEPTH + 0.4, FENCE_HEIGHT - 0.4, EDGE)), "no relief at the fence edge")
        self.assertFalse(contains(tris, (FENCE_DEPTH + 0.3, 0.3, EDGE)), "no relief at the table")
        self.assertTrue(contains(tris, (FENCE_DEPTH + 1.5, 1.5, EDGE)), "relief too large")

    def test_zero_relief_leaves_the_corners_square(self):
        tris = render(Dust_Relief=0)
        self.assertTrue(contains(tris, (FENCE_DEPTH + 0.4, FENCE_HEIGHT - 0.4, EDGE)))
        self.assertTrue(contains(tris, (FENCE_DEPTH + 0.3, 0.3, EDGE)))

    def test_bolt_slots_are_cut_through_both_legs(self):
        tris = render()
        mid = WIDTH / 2
        for point in ((10, 71, mid), (45, 30, mid), (45, 15, mid), (45, 50, mid)):
            self.assertFalse(contains(tris, point), f"slot blocked at {point}")
        for point in ((10, 71, 4), (45, 30, 4), (45, 30, WIDTH - 4)):
            self.assertTrue(contains(tris, point), f"slot too wide at {point}")


if __name__ == "__main__":
    unittest.main()
