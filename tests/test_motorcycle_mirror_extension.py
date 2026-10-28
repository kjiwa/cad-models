"""Property tests for motorcycle_mirror_extension: sockets, thread, 45-degree underside, and lead-in chamfers."""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

MIRROR_SCAD = os.path.join(REPO_ROOT, "models", "motorcycle_mirror_extension", "motorcycle_mirror_extension.scad")
HEIGHT = 36
LENGTH = 40.5
SOCKET_D = 19.5
SCREW_D = 10.5
SCREW_DEPTH = 6
HEAD_D = 16.5
THREAD_DEPTH = 16
THREAD_BASE_Z = HEIGHT - THREAD_DEPTH
FAST = {"$fn": "64"}

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(
            MIRROR_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}}, openscadpath=os.path.join(REPO_ROOT, "lib")
        )
    return _cache[key]


def thread_flank_hits(tris, radius, z0, z1, steps=24, x=LENGTH):
    """Return (solid, empty) sample counts along a vertical line at the given radius from the thread axis."""
    zs = [z0 + (z1 - z0) * (i + 0.5) / steps for i in range(steps)]
    solid = sum(contains(tris, (x + radius, 0, z)) for z in zs)
    return solid, steps - solid


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class MotorcycleMirrorExtensionTestCase(unittest.TestCase):
    def test_overall_size_matches_the_original(self):
        size = fingerprint(render())["bbox_size_mm"]
        for got, want in zip(size, (LENGTH + SOCKET_D, SOCKET_D, HEIGHT)):
            self.assertAlmostEqual(got, want, delta=0.05)

    def test_screw_hole_goes_through_the_lower_socket(self):
        tris = render()
        self.assertFalse(contains(tris, (0, 0, 0.1)), "screw hole is closed at the bottom")
        self.assertFalse(contains(tris, (SCREW_D / 2 - 0.3, 0, 3)), "screw hole is narrower than Screw_Diameter")
        self.assertTrue(contains(tris, (SCREW_D / 2 + 0.3, 0, 3)), "screw hole is wider than Screw_Diameter")

    def test_counterbore_seats_the_screw_head(self):
        tris = render()
        z = SCREW_DEPTH + 2
        self.assertFalse(contains(tris, (HEAD_D / 2 - 0.3, 0, z)), "counterbore is narrower than the head")
        self.assertTrue(contains(tris, (HEAD_D / 2 + 0.3, 0, z)), "counterbore is wider than the head")
        self.assertTrue(contains(tris, (HEAD_D / 2 - 0.3, 0, SCREW_DEPTH - 0.5)), "shoulder under the head is missing")

    def test_upper_socket_is_threaded(self):
        solid, empty = thread_flank_hits(render(), 7.0, THREAD_BASE_Z + 3, HEIGHT - 3)
        self.assertGreater(solid, 0, "thread has no teeth")
        self.assertGreater(empty, 0, "thread has no grooves")

    def test_thread_bore_is_open_on_the_axis(self):
        tris = render()
        for z in (THREAD_BASE_Z + 1, HEIGHT - 1):
            self.assertFalse(contains(tris, (LENGTH, 0, z)), "thread bore is blocked")

    def test_upper_socket_wall_surrounds_the_thread(self):
        self.assertTrue(contains(render(), (LENGTH + SOCKET_D / 2 - 0.4, 0, HEIGHT - 4)), "socket wall is missing")

    def test_m10_preset_uses_the_smaller_thread(self):
        tris = render(Thread_Diameter=10, Thread_Pitch=1.25)
        self.assertFalse(contains(tris, (LENGTH + 3.0, 0, HEIGHT - 8)), "M10 bore is narrower than 10 mm")
        solid, _ = thread_flank_hits(tris, 5.0, THREAD_BASE_Z + 3, HEIGHT - 3)
        self.assertGreater(solid, 0, "M10 thread has no teeth")
        self.assertTrue(contains(tris, (LENGTH + 6.5, 0, HEIGHT - 8)), "M10 wall is missing")

    def test_underside_runs_at_45_degrees(self):
        tris = render()
        x = LENGTH + 4.5
        self.assertTrue(contains(tris, (x, 0, 16.5)), "underside is not filled to 45 degrees")
        self.assertFalse(contains(tris, (x, 0, 12)), "underside is filled below 45 degrees")

    def test_bottom_face_is_flat_inside_the_edge_radius(self):
        tris = render()
        self.assertTrue(contains(tris, (7, 0, 0.1)), "bearing face is not flat")
        self.assertFalse(contains(tris, (-SOCKET_D / 2 + 0.05, 0, 0.1)), "bottom edge is square")

    def test_thread_mouth_has_a_lead_in_chamfer(self):
        tris = render()
        self.assertFalse(contains(tris, (LENGTH + 7.9, 0, HEIGHT - 0.05)), "thread mouth is square")
        self.assertTrue(contains(tris, (LENGTH + 7.9, 0, HEIGHT - 3)), "chamfer cuts too deep")

    def test_counterbore_mouth_has_a_lead_in_chamfer(self):
        tris = render()
        z = 13 - 0.05
        self.assertFalse(contains(tris, (HEAD_D / 2 + 0.3, 0, z)), "counterbore mouth is square")


if __name__ == "__main__":
    unittest.main()
