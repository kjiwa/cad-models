"""Property tests for popsicle_stick_joints: pocket size, arm layout per preset, open top, and support-free printing."""

import json
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

JOINT_DIR = os.path.join(REPO_ROOT, "models", "popsicle_stick_joints")
JOINT_SCAD = os.path.join(JOINT_DIR, "popsicle_stick_joints.scad")
WIDTH = 10
THICKNESS = 2
LENGTH = 14
WALL = 2
CHAMFER = 0.5
JOINT_WIDTH = WIDTH + 2 * WALL
JOINT_THICKNESS = THICKNESS + 2 * WALL
FAST = {"$fn": "32"}

# Stick_Count, Joint_Angle for each preset and the default
LAYOUTS = {
    "Default": (2, 90),
    "Cap": (1, 0),
    "Two_Way_30": (2, 30),
    "Two_Way_45": (2, 45),
    "Two_Way_60": (2, 60),
    "Two_Way_120": (2, 120),
    "Straight": (2, 180),
}

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(
            JOINT_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}}, openscadpath=os.path.join(REPO_ROOT, "lib")
        )
    return _cache[key]


def distance_from_origin(angle):
    return 0 if angle == 0 or angle >= 180 else JOINT_WIDTH / (2 * math.tan(math.radians(angle / 2)))


def arm_point(index, angle, x, y, z):
    """World point for local (x, y, z) on arm `index`, whose pocket starts at distance_from_origin."""
    a = math.radians(index * angle)
    x += distance_from_origin(angle)
    return (x * math.cos(a) - y * math.sin(a), x * math.sin(a) + y * math.cos(a), z)


def _normal(tri):
    (ax, ay, az), (bx, by, bz), (cx, cy, cz) = tri
    ux, uy, uz = bx - ax, by - ay, bz - az
    vx, vy, vz = cx - ax, cy - ay, cz - az
    n = (uy * vz - uz * vy, uz * vx - ux * vz, ux * vy - uy * vx)
    length = math.sqrt(sum(c * c for c in n))
    return (0, 0, 0) if length == 0 else tuple(c / length for c in n)


