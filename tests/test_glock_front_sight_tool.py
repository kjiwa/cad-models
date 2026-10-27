"""Property tests for glock_front_sight_tool: cavity width per slide, entry chamfers, sight slot, and overall size."""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

TOOL_SCAD = os.path.join(REPO_ROOT, "models", "glock_front_sight_tool", "glock_front_sight_tool.scad")
SLIDES = {"compact": 21, "slimline": 22, "standard": 25.5, "wide": 28.5}
CLEARANCE = 0.2
SIGHT_WIDTH = 3.5
SIGHT_LENGTH = 10
HEIGHT = 15
LENGTH = 20
WALL = 3
FAST = {"$fn": "32"}

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(
            TOOL_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}}, openscadpath=os.path.join(REPO_ROOT, "lib")
        )
    return _cache[key]


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class GlockFrontSightToolTestCase(unittest.TestCase):
    def test_cavity_width_is_slide_width_plus_clearance_for_every_slide(self):
        for size, width in SLIDES.items():
            tris = render(Slide_Size=f'"{size}"')
            half = (width + CLEARANCE) / 2
            for side in (1, -1):
                self.assertFalse(contains(tris, (LENGTH / 2, side * (half - 0.05), 5)), f"cavity too narrow for {width}")
                self.assertTrue(contains(tris, (LENGTH / 2, side * (half + 0.05), 5)), f"cavity too wide for {width}")

    def test_cavity_entry_is_wider_than_the_slide_at_the_bottom(self):
        for size, width in SLIDES.items():
            tris = render(Slide_Size=f'"{size}"')
            for side in (1, -1):
                self.assertFalse(contains(tris, (LENGTH / 2, side * (width / 2 + 0.6), 0.05)), f"no entry chamfer for {width}")

    def test_outer_size_is_tool_length_by_slide_plus_walls_by_tool_height(self):
        for size, width in SLIDES.items():
            bbox = fingerprint(render(Slide_Size=f'"{size}"'))["bbox_size_mm"]
            for got, want in zip(bbox, (LENGTH, width + 2 * WALL, HEIGHT)):
                self.assertAlmostEqual(got, want, delta=0.05)

    def test_part_is_centered_on_y(self):
        ys = [vertex[1] for tri in render() for vertex in tri]
        self.assertAlmostEqual(min(ys), -(25.5 + 2 * WALL) / 2, delta=0.05)
        self.assertAlmostEqual(max(ys), (25.5 + 2 * WALL) / 2, delta=0.05)

    def test_sight_slot_is_sight_width_and_open_at_the_end(self):
        tris = render()
        z = HEIGHT - WALL / 2
        x = SIGHT_LENGTH / 2
        for side in (1, -1):
            self.assertFalse(contains(tris, (x, side * (SIGHT_WIDTH / 2 - 0.05), z)), "slot too narrow")
            self.assertTrue(contains(tris, (x, side * (SIGHT_WIDTH / 2 + 0.05), z)), "slot too wide")
        self.assertFalse(contains(tris, (0.1, 0, z)), "slot is closed at the end")
        self.assertTrue(contains(tris, (SIGHT_LENGTH + 0.5, 0, z)), "slot runs past its length")

    def test_sight_slot_entry_is_chamfered(self):
        tris = render()
        z = HEIGHT - WALL / 2
        for side in (1, -1):
            self.assertFalse(contains(tris, (0.1, side * (SIGHT_WIDTH / 2 + 0.5), z)), "slot entry has no chamfer")

    def test_outer_edges_are_rounded(self):
        tris = render()
        half = (25.5 + 2 * WALL) / 2
        self.assertFalse(contains(tris, (LENGTH - 0.1, half - 0.1, HEIGHT - 0.1)), "top corner is square")
        self.assertFalse(contains(tris, (LENGTH - 0.1, half - 0.1, 8)), "vertical edge is square")

    def test_invalid_parameters_fail_their_asserts(self):
        cases = [
            ({"Sight_Width": "25"}, "Sight_Width plus twice Entry_Chamfer must be less than the cavity width"),
            ({"Sight_Length": "1"}, "Sight_Length must exceed Entry_Chamfer"),
            (
                {"Tool_Length": "2", "Sight_Length": "1", "Entry_Chamfer": "0.5"},
                "Edge_Radius must be at most half of Wall_Thickness and Tool_Length",
            ),
        ]
        for params, message in cases:
            with self.subTest(params=params):
                with self.assertRaises(RuntimeError) as ctx:
                    render_triangles(TOOL_SCAD, {**FAST, **params}, openscadpath=os.path.join(REPO_ROOT, "lib"))
                self.assertIn(message, str(ctx.exception))


if __name__ == "__main__":
    unittest.main()
