"""Property tests for sw_motech_t_lock_molle_adapter: ring and notch fit clearance, bayonet opening, and strap slots."""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

ADAPTER_SCAD = os.path.join(REPO_ROOT, "models", "sw_motech_t_lock_molle_adapter", "sw_motech_t_lock_molle_adapter.scad")
RING_R = 17
NOTCH_TIP_R = 18
NOTCH_HALF_WIDTH = 1.5
PLATE_T = 3
RING_Z = PLATE_T + 2.5
OPENING_Z = PLATE_T + 4
SLOT_X = 20
SLOT_Y = 19.5
SLOT_HALF_LENGTH = 13
SLOT_HALF_WIDTH = 2.5
FAST = {"$fn": "64"}

_cache = {}


def render(**params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(
            ADAPTER_SCAD, {**FAST, **{k: str(v) for k, v in params.items()}}, openscadpath=os.path.join(REPO_ROOT, "lib")
        )
    return _cache[key]


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class SwMotechTLockMolleAdapterTestCase(unittest.TestCase):
    def test_overall_size_is_independent_of_the_clearance_in_plate_extent(self):
        for clearance in (0, 0.3):
            size = fingerprint(render(Fit_Clearance=clearance))["bbox_size_mm"]
            for got, want in zip(size, (80, 70, 8)):
                self.assertAlmostEqual(got, want, delta=0.05)

    def test_ring_outside_shrinks_by_the_clearance_per_side(self):
        for clearance in (0, 0.3):
            tris = render(Fit_Clearance=clearance)
            r = RING_R - clearance
            for dx, dy in ((0, 1), (0, -1)):
                self.assertTrue(contains(tris, (dx * (r - 0.1), dy * (r - 0.1), RING_Z)), f"ring wall is missing at clearance {clearance}")
                self.assertFalse(contains(tris, (dx * (r + 0.1), dy * (r + 0.1), RING_Z)), f"ring is wider than 34 - 2c at clearance {clearance}")

    def test_notch_tip_retracts_by_the_clearance(self):
        for clearance in (0, 0.3):
            tris = render(Fit_Clearance=clearance)
            tip = NOTCH_TIP_R - clearance
            for side in (1, -1):
                self.assertTrue(contains(tris, (side * (tip - 0.2), 0, RING_Z)), f"notch is missing at clearance {clearance}")
                self.assertFalse(contains(tris, (side * (tip + 0.2), 0, RING_Z)), f"notch tip is past 36/2 - c at clearance {clearance}")

    def test_notch_narrows_by_the_clearance_per_side(self):
        for clearance in (0, 0.3):
            tris = render(Fit_Clearance=clearance)
            half = NOTCH_HALF_WIDTH - clearance
            self.assertTrue(contains(tris, (NOTCH_TIP_R - 0.95 - clearance, half - 0.1, RING_Z)), f"notch is narrower than 3 - 2c at clearance {clearance}")
            self.assertFalse(contains(tris, (NOTCH_TIP_R - 0.95 - clearance, half + 0.1, RING_Z)), f"notch is wider than 3 - 2c at clearance {clearance}")

    def test_bayonet_opening_ignores_the_clearance(self):
        for clearance in (0, 0.3):
            tris = render(Fit_Clearance=clearance)
            self.assertFalse(contains(tris, (0, 12.0, OPENING_Z)), "opening is shorter than the long diameter")
            self.assertTrue(contains(tris, (0, 12.9, OPENING_Z)), "opening is longer than the long diameter")
            self.assertFalse(contains(tris, (9.5, 0, OPENING_Z)), "opening is narrower than the short diameter")
            self.assertTrue(contains(tris, (10.4, 0, OPENING_Z)), "opening is wider than the short diameter")

    def test_strap_slots_sit_where_the_original_put_them(self):
        tris = render()
        z = PLATE_T / 2
        for sx in (1, -1):
            for sy in (1, -1):
                cx, cy = sx * SLOT_X, sy * SLOT_Y
                self.assertFalse(contains(tris, (cx, cy, z)), "slot centre is solid")
                self.assertFalse(contains(tris, (cx + sx * (SLOT_HALF_LENGTH - 0.5), cy, z)), "slot is shorter than 26")
                self.assertTrue(contains(tris, (cx + sx * (SLOT_HALF_LENGTH + 0.5), cy, z)), "slot is longer than 26")
                self.assertFalse(contains(tris, (cx, cy + (SLOT_HALF_WIDTH - 0.1), z)), "slot is narrower than 5")
                self.assertTrue(contains(tris, (cx, cy + (SLOT_HALF_WIDTH + 0.1), z)), "slot is wider than 5")
                self.assertTrue(contains(tris, (cx, cy - (SLOT_HALF_WIDTH + 0.1), z)), "slot is wider than 5")

    def test_strap_slot_edges_are_rounded_on_both_faces(self):
        tris = render()
        self.assertFalse(contains(tris, (SLOT_X, SLOT_Y + SLOT_HALF_WIDTH + 0.1, PLATE_T - 0.1)), "slot top edge is square")
        self.assertFalse(contains(tris, (SLOT_X, SLOT_Y + SLOT_HALF_WIDTH + 0.1, 0.1)), "slot bottom edge is square")

    def test_plate_perimeter_is_rounded_on_the_top_and_flat_on_the_bottom(self):
        tris = render()
        self.assertFalse(contains(tris, (40 - 0.05, 0, PLATE_T - 0.05)), "plate top edge is square")
        self.assertTrue(contains(tris, (40 - 0.05, 0, 0.05)), "plate bottom edge is rounded")


if __name__ == "__main__":
    unittest.main()
