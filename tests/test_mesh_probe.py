"""The indexed `contains` must agree with a brute-force ray cast over every triangle."""

import os
import random
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import render_triangles  # noqa: E402
from mesh_probe import _ray_hits_triangle, contains  # noqa: E402

SAMPLES = 2000


def brute_force_contains(tris, point):
    return sum(_ray_hits_triangle(point, t) for t in tris) % 2 == 1


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class MeshProbeTestCase(unittest.TestCase):
    def test_indexed_contains_matches_brute_force(self):
        scad = os.path.join(REPO_ROOT, "models", "wall_hook", "wall_hook.scad")
        tris = render_triangles(scad, {"$fn": "32"}, openscadpath=os.path.join(REPO_ROOT, "lib"))
        lo = [min(p[i] for t in tris for p in t) for i in range(3)]
        hi = [max(p[i] for t in tris for p in t) for i in range(3)]
        rng = random.Random(0)
        inside = 0
        for _ in range(SAMPLES):
            point = tuple(rng.uniform(lo[i] - 5, hi[i] + 5) for i in range(3))
            expected = brute_force_contains(tris, point)
            inside += expected
            self.assertEqual(contains(tris, point), expected, f"mismatch at {point}")
        self.assertGreater(inside, 0)
        self.assertLess(inside, SAMPLES)


if __name__ == "__main__":
    unittest.main()
