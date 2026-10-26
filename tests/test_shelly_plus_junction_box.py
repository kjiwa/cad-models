"""Property tests for shelly_plus_junction_box: box size, corner screw posts, lid holes, plug fit, and the mount."""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

BOX_SCAD = os.path.join(REPO_ROOT, "models", "shelly_plus_junction_box", "shelly_plus_junction_box.scad")
WALL = 2.0
OUTER_X = 97.2
OUTER_Y = 48.0
OUTER_Z = 23.0
POST_D = 7.0
PILOT_D = 2.5
HOLE_D = 3.5
HEAD_D = 7.0
CLEARANCE = 0.2
POST_TOP = OUTER_Z - WALL
POST_CENTERS = [
    (x, y)
    for x in (WALL + POST_D / 2, OUTER_X - WALL - POST_D / 2)
    for y in (WALL + POST_D / 2, OUTER_Y - WALL - POST_D / 2)
]
FAST = {"$fn": "32"}

_cache = {}


def render(part="box", **params):
    key = (part, tuple(sorted(params.items())))
    if key not in _cache:
        args = {**FAST, "Part": f'"{part}"', **{k: str(v) for k, v in params.items()}}
        _cache[key] = render_triangles(BOX_SCAD, args, openscadpath=os.path.join(REPO_ROOT, "lib"))
    return _cache[key]


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class ShellyPlusJunctionBoxTestCase(unittest.TestCase):
    def test_box_size_matches_the_original(self):
        size = fingerprint(render("box"))["bbox_size_mm"]
        for got, want in zip(size, (OUTER_X, OUTER_Y, OUTER_Z)):
            self.assertAlmostEqual(got, want, delta=0.05)

    def test_each_corner_has_a_post_with_an_open_pilot(self):
        tris = render("box")
        for x, y in POST_CENTERS:
            self.assertTrue(contains(tris, (x + POST_D / 2 - 0.5, y, 10)), f"no post at {x},{y}")
            self.assertTrue(contains(tris, (x, y + POST_D / 2 - 0.5, 10)), f"no post at {x},{y}")
            self.assertFalse(contains(tris, (x, y, 10)), f"pilot closed at {x},{y}")
            self.assertFalse(contains(tris, (x, y, POST_TOP - 0.3)), f"pilot closed at top of {x},{y}")
            self.assertTrue(contains(tris, (x + 2, y, POST_TOP - 0.3)), f"post short at {x},{y}")
            self.assertFalse(contains(tris, (x + 2, y, POST_TOP + 0.3)), f"post tall at {x},{y}")

    def test_each_post_fills_its_corner(self):
        tris = render("box")
        for x in (WALL + 0.5, OUTER_X - WALL - 0.5):
            for y in (WALL + 0.5, OUTER_Y - WALL - 0.5):
                self.assertTrue(contains(tris, (x, y, 10)), f"corner empty at {x},{y}")

    def test_each_post_is_rounded_on_its_inward_edge(self):
        tris = render("box")
        for x, y in POST_CENTERS:
            dx = 1 if x < OUTER_X / 2 else -1
            dy = 1 if y < OUTER_Y / 2 else -1
            self.assertFalse(
                contains(tris, (x + dx * (POST_D / 2 - 0.3), y + dy * (POST_D / 2 - 0.3), 10)),
                f"inward edge of the post at {x},{y} is not rounded",
            )

    def test_posts_stay_clear_of_the_wago_housings(self):
        tris = render("box")
        self.assertFalse(contains(tris, (15, WALL + POST_D / 2, 10)), "post reaches the Wago housing")

    def test_oversized_post_is_rejected(self):
        with self.assertRaises(RuntimeError):
            render("box", Post_Diameter=30)

    def test_lid_holes_sit_on_the_post_axes(self):
        tris = render("lid")
        for x, y in POST_CENTERS:
            self.assertFalse(contains(tris, (x, y, 0.1)), f"no countersink at {x},{y}")
            self.assertFalse(contains(tris, (x, y, 3.9)), f"no through hole at {x},{y}")
            self.assertFalse(contains(tris, (x + HOLE_D / 2 - 0.3, y, 3.9)), f"hole narrow at {x},{y}")
            self.assertTrue(contains(tris, (x + HOLE_D / 2 + 0.3, y, 3.9)), f"hole wide at {x},{y}")
            self.assertTrue(contains(tris, (x + HEAD_D / 2 + 0.3, y, 0.1)), f"countersink wide at {x},{y}")

    def test_lid_plug_is_smaller_than_the_opening_by_twice_the_clearance(self):
        tris = render("lid")
        mid_x, mid_y = OUTER_X / 2, OUTER_Y / 2
        for edge in (WALL + CLEARANCE, OUTER_X - WALL - CLEARANCE):
            inward = 1 if edge < mid_x else -1
            self.assertFalse(contains(tris, (edge - inward * 0.1, mid_y, 3)), "plug is wider than the opening less clearance")
            self.assertTrue(contains(tris, (edge + inward * 0.1, mid_y, 3)), "plug is narrower than the opening less clearance")
        for edge in (WALL + CLEARANCE, OUTER_Y - WALL - CLEARANCE):
            inward = 1 if edge < mid_y else -1
            self.assertFalse(contains(tris, (mid_x, edge - inward * 0.1, 3)), "plug is deeper than the opening less clearance")
            self.assertTrue(contains(tris, (mid_x, edge + inward * 0.1, 3)), "plug is shallower than the opening less clearance")

    def test_lid_is_rounded_on_the_outer_face_and_square_where_it_meets_the_box(self):
        tris = render("lid")
        mid_y = OUTER_Y / 2
        self.assertFalse(contains(tris, (0.05, mid_y, 0.05)), "outer face edge is square")
        self.assertTrue(contains(tris, (0.05, mid_y, WALL - 0.05)), "mating face edge is rounded")

    def test_lid_size(self):
        size = fingerprint(render("lid"))["bbox_size_mm"]
        for got, want in zip(size, (OUTER_X, OUTER_Y, 2 * WALL)):
            self.assertAlmostEqual(got, want, delta=0.05)

    def test_wago_row_fits_inside_the_box_at_the_largest_count(self):
        box_y = fingerprint(render("box", Wago_Connector_Left_Count=4))["bbox_size_mm"][1]
        lid_y = fingerprint(render("lid", Wago_Connector_Left_Count=4))["bbox_size_mm"][1]
        self.assertAlmostEqual(box_y, lid_y, delta=0.05, msg="Wago row pokes through the outer wall")
        self.assertGreaterEqual(lid_y, 4 * (18.8 + 2 * WALL), "box is shorter than the Wago row")

    def test_mount_tab_hole_is_centered_when_width_and_length_differ(self):
        tris = render("mount", Mount_Width=15, Mount_Tab_Length=30)
        self.assertFalse(contains(tris, (7.5 + 2.2, -15, 1)), "tab hole is off center")
        self.assertFalse(contains(tris, (7.5 - 2.2, -15, 1)), "tab hole is off center")
        self.assertTrue(contains(tris, (7.5 + 2.8, -15, 1)), "tab hole is too wide")

    def test_mount_size_matches_the_original(self):
        size = fingerprint(render("mount"))["bbox_size_mm"]
        for got, want in zip(size, (19.05, OUTER_Y + 2 * WALL + 2 * 19.05, OUTER_Z + 2 * WALL)):
            self.assertAlmostEqual(got, want, delta=0.05)


if __name__ == "__main__":
    unittest.main()
