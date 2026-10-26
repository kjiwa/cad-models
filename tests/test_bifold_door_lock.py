"""Property tests for bifold_door_lock: overall size, door slot, lead-in chamfer, and the front knob."""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

LOCK_SCAD = os.path.join(REPO_ROOT, "models", "bifold_door_lock", "bifold_door_lock.scad")
DOOR = 36.5125
GAP = 3.175
WIDTH = 152.4
DEPTH = 50.8
WALL = 6.35
KNOB_WIDTH = 19.05
KNOB_DEPTH = 4.7625
CHAMFER = 2.0
BODY_Y = DOOR + 2 * WALL
HEIGHT = DEPTH + GAP
TOP = HEIGHT / 2
FRONT = -BODY_Y / 2
FAST = {"$fn": "32"}

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(
            LOCK_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}}, openscadpath=os.path.join(REPO_ROOT, "lib")
        )
    return _cache[key]


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class BifoldDoorLockTestCase(unittest.TestCase):
    def test_overall_size_matches_the_original_in_millimeters(self):
        size = fingerprint(render())["bbox_size_mm"]
        for got, want in zip(size, (WIDTH, BODY_Y + KNOB_DEPTH, HEIGHT)):
            self.assertAlmostEqual(got, want, delta=0.05)

    def test_slot_is_door_thickness_wide(self):
        tris = render()
        for side in (1, -1):
            y = side * DOOR / 2
            self.assertFalse(contains(tris, (30, y - side * 0.3, 0)), "slot is narrower than the door")
            self.assertTrue(contains(tris, (30, y + side * 0.3, 0)), "slot is wider than the door")

    def test_slot_floor_leaves_the_top_gap(self):
        tris = render()
        floor = -TOP + GAP
        self.assertTrue(contains(tris, (30, 0, floor - 0.3)), "slot floor is missing")
        self.assertFalse(contains(tris, (30, 0, floor + 0.3)), "slot floor is too thick")

    def test_slot_is_open_at_the_top_and_ends(self):
        tris = render()
        self.assertFalse(contains(tris, (30, 0, TOP - 0.3)), "slot is closed at the top")
        self.assertFalse(contains(tris, (WIDTH / 2 - 0.3, 0, 0)), "slot is closed at the end")

    def test_slot_mouth_has_a_lead_in_chamfer(self):
        tris = render()
        y = DOOR / 2 + CHAMFER - 0.5
        self.assertFalse(contains(tris, (30, y, TOP - 0.2)), "slot mouth has no lead-in")
        self.assertTrue(contains(tris, (30, DOOR / 2 + 0.3, TOP - CHAMFER - 1)), "lead-in cuts below the chamfer")

    def test_no_chamfer_leaves_the_mouth_square(self):
        tris = render(Lead_In_Chamfer=0)
        self.assertTrue(contains(tris, (30, DOOR / 2 + 0.3, TOP - 0.3)), "mouth is chamfered at zero")

    def test_body_corners_are_rounded(self):
        self.assertFalse(contains(render(), (WIDTH / 2 - 0.1, FRONT + 0.1, 0)), "vertical corner is square")

    def test_knob_protrudes_from_the_front(self):
        tris = render()
        self.assertTrue(contains(tris, (8.5, FRONT - 1.5, 0)), "knob is missing")
        self.assertFalse(contains(tris, (0, FRONT - KNOB_DEPTH + 0.5, 0)), "knob has no front groove")
        self.assertTrue(contains(tris, (0, FRONT - 1.0, 0)), "knob groove is too deep")
        self.assertFalse(contains(tris, (8.5, FRONT - 1.5, TOP - 3.175 + 0.5)), "knob is taller than the lock")


if __name__ == "__main__":
    unittest.main()
