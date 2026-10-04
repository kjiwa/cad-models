"""Property tests for Hook_Tilt_Angle / Hook_Lip_Orientation and Holder_Tilt_Angle.

Zero-tilt output is pinned to HEAD by the fixtures in geometry_fixtures.json; these
tests cover what tilting must preserve (a single shell, nothing hanging below the
backer, the pocket floor) and the vertical-lip bridge. In exported STL coordinates the
model is rotated 180 degrees about Z, so the backer and socket sit at +Y and
hooks/pockets at -Y.
"""

import math
import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import render_triangles  # noqa: E402
from mesh_probe import contains, shell_count  # noqa: E402

HOOK_SCAD = os.path.join(REPO_ROOT, "peglock_hook", "peglock_hook.scad")
HOLDER_SCAD = os.path.join(REPO_ROOT, "peglock_holder", "peglock_holder.scad")

FAST = {"$fn": "32"}
HOOK_CONFIGS = {
    "default": {},
    "depth25": {"Hook_Depth": "25"},
    "rows2": {"Hook_Rows": "2", "Hook_Depth": "25"},
    "quantity2": {"Hook_Item_Quantity": "2"},
    "fillet10": {"Hook_Root_Fillet": "10"},
}
HOLDER_CONFIGS = {
    "default": {},
    "tall": {"Holder_Height": "50"},
    "rows3": {"Holder_Rows": "3"},
    "open_bottom": {"Holder_Closed_Bottom": "false"},
    "no_opening": {"Holder_Front_Opening": "0"},
}
HOOK_TILTS = (15, 45)
HOLDER_TILTS = (15, 45)

_cache = {}


def render(scad, params):
    key = (scad, tuple(sorted(params.items())))
    if key not in _cache:
        _cache[key] = render_triangles(scad, {**FAST, **params}, openscadpath=os.path.join(REPO_ROOT, "lib"))
    return _cache[key]


def volume(tris):
    return abs(sum(
        (a[0] * (b[1] * c[2] - b[2] * c[1]) - a[1] * (b[0] * c[2] - b[2] * c[0]) + a[2] * (b[0] * c[1] - b[1] * c[0])) / 6
        for a, b, c in tris
    ))


def min_z(tris, in_front):
    return min(v[2] for t in tris for v in t if (v[1] < -0.01) == in_front and abs(v[1]) >= 0.01)


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class TiltInvariantsTestCase(unittest.TestCase):
    def _check_invariants(self, scad, angle_param, base, angle):
        flat = render(scad, {**base, angle_param: "0"})
        tilted = render(scad, {**base, angle_param: str(angle)})

        # Parts that only touch on faces render as separate shells under some backends, so only compare upward.
        self.assertLessEqual(shell_count(tilted), shell_count(flat), "tilt detached part of the model")

        # HEAD already lets a tall closed-bottom body overhang the backer by half a wall; tilting must not add more.
        overhang = max(0.0, min_z(flat, in_front=False) - min_z(flat, in_front=True))
        allowed = min_z(tilted, in_front=False) - overhang
        self.assertGreaterEqual(min_z(tilted, in_front=True), allowed - 0.01, "tilted body hangs below the backer")

    def test_hook_tilt_preserves_shape(self):
        for name, cfg in HOOK_CONFIGS.items():
            for angle in HOOK_TILTS:
                with self.subTest(config=name, angle=angle):
                    self._check_invariants(HOOK_SCAD, "Hook_Tilt_Angle", cfg, angle)

    def test_hook_vertical_lip_preserves_shape(self):
        cfg = {"Hook_Lip_Orientation": '"vertical"', "Hook_Depth": "25"}
        for angle in HOOK_TILTS:
            with self.subTest(angle=angle):
                self._check_invariants(HOOK_SCAD, "Hook_Tilt_Angle", cfg, angle)

    def test_holder_tilt_preserves_shape(self):
        for name, cfg in HOLDER_CONFIGS.items():
            for angle in HOLDER_TILTS:
                with self.subTest(config=name, angle=angle):
                    self._check_invariants(HOLDER_SCAD, "Holder_Tilt_Angle", cfg, angle)

    def test_holder_closed_bottom_floor_survives_tilt(self):
        wall = 1.5875
        for name, height in (("default", 12.7), ("mid", 20.0)):
            floors = {}
            for angle in (0, *HOLDER_TILTS):
                # Same total body height either way, so only the floor differs.
                closed = render(HOLDER_SCAD, {"Holder_Height": str(height), "Holder_Tilt_Angle": str(angle)})
                opened = render(
                    HOLDER_SCAD,
                    {
                        "Holder_Height": str(height + wall),
                        "Holder_Closed_Bottom": "false",
                        "Holder_Tilt_Angle": str(angle),
                    },
                )
                floors[angle] = volume(closed) - volume(opened)
            self.assertGreater(floors[0], 50.0)
            for angle in HOLDER_TILTS:
                with self.subTest(config=name, angle=angle):
                    self.assertAlmostEqual(floors[angle], floors[0], delta=0.1 * floors[0])

    def test_hook_arm_rises_with_tilt(self):
        flat = render(HOOK_SCAD, {"Hook_Depth": "25"})
        tilted = render(HOOK_SCAD, {"Hook_Depth": "25", "Hook_Tilt_Angle": "30"})
        self.assertGreater(max(v[2] for t in tilted for v in t if v[1] < -0.01),
                           max(v[2] for t in flat for v in t if v[1] < -0.01) + 5.0)

    def test_hook_vertical_lip_at_zero_tilt_matches_default(self):
        default = render(HOOK_SCAD, {})
        vertical = render(HOOK_SCAD, {"Hook_Lip_Orientation": '"vertical"'})
        self.assertEqual(len(default), len(vertical))


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class VerticalLipBridgeTestCase(unittest.TestCase):
    """The vertical lip leans forward of the arm's end face; the wedge between them must be solid."""

    def test_wedge_between_arm_end_and_lip_is_solid(self):
        height, depth = 6.35, 25.0
        for angle in (15, 45):
            with self.subTest(angle=angle):
                tris = render(
                    HOOK_SCAD,
                    {"Hook_Tilt_Angle": str(angle), "Hook_Lip_Orientation": '"vertical"', "Hook_Depth": str(depth)},
                )
                a = math.radians(angle)
                backer_bottom = min(v[2] for t in tris for v in t if v[1] > 0.01)
                pivot_z = backer_bottom + height / math.cos(a)

                # Wedge A=(depth,-h/2) B=(depth,0) C=(depth+(h/2)tan a,0) in arm-frame (u, v)
                # relative to the arm's top-back pivot; probe its centroid.
                u = depth + (height / 2) * math.tan(a) / 3
                v = -height / 6
                y = u * math.cos(a) - v * math.sin(a)
                z = pivot_z + u * math.sin(a) + v * math.cos(a)

                self.assertTrue(contains(tris, (0.0, -y, z)), "gap between hook arm and vertical lip")


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class TiltAngleBoundsTestCase(unittest.TestCase):
    def _assert_rejected(self, scad, param, value):
        with self.assertRaises(RuntimeError) as ctx:
            render_triangles(scad, {param: str(value)}, openscadpath=os.path.join(REPO_ROOT, "lib"))
        self.assertIn(param, str(ctx.exception))

    def test_angle_out_of_range_asserts(self):
        for scad, param in ((HOOK_SCAD, "Hook_Tilt_Angle"), (HOLDER_SCAD, "Holder_Tilt_Angle")):
            for value in (-1, 46):
                with self.subTest(param=param, value=value):
                    self._assert_rejected(scad, param, value)


if __name__ == "__main__":
    unittest.main()
