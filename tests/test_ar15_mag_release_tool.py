"""Property tests for ar15_mag_release_tool: plunger and head size, grip texture, and rounded thumb face and tip."""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

TOOL_SCAD = os.path.join(REPO_ROOT, "models", "ar15_mag_release_tool", "ar15_mag_release_tool.scad")
PLUNGER = (7.9375, 12.7, 9.525)
HEAD = (11.1125, 15.875, 6.35)
FAST = {"$fn": "32"}
TOL = 0.05

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(
            TOOL_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}}, openscadpath=os.path.join(REPO_ROOT, "lib")
        )
    return _cache[key]


def extent(tris, z_min, z_max):
    """Return (x, y) full extents of the vertices with z strictly between the bounds."""
    pts = [v for tri in tris for v in tri if z_min < v[2] < z_max]
    return tuple(max(p[i] for p in pts) - min(p[i] for p in pts) for i in (0, 1))


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class Ar15MagReleaseToolTestCase(unittest.TestCase):
    def test_head_matches_the_source_size(self):
        tris = render()
        x, y = extent(tris, 1.5, HEAD[2] - 0.05)
        self.assertAlmostEqual(x, HEAD[0], delta=TOL)
        self.assertAlmostEqual(y, HEAD[1], delta=TOL)
        self.assertAlmostEqual(min(v[2] for t in tris for v in t), 0, delta=TOL)

    def test_plunger_matches_the_source_size_and_stands_on_the_head(self):
        tris = render()
        x, y = extent(tris, HEAD[2] + 0.05, HEAD[2] + PLUNGER[2] - 1)
        self.assertAlmostEqual(x, PLUNGER[0], delta=TOL)
        self.assertAlmostEqual(y, PLUNGER[1], delta=TOL)
        self.assertAlmostEqual(max(v[2] for t in tris for v in t), HEAD[2] + PLUNGER[2], delta=TOL)

    def test_head_side_is_textured(self):
        tris = render()
        x = HEAD[0] / 2 - TOL
        probes = [contains(tris, (x, y / 4, 1.5 + z / 4)) for y in range(-8, 9) for z in range(0, 12)]
        self.assertIn(False, probes, "no recess found just inside the side surface")
        self.assertIn(True, probes, "texture removed the whole side surface")

    def test_plunger_tip_is_rounded(self):
        tris = render()
        top = HEAD[2] + PLUNGER[2]
        self.assertTrue(contains(tris, (0, 0, top - TOL)))
        self.assertFalse(contains(tris, (PLUNGER[0] / 2 - TOL, 0, top - TOL)))
        self.assertFalse(contains(tris, (0, PLUNGER[1] / 2 - TOL, top - TOL)))

    def test_thumb_face_perimeter_is_rounded(self):
        tris = render()
        self.assertTrue(contains(tris, (0, 0, TOL)))
        self.assertFalse(contains(tris, (HEAD[0] / 2 - TOL, 0, TOL)))
        self.assertFalse(contains(tris, (0, HEAD[1] / 2 - TOL, TOL)))


if __name__ == "__main__":
    unittest.main()
