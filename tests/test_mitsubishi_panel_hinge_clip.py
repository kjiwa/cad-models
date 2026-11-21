"""Property tests for mitsubishi_panel_hinge_clip: caliper-measured features, mirrored hands, pair layout and asserts."""

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

CLIP_SCAD = os.path.join(REPO_ROOT, "models", "mitsubishi_panel_hinge_clip", "mitsubishi_panel_hinge_clip.scad")
FAST = {"$fn": "32"}
EDGE = 0.05

SHOULDER_WIDTH = 17
LUG_PROJECTION = 3.5
FIN_HEIGHT = 30
LEG_LENGTH = 9.2
LEG_GAP = 6.45
LEG_THICKNESS = 2.15
LEG_X = 23.75
NECK_START = 5
NECK_WIDTH = 9.6
NECK_THICKNESS = 1.8
TONGUE_WIDTH = 10
TONGUE_PROBE = (28.2, -2.21)
CRADLE_CENTER = (7, 6.9, 8.15)
CRADLE_RADIUS = 6
CRADLE_PROBE_ANGLE = 300
LIP_PROBE_X = 17.15
LIP_PROBE_Z = 29
LIP_PROBE_Y = 2.0
PAIR_GAP = 5

_cache = {}


def shell_count(tris):
    """Number of connected bodies, joining triangles that share a vertex."""
    parent = {}

    def find(v):
        while parent.setdefault(v, v) != v:
            parent[v] = parent[parent[v]]
            v = parent[v]
        return v

    for tri in tris:
        keys = [tuple(round(c, 4) for c in vertex) for vertex in tri]
        for key in keys[1:]:
            parent[find(key)] = find(keys[0])
    return len({find(v) for v in list(parent)})


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(
            CLIP_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}}, openscadpath=os.path.join(REPO_ROOT, "lib")
        )
    return _cache[key]


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class MitsubishiPanelHingeClipTestCase(unittest.TestCase):
    def test_leg_gap_is_the_measured_gap_between_inside_faces(self):
        tris = render()
        for side in (1, -1):
            self.assertFalse(contains(tris, (LEG_X, side * (LEG_GAP / 2 - EDGE), -4)), "gap too narrow")
            self.assertTrue(contains(tris, (LEG_X, side * (LEG_GAP / 2 + EDGE), -4)), "gap too wide")
            self.assertTrue(contains(tris, (LEG_X, side * (LEG_GAP / 2 + LEG_THICKNESS - EDGE), -4)), "leg too thin")
            self.assertFalse(contains(tris, (LEG_X, side * (LEG_GAP / 2 + LEG_THICKNESS + EDGE), -4)), "leg too thick")

    def test_neck_is_the_measured_width_and_thickness(self):
        tris = render()
        x = NECK_START + 2
        for side in (1, -1):
            self.assertTrue(contains(tris, (x, side * (NECK_WIDTH / 2 - EDGE), NECK_THICKNESS / 2)), "neck too narrow")
            self.assertFalse(contains(tris, (x, side * (NECK_WIDTH / 2 + EDGE), NECK_THICKNESS / 2)), "neck too wide")
        self.assertTrue(contains(tris, (x, 0, NECK_THICKNESS - EDGE)), "neck too thin")
        self.assertFalse(contains(tris, (x, 0, NECK_THICKNESS + EDGE)), "neck too thick")

    def test_tongue_is_the_measured_width(self):
        tris = render()
        x, z = TONGUE_PROBE
        for side in (1, -1):
            self.assertTrue(contains(tris, (x, side * (TONGUE_WIDTH / 2 - EDGE), z)), "tongue too narrow")
            self.assertFalse(contains(tris, (x, side * (TONGUE_WIDTH / 2 + EDGE), z)), "tongue too wide")

    def test_cradle_inside_radius_is_the_measured_radius(self):
        tris = render()
        x, y, z = CRADLE_CENTER
        cos, sin = math.cos(math.radians(CRADLE_PROBE_ANGLE)), math.sin(math.radians(CRADLE_PROBE_ANGLE))
        self.assertFalse(contains(tris, (x + (CRADLE_RADIUS - EDGE) * cos, y, z + (CRADLE_RADIUS - EDGE) * sin)), "cradle radius too small")
        self.assertTrue(contains(tris, (x + (CRADLE_RADIUS + EDGE) * cos, y, z + (CRADLE_RADIUS + EDGE) * sin)), "cradle radius too large")

    def test_overall_size_is_fin_plus_legs_tall_and_lug_span_wide(self):
        bbox = fingerprint(render())["bbox_size_mm"]
        self.assertAlmostEqual(bbox[1], SHOULDER_WIDTH + 2 * LUG_PROJECTION, delta=EDGE)
        self.assertAlmostEqual(bbox[2], FIN_HEIGHT + LEG_LENGTH, delta=EDGE)

    def test_lip_overhangs_the_left_clip_towards_positive_y_and_the_right_clip_towards_negative_y(self):
        for part, side in (("left", 1), ("right", -1)):
            tris = render(Part=f'"{part}"')
            self.assertTrue(contains(tris, (LIP_PROBE_X, side * LIP_PROBE_Y, LIP_PROBE_Z)), f"no lip on the {part} clip")
            self.assertFalse(contains(tris, (LIP_PROBE_X, -side * LIP_PROBE_Y, LIP_PROBE_Z)), f"lip on the wrong side of the {part} clip")

    def test_every_variant_is_one_connected_body(self):
        variants = [
            {},
            {"Part": '"right"'},
            {"Foot_Side": '"inward"'},
            {"Foot_Projection": 0},
            {"Cradle_Arc_Angle": 30},
            {"Cradle_Arc_Angle": 180},
            {"Plate_A_Angle": 90},
            {"Plate_A_Angle": 0},
            {"Tongue_Drop_Angle": 90, "Tongue_Rise_Angle": 90},
        ]
        for params in variants:
            with self.subTest(params=params):
                self.assertEqual(shell_count(render(**params)), 1)

    def test_hands_have_equal_volume_and_size(self):
        left, right = fingerprint(render(Part='"left"')), fingerprint(render(Part='"right"'))
        self.assertAlmostEqual(left["volume_mm3"], right["volume_mm3"], delta=1)
        self.assertEqual(left["bbox_size_mm"], right["bbox_size_mm"])

    def test_pair_holds_both_hands_with_a_gap(self):
        single = fingerprint(render())["bbox_size_mm"]
        pair = fingerprint(render(Part='"pair"'))["bbox_size_mm"]
        self.assertAlmostEqual(pair[1], 2 * single[1] + PAIR_GAP, delta=EDGE)
        self.assertAlmostEqual(pair[2], single[2], delta=EDGE)

    def test_feet_follow_foot_side_and_vanish_at_zero_projection(self):
        z = -LEG_LENGTH + 0.5
        outward = LEG_GAP / 2 + LEG_THICKNESS + 0.5
        inward = LEG_GAP / 2 - 0.5
        self.assertTrue(contains(render(), (LEG_X, outward, z)), "no outward foot")
        self.assertFalse(contains(render(), (LEG_X, inward, z)), "inward foot on an outward clip")
        self.assertTrue(contains(render(Foot_Side='"inward"'), (LEG_X, inward, z)), "no inward foot")
        self.assertFalse(contains(render(Foot_Projection=0), (LEG_X, outward, z)), "foot at zero projection")

    def test_invalid_parameters_fail_their_asserts(self):
        cases = [
            ({"Tongue_Drop_Length": "25"}, "Tongue_Drop_Length must be less than Tongue_Length"),
            ({"Barrel_Wall": "4"}, "Barrel_Wall must be less than Barrel_Depth"),
            ({"Fin_Top_Width": "20"}, "Fin_Top_Width must not exceed Fin_Base_Width"),
            ({"Leg_Gap": "20"}, "The legs must fit within Lower_Width"),
            ({"Lug_Length": "8"}, "Lug_Length must not exceed Shoulder_Length or Lower_Length"),
            ({"Cradle_Position": "40"}, "The cradle must stand on the base plate"),
            ({"Foot_Side": '"inward"', "Foot_Projection": "4"}, "Inward feet must leave a gap between the legs"),
        ]
        for params, message in cases:
            with self.subTest(params=params):
                with self.assertRaises(RuntimeError) as ctx:
                    render_triangles(CLIP_SCAD, {**FAST, **params}, openscadpath=os.path.join(REPO_ROOT, "lib"))
                self.assertIn(message, str(ctx.exception))


if __name__ == "__main__":
    unittest.main()
