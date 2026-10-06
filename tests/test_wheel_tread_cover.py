"""Property tests for wheel_tread_cover: the wrapped end forms a lip outside the wheel profile."""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

COVER_SCAD = os.path.join(REPO_ROOT, "wheel_tread_cover", "wheel_tread_cover.scad")
FAST = {"$fn": "32"}
INNER_DIAMETER = 171.45
WIDTH = 52.3875
THICKNESS = 3.175
EDGE_RADIUS = 6.35
BASELINE_VOLUME = 68279.8

_cache = {}


def render(params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(COVER_SCAD, params, openscadpath=os.path.join(REPO_ROOT, "lib"))
    return _cache[key]


def lip_point():
    return (INNER_DIAMETER / 2 - EDGE_RADIUS / 2, 0, WIDTH / 2 + THICKNESS / 2)


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class WheelTreadCoverTestCase(unittest.TestCase):
    def test_wrap_wraps_the_top_end(self):
        tris = render({**FAST, "Wrap_Angle": "90"})
        self.assertTrue(contains(tris, lip_point()), "lip over the wheel shoulder is empty at Wrap_Angle=90")

    def test_no_wrap_leaves_the_end_flat(self):
        tris = render({**FAST, "Wrap_Angle": "0"})
        self.assertFalse(contains(tris, lip_point()), "material above the sleeve end at Wrap_Angle=0")

    def test_wrap_only_on_top_end(self):
        tris = render({**FAST, "Wrap_Angle": "90"})
        x, y, z = lip_point()
        self.assertFalse(contains(tris, (x, y, -z)), "bottom end is wrapped")

    def test_bore_stays_the_wheel_profile(self):
        tris = render({**FAST, "Wrap_Angle": "90"})
        r = INNER_DIAMETER / 2
        self.assertFalse(contains(tris, (r - 1, 0, 0)), "bore is not empty at mid width")
        self.assertFalse(contains(tris, (r - EDGE_RADIUS - 1, 0, WIDTH / 2 - 1)), "lip intrudes inside the wheel profile")
        self.assertFalse(contains(tris, (r - 1, 0, WIDTH / 2 - EDGE_RADIUS - 1)), "lip intrudes inside the wheel profile")

    def test_zero_wrap_matches_flat_sleeve_volume(self):
        vol = fingerprint(render({"Wrap_Angle": "0"}))["volume_mm3"]
        self.assertAlmostEqual(vol / BASELINE_VOLUME, 1.0, delta=0.005)

    def test_volume_grows_with_wrap(self):
        vols = [fingerprint(render({**FAST, "Wrap_Angle": a}))["volume_mm3"] for a in ("0", "45", "90")]
        self.assertLess(vols[0], vols[1])
        self.assertLess(vols[1], vols[2])

    def test_wrap_extends_the_z_extent(self):
        flat = fingerprint(render({**FAST, "Wrap_Angle": "0"}))["bbox_size_mm"][2]
        wrapped = fingerprint(render({**FAST, "Wrap_Angle": "90"}))["bbox_size_mm"][2]
        self.assertAlmostEqual(flat, WIDTH, delta=0.05)
        self.assertAlmostEqual(wrapped, WIDTH + THICKNESS, delta=0.05)


if __name__ == "__main__":
    unittest.main()
