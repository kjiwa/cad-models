"""Property tests for peglock_magnet_mount: pockets reach the plate face and the slab between them stays solid.

In exported STL coordinates the model is rotated 180 degrees about Z, so the plate sits at +Y,
the magnet slab extends toward -Y, and model X is mirrored.
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

MODEL_DIR = os.path.join(REPO_ROOT, "peglock_magnet_mount")
MAGNET_SCAD = os.path.join(MODEL_DIR, "peglock_magnet_mount.scad")
PRESETS_PATH = os.path.join(MODEL_DIR, "peglock_magnet_mount.json")
FAST = {"$fn": "32"}
PLATE = 1.5875
SOCKET_HEIGHT = 35.4

_cache = {}


def preset_params(name):
    with open(PRESETS_PATH, encoding="utf-8") as f:
        return json.load(f)["parameterSets"][name]


def render(params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(MAGNET_SCAD, {**FAST, **params}, openscadpath=os.path.join(REPO_ROOT, "lib"))
    return _cache[key]


def stl_point(model_x, model_y, z):
    return (-model_x, -model_y, z)


def pocket_centres(columns, rows, d, s):
    pitch = d + s
    width, height = columns * pitch + s, rows * pitch + s
    xs = [-width / 2 + d / 2 + s + j * pitch for j in range(columns)]
    zs = [-height / 2 + d / 2 + s + i * pitch for i in range(rows)]
    return xs, zs


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class MagnetMountTestCase(unittest.TestCase):
    def _check_grid(self, columns, rows, d=12.0, depth=3.5, s=2.0):
        tris = render({"Columns": str(columns), "Rows": str(rows), "Magnet_Diameter": str(d),
                       "Magnet_Depth": str(depth), "Magnet_Spacing": str(s)})
        xs, zs = pocket_centres(columns, rows, d, s)
        for x in xs:
            for z in zs:
                with self.subTest(pocket=(x, z)):
                    for y in (0.05, depth / 2, depth - 0.05):
                        self.assertFalse(contains(tris, stl_point(x, y, z)), f"pocket solid at y={y}")
                    self.assertFalse(contains(tris, stl_point(x + d / 2 - 0.1, depth / 2, z)), "pocket rim solid")
                    self.assertTrue(contains(tris, stl_point(x + d / 2 + 0.1, depth / 2, z)), "pocket wider than d")
                    self.assertTrue(contains(tris, stl_point(x, -PLATE / 2, z)), "plate is empty behind the pocket")
        for x in xs[:-1]:
            gap = x + d / 2 + s / 2
            self.assertTrue(contains(tris, stl_point(gap, depth / 2, zs[0])), "slab is empty between columns")
        for z in zs[:-1]:
            gap = z + d / 2 + s / 2
            self.assertTrue(contains(tris, stl_point(xs[0], depth / 2, gap)), "slab is empty between rows")
        self.assertTrue(contains(tris, stl_point(xs[0] - d / 2 - s / 2, depth / 2, zs[0])), "slab rim is empty")
        self.assertFalse(contains(tris, stl_point(xs[0], depth + 0.2, zs[0])), "slab is taller than Magnet_Depth")

    def test_single(self):
        self._check_grid(1, 1)

    def test_pair(self):
        self._check_grid(2, 1)

    def test_grid_2x2(self):
        self._check_grid(2, 2)

    def test_pair_preset_bbox(self):
        params = preset_params("Pair_12mm")
        self.assertEqual(params["Columns"], "2")
        self.assertEqual(params["Rows"], "1")
        bbox = fingerprint(render(params))["bbox_size_mm"]
        self.assertAlmostEqual(bbox[0], 2 * (12 + 2) + 2, delta=0.05)
        self.assertAlmostEqual(bbox[2], SOCKET_HEIGHT, delta=0.05)

    def test_zero_corner_radius_renders(self):
        tris = render({"Corner_Radius": "0"})
        self.assertFalse(contains(tris, stl_point(0, 1.75, 0)))

    def test_bad_counts_assert(self):
        for param in ("Columns", "Rows"):
            with self.subTest(param=param):
                with self.assertRaises(RuntimeError) as ctx:
                    render_triangles(MAGNET_SCAD, {**FAST, param: "0"}, openscadpath=os.path.join(REPO_ROOT, "lib"))
                self.assertIn(f"{param} must be at least 1", str(ctx.exception))


if __name__ == "__main__":
    unittest.main()
