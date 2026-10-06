"""Tests for entryway_table: accent grooves and the taper cut follow the leg board size."""

import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))

from geometry_fingerprint import render_fingerprint  # noqa: E402

TABLE_SCAD = os.path.join(REPO_ROOT, "entryway_table", "entryway_table.scad")
DEFAULT_VOLUME_MM3 = 21857436.2
DEFAULT_BBOX_MM = [1219.2, 279.4, 933.45]
HARDCODED_WIDE_LEG_VOLUME_MM3 = 21072284.9


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class EntrywayTableTestCase(unittest.TestCase):
    def test_default_geometry_is_unchanged(self):
        fp = render_fingerprint(TABLE_SCAD, {})
        self.assertAlmostEqual(fp["volume_mm3"], DEFAULT_VOLUME_MM3, delta=DEFAULT_VOLUME_MM3 * 0.0005)
        self.assertEqual(fp["bbox_size_mm"], DEFAULT_BBOX_MM)

    def test_groove_and_taper_follow_leg_board_width(self):
        fp = render_fingerprint(TABLE_SCAD, {"Leg_Board_Width": "76.2"})
        self.assertNotAlmostEqual(
            fp["volume_mm3"], HARDCODED_WIDE_LEG_VOLUME_MM3, delta=HARDCODED_WIDE_LEG_VOLUME_MM3 * 0.0005
        )


if __name__ == "__main__":
    unittest.main()
