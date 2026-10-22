"""Pegboard-family models hang from a back that is one flat, fully backed surface: no wall overhangs the plate, no piece floats.

In exported STL coordinates the plate spans y 0..thickness and the body extends toward -Y. Every solid sample of the body
section just in front of the plate must have plate behind it, and each configuration must be a single shell.
"""

import json
import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import render_triangles  # noqa: E402
from mesh_probe import contains, shell_count  # noqa: E402
from test_screw_access import FAST, scad_literal  # noqa: E402

STEP = 1.0
BODY_Y = -0.1
PLATE_Y = 0.1


def scad(model):
    return os.path.join(REPO_ROOT, "models", model, f"{model}.scad")


def holder_presets():
    with open(os.path.join(REPO_ROOT, "models", "wall_holder", "wall_holder.json")) as f:
        return json.load(f)["parameterSets"]


HOLDER_EXTRAS = {
    "default": {},
    "columns4_rows2": {"Columns": "4", "Rows": "2", "Pocket_Widths": "12", "Pocket_Depths": "20", "Pocket_Height": "30"},
    "tilt15": {"Tilt_Angle": "15", "Pocket_Widths": "40", "Pocket_Depths": "20", "Pocket_Height": "30"},
    "tilt45": {"Tilt_Angle": "45", "Pocket_Widths": "40", "Pocket_Depths": "20", "Pocket_Height": "30"},
    "no_bottom": {"Include_Bottom": "false", "Pocket_Widths": "40", "Pocket_Depths": "20", "Pocket_Height": "30"},
    "monolithic": {"Mount_Type": "monolithic", "Pocket_Widths": "40", "Pocket_Depths": "30", "Pocket_Height": "40"},
    "screws_ears": {"Mount_Type": "screws", "Screw_Placement": "ears", "Pocket_Widths": "40", "Pocket_Depths": "30", "Pocket_Height": "40"},
    "screws_back": {"Mount_Type": "screws", "Screw_Placement": "back", "Pocket_Widths": "70", "Pocket_Depths": "30", "Pocket_Height": "40", "Opening_Width": "50"},
    "gusset_bottom_radius": {"Junction_Gusset_Chamfer": "5", "Bottom_Edge_Radius": "1.5", "Pocket_Widths": "40", "Pocket_Depths": "20", "Pocket_Height": "30"},
}


def configurations():
    for name, params in {**HOLDER_EXTRAS, **holder_presets()}.items():
        yield f"wall_holder {name}", scad("wall_holder"), params
    yield "wall_bit_holder default", scad("wall_bit_holder"), {}
    yield "wall_bit_holder screws", scad("wall_bit_holder"), {"Mount_Type": "screws"}
    yield "wall_magnet_mount default", scad("wall_magnet_mount"), {}
    yield "wall_hook default", scad("wall_hook"), {}


def render(path, params):
    literals = {k: scad_literal(k, v) for k, v in params.items()}
    return render_triangles(path, {**FAST, **literals}, openscadpath=os.path.join(REPO_ROOT, "lib"))


def unbacked(tris):
    """Body samples in rows that have a plate behind them but not at that sample (body above the plate hangs by design)."""
    xs = [p[0] for t in tris for p in t]
    zs = [p[2] for t in tris for p in t]
    nx = int((max(xs) - min(xs)) / STEP) + 1
    nz = int((max(zs) - min(zs)) / STEP) + 1
    found = []
    for j in range(nz):
        z = min(zs) + (j + 0.5) * STEP
        if not contains(tris, (0, PLATE_Y, z)) and not contains(tris, (STEP, PLATE_Y, z)):
            continue
        for i in range(nx):
            x = min(xs) + (i + 0.5) * STEP
            if contains(tris, (x, BODY_Y, z)) and not contains(tris, (x, PLATE_Y, z)):
                found.append((round(x, 1), round(z, 1)))
    return found


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class BackFlushTestCase(unittest.TestCase):
    def test_every_wall_of_the_body_is_backed_by_the_plate(self):
        for name, path, params in configurations():
            with self.subTest(config=name):
                gaps = unbacked(render(path, params))
                self.assertEqual(gaps, [], f"{len(gaps)} body samples overhang the plate, first at (x, z) = {gaps[:3]}")

    def test_every_configuration_is_one_piece(self):
        for name, path, params in configurations():
            with self.subTest(config=name):
                self.assertEqual(shell_count(render(path, params)), 1)


if __name__ == "__main__":
    unittest.main()
