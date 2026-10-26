"""Property tests for closet_pole_socket: bore, open slot, screw hole, and the Part selection."""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

SOCKET_SCAD = os.path.join(REPO_ROOT, "models", "closet_pole_socket", "closet_pole_socket.scad")
BASE_D = 55.6
BASE_T = 3.5
SCREW_D = 4
HEAD_D = 8.75
OUTER_D = 41
INNER_D = 35
HEIGHT = 19
FAST = {"$fn": "64"}

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(
            SOCKET_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}}, openscadpath=os.path.join(REPO_ROOT, "lib")
        )
    return _cache[key]


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class ClosetPoleSocketTestCase(unittest.TestCase):
    def test_overall_size_matches_the_original(self):
        size = fingerprint(render())["bbox_size_mm"]
        for got, want in zip(size, (BASE_D, BASE_D, BASE_T + HEIGHT)):
            self.assertAlmostEqual(got, want, delta=0.05)

    def test_bore_equals_socket_inner_diameter(self):
        tris = render()
        z = BASE_T + HEIGHT / 2
        for dx, dy in ((1, 0), (0, 1), (-1, 0), (0, -1)):
            self.assertTrue(contains(tris, (dx * (INNER_D / 2 + 0.3), dy * (INNER_D / 2 + 0.3), z)), "wall is missing")
            self.assertFalse(contains(tris, (dx * (INNER_D / 2 - 0.3), dy * (INNER_D / 2 - 0.3), z)), "bore is narrower than Socket_Inner_Diameter")

    def test_bore_is_closed_by_the_base(self):
        self.assertTrue(contains(render(), (10, 10, BASE_T / 2)), "base is missing under the bore")
        self.assertFalse(contains(render(), (10, 10, BASE_T + 1)), "bore floor is above the base")

    def test_screw_hole_goes_through_the_base(self):
        tris = render()
        self.assertFalse(contains(tris, (0, 0, 0.1)), "screw hole is closed at the bottom")
        self.assertFalse(contains(tris, (0, 0, BASE_T - 0.1)), "screw hole is closed at the top")
        self.assertTrue(contains(tris, (SCREW_D / 2 + 0.5, 0, 0.1)), "screw hole is wider than the shank")
        self.assertFalse(contains(tris, (HEAD_D / 2 - 0.5, 0, BASE_T - 0.1)), "countersink is narrower than the head")

    def test_open_slot_equals_the_bore_width(self):
        tris = render(Part='"open"')
        z = BASE_T + HEIGHT / 2
        for side in (1, -1):
            self.assertFalse(contains(tris, (side * (INNER_D / 2 - 0.3), 19, z)), "slot is narrower than the bore")
            self.assertTrue(contains(tris, (side * (INNER_D / 2 + 0.3), 8, z)), "slot is wider than the bore")
        self.assertTrue(contains(tris, (0, -19, z)), "back wall is missing")
        self.assertFalse(contains(tris, (0, 19, z)), "open side is closed")

    def test_closed_socket_has_a_full_wall(self):
        self.assertTrue(contains(render(), (0, 19, BASE_T + HEIGHT / 2)), "closed socket has a gap")

    def test_open_slot_entry_is_chamfered(self):
        tris = render(Part='"open"')
        z = BASE_T + HEIGHT / 2
        self.assertFalse(contains(tris, (INNER_D / 2 + 0.3, 10.2, z)), "slot entry corner is square")

    def test_socket_lip_is_rounded(self):
        z = BASE_T + HEIGHT - 0.1
        self.assertFalse(contains(render(), (OUTER_D / 2 - 0.05, 0, z)), "socket lip is square")

    def test_base_rim_is_chamfered(self):
        self.assertFalse(contains(render(), (BASE_D / 2 - 0.1, 0, BASE_T - 0.1)), "base rim is square")


if __name__ == "__main__":
    unittest.main()
