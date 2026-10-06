"""Property tests for keyhole_router_template: fenced slot choice, workpiece spacing, V-notch marks, rounded corners."""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

TEMPLATE_SCAD = os.path.join(REPO_ROOT, "keyhole_router_template", "keyhole_router_template.scad")
FAST = {"$fn": "32"}
PLATE = 6.35
FENCE = 3.175
FENCE_HEIGHT = 6.35
WORKPIECE = 31.75
GUIDE = 16.66875
SHORT = 31.75
LONG = 139.7
VENT = 12.7
MARK = 2.38125
CORNER = 3.175
FENCE_Y = WORKPIECE / 2 + FENCE / 2
EDGE_DEPTH = WORKPIECE + 2 * FENCE

_cache = {}


def render(params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(TEMPLATE_SCAD, {**FAST, **params})
    return _cache[key]


def edge_guide(**params):
    base = {"Style": '"edge_guide"', "Plate_Width": "228.6"}
    return render({**base, **params})


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class KeyholeTemplateTestCase(unittest.TestCase):
    def test_edge_guide_routes_chosen_slot(self):
        for choice, length in (("short", SHORT), ("long", LONG)):
            with self.subTest(choice=choice):
                tris = edge_guide(Fenced_Slot='"%s"' % choice)
                self.assertFalse(contains(tris, (length / 2, 0, PLATE / 2)), "slot end is solid")
                self.assertFalse(contains(tris, (-length / 2, 0, PLATE / 2)), "slot end is solid")
                self.assertTrue(contains(tris, (length / 2 + GUIDE / 2 + VENT + 2, 0, PLATE / 2)), "plate past vent is empty")

    def test_edge_guide_depth_follows_workpiece_width(self):
        for width in (31.75, 40.0):
            with self.subTest(width=width):
                bbox = fingerprint(edge_guide(Workpiece_Width=str(width)))["bbox_size_mm"]
                self.assertAlmostEqual(bbox[1], width + 2 * FENCE, delta=0.05)

    def test_fences_straddle_workpiece(self):
        tris = edge_guide()
        z = PLATE + FENCE_HEIGHT / 2
        for side in (1, -1):
            self.assertTrue(contains(tris, (50, side * FENCE_Y, z)), "fence is empty")
        self.assertFalse(contains(tris, (50, 0, z)), "gap between fences is solid")
        self.assertFalse(contains(tris, (50, WORKPIECE / 2 - 0.1, z)), "fence intrudes on workpiece")
        self.assertTrue(contains(tris, (50, 0, PLATE / 2)), "plate is empty")

    def test_edge_guide_notches_cut_both_fences(self):
        for choice, length in (("short", SHORT), ("long", LONG)):
            tris = edge_guide(Fenced_Slot='"%s"' % choice)
            for x in (-length / 2, 0, length / 2):
                for side in (1, -1):
                    for z in (PLATE / 2, PLATE + FENCE_HEIGHT - 0.1):
                        with self.subTest(choice=choice, x=x, side=side, z=z):
                            self.assertFalse(contains(tris, (x, side * (EDGE_DEPTH / 2 - 0.5), z)), "notch is solid")
                            self.assertTrue(contains(tris, (x + 6, side * (EDGE_DEPTH / 2 - 0.5), z)), "plate is empty beside notch")
                            self.assertTrue(contains(tris, (x + MARK - 0.3, side * (EDGE_DEPTH / 2 - 0.5), z)), "notch is wider than 90 degrees")

    def test_three_slot_notches_on_nearest_edge(self):
        tris = render({})
        depth = 76.2
        offset = (LONG - SHORT) / 2
        for x in (-LONG / 2, 0, LONG / 2):
            with self.subTest(row="long", x=x):
                self.assertFalse(contains(tris, (x, depth / 2 - 0.5, PLATE / 2)), "long notch is solid")
                self.assertTrue(contains(tris, (x + 6, depth / 2 - 0.5, PLATE / 2)), "plate is empty beside notch")
        for centre in (-offset, offset):
            for x in (centre - SHORT / 2, centre, centre + SHORT / 2):
                with self.subTest(row="short", x=x):
                    self.assertFalse(contains(tris, (x, -depth / 2 + 0.5, PLATE / 2)), "short notch is solid")
                    self.assertTrue(contains(tris, (x + 6, -depth / 2 + 0.5, PLATE / 2)), "plate is empty beside notch")
        self.assertTrue(contains(tris, (0, -depth / 2 + 0.5, PLATE / 2)), "long slot centre marked on the short row edge")

    def test_zero_mark_depth_removes_notches(self):
        tris = render({"Mark_Depth": "0"})
        self.assertTrue(contains(tris, (0, 76.2 / 2 - 0.5, PLATE / 2)))

    def test_corners_are_rounded(self):
        width = 228.6
        for params, depth in (({}, 76.2), ({"Style": '"edge_guide"'}, EDGE_DEPTH)):
            with self.subTest(style=params.get("Style")):
                tris = render(params)
                self.assertFalse(contains(tris, (width / 2 - 0.2, depth / 2 - 0.2, 1)), "corner is square")
                self.assertTrue(contains(tris, (width / 2 - CORNER, depth / 2 - 0.6, 1)), "rounded edge is empty")

    def test_mark_depth_assert(self):
        with self.assertRaises(RuntimeError) as ctx:
            render_triangles(TEMPLATE_SCAD, {**FAST, "Mark_Depth": "20"})
        self.assertIn("Mark_Depth", str(ctx.exception))

    def test_edge_guide_notch_stops_inside_the_fence(self):
        with self.assertRaises(RuntimeError) as ctx:
            render_triangles(TEMPLATE_SCAD, {**FAST, "Style": '"edge_guide"', "Mark_Depth": str(FENCE)})
        self.assertIn("Fence_Thickness", str(ctx.exception))

    def test_edge_guide_fences_stand_above_the_plate(self):
        tris = render({"Style": '"edge_guide"'})
        self.assertEqual(max(p[2] for t in tris for p in t), PLATE + 6.35)


if __name__ == "__main__":
    unittest.main()
