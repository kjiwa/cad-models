"""Property tests for peglock_bit_holder: tier pitch, hexagon pockets, grip relief, entry chamfer, plate seat, rounding.

In exported STL coordinates the model is rotated 180 degrees about Z, so the plate sits at +Y,
the tiers extend toward -Y, and model X is mirrored. Probe points are given in a pocket frame:
x along the row, u from the cell's back wall toward its front, v up the tilted pocket axis.
"""

import json
import math
import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains, shell_count  # noqa: E402

MODEL_DIR = os.path.join(REPO_ROOT, "peglock_bit_holder")
BIT_SCAD = os.path.join(MODEL_DIR, "peglock_bit_holder.scad")
PRESETS_PATH = os.path.join(MODEL_DIR, "peglock_bit_holder.json")
FAST = {"$fn": "32"}
SOCKET_HEIGHT = 35.4
WIDTH, WALL, DEPTH, TILT, CHAMFER = 6.75, 2.68, 15.0, 15.0, 0.5
RADIUS, PLATE = 1.0, 1.5875

_cache = {}


def render(params=None):
    key = tuple(sorted((params or {}).items()))
    if key not in _cache:
        _cache[key] = render_triangles(BIT_SCAD, {**FAST, **(params or {})}, openscadpath=os.path.join(REPO_ROOT, "lib"))
    return _cache[key]


def cell_size():
    return 2 * WIDTH / math.sqrt(3) + 2 * WALL


def rise():
    return cell_size() * math.sin(math.radians(TILT))


def tier_pitch():
    return rise() + cell_size() * math.cos(math.radians(TILT)) / math.tan(math.radians(TILT))


def column_x(i, columns):
    return -columns * cell_size() / 2 + cell_size() / 2 + i * cell_size()


def stl_point(x, u, v, tier=0):
    """Pocket-frame point in tier `tier` (0 is the top tier) as an STL-frame point."""
    t = math.radians(TILT)
    y = u * math.cos(t) + v * math.sin(t)
    z = rise() - u * math.sin(t) + v * math.cos(t) - tier * tier_pitch()
    return (-x, -y, z)


def mouth_height():
    return DEPTH + WALL


def profile_corner(kind):
    """Convex corner of the side profile: its [y, z] vertex and unit directions along both edges.

    Front-bottom, front-top and bottom-back belong to the lowest tier, back-top to the top tier.
    """
    t = math.radians(TILT)
    s, c = math.sin(t), math.cos(t)
    depth = cell_size() * c
    low = -tier_pitch()
    h = mouth_height()
    return {
        "front-bottom": ((depth, low), (s, c), (-1, 0)),
        "front-top": ((depth + h * s, low + h * c), (-s, -c), (-c, s)),
        "back-top": ((h * s, rise() + h * c), (c, -s), (-s, -c)),
        "bottom-back": ((0, low), (0, 1), (1, 0)),
    }[kind]


def rounded_corner_probe(kind, x_model):
    """STL point on a corner's bisector, half way from the vertex to where a radius-1 rounding starts."""
    (y, z), e1, e2 = profile_corner(kind)
    bx, bz = e1[0] + e2[0], e1[1] + e2[1]
    norm = math.hypot(bx, bz)
    half = math.asin(math.hypot(e1[0] - e2[0], e1[1] - e2[1]) / 2)
    reach = 0.5 * RADIUS * (1 / math.sin(half) - 1)
    return (-x_model, -(y + bx / norm * reach), z + bz / norm * reach)


