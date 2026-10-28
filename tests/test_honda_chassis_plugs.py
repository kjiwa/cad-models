"""Property tests for honda_chassis_plugs: cap, stem OD at the rib crests, bore, fins, and plain stems."""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

PLUG_SCAD = os.path.join(REPO_ROOT, "models", "honda_chassis_plugs", "honda_chassis_plugs.scad")
FAST = {"$fn": "64"}
WALL = 3
RIB_HEIGHT = 1
CAP_THICKNESS = 7.5
CAP_RADIUS = 3.75

FRAME = dict(cap=37, stem=20, length=16, ribs=10, params={})
PILLION_LEFT = dict(
    cap=40,
    stem=34,
    length=7,
    ribs=5,
    params={"Cap_Diameter": 40, "Stem_Diameter": 34, "Stem_Length": 7, "Rib_Count": 5},
)
PILLION_RIGHT = dict(
    cap=40,
    stem=35,
    length=7,
    ribs=5,
    params={"Cap_Diameter": 40, "Stem_Diameter": 35, "Stem_Length": 7, "Rib_Count": 5},
)
VARIANTS = {"frame": FRAME, "pillion left": PILLION_LEFT, "pillion right": PILLION_RIGHT}

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(
            PLUG_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}}, openscadpath=os.path.join(REPO_ROOT, "lib")
        )
    return _cache[key]


def rib_heights(variant):
    """Printed z of each rib's crest: the stem sits above the cap, and ribs count from the tip."""
    step = variant["length"] / (variant["ribs"] + 1)
    top = variant["length"] + CAP_THICKNESS
    return [top - ((i + 1) * step - RIB_HEIGHT / 2) for i in range(variant["ribs"])]


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class HondaChassisPlugsTestCase(unittest.TestCase):
    def test_cap_diameter_and_total_height(self):
        for name, v in VARIANTS.items():
            with self.subTest(name):
                size = fingerprint(render(**v["params"]))["bbox_size_mm"]
                for got, want in zip(size, (v["cap"], v["cap"], v["length"] + CAP_THICKNESS)):
                    self.assertAlmostEqual(got, want, delta=0.05)

    def test_stem_outside_diameter_is_the_rib_crests(self):
        for name, v in VARIANTS.items():
            tris = render(**v["params"])
            for z in rib_heights(v):
                with self.subTest(name, z=z):
                    self.assertTrue(contains(tris, (v["stem"] / 2 - 0.1, 0, z)), "rib crest is below Stem_Diameter")
                    self.assertFalse(contains(tris, (v["stem"] / 2 + 0.05, 0, z)), "rib crest is above Stem_Diameter")

    def test_stem_is_narrower_between_the_ribs(self):
        for name, v in VARIANTS.items():
            with self.subTest(name):
                gap = (rib_heights(v)[0] + rib_heights(v)[1]) / 2
                self.assertFalse(contains(render(**v["params"]), (v["stem"] / 2 - 0.1, 0, gap)), "no gap between ribs")

    def test_bore_equals_stem_minus_two_walls(self):
        for name, v in VARIANTS.items():
            tris = render(**v["params"])
            bore = v["stem"] / 2 - WALL
            z = CAP_THICKNESS + v["length"] / 2
            with self.subTest(name):
                self.assertFalse(contains(tris, (bore - 0.3, 0, z)), "bore is narrower than the stem less two walls")
                self.assertTrue(contains(tris, (bore + 0.3, 0, z)), "bore is wider than the stem less two walls")
                self.assertFalse(contains(tris, (0, 0, v["length"] + CAP_THICKNESS - 0.1)), "bore is closed at the tip")

    def test_cap_floor_closes_the_bore(self):
        tris = render()
        self.assertTrue(contains(tris, (0, 0, WALL - 0.2)), "cap floor is thinner than Wall_Thickness")
        self.assertFalse(contains(tris, (0, 0, WALL + 0.2)), "cap floor is thicker than Wall_Thickness")

    def test_cap_is_rounded_on_its_visible_face_and_flat_on_the_tube_face(self):
        tris = render()
        self.assertFalse(contains(tris, (FRAME["cap"] / 2 - 0.1, 0, 0.1)), "cap edge is square")
        self.assertTrue(contains(tris, (FRAME["cap"] / 2 - 0.1, 0, CAP_THICKNESS - 0.1)), "cap is not full diameter at the tube face")

    def test_every_rib_is_a_half_round_on_a_full_wall(self):
        for name, v in VARIANTS.items():
            tris = render(**v["params"])
            core = v["stem"] / 2 - RIB_HEIGHT
            for z in rib_heights(v):
                for dz in (-0.4, 0.4):
                    with self.subTest(name, z=z, dz=dz):
                        self.assertTrue(contains(tris, (core + 0.1, 0, z + dz)), "wall is cut away under the rib")

    def test_stem_tip_has_a_lead_in_chamfer(self):
        tris = render(Rib_Count=0)
        top = FRAME["length"] + CAP_THICKNESS
        self.assertFalse(contains(tris, (FRAME["stem"] / 2 - 0.1, 0, top - 0.1)), "stem tip edge is square")
        self.assertTrue(contains(tris, (FRAME["stem"] / 2 - 0.1, 0, top - 2)), "chamfer cuts too deep")

    def test_one_fin_renders(self):
        tris = render(Fin_Count=1)
        z = CAP_THICKNESS + FRAME["length"] / 2
        self.assertTrue(contains(tris, (FRAME["stem"] / 2 + 1.5, 0, z)), "single fin is missing")
        self.assertTrue(contains(tris, (0, FRAME["stem"] / 2 + 1.5, z)), "single fin has no crossing disc")

    def test_fins_are_graduated(self):
        tris = render(Fin_Count=2)
        fin_z = [CAP_THICKNESS + FRAME["length"] - (i + 1) * FRAME["length"] / 3 for i in range(2)]
        small, large = 25 / 2, 30 / 2
        self.assertTrue(contains(tris, (small - 0.3, 0, fin_z[0])), "small fin is missing")
        self.assertFalse(contains(tris, (small + 0.3, 0, fin_z[0])), "small fin is too large")
        self.assertTrue(contains(tris, (large - 0.3, 0, fin_z[1])), "large fin is missing")

    def test_no_fins_by_default(self):
        z = CAP_THICKNESS + FRAME["length"] / 2
        self.assertFalse(contains(render(), (FRAME["stem"] / 2 + 1.5, 0, z)), "fin present at Fin_Count 0")

    def test_zero_ribs_gives_a_plain_stem(self):
        tris = render(Rib_Count=0)
        for z in (CAP_THICKNESS + 2, CAP_THICKNESS + FRAME["length"] / 2, CAP_THICKNESS + FRAME["length"] - 3):
            with self.subTest(z=z):
                self.assertTrue(contains(tris, (FRAME["stem"] / 2 - 0.1, 0, z)), "stem is narrower than Stem_Diameter")
                self.assertFalse(contains(tris, (FRAME["stem"] / 2 + 0.05, 0, z)), "stem is wider than Stem_Diameter")


if __name__ == "__main__":
    unittest.main()