def _down_facing(tris, limit):
    """Triangles whose normal points down by more than `limit` (cosine of the overhang angle from vertical)."""
    return [t for t in tris if _normal(t)[2] < -limit]


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class PopsicleStickJointsTestCase(unittest.TestCase):
    def test_pocket_equals_stick_width_and_thickness(self):
        tris = render(Stick_Count=1, Joint_Angle=0)
        x = 8
        for sign in (1, -1):
            self.assertFalse(contains(tris, (x, sign * (WIDTH / 2 - 0.3), 0)), "pocket is narrower than the stick")
            self.assertTrue(contains(tris, (x, sign * (WIDTH / 2 + 0.3), 0)), "pocket is wider than the stick")
            self.assertFalse(contains(tris, (x, 0, sign * (THICKNESS / 2 - 0.3))), "pocket is thinner than the stick")
            self.assertTrue(contains(tris, (x, 0, sign * (THICKNESS / 2 + 0.3))), "pocket is thicker than the stick")

    def test_pocket_is_straight_until_the_mouth_lead_in(self):
        tris = render(Stick_Count=1, Joint_Angle=0)
        for x in (WALL + 0.3, 8, LENGTH - CHAMFER - 0.1):
            for sign in (1, -1):
                self.assertTrue(contains(tris, (x, sign * (WIDTH / 2 + 0.1), 0)), f"pocket flares at x={x}")
                self.assertFalse(contains(tris, (x, sign * (WIDTH / 2 - 0.1), 0)), f"pocket narrows at x={x}")
                self.assertTrue(contains(tris, (x, 0, sign * (THICKNESS / 2 + 0.1))), f"pocket flares in thickness at x={x}")

    def test_pocket_runs_flat_to_the_hub_wall(self):
        tris = render(Stick_Count=1, Joint_Angle=0)
        self.assertTrue(contains(tris, (WALL - 0.3, 0, 0)), "hub wall is thin")
        self.assertFalse(contains(tris, (WALL + 0.3, 0, 0)), "pocket does not reach the hub wall")
        self.assertFalse(contains(tris, (WALL + 0.3, WIDTH / 2 - 0.3, THICKNESS / 2 - 0.3)), "pocket corner is filled")

    def test_default_is_two_way_ninety_degrees_with_a_slotted_top(self):
        tris = render()
        self.assertTrue(contains(tris, arm_point(0, 90, 8, 0, THICKNESS / 2 + 0.5)), "default top is open")
        for i in (0, 1):
            self.assertFalse(contains(tris, arm_point(i, 90, 8, 0, 0)), f"arm {i} pocket is missing")
        self.assertFalse(contains(tris, arm_point(2, 90, 8, 0, 0)), "default has a third arm")

    def test_arm_count_and_angle_per_layout(self):
        for name, (count, angle) in LAYOUTS.items():
            tris = render(Stick_Count=count, Joint_Angle=angle)
            for i in range(count):
                with self.subTest(layout=name, arm=i):
                    self.assertFalse(contains(tris, arm_point(i, angle, 8, 0, 0)), "pocket is missing")
                    self.assertTrue(contains(tris, arm_point(i, angle, 8, WIDTH / 2 + 1, 0)), "arm wall is missing")
            if count * angle % 360:
                with self.subTest(layout=name, arm=count):
                    self.assertFalse(contains(tris, arm_point(count, angle, 8, WIDTH / 2 + 1, 0)), "extra arm")

    def test_open_top_removes_the_lid(self):
        closed = render(Stick_Count=1, Joint_Angle=0)
        opened = render(Stick_Count=1, Joint_Angle=0, Top='"open"')
        self.assertTrue(contains(closed, (8, 0, THICKNESS / 2 + 0.5)), "closed roof is missing")
        self.assertFalse(contains(opened, (8, 0, THICKNESS / 2 + 0.5)), "open top keeps the lid")
        self.assertTrue(contains(opened, (8, 0, -THICKNESS / 2 - 0.5)), "open floor is missing")
        self.assertTrue(contains(opened, (8, WIDTH / 2 + 1, THICKNESS / 2 + 0.5 - 1)), "open side wall is missing")

    def test_pocket_mouth_has_a_lead_in_with_a_flat_roof(self):
        tris = render(Stick_Count=1, Joint_Angle=0)
        x = WALL + (LENGTH - WALL) - 0.1
        self.assertFalse(contains(tris, (x, WIDTH / 2 + 0.3, 0)), "mouth side is not chamfered")
        self.assertFalse(contains(tris, (x, 0, -THICKNESS / 2 - 0.3)), "mouth floor is not chamfered")
        self.assertTrue(contains(tris, (x, 0, THICKNESS / 2 + 0.2)), "mouth roof is not flat")
        self.assertTrue(contains(tris, (8, WIDTH / 2 + 0.3, 0)), "chamfer runs the whole pocket")

    def test_outer_arm_edges_are_eased(self):
        tris = render(Stick_Count=1, Joint_Angle=0)
        y = JOINT_WIDTH / 2 - 0.05
        self.assertFalse(contains(tris, (8, y, JOINT_THICKNESS / 2 - 0.05)), "top outer edge is square")
        self.assertFalse(contains(tris, (8, y, -JOINT_THICKNESS / 2 + 0.05)), "bottom outer edge is square")
        self.assertTrue(contains(tris, (8, 0, JOINT_THICKNESS / 2 - 0.05)), "top face is not flat")

    def test_closed_joint_prints_without_supports(self):
        """No face tilts more than 45 degrees past vertical, except the flat pocket roofs and the bed face."""
        limit = math.cos(math.radians(45)) + 1e-3
        for name, (count, angle) in LAYOUTS.items():
            tris = render(Stick_Count=count, Joint_Angle=angle)
            zmin = min(p[2] for t in tris for p in t)
            roofs = []
            for t in _down_facing(tris, limit):
                zs = [p[2] for p in t]
                if max(zs) - min(zs) < 1e-6 and abs(zs[0] - zmin) < 1e-6:
                    continue
                with self.subTest(layout=name):
                    self.assertAlmostEqual(zs[0], THICKNESS / 2, places=4, msg="overhang other than a pocket roof")
                    self.assertAlmostEqual(_normal(t)[2], -1, places=4, msg="pocket roof is not flat")
                roofs.append(t)
            for t in roofs:
                for p in t:
                    self.assertTrue(
                        any(self._inside_roof(p, i, angle) for i in range(count)),
                        f"{name}: roof vertex {p} is outside every pocket",
                    )

    @staticmethod
    def _inside_roof(point, index, angle):
        a = math.radians(-index * angle)
        x = point[0] * math.cos(a) - point[1] * math.sin(a) - distance_from_origin(angle)
        y = point[0] * math.sin(a) + point[1] * math.cos(a)
        return WALL - 1e-3 <= x <= LENGTH + 1e-3 and abs(y) <= WIDTH / 2 + CHAMFER + 1e-3

    def test_each_pocket_roof_bridges_only_the_stick_width(self):
        for name, (count, angle) in LAYOUTS.items():
            tris = render(Stick_Count=count, Joint_Angle=angle)
            for i in range(count):
                with self.subTest(layout=name, arm=i):
                    span = self._roof_span(tris, i, angle)
                    self.assertAlmostEqual(span, WIDTH + 2 * CHAMFER, delta=1e-3)
                    self.assertLessEqual(WIDTH + 2 * CHAMFER, 15)

    def _roof_span(self, tris, index, angle):
        """Widest local y extent of the flat roof triangles that belong to arm `index`."""
        ys = []
        for t in _down_facing(tris, 0.999):
            if abs(t[0][2] - THICKNESS / 2) > 1e-4 or any(abs(p[2] - THICKNESS / 2) > 1e-4 for p in t):
                continue
            if all(self._inside_roof(p, index, angle) for p in t):
                a = math.radians(-index * angle)
                ys += [p[0] * math.sin(a) + p[1] * math.cos(a) for p in t]
        return max(ys) - min(ys)

    def test_presets_match_the_layout_table(self):
        with open(os.path.join(JOINT_DIR, "popsicle_stick_joints.json"), encoding="utf-8") as f:
            sets = json.load(f)["parameterSets"]
        self.assertEqual(sorted(sets), sorted(n for n in LAYOUTS if n != "Default"))
        for name, params in sets.items():
            count, angle = LAYOUTS[name]
            self.assertEqual((int(params.get("Stick_Count", 2)), int(params.get("Joint_Angle", 90))), (count, angle))


if __name__ == "__main__":
    unittest.main()
