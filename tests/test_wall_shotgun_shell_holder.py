"""Property tests for wall_shotgun_shell_holder: rim channel, shell channel, column seats, column pitch, entry chamfer, rounding.

In exported STL coordinates the model is rotated 180 degrees about Z, so the plate sits at +Y and the
columns extend toward -Y. Probe points are (x offset from the holder center, depth in front of the plate,
height above the holder bottom). Column i is centered at column_x(i).
"""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

SCAD = os.path.join(REPO_ROOT, "models", "wall_shotgun_shell_holder", "wall_shotgun_shell_holder.scad")
FAST = {"$fn": "64"}
RIM, RIM_T, SHELL, DEPTH, WALL = 23.0, 2.0, 20.5, 10.0, 4.0
COLUMNS, ROWS = 2, 5
WIDTH = COLUMNS * (RIM + WALL) + WALL
HEIGHT = ROWS * RIM + WALL
FRONT = DEPTH + WALL
MID = HEIGHT / 2
PLATE_T = 1.5875

_cache = {}


def render(params=None):
    key = tuple(sorted((params or {}).items()))
    if key not in _cache:
        _cache[key] = render_triangles(SCAD, {**FAST, **(params or {})}, openscadpath=os.path.join(REPO_ROOT, "lib"))
    return _cache[key]


def column_x(i):
    return -WIDTH / 2 + WALL + RIM / 2 + i * (RIM + WALL)


def solid(tris, x, depth, z):
    return contains(tris, (x, -depth, z))


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class ShotgunShellHolderTestCase(unittest.TestCase):
    def test_shell_channel_width(self):
        tris = render()
        depth = WALL + RIM_T + 1
        for i in range(COLUMNS):
            c = column_x(i)
            with self.subTest(column=i):
                for side in (-1, 1):
                    self.assertFalse(solid(tris, c + side * (SHELL / 2 - 0.3), depth, MID))
                    self.assertTrue(solid(tris, c + side * (SHELL / 2 + 0.3), depth, MID))

    def test_rim_channel_width(self):
        tris = render()
        depth = WALL + RIM_T / 2
        for i in range(COLUMNS):
            c = column_x(i)
            with self.subTest(column=i):
                for side in (-1, 1):
                    self.assertFalse(solid(tris, c + side * (RIM / 2 - 0.3), depth, MID))
                    self.assertTrue(solid(tris, c + side * (RIM / 2 + 0.3), depth, MID))

    def test_rim_channel_thickness(self):
        tris = render()
        x = column_x(0) + (SHELL + RIM) / 4
        self.assertTrue(solid(tris, x, WALL - 0.3, MID))
        self.assertFalse(solid(tris, x, WALL + 0.3, MID))
        self.assertFalse(solid(tris, x, WALL + RIM_T - 0.3, MID))
        self.assertTrue(solid(tris, x, WALL + RIM_T + 0.3, MID))

    def test_channels_open_at_the_top(self):
        tris = render()
        for i in range(COLUMNS):
            c = column_x(i)
            with self.subTest(column=i):
                self.assertFalse(solid(tris, c, WALL + RIM_T + 1, HEIGHT - 0.5))
                self.assertFalse(solid(tris, c + RIM / 2 - 0.5, WALL + RIM_T / 2, HEIGHT - 0.5))

    def test_seat_at_each_column_bottom(self):
        tris = render()
        for i in range(COLUMNS):
            c = column_x(i)
            with self.subTest(column=i):
                for side in (-1, 1):
                    self.assertTrue(solid(tris, c + side * (SHELL / 2 - 1), FRONT - 2, WALL + 1))
                    self.assertFalse(solid(tris, c + side * (SHELL / 2 - 1), FRONT - 2, WALL + SHELL / 2 + 2))
                self.assertFalse(solid(tris, c, FRONT - 2, WALL + 3))
                self.assertFalse(solid(tris, c + SHELL / 2 - 1, WALL + RIM_T / 2, WALL + 1))

    def test_column_pitch(self):
        tris = render()
        mid = (column_x(0) + column_x(1)) / 2
        depth = WALL + RIM_T / 2
        self.assertTrue(solid(tris, mid + WALL / 2 - 0.3, depth, MID))
        self.assertTrue(solid(tris, mid - WALL / 2 + 0.3, depth, MID))
        self.assertFalse(solid(tris, mid + WALL / 2 + 0.3, depth, MID))
        self.assertFalse(solid(tris, mid - WALL / 2 - 0.3, depth, MID))

    def test_entry_chamfer_flares_the_channel_mouth(self):
        x = column_x(0) + SHELL / 2 + 0.5
        depth = WALL + RIM_T + 1
        self.assertFalse(solid(render(), x, depth, HEIGHT - 0.1))
        self.assertTrue(solid(render({"Entry_Chamfer": "0"}), x, depth, HEIGHT - 0.1))
        self.assertTrue(solid(render(), x, depth, HEIGHT - 3))

    def test_entry_chamfer_is_a_45_degree_flare_of_the_chamfer_size(self):
        edge = column_x(0) + SHELL / 2
        depth = WALL + RIM_T + 1
        tris = render()
        self.assertFalse(solid(tris, edge + 0.8, depth, HEIGHT - 0.05), "flare is narrower than the chamfer at the top")
        self.assertTrue(solid(tris, edge + 1.2, depth, HEIGHT - 0.05), "flare is wider than the chamfer at the top")
        self.assertFalse(solid(tris, edge + 0.4, depth, HEIGHT - 0.5), "flare is not 45 degrees")
        self.assertTrue(solid(tris, edge + 0.7, depth, HEIGHT - 0.5), "flare is not 45 degrees")

    def test_outer_edges_are_rounded_and_the_back_is_square(self):
        x = WIDTH / 2 - 0.05
        self.assertFalse(solid(render(), x, FRONT / 2, HEIGHT - 0.05))
        self.assertTrue(solid(render({"Corner_Radius": "0"}), x, FRONT / 2, HEIGHT - 0.05))
        self.assertTrue(solid(render(), x, 0.2, MID))

    def test_screw_mount_leaves_the_channels_intact(self):
        tris = render({"Mount_Type": '"screws"', "Screw_Hole_Rows": "2"})
        for i in range(COLUMNS):
            c = column_x(i)
            with self.subTest(column=i):
                self.assertFalse(solid(tris, c, WALL + RIM_T / 2, MID))
                self.assertTrue(contains(tris, (c, PLATE_T / 2, MID)))
                for z in (HEIGHT / 4, 3 * HEIGHT / 4):
                    self.assertTrue(contains(tris, (c, PLATE_T / 2, z)))
        ear = WIDTH / 2 + 3 + 9.525 / 2
        holes = [(x, z) for x in (-ear, ear) for z in (19.05, HEIGHT - 19.05)]
        for x, z in holes:
            self.assertFalse(contains(tris, (x, PLATE_T / 2, z)), f"no screw hole at x={x} z={z}")


if __name__ == "__main__":
    unittest.main()
