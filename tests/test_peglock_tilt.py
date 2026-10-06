"""Property tests for Arm_Tilt_Angle / Lip_Orientation and Tilt_Angle.

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
    "depth25": {"Arm_Length": "25"},
    "rows2": {"Rows": "2", "Arm_Length": "25"},
    "quantity2": {"Hooks_Per_Arm": "2"},
    "fillet10": {"Root_Fillet_Radius": "10"},
}
HOLDER_CONFIGS = {
    "default": {},
    "tall": {"Pocket_Height": "50"},
    "rows3": {"Rows": "3"},
    "open_bottom": {"Include_Bottom": "false"},
    "no_opening": {"Opening_Width": "0"},
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

        self.assertGreaterEqual(
            min_z(tilted, in_front=True), min_z(tilted, in_front=False) - 0.01, "tilted body hangs below the backer"
        )

    def test_hook_tilt_preserves_shape(self):
        for name, cfg in HOOK_CONFIGS.items():
            for angle in HOOK_TILTS:
                with self.subTest(config=name, angle=angle):
                    self._check_invariants(HOOK_SCAD, "Arm_Tilt_Angle", cfg, angle)

    def test_hook_vertical_lip_preserves_shape(self):
        cfg = {"Lip_Orientation": '"vertical"', "Arm_Length": "25"}
        for angle in HOOK_TILTS:
            with self.subTest(angle=angle):
                self._check_invariants(HOOK_SCAD, "Arm_Tilt_Angle", cfg, angle)

    def test_holder_tilt_preserves_shape(self):
        for name, cfg in HOLDER_CONFIGS.items():
            for angle in HOLDER_TILTS:
                with self.subTest(config=name, angle=angle):
                    self._check_invariants(HOLDER_SCAD, "Tilt_Angle", cfg, angle)

    def test_holder_never_overhangs_plate(self):
        for name, cfg in HOLDER_CONFIGS.items():
            for angle in (0, *HOLDER_TILTS):
                with self.subTest(config=name, angle=angle):
                    tris = render(HOLDER_SCAD, {**cfg, "Tilt_Angle": str(angle)})
                    self.assertGreaterEqual(min_z(tris, in_front=True), min_z(tris, in_front=False) - 0.01)

    def test_holder_center_alignment(self):
        wall = 1.5875
        for angle in (0, 15, 45):
            with self.subTest(angle=angle):
                tris = render(HOLDER_SCAD, {"Vertical_Alignment": '"center"', "Tilt_Angle": str(angle)})
                a = math.radians(angle)
                envelope = (12.7 + wall) * math.cos(a) + (6.35 + wall) * math.sin(a)
                self.assertAlmostEqual(min_z(tris, in_front=True), -envelope / 2, delta=0.02)

    def test_holder_closed_bottom_floor_survives_tilt(self):
        wall = 1.5875
        for name, height in (("default", 12.7), ("mid", 20.0)):
            floors = {}
            for angle in (0, *HOLDER_TILTS):
                # Same total body height either way, so only the floor differs.
                closed = render(HOLDER_SCAD, {"Pocket_Height": str(height), "Tilt_Angle": str(angle)})
                opened = render(
                    HOLDER_SCAD,
                    {
                        "Pocket_Height": str(height + wall),
                        "Include_Bottom": "false",
                        "Tilt_Angle": str(angle),
                    },
                )
                floors[angle] = volume(closed) - volume(opened)
            self.assertGreater(floors[0], 50.0)
            for angle in HOLDER_TILTS:
                with self.subTest(config=name, angle=angle):
                    self.assertAlmostEqual(floors[angle], floors[0], delta=0.1 * floors[0])

    def test_hook_arm_rises_with_tilt(self):
        flat = render(HOOK_SCAD, {"Arm_Length": "25"})
        tilted = render(HOOK_SCAD, {"Arm_Length": "25", "Arm_Tilt_Angle": "30"})
        self.assertGreater(max(v[2] for t in tilted for v in t if v[1] < -0.01),
                           max(v[2] for t in flat for v in t if v[1] < -0.01) + 5.0)

    def test_hook_vertical_lip_at_zero_tilt_matches_default(self):
        default = render(HOOK_SCAD, {})
        vertical = render(HOOK_SCAD, {"Lip_Orientation": '"vertical"'})
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
                    {"Arm_Tilt_Angle": str(angle), "Lip_Orientation": '"vertical"', "Arm_Length": str(depth)},
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
        for scad, param in ((HOOK_SCAD, "Arm_Tilt_Angle"), (HOLDER_SCAD, "Tilt_Angle")):
            for value in (-1, 46):
                with self.subTest(param=param, value=value):
                    self._assert_rejected(scad, param, value)

    def test_tilted_rows_must_not_overlap(self):
        # Parallel arms sit Row_Spacing * cos(tilt) apart and need Arm_Height + Lip_Height of room.
        params = {"Rows": "2", "Row_Spacing": "10", "Arm_Tilt_Angle": "0"}
        render_triangles(HOOK_SCAD, params, openscadpath=os.path.join(REPO_ROOT, "lib"))
        with self.assertRaises(RuntimeError):
            render_triangles(HOOK_SCAD, {**params, "Arm_Tilt_Angle": "45"}, openscadpath=os.path.join(REPO_ROOT, "lib"))


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class HolderBackerThicknessTestCase(unittest.TestCase):
    """A thicker plate grows toward the pegboard; the pocket side stays put."""

    def test_plate_grows_backward_only(self):
        extra = 1.5875
        for mount in ("peglock", "monolithic"):
            for angle in (0, 15):
                with self.subTest(mount=mount, angle=angle):
                    base = {"Mount_Type": f'"{mount}"', "Tilt_Angle": str(angle)}
                    thin = render(HOLDER_SCAD, base)
                    thick = render(HOLDER_SCAD, {**base, "Backplate_Thickness": str(1.5875 + extra)})
                    max_y = lambda tris: max(v[1] for t in tris for v in t)
                    min_y = lambda tris: min(v[1] for t in tris for v in t)
                    self.assertAlmostEqual(max_y(thick) - max_y(thin), extra, delta=0.01)
                    self.assertAlmostEqual(min_y(thick), min_y(thin), delta=0.01)


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class HolderSoftenedJunctionTestCase(unittest.TestCase):
    """Bottom roundover and junction gusset change the shape without detaching or overhanging anything."""

    CONFIGS = {"default": {}, "grid": {"Rows": "3", "Columns": "2"}, "open_bottom": {"Include_Bottom": "false"}}

    def _compare(self, knob, value, expect_more):
        for name, cfg in self.CONFIGS.items():
            for angle in (0, 15, 45):
                with self.subTest(config=name, angle=angle):
                    base = {**cfg, "Tilt_Angle": str(angle)}
                    plain = render(HOLDER_SCAD, base)
                    tris = render(HOLDER_SCAD, {**base, knob: value})
                    self.assertLessEqual(shell_count(tris), shell_count(plain))
                    self.assertGreaterEqual(min_z(tris, in_front=True), min_z(tris, in_front=False) - 0.01)
                    delta = volume(tris) - volume(plain)
                    self.assertGreater(delta if expect_more else -delta, 1.0)

    def test_junction_gusset_adds_material(self):
        self._compare("Junction_Gusset_Chamfer", "4", expect_more=True)

    def test_bottom_roundover_removes_material(self):
        self._compare("Bottom_Edge_Radius", "1.5", expect_more=False)


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class HookRootAndAlignmentTestCase(unittest.TestCase):
    """The root fillet follows the tilted arm, and the root always fits on the plate."""

    HEIGHT = 6.35
    WIDTH = 12.7

    def test_center_alignment(self):
        for angle in (0, 30):
            with self.subTest(angle=angle):
                tris = render(HOOK_SCAD, {"Vertical_Alignment": '"center"', "Arm_Tilt_Angle": str(angle)})
                root = [v[2] for t in tris for v in t if abs(v[1]) < 0.011 and abs(v[0]) <= self.WIDTH / 2 + 0.01]
                root_height = self.HEIGHT / math.cos(math.radians(angle))
                self.assertAlmostEqual(min(v for v in root if v > -17.0), -root_height / 2, delta=0.02)

    def test_root_fillet_flares_at_plate_and_follows_arm(self):
        fillet = 1.0  # below every clamp, so flare and reach equal the setting
        for angle in (15, 30, 45):
            with self.subTest(angle=angle):
                tris = render(HOOK_SCAD, {"Arm_Tilt_Angle": str(angle), "Root_Fillet_Radius": str(fillet)})
                a = math.radians(angle)

                flare_x = [abs(v[0]) for t in tris for v in t if -0.02 < v[1] < -0.005]
                self.assertAlmostEqual(max(flare_x), self.WIDTH / 2 + fillet, delta=0.02)

                pivot_z = min_z(tris, in_front=False) + fillet + self.HEIGHT / math.cos(a)

                def arm_bottom(y):
                    return pivot_z + (y - self.HEIGHT * math.sin(a)) / math.cos(a) * math.sin(a) - self.HEIGHT * math.cos(a)

                # Part-way along the fillet there is flare material below the arm's lower surface...
                self.assertTrue(contains(tris, (0.0, -0.3 * fillet, arm_bottom(0.3 * fillet) - 0.35)))
                # ...and once it ends the surface runs flush with the arm: no ledge.
                self.assertFalse(contains(tris, (0.0, -0.98 * fillet, arm_bottom(0.98 * fillet) - 0.15)))

    def test_flare_never_passes_plate_edge(self):
        for angle in (0, 30):
            with self.subTest(angle=angle):
                tris = render(
                    HOOK_SCAD,
                    {"Arm_Tilt_Angle": str(angle), "Root_Fillet_Radius": "10", "Rows": "4", "Arm_Length": "10"},
                )
                plate = [v[2] for t in tris for v in t if v[1] > 0.01]
                root = [v[2] for t in tris for v in t if -0.02 < v[1] < -0.005]
                self.assertGreaterEqual(min(root), min(plate) - 0.01)
                self.assertLessEqual(max(root), max(plate) + 0.01)


if __name__ == "__main__":
    unittest.main()
