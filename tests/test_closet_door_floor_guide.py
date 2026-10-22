"""Property tests for closet_door_floor_guide: overall size, door channels, and the guides' rounded tops."""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

GUIDE_SCAD = os.path.join(REPO_ROOT, "models", "closet_door_floor_guide", "closet_door_floor_guide.scad")
DOOR = 34.925
CLEARANCE = 1.5875
MIDDLE = 9.525
END = 3.175
BASE = 2.38125
HEIGHT = 19.05
FAST = {"$fn": "32"}

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(
            GUIDE_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}}, openscadpath=os.path.join(REPO_ROOT, "lib")
        )
    return _cache[key]


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class ClosetDoorFloorGuideTestCase(unittest.TestCase):
    def test_overall_size_matches_the_original_in_millimeters(self):
        size = fingerprint(render())["bbox_size_mm"]
        for got, want in zip(size, (88.9, BASE + HEIGHT, 17.4625)):
            self.assertAlmostEqual(got, want, delta=0.05)

    def test_each_door_channel_is_door_thickness_plus_clearance(self):
        tris = render()
        y = -(BASE / 2 + HEIGHT / 2)
        gap_start = MIDDLE / 2
        gap_end = gap_start + DOOR + CLEARANCE
        for side in (1, -1):
            self.assertFalse(contains(tris, (side * (gap_start + 0.3), y, 0)), "channel is narrower than the door")
            self.assertFalse(contains(tris, (side * (gap_end - 0.3), y, 0)), "channel is narrower than the door")
            self.assertTrue(contains(tris, (side * (gap_start - 0.3), y, 0)), "middle guide is thin")
            self.assertTrue(contains(tris, (side * (gap_end + 0.3), y, 0)), "end guide is missing")

    def test_base_spans_both_channels(self):
        tris = render()
        self.assertTrue(contains(tris, (20, 0, 0)), "base is missing under the channel")
        self.assertTrue(contains(tris, (-44, 0, 0)), "base is short at the end")

    def test_guide_tops_are_rounded(self):
        tris = render()
        y = -(BASE / 2 + HEIGHT - 0.1)
        self.assertFalse(contains(tris, (MIDDLE / 2 - 0.1, y, 8.6)), "guide top corner is square")
        self.assertTrue(contains(tris, (0, y, 0)), "guide top is not flat")


if __name__ == "__main__":
    unittest.main()
