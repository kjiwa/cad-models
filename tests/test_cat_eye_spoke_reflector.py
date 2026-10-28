"""Property tests for cat_eye_spoke_reflector: faceted faces, mount, spoke nut, and the unfolded tape template."""

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

REFLECTOR_SCAD = os.path.join(REPO_ROOT, "models", "cat_eye_spoke_reflector", "cat_eye_spoke_reflector.scad")
D = 66.0
T = 18.0
MOUNT_LENGTH = 120.0
CREASE = D / 6
FACET_ANGLE = math.atan(0.75 * T / D)
SLOPE = math.tan(FACET_ANGLE)
NUT_LENGTH = 10.7
NUT_WIDTH = 8.75
NUT_HEIGHT = 5.0
SCREW_D = 3.5
GROOVE_X = (NUT_LENGTH - (NUT_WIDTH - SCREW_D) / 2) / 2
TEMPLATE_THICKNESS = 1.5
FAST = {"$fn": "64"}

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(
            REFLECTOR_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}}, openscadpath=os.path.join(REPO_ROOT, "lib")
        )
    return _cache[key]


def top_face_height(tris, x):
    lo, hi = T / 2, T + 0.5
    while hi - lo > 0.002:
        mid = (lo + hi) / 2
        lo, hi = (mid, hi) if contains(tris, (x, 0, mid)) else (lo, mid)
    return lo


def developed_face_length(tris):
    xs = [-D / 2 + 0.01 + i * 0.5 for i in range(int((D - 0.02) / 0.5) + 1)] + [D / 2 - 0.01]
    pts = [(x, top_face_height(tris, x)) for x in xs]
    return sum(math.hypot(b[0] - a[0], b[1] - a[1]) for a, b in zip(pts, pts[1:])) + 0.02


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class CatEyeSpokeReflectorTestCase(unittest.TestCase):
    def test_reflector_size_matches_the_original(self):
        info = fingerprint(render())
        for got, want in zip(info["bbox_size_mm"], (MOUNT_LENGTH, D, T)):
            self.assertAlmostEqual(got, want, delta=0.05)
        self.assertFalse(contains(render(), (30, 0, -0.1)), "reflector sinks below z = 0")
        self.assertTrue(contains(render(), (0, 0, 0.1)), "reflector does not sit on z = 0")

    def test_faces_are_flat_at_the_crease_and_faceted_beyond(self):
        tris = render()
        x = 30
        face = T - SLOPE * (x - CREASE)
        self.assertTrue(contains(tris, (CREASE, 0, T - 0.1)), "face is missing at the crease")
        self.assertFalse(contains(tris, (x, 0, T - 0.1)), "outer facet is not cut")
        self.assertTrue(contains(tris, (x, 0, face - 0.1)), "facet cuts too deep")
        self.assertFalse(contains(tris, (x, 0, face + 0.1)), "facet cuts too shallow")
        self.assertFalse(contains(tris, (-x, 0, face + 0.1)), "negative-side facet is not cut")
        self.assertFalse(contains(tris, (x, 0, T - face - 0.1)), "bottom facet is not cut")
        self.assertTrue(contains(tris, (x, 0, T - face + 0.1)), "bottom facet cuts too deep")

    def test_mount_plate_has_slots_at_mid_height(self):
        tris = render()
        slot_x = (MOUNT_LENGTH - 15 - 15 + 4.5) / 2
        y = (D - 15) / 2
        self.assertTrue(contains(tris, (50, y - 6, T / 2)), "mount arm is missing")
        self.assertFalse(contains(tris, (slot_x, y, T / 2)), "mount slot is closed")
        self.assertFalse(contains(tris, (-slot_x, y, T / 2)), "mount slot is closed on the other arm")

    def test_nut_size_matches_the_original(self):
        info = fingerprint(render(Part='"nut"'))
        for got, want in zip(info["bbox_size_mm"], (NUT_LENGTH, NUT_WIDTH, NUT_HEIGHT)):
            self.assertAlmostEqual(got, want, delta=0.05)

    def test_nut_screw_hole_goes_through(self):
        tris = render(Part='"nut"')
        self.assertFalse(contains(tris, (0, 0, 0.1)), "screw hole is closed at the bottom")
        self.assertFalse(contains(tris, (0, 0, NUT_HEIGHT - 0.1)), "screw hole is closed at the top")
        self.assertFalse(contains(tris, (SCREW_D / 2 - 0.2, 0, 2.5)), "screw hole is narrower than Screw_Diameter")
        self.assertTrue(contains(tris, (SCREW_D / 2 + 0.2, 0, 2.5)), "screw hole is wider than Screw_Diameter")

    def test_nut_spoke_groove_is_open_across_the_nut(self):
        tris = render(Part='"nut"')
        for y in (-3, 0, 3):
            self.assertFalse(contains(tris, (GROOVE_X, y, NUT_HEIGHT - 0.5)), "spoke groove is closed")
        self.assertFalse(contains(tris, (GROOVE_X, 0, NUT_HEIGHT - 1.9)), "spoke groove is shallower than the spoke")
        self.assertTrue(contains(tris, (GROOVE_X, 0, NUT_HEIGHT - 2.1)), "spoke groove is too deep")
        self.assertFalse(contains(tris, (GROOVE_X + 0.9, 0, NUT_HEIGHT - 0.5)), "spoke groove is narrower than the spoke")
        self.assertTrue(contains(tris, (GROOVE_X + 1.1, 0, NUT_HEIGHT - 0.5)), "spoke groove is too wide")

    def test_nut_top_edge_is_rounded(self):
        self.assertFalse(contains(render(Part='"nut"'), (NUT_LENGTH - NUT_WIDTH / 2 - 0.025, 0, NUT_HEIGHT - 0.05)), "nut top edge is square")

    def test_template_extent_is_the_unfolded_face(self):
        info = fingerprint(render(Part='"template"'))
        want_x = D / 3 + 2 * (D / 3) / math.cos(FACET_ANGLE)
        for got, want in zip(info["bbox_size_mm"], (want_x, D, TEMPLATE_THICKNESS)):
            self.assertAlmostEqual(got, want, delta=0.05)

    def test_template_outline_stretches_beyond_the_crease(self):
        tris = render(Part='"template"')
        u = CREASE + (30 - CREASE) / math.cos(FACET_ANGLE)
        half_chord = math.sqrt((D / 2) ** 2 - 30**2)
        z = TEMPLATE_THICKNESS / 2
        self.assertTrue(contains(tris, (u, half_chord - 0.3, z)), "outline is narrower than the face")
        self.assertFalse(contains(tris, (u, half_chord + 0.3, z)), "outline is wider than the face")
        self.assertTrue(contains(tris, (CREASE - 0.1, D / 2 - 1, z)) or contains(tris, (CREASE - 0.1, 31, z)), "flat part is missing")

    def test_template_length_equals_the_developed_face(self):
        want = developed_face_length(render())
        got = fingerprint(render(Part='"template"'))["bbox_size_mm"][0]
        self.assertAlmostEqual(got, want, delta=0.2)


if __name__ == "__main__":
    unittest.main()