def centre(v=WALL + DEPTH / 2):
    return cell_size() / 2, v


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class BitHolderTestCase(unittest.TestCase):
    def test_bbox_follows_tier_pitch(self):
        top = rise() + (DEPTH + WALL) * math.cos(math.radians(TILT))
        for rows in (1, 2):
            with self.subTest(rows=rows):
                bbox = fingerprint(render({"Rows": str(rows), "Corner_Radius": "0"}))["bbox_size_mm"]
                self.assertAlmostEqual(bbox[0], 10 * cell_size(), delta=0.05)
                self.assertAlmostEqual(bbox[2], top + max(SOCKET_HEIGHT - rise(), (rows - 1) * tier_pitch()), delta=0.05)

    def test_hexagon_flats_front_and_back_corners_along_row(self):
        tris = render({"Relief_Width": "0"})
        u0, v = centre()
        x0 = column_x(3, 10)
        for sign in (-1, 1):
            with self.subTest(sign=sign):
                self.assertFalse(contains(tris, stl_point(x0, u0 + sign * (WIDTH / 2 - 0.1), v)), "flat pocket too narrow")
                self.assertTrue(contains(tris, stl_point(x0, u0 + sign * (WIDTH / 2 + 0.1), v)), "flat pocket too wide")
                corner = WIDTH / math.sqrt(3)
                self.assertFalse(contains(tris, stl_point(x0 + sign * (corner - 0.1), u0, v)), "corner pocket too narrow")
                self.assertTrue(contains(tris, stl_point(x0 + sign * (corner + 0.1), u0, v)), "corner pocket too wide")

    def test_relief_slot_cuts_dividers(self):
        divider = column_x(3, 10) + cell_size() / 2
        u0, v = centre()
        self.assertFalse(contains(render(), stl_point(divider, u0, v)), "no relief through the divider")
        self.assertTrue(contains(render({"Relief_Width": "0"}), stl_point(divider, u0, v)), "divider is empty without relief")

    def test_second_tier_is_one_pitch_up(self):
        tris = render()
        u0, v = centre()
        x0 = column_x(3, 10)
        for tier in (0, 1):
            with self.subTest(tier=tier):
                self.assertFalse(contains(tris, stl_point(x0, u0, v, tier)), "pocket centre is solid")
                self.assertTrue(contains(tris, stl_point(x0, u0 + WIDTH / 2 + 0.1, v, tier)), "pocket wall is missing")
        centre_z = [stl_point(x0, u0, v, tier)[2] for tier in (0, 1)]
        self.assertAlmostEqual(centre_z[0] - centre_z[1], tier_pitch(), places=6)

    def test_entry_chamfer_widens_mouth(self):
        u0, _ = centre()
        x0 = column_x(3, 10)
        point = stl_point(x0, u0 + WIDTH / 2 + CHAMFER / 2, WALL + DEPTH - CHAMFER / 4)
        self.assertFalse(contains(render(), point), "no lead-in at the mouth")
        self.assertTrue(contains(render({"Entry_Chamfer": "0"}), point), "mouth is empty without chamfer")

    def test_plate_top_is_flush_with_wedge(self):
        tris = render()
        for dz, solid in ((2, False), (-2, True)):
            with self.subTest(dz=dz):
                point = (0, 0.5, rise() + dz)
                self.assertEqual(contains(tris, point), solid, "plate does not end at the wedge top")

    def test_plate_ends_where_the_back_face_turns_into_the_roundover(self):
        for mount in ('"peglock"', '"monolithic"'):
            for radius in (0.0, RADIUS, 2.0):
                flat = 10 * cell_size() / 2 - radius
                params = {"Mount_Type": mount, "Corner_Radius": str(radius)}
                for sign in (-1, 1):
                    with self.subTest(mount=mount, radius=radius, sign=sign):
                        z = rise() - 5
                        self.assertTrue(contains(render(params), (sign * (flat - 0.1), 0.5, z)), "plate is too narrow")
                        self.assertFalse(contains(render(params), (sign * (flat + 0.1), 0.5, z)), "plate overhangs the roundover")

    def test_profile_corners_are_rounded_along_the_row(self):
        end = 10 * cell_size() / 2
        kinds = ("front-bottom", "front-top", "back-top", "bottom-back")
        for kind in kinds:
            for label, x_model in (("end", end - 0.3 * RADIUS), ("mid", 0.0)):
                with self.subTest(corner=kind, at=label):
                    point = rounded_corner_probe(kind, x_model)
                    self.assertFalse(contains(render(), point), "corner is square")
                    self.assertTrue(contains(render({"Corner_Radius": "0"}), point), "probe is outside the body")

    def test_variants_render_one_shell(self):
        variants = (
            {},
            {"Relief_Width": "0"},
            {"Entry_Chamfer": "0"},
            {"Corner_Radius": "0"},
            {"Rows": "1"},
            {"Mount_Type": '"monolithic"'},
        )
        for params in variants:
            with self.subTest(params=params):
                self.assertEqual(shell_count(render(params)), 1)

    def test_preset_reproduces_defaults(self):
        with open(PRESETS_PATH, encoding="utf-8") as f:
            params = json.load(f)["parameterSets"]["Hex_Bit_1_4in"]
        self.assertEqual(shell_count(render(params)), 1)

    def test_out_of_range_parameters_assert(self):
        cases = [
            ({"Tilt_Angle": "0"}, "Tilt_Angle must be greater than 0"),
            ({"Tilt_Angle": "90"}, "Tilt_Angle must not exceed 45"),
            ({"Relief_Width": "6.75"}, "Relief_Width must be less than Bit_Width"),
            ({"Entry_Chamfer": "2.5"}, "Entry_Chamfer is too large for Wall_Thickness"),
            ({"Pocket_Height": "0.3", "Entry_Chamfer": "0.4"}, "Entry_Chamfer must not exceed Pocket_Height"),
        ]
        for params, message in cases:
            with self.subTest(params=params):
                with self.assertRaises(RuntimeError) as ctx:
                    render_triangles(BIT_SCAD, {**FAST, **params}, openscadpath=os.path.join(REPO_ROOT, "lib"))
                self.assertIn(message, str(ctx.exception))


if __name__ == "__main__":
    unittest.main()
