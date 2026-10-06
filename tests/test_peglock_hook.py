"""Property tests for peglock_hook arm profiles.

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

from geometry_fingerprint import render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

HOOK_SCAD = os.path.join(REPO_ROOT, "peglock_hook", "peglock_hook.scad")
FAST = {"$fn": "32"}
ARM_WIDTH = 12.7
ARM_HEIGHT = 6.35
ARM_CENTER_Z = -11.35


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


if __name__ == "__main__":
    unittest.main()
