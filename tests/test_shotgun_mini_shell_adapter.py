"""Property tests for shotgun_mini_shell_adapter: the sloped cut and lip faces follow Front_Cutout_Angle."""

import math
import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

ADAPTER_SCAD = os.path.join(
    REPO_ROOT, "shotgun_mini_shell_adapter", "shotgun_mini_shell_adapter.scad"
)
WIDTH = 35
HEIGHT = 20.5
DROP = 4
NOTCH_START_DX = HEIGHT - 7
X0 = WIDTH / 2 - HEIGHT
PROBE_Y = 6.5
EPS = 0.2

_cache = {}


def render(angle):
    if angle not in _cache:
        _cache[angle] = render_triangles(ADAPTER_SCAD, {"Front_Cutout_Angle": str(angle), "$fn": "32"})
    return _cache[angle]


def cut_dx(angle, z):
    return (z + DROP) * math.tan(math.radians(angle))


def probe(tris, dx, z):
    return contains(tris, (X0 + dx, PROBE_Y, z))


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class ShellAdapterSlopeTestCase(unittest.TestCase):
    def check_cut_face(self, angle, z):
        tris = render(angle)
        dx = cut_dx(angle, z)
        self.assertTrue(probe(tris, dx - EPS, z), "material missing behind the cut face at %d degrees" % angle)
        self.assertFalse(probe(tris, dx + EPS, z), "cut face not at %d degrees from vertical" % angle)

    def check_lip_inner_face(self, angle, z):
        tris = render(angle)
        dx = cut_dx(angle, z) - DROP
        self.assertGreater(dx - EPS, NOTCH_START_DX, "probe is not inside the front notch")
        self.assertFalse(probe(tris, dx - EPS, z), "lip extends past its inner face at %d degrees" % angle)
        self.assertTrue(probe(tris, dx + EPS, z), "lip inner face not at %d degrees from vertical" % angle)

    def test_cut_face_30(self):
        self.check_cut_face(30, 8)

    def test_cut_face_60(self):
        self.check_cut_face(60, 2)

    def test_lip_outer_face_30(self):
        tris = render(30)
        z = 20.3
        dx = cut_dx(30, z)
        self.assertGreater(dx - EPS, NOTCH_START_DX, "probe is not inside the front notch")
        self.assertTrue(probe(tris, dx - EPS, z), "lip missing behind the cut plane at 30 degrees")
        self.assertFalse(probe(tris, dx + EPS, z), "lip extends past the cut plane at 30 degrees")

    def test_lip_outer_face_60(self):
        tris = render(60)
        z = 6
        dx = cut_dx(60, z)
        self.assertTrue(probe(tris, dx - EPS, z), "lip missing behind the cut plane at 60 degrees")
        self.assertFalse(probe(tris, dx + EPS, z), "lip extends past the cut plane at 60 degrees")

    def test_lip_inner_face_60(self):
        self.check_lip_inner_face(60, 7)

    def test_lip_inner_face_45(self):
        self.check_lip_inner_face(45, 15)

    def test_cut_and_lip_share_plane_45(self):
        self.check_cut_face(45, 8)


if __name__ == "__main__":
    unittest.main()
