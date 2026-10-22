"""Property tests for wall_hook arm profiles.

In exported STL coordinates the model is rotated 180 degrees about Z, so the arm extends
toward -Y and model X is mirrored.
"""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

HOOK_SCAD = os.path.join(REPO_ROOT, "models", "wall_hook", "wall_hook.scad")
FAST = {"$fn": "32"}
ARM_WIDTH = 12.7
ARM_HEIGHT = 6.35
ARM_CENTER_Z = -11.35
ANGLED_ON_SCREWS = {
    "Mount_Type": '"screws"',
    "Backplate_Height": "152.4",
    "Screw_Hole_Rows": "2",
    "Screw_Hole_Inset": "19.05",
    "Screw_Head_Diameter": "16",
    "Vertical_Alignment": '"screws"',
    "Arm_Width": "38.1",
    "Arm_Height": "12.7",
    "Arm_Depth": "76.2",
    "Arm_Tilt_Angle": "60",
    "Lip_Height": "0",
    "Lip_Thickness": "0",
}


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class HookArmProfileTestCase(unittest.TestCase):
    def test_sharp_right_triangle_arm_is_solid(self):
        tris = render_triangles(
            HOOK_SCAD,
            {**FAST, "Arm_Shape": '"right_triangle"', "Arm_Edge_Radius": "0"},
            openscadpath=os.path.join(REPO_ROOT, "lib"),
        )
        arm_y = -3.0
        self.assertTrue(contains(tris, (0, arm_y, ARM_CENTER_Z - 1)), "arm is empty below the hypotenuse")
        self.assertTrue(
            contains(tris, (ARM_WIDTH / 2 - 0.5, arm_y, ARM_CENTER_Z + ARM_HEIGHT / 2 - 0.5)),
            "square corner is missing",
        )
        self.assertFalse(
            contains(tris, (-ARM_WIDTH / 2 + 0.5, arm_y, ARM_CENTER_Z + ARM_HEIGHT / 2 - 0.5)),
            "arm fills above the hypotenuse",
        )


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class HookBackplateTestCase(unittest.TestCase):
    def render(self, params):
        return render_triangles(HOOK_SCAD, {**FAST, **params}, openscadpath=os.path.join(REPO_ROOT, "lib"))

    def test_zero_backplate_height_fits_to_content(self):
        self.assertEqual(
            fingerprint(self.render({"Backplate_Height": "0"})), fingerprint(self.render({}))
        )

    def test_backplate_height_extends_plate(self):
        for alignment in ("bottom", "screws"):
            with self.subTest(alignment=alignment):
                tris = self.render(
                    {"Mount_Type": '"screws"', "Backplate_Height": "152.4", "Vertical_Alignment": f'"{alignment}"'}
                )
                self.assertAlmostEqual(fingerprint(tris)["bbox_size_mm"][2], 152.4, delta=0.05)

    def test_centered_arm_on_tall_plate(self):
        tris = self.render(
            {
                "Mount_Type": '"screws"',
                "Screw_Hole_Rows": "2",
                "Screw_Hole_Inset": "19.05",
                "Backplate_Height": "152.4",
                "Vertical_Alignment": '"center"',
            }
        )
        self.assertTrue(contains(tris, (0, -3.0, 0.0)), "arm is not centered on the plate")

    def test_backplate_height_requires_screw_mount(self):
        with self.assertRaises(RuntimeError) as ctx:
            self.render({"Backplate_Height": "152.4"})
        self.assertIn("Backplate_Height needs Mount_Type screws", str(ctx.exception))

    def test_screw_grid_counts_and_inset_are_validated(self):
        for params, message in (
            ({"Screw_Hole_Columns": "0"}, "Screw_Hole_Columns must be a positive integer"),
            ({"Screw_Hole_Rows": "1.5"}, "Screw_Hole_Rows must be a positive integer"),
            ({"Screw_Hole_Inset": "100"}, "Screw_Hole_Inset must not exceed half the plate"),
        ):
            with self.subTest(params=params):
                with self.assertRaises(RuntimeError) as ctx:
                    self.render({"Mount_Type": '"screws"', "Screw_Hole_Columns": "2", "Screw_Hole_Rows": "2", **params})
                self.assertIn(message, str(ctx.exception))

    def test_screw_mount_holes_are_clear_of_the_arm(self):
        params = {
            "Mount_Type": '"screws"',
            "Screw_Hole_Columns": "1",
            "Screw_Hole_Rows": "2",
            "Screw_Hole_Inset": "19.05",
            "Backplate_Height": "152.4",
            "Vertical_Alignment": '"center"',
        }
        tris = self.render(params)
        for z in (-57.15, 57.15):
            with self.subTest(z=z):
                self.assertFalse(contains(tris, (0, 0.8, z)), "no screw hole")
        self.assertTrue(contains(tris, (0, 0.8, 0.0)))

    def test_screws_alignment_requires_screw_mount(self):
        with self.assertRaises(RuntimeError) as ctx:
            self.render({"Vertical_Alignment": '"screws"'})
        self.assertIn("Vertical_Alignment screws needs Mount_Type screws", str(ctx.exception))

    def test_arm_raised_into_a_screw_head_is_rejected(self):
        for params in (
            {"Vertical_Alignment": '"center"', "Screw_Hole_Rows": "1"},
            {**ANGLED_ON_SCREWS, "Arm_Depth": "90"},
        ):
            with self.subTest(params=params):
                with self.assertRaises(RuntimeError) as ctx:
                    self.render({**ANGLED_ON_SCREWS, **params})
                self.assertIn("screw heads overlap the arm", str(ctx.exception))

    def test_tilt_cap_is_60(self):
        self.render({"Arm_Tilt_Angle": "60"})
        with self.assertRaises(RuntimeError) as ctx:
            self.render({"Arm_Tilt_Angle": "61"})
        self.assertIn("Arm_Tilt_Angle must be between 0 and 60", str(ctx.exception))


if __name__ == "__main__":
    unittest.main()
