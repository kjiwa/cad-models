"""A screw-mounted wall_holder has a flat back as wide and tall as the body, with square corners, so it seats flush on a wall.

In exported STL coordinates the plate spans y 0..thickness and the body extends toward -Y.
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
from mesh_probe import contains  # noqa: E402
from test_screw_access import FAST, scad_literal  # noqa: E402

SCAD = os.path.join(REPO_ROOT, "models", "wall_holder", "wall_holder.scad")
PRESETS_JSON = os.path.join(REPO_ROOT, "models", "wall_holder", "wall_holder.json")
EDGE = 0.15


def screw_presets():
    with open(PRESETS_JSON) as f:
        for name, params in json.load(f)["parameterSets"].items():
            if params.get("Mount_Type") == "screws":
                yield name, params


def render(params):
    literals = {k: scad_literal(k, v) for k, v in params.items()}
    return render_triangles(SCAD, {**FAST, **literals}, openscadpath=os.path.join(REPO_ROOT, "lib"))


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class HolderFlushBackTestCase(unittest.TestCase):
    def test_back_is_as_wide_and_tall_as_the_body_with_square_corners(self):
        presets = list(screw_presets())
        self.assertTrue(presets)
        for name, params in presets:
            with self.subTest(preset=name):
                tris = render(params)
                plate = [p for t in tris for p in t if 0.01 <= p[1] <= 3.01]
                zs = [p[2] for p in plate]
                half = max(p[0] for p in plate)
                for x in (-half + EDGE, half - EDGE):
                    for z in (min(zs) + EDGE, max(zs) - EDGE):
                        self.assertTrue(contains(tris, (x, 0.4, z)), f"plate corner is cut at x={x:.2f} z={z:.2f}")
                        self.assertTrue(contains(tris, (x, -0.4, z)), f"body corner is cut or rounded at x={x:.2f} z={z:.2f}")

    def test_plate_matches_the_body_width(self):
        for name, params in screw_presets():
            with self.subTest(preset=name):
                tris = render(params)
                plate = [p[0] for t in tris for p in t if 0.01 <= p[1] <= 3.01]
                body = [p[0] for t in tris for p in t if p[1] < -3]
                self.assertAlmostEqual(max(plate), max(body), delta=0.05)
                self.assertAlmostEqual(min(plate), min(body), delta=0.05)


if __name__ == "__main__":
    unittest.main()
