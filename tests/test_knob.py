"""Property tests for knob: bore and nut pocket sizes per preset, flutes cut into the rim, cap fits the pocket."""

import json
import math
import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

KNOB_DIR = os.path.join(REPO_ROOT, "models", "knob")
KNOB_SCAD = os.path.join(KNOB_DIR, "knob.scad")
FAST = {"$fn": "32"}

_cache = {}


def _value(text):
    try:
        float(text)
        return text
    except ValueError:
        return f'"{text}"'


def preset(name):
    with open(os.path.join(KNOB_DIR, "knob.json"), encoding="utf-8") as f:
        return {k: _value(v) for k, v in json.load(f)["parameterSets"][name].items()}


def render(params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(KNOB_SCAD, {**FAST, **params}, openscadpath=os.path.join(REPO_ROOT, "lib"))
    return _cache[key]


def corner_radius(across_flats):
    return across_flats / math.sqrt(3)


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class KnobTestCase(unittest.TestCase):
    def test_default_stop_block_knob_pocket_and_bore(self):
        tris = render({})
        self.assertEqual(fingerprint(tris)["bbox_size_mm"][2], 12)
        self.assertFalse(contains(tris, (3.3, 0, 8)), "bore too narrow")
        self.assertTrue(contains(tris, (3.8, 0, 8)), "bore too wide")
        self.assertFalse(contains(tris, (corner_radius(10.825) - 0.2, 0, 2)), "nut pocket corner is closed")
        self.assertFalse(contains(tris, (0, 10.825 / 2 - 0.2, 2)), "nut pocket flat is closed")
        self.assertTrue(contains(tris, (0, 10.825 / 2 + 0.3, 2)), "nut pocket is oversize")
        self.assertTrue(contains(tris, (corner_radius(10.825) - 0.2, 0, 6.2)), "nut pocket is deeper than Nut_Thickness")

    def test_default_flutes_are_cut_into_the_rim(self):
        tris = render({})
        self.assertFalse(contains(tris, (9.0, 0, 6)), "no flute at angle 0")
        a = math.radians(36)
        self.assertTrue(contains(tris, (9.0 * math.cos(a), 9.0 * math.sin(a), 6)), "no lobe between flutes")

    def test_rockler_blade_holder_knob(self):
        tris = render(preset("Rockler_Blade_Holder_Knob"))
        self.assertEqual(fingerprint(tris)["bbox_size_mm"][2], 15)
        self.assertFalse(contains(tris, (6.0, 0, 13)), "bore too narrow")
        self.assertTrue(contains(tris, (7.0, 0, 13)), "bore too wide")
        self.assertFalse(contains(tris, (corner_radius(18.62) - 0.2, 0, 5)), "nut pocket corner is closed")
        self.assertTrue(contains(tris, (corner_radius(18.62) - 0.2, 0, 12.3)), "nut pocket is deeper than Nut_Thickness")

    def test_m10_lock_knob(self):
        tris = render(preset("M10_Lock_Knob"))
        self.assertEqual(fingerprint(tris)["bbox_size_mm"][2], 18)
        self.assertFalse(contains(tris, (5.0, 0, 12)), "bore too narrow")
        self.assertTrue(contains(tris, (5.6, 0, 12)), "bore too wide")
        self.assertFalse(contains(tris, (corner_radius(17) - 0.2, 0, 4)), "nut pocket corner is closed")
        self.assertTrue(contains(tris, (corner_radius(17) - 0.2, 0, 8.4)), "nut pocket is deeper than Nut_Thickness")

    def test_miter_gauge_handle_pocket_is_open_at_the_top(self):
        tris = render(preset("Miter_Gauge_Handle"))
        self.assertEqual(fingerprint(tris)["bbox_size_mm"][2], 50.8)
        self.assertFalse(contains(tris, (corner_radius(11.5) - 0.2, 0, 45)), "pocket corner is closed")
        self.assertTrue(contains(tris, (corner_radius(11.5) - 0.2, 0, 20)), "pocket reaches below Pocket_Depth")
        self.assertFalse(contains(tris, (3.0, 0, 10)), "bore too narrow")
        self.assertTrue(contains(tris, (3.5, 0, 10)), "bore too wide")
        self.assertTrue(contains(tris, (10.0, 0, 45)), "wall is missing")

    def test_cap_fits_the_miter_pocket_with_clearance(self):
        cap = render(preset("Miter_Gauge_Handle_Cap"))
        size = fingerprint(cap)["bbox_size_mm"]
        pocket_depth = 24.525
        self.assertAlmostEqual(size[2], pocket_depth - 3.97, delta=0.05)
        self.assertLess(size[1], 11.5, "cap does not clear the pocket flats")
        self.assertGreater(size[1], 11.5 - 0.6, "cap is loose in the pocket")

    def test_cap_requires_a_top_pocket(self):
        with self.assertRaises(RuntimeError):
            render({"Part": '"cap"'})


if __name__ == "__main__":
    unittest.main()
