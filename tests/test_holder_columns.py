"""Property tests for peglock_holder per-column pockets and zero-disable parameters.

In exported STL coordinates the model is rotated 180 degrees about Z, so the backer sits at +Y,
pockets extend toward -Y, and model X is mirrored.
"""

import json
import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains, shell_count  # noqa: E402
from test_geometry_regression import BBOX_ABS_TOL_MM, FIXTURES_PATH, VOLUME_REL_TOL  # noqa: E402

HOLDER_SCAD = os.path.join(REPO_ROOT, "peglock_holder", "peglock_holder.scad")
WALL = 1.5875
FAST = {"$fn": "32"}

# Non-zero values elsewhere so each zeroed parameter is the only thing that changes.
ZERO_BASE = {"Tilt_Angle": "15", "Bottom_Edge_Radius": "1.5", "Junction_Gusset": "5", "Pocket_Height": "25"}
ZERO_DISABLE_PARAMS = (
    "Lip_Height",
    "Opening_Width",
    "Opening_Chamfer",
    "Corner_Radius",
    "Bottom_Edge_Radius",
    "Junction_Gusset",
    "Entry_Chamfer",
)

_cache = {}


def render(params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(HOLDER_SCAD, {**FAST, **params}, openscadpath=os.path.join(REPO_ROOT, "lib"))
    return _cache[key]


def stl_point(model_x, model_y, z):
    return (-model_x, -model_y, z)


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class HolderColumnsTestCase(unittest.TestCase):
    def test_defaults_match_default_fixture(self):
        with open(FIXTURES_PATH, encoding="utf-8") as f:
            case = json.load(f)["peglock_holder_default"]
        actual = fingerprint(render(case["params"]))
        expect = case["expect"]
        self.assertAlmostEqual(
            actual["volume_mm3"], expect["volume_mm3"], delta=max(expect["volume_mm3"] * VOLUME_REL_TOL, 1.0)
        )
        for i in range(3):
            self.assertAlmostEqual(actual["bbox_size_mm"][i], expect["bbox_size_mm"][i], delta=BBOX_ABS_TOL_MM)

    def test_single_value_applies_to_every_column(self):
        explicit = fingerprint(render({"Columns": "3", "Pocket_Widths": '"12.7"', "Pocket_Depths": '"6.35"'}))
        listed = fingerprint(render({"Columns": "3", "Pocket_Widths": '"12.7,12.7,12.7"', "Pocket_Depths": '"6.35,6.35,6.35"'}))
        self.assertEqual(explicit["bbox_size_mm"], listed["bbox_size_mm"])
        self.assertAlmostEqual(explicit["volume_mm3"], listed["volume_mm3"], delta=0.5)

    def test_two_columns_with_different_widths(self):
        w1, w2, depth = 20.0, 71.25, 31.25
        tris = render({
            "Columns": "2",
            "Pocket_Widths": '"20,71.25"',
            "Pocket_Depths": f'"{depth}"',
            "Pocket_Height": "50",
            "Mount_Type": '"monolithic"',
        })
        overall = w1 + w2 + 3 * WALL
        self.assertAlmostEqual(fingerprint(tris)["bbox_size_mm"][0], overall, delta=0.05)

        left = -overall / 2
        c1 = left + WALL + w1 / 2
        divider = left + WALL + w1 + WALL / 2
        c2 = left + 2 * WALL + w1 + w2 / 2
        y, z = depth / 2, 5.0
        for name, x in (("pocket 1 centre", c1), ("pocket 2 centre", c2)):
            with self.subTest(name):
                self.assertFalse(contains(tris, stl_point(x, y, z)), f"{name} is solid")
        self.assertTrue(contains(tris, stl_point(divider, y, z)), "divider is empty")

    def test_per_column_depth(self):
        tris = render({
            "Columns": "2",
            "Pocket_Widths": '"15,15"',
            "Pocket_Depths": '"20,10"',
            "Pocket_Height": "30",
            "Opening_Width": "0",
        })
        overall = 30 + 3 * WALL
        left = -overall / 2
        c1 = left + WALL + 7.5
        c2 = left + 2 * WALL + 15 + 7.5
        z = 5.0
        self.assertFalse(contains(tris, stl_point(c1, 15.0, z)), "deep pocket is solid at 15 mm")
        self.assertTrue(contains(tris, stl_point(c2, 15.0, z)), "shallow pocket is empty at 15 mm")
        self.assertFalse(contains(tris, stl_point(c2, 5.0, z)), "shallow pocket is solid at 5 mm")

    def _assert_render_fails(self, params, *messages):
        with self.assertRaises(RuntimeError) as ctx:
            render_triangles(HOLDER_SCAD, {**FAST, **params}, openscadpath=os.path.join(REPO_ROOT, "lib"))
        for message in messages:
            self.assertIn(message, str(ctx.exception))

    def test_plate_stays_within_body_back_face(self):
        for mount in ("peglock", "monolithic"):
            for columns in (1, 2, 4):
                with self.subTest(mount=mount, columns=columns):
                    tris = render({"Columns": str(columns), "Mount_Type": f'"{mount}"'})
                    body = columns * 12.7 + (columns + 1) * WALL
                    width = fingerprint(tris)["bbox_size_mm"][0]
                    self.assertGreaterEqual(width, body - 0.05)
                    if width > body + 0.05:
                        continue  # the socket base or peg span is wider than the body
                    # The plate sits at +Y in STL coordinates; the body's rounded corners start where the plate ends.
                    self.assertFalse(contains(tris, (body / 2 - 0.1, WALL / 2, 0.0)), "plate reaches into the rounded body corner")

    def test_entry_chamfer_widens_pocket_mouth(self):
        # Vertical_Alignment center puts the body's top at (Pocket_Height + Wall_Thickness) / 2.
        chamfer, width, depth = 0.5, 12.7, 6.35
        top = (12.7 + WALL) / 2
        tris = render({"Vertical_Alignment": '"center"', "Opening_Width": "0", "Lip_Height": "0"})
        x = width / 2 + chamfer / 2
        self.assertFalse(contains(tris, stl_point(x, depth / 2, top - 0.05)), "wall is solid inside the chamfer")
        self.assertTrue(contains(tris, stl_point(x, depth / 2, top - 2.05)), "wall is empty below the chamfer")

    def test_entry_chamfer_asserts(self):
        for bad, message in (
            ("-0.1", "Entry_Chamfer must not be negative"),
            ("0.7", "Entry_Chamfer must be less than half of Wall_Thickness"),
            ("1.6", "Entry_Chamfer must be less than half of Wall_Thickness"),
        ):
            with self.subTest(Entry_Chamfer=bad):
                self._assert_render_fails({"Entry_Chamfer": bad}, message)
        self._assert_render_fails(
            {"Pocket_Height": "0.3", "Entry_Chamfer": "0.4"}, "Entry_Chamfer must not exceed Pocket_Height"
        )

    def test_malformed_entry_asserts(self):
        for param in ("Pocket_Widths", "Pocket_Depths"):
            for bad in ("abc", "-3", "0"):
                with self.subTest(param=param, bad=bad):
                    self._assert_render_fails(
                        {"Columns": "2", param: f'"12,{bad}"'}, f"{param} entry '{bad}' is not a positive number"
                    )

    def test_count_mismatch_asserts(self):
        for param in ("Pocket_Widths", "Pocket_Depths"):
            with self.subTest(param=param):
                self._assert_render_fails(
                    {"Columns": "2", param: '"12,13,14"'}, f"{param} has 3 values but Columns is 2"
                )

    def test_zero_disable_parameters_render_one_shell(self):
        for param in ZERO_DISABLE_PARAMS:
            with self.subTest(param=param):
                tris = render({**ZERO_BASE, param: "0"})
                self.assertEqual(shell_count(tris), 1, f"{param} = 0 does not render as a single shell")

    def test_lip_survives_any_corner_radius(self):
        # Lip_Thickness 3.175 and a lip-sized rim: the lip must stay for radii below half its thickness, and at 0.
        for radius in ("0", "0.001", "1", "3.175"):
            with self.subTest(Corner_Radius=radius):
                with_lip = fingerprint(render({"Corner_Radius": radius}))["volume_mm3"]
                no_lip = fingerprint(render({"Corner_Radius": radius, "Lip_Height": "0"}))["volume_mm3"]
                self.assertGreater(with_lip, no_lip + 20.0, f"lip vanished at Corner_Radius = {radius}")


if __name__ == "__main__":
    unittest.main()
