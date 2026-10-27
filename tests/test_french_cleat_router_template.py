"""Property tests for french_cleat_router_template: cleat opening, optional dog-bone corner reliefs, and screw holes."""

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

TEMPLATE_SCAD = os.path.join(
    REPO_ROOT, "models", "french_cleat_router_template", "french_cleat_router_template.scad"
)
WALL = 6.35
CLEAT_THICKNESS = 19.05
CLEAT_HEIGHT = 95.25
CLEAT_ANGLE = 30
CLEAT_Y0 = (171.45 - CLEAT_HEIGHT) / 2
PLATE_Z = 25.4
HOLE_Z = 9.525
FAST = {"$fn": "32"}
DOG_BONES = {"Corner_Bit_Diameter": 6.35}

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(
            TEMPLATE_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}}, openscadpath=os.path.join(REPO_ROOT, "lib")
        )
    return _cache[key]


def _plate(x, y):
    return (WALL + x, CLEAT_Y0 + y, PLATE_Z)


BIT_RADIUS = 6.35 / 2
OUTSIDE = 0.3
RELIEF_CLEARANCE = 0.2
RING_POINTS = 24
REACH_STEPS = 8


def _relief_probes():
    """Points in the plate material just outside each closed corner's walls, half a bit radius from the corner.

    The corner relief is only usable if it opens into the cleat opening along both walls, so a bearing can
    enter it. Each pair is one probe beside each wall that meets at the corner.
    """
    a = math.radians(CLEAT_ANGLE)
    along = BIT_RADIUS / 2
    bottom = (CLEAT_THICKNESS, 0)
    top = (CLEAT_THICKNESS, CLEAT_HEIGHT)
    return [
        _plate(bottom[0] + OUTSIDE, bottom[1] + along),
        _plate(bottom[0] - along, bottom[1] - OUTSIDE),
        _plate(top[0] + OUTSIDE, top[1] - along),
        _plate(top[0] - along * math.cos(a) - OUTSIDE * math.sin(a), top[1] - along * math.sin(a) + OUTSIDE * math.cos(a)),
    ]


def _closed_corners():
    """Each closed corner as (corner, bisector into the opening, half angle, unit vectors along its two walls)."""
    t = math.tan(math.radians(CLEAT_ANGLE))
    outline = [(0, 0), (CLEAT_THICKNESS, 0), (CLEAT_THICKNESS, CLEAT_HEIGHT), (0, CLEAT_HEIGHT - CLEAT_THICKNESS * t)]

    def unit(v):
        n = math.hypot(*v)
        return (v[0] / n, v[1] / n)

    corners = []
    for i in (1, 2):
        c = outline[i]
        walls = [unit((outline[j][0] - c[0], outline[j][1] - c[1])) for j in ((i - 1) % 4, (i + 1) % 4)]
        bis = unit((walls[0][0] + walls[1][0], walls[0][1] + walls[1][1]))
        half = math.acos(walls[0][0] * walls[1][0] + walls[0][1] * walls[1][1]) / 2
        corners.append((c, bis, half, walls))
    return corners


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class FrenchCleatRouterTemplateTestCase(unittest.TestCase):
    def test_overall_size_matches_the_original_in_millimeters(self):
        size = fingerprint(render())["bbox_size_mm"]
        for got, want in zip(size, (82.55, 171.45, 31.75)):
            self.assertAlmostEqual(got, want, delta=0.05)

    def test_cleat_opening_matches_the_original_in_millimeters(self):
        tris = render()
        self.assertFalse(contains(tris, _plate(10, 1)), "opening is missing above its bottom edge")
        self.assertTrue(contains(tris, _plate(1, -1)), "opening extends below the cleat")
        self.assertFalse(contains(tris, _plate(CLEAT_THICKNESS - 1, 40)), "opening is thinner than the cleat")
        self.assertTrue(contains(tris, _plate(CLEAT_THICKNESS + 1, 40)), "opening is wider than the cleat")
        slope = CLEAT_HEIGHT - (CLEAT_THICKNESS - 2) * math.tan(math.radians(CLEAT_ANGLE))
        self.assertFalse(contains(tris, _plate(2, slope - 0.5)), "sloped edge is too low")
        self.assertTrue(contains(tris, _plate(2, slope + 0.5)), "sloped edge is too high")

    def test_closed_corners_are_relieved_for_the_router_bit(self):
        tris = render(**DOG_BONES)
        for probe in _relief_probes():
            self.assertFalse(contains(tris, probe), f"dog-bone relief does not open into the cleat opening at {probe}")

    def _assert_corner_bit_reaches_each_corner(self, tris, r):
        for c, bis, half, _ in _closed_corners():
            for k in range(REACH_STEPS + 1):
                d = r / math.sin(half) + (r - r / math.sin(half)) * k / REACH_STEPS
                cx, cy = c[0] + bis[0] * d, c[1] + bis[1] * d
                for n in range(RING_POINTS):
                    th = 2 * math.pi * n / RING_POINTS
                    probe = _plate(cx + (r - 0.05) * math.cos(th), cy + (r - 0.05) * math.sin(th))
                    self.assertFalse(contains(tris, probe), f"bit of radius {r} cannot reach corner {c} at {probe}")

    def test_corner_bit_reaches_each_closed_corner(self):
        self._assert_corner_bit_reaches_each_corner(render(**DOG_BONES), BIT_RADIUS)

    def test_larger_corner_bit_reaches_each_closed_corner(self):
        self._assert_corner_bit_reaches_each_corner(render(Corner_Bit_Diameter=22.225), 22.225 / 2)

    def test_relief_overcuts_each_wall_by_no_more_than_the_bit_geometry(self):
        tris = render(**DOG_BONES)
        r = BIT_RADIUS
        for c, bis, half, walls in _closed_corners():
            center = (c[0] + bis[0] * r, c[1] + bis[1] * r)
            for w in walls:
                along = (center[0] - c[0]) * w[0] + (center[1] - c[1]) * w[1]
                foot = (c[0] + w[0] * along, c[1] + w[1] * along)
                nx, ny = foot[0] - center[0], foot[1] - center[1]
                norm = math.hypot(nx, ny)
                depth = r * (1 - math.sin(half)) + RELIEF_CLEARANCE + OUTSIDE
                probe = _plate(foot[0] + nx / norm * depth, foot[1] + ny / norm * depth)
                self.assertTrue(contains(tris, probe), f"relief overcuts a wall by more than the bit geometry at {probe}")

    def test_default_leaves_the_corners_closed(self):
        tris = render()
        for probe in _relief_probes():
            self.assertTrue(contains(tris, probe), f"corner is relieved with no router bit at {probe}")

    def test_zero_angle_cuts_a_rectangular_opening(self):
        tris = render(Cleat_Angle=0)
        self.assertFalse(contains(tris, _plate(2, CLEAT_HEIGHT - 0.5)), "rectangular opening is too short")
        self.assertTrue(contains(tris, _plate(2, CLEAT_HEIGHT + 0.5)), "rectangular opening is too tall")

    def test_screw_holes_match_the_original_in_millimeters(self):
        tris = render()
        for y in (25.4, 171.45 - 25.4):
            self.assertFalse(contains(tris, (3, y, HOLE_Z)), "screw hole is missing")
            self.assertFalse(contains(tris, (3, y + 3.5, HOLE_Z)), "countersink is too narrow")
            self.assertTrue(contains(tris, (3, y + 4.5, HOLE_Z)), "countersink is too wide")


if __name__ == "__main__":
    unittest.main()
