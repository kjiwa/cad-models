"""Property test: nothing at the backplate face pokes past the plate's rounded corners.

In exported STL coordinates the model is rotated 180 degrees about Z, so the backplate
spans y from 0 to Backplate_Thickness and content sits at -Y.
"""

import json
import math
import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))

from geometry_fingerprint import render_triangles  # noqa: E402

HOOK_SCAD = os.path.join(REPO_ROOT, "peglock_hook", "peglock_hook.scad")
HOOK_PRESETS = os.path.join(REPO_ROOT, "peglock_hook", "peglock_hook.json")
MAGNET_SCAD = os.path.join(REPO_ROOT, "peglock_magnet_mount", "peglock_magnet_mount.scad")

FAST = {"$fn": "32"}
PLATE_THICKNESS = 1.5875
CORNER_RADIUS = 3.175
TOLERANCE = 0.05


def preset(name):
    with open(HOOK_PRESETS, encoding="utf-8") as f:
        values = json.load(f)["parameterSets"][name]
    return {k: v if v.replace(".", "", 1).isdigit() else f'"{v}"' for k, v in values.items()}


def plate_vertices(tris):
    return [v for t in tris for v in t if -0.01 <= v[1] <= PLATE_THICKNESS + 0.01]


def overhang(vertices):
    """Largest distance any vertex sits outside the rounded rectangle bounding all of them."""
    xs = [v[0] for v in vertices]
    zs = [v[2] for v in vertices]
    cx, cz = (max(xs) + min(xs)) / 2, (max(zs) + min(zs)) / 2
    hx, hz = (max(xs) - min(xs)) / 2, (max(zs) - min(zs)) / 2
    worst = 0.0
    for v in vertices:
        dx = max(abs(v[0] - cx) - (hx - CORNER_RADIUS), 0.0)
        dz = max(abs(v[2] - cz) - (hz - CORNER_RADIUS), 0.0)
        worst = max(worst, math.hypot(dx, dz) - CORNER_RADIUS)
    return worst


def hook(**params):
    return HOOK_SCAD, params


CASES = {
    "hook_sockets_1_4in": hook(**preset("Sockets_1_4in")),
    "hook_sockets_3_8in": hook(**preset("Sockets_3_8in")),
    "hook_sockets_1_2in": hook(**preset("Sockets_1_2in")),
    "hook_grid": hook(Rows="4", Columns="6"),
    "hook_fillet": hook(Root_Fillet_Radius="2"),
    "hook_tilted_fillet": hook(Arm_Tilt_Angle="30", Root_Fillet_Radius="2"),
    "hook_circle": hook(**{**preset("Sockets_1_4in"), "Arm_Shape": '"circle"'}),
    "hook_triangle": hook(**{**preset("Sockets_1_4in"), "Arm_Shape": '"triangle"'}),
    "hook_centered": hook(Vertical_Alignment='"center"'),
    "hook_monolithic": hook(Mount_Type='"monolithic"'),
    "magnet_2x3": (MAGNET_SCAD, {"Columns": "2", "Rows": "3"}),
    "magnet_10x6": (MAGNET_SCAD, {"Columns": "10", "Rows": "6"}),
}


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class PlateCornersTestCase(unittest.TestCase):
    def test_content_stays_inside_plate_corners(self):
        for name, (scad, params) in CASES.items():
            with self.subTest(case=name):
                tris = render_triangles(scad, {**FAST, **params}, openscadpath=os.path.join(REPO_ROOT, "lib"))
                self.assertLessEqual(overhang(plate_vertices(tris)), TOLERANCE, "content overhangs the plate corner")


if __name__ == "__main__":
    unittest.main()
