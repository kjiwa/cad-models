"""Golden-file geometry regression tests for models sharing lib/pegboard.

Renders a small, representative parameter matrix for ryobi_40v_battery_holder and
razor_blade_dispenser and compares each against a checked-in fingerprint (triangle
count, volume, bbox). Exists because commit e55c1f6 silently changed span_2 lower-pin
placement while extracting lib/pegboard/pegs.scad, and the STL-diff check relied on at
the time only covered each model's default configuration.

Requires the `openscad` binary; skips (not fails) when it isn't on PATH, so this file
must run after OpenSCAD is installed in CI, not before.
"""

import json
import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))

from geometry_fingerprint import render_fingerprint  # noqa: E402

FIXTURES_PATH = os.path.join(os.path.dirname(__file__), "fixtures", "geometry_fixtures.json")

# Volume/bbox come from a floating-point boolean render; allow a tight relative
# tolerance for solver/version drift while still catching real geometry changes
# (the span_2 regression this test guards against moved a pin by several mm,
# changing volume by well over 1%).
VOLUME_REL_TOL = 0.005
BBOX_ABS_TOL_MM = 0.05


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class GeometryRegressionTestCase(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        with open(FIXTURES_PATH, encoding="utf-8") as f:
            cls.fixtures = json.load(f)

    def _check_case(self, name):
        case = self.fixtures[name]
        actual = render_fingerprint(
            os.path.join(REPO_ROOT, case["scad"]),
            case["params"],
            openscadpath=os.path.join(REPO_ROOT, "lib"),
        )
        expect = case["expect"]

        self.assertEqual(
            actual["triangles"], expect["triangles"],
            f"{name}: triangle count changed ({expect['triangles']} -> {actual['triangles']})",
        )
        self.assertAlmostEqual(
            actual["volume_mm3"], expect["volume_mm3"],
            delta=max(expect["volume_mm3"] * VOLUME_REL_TOL, 1.0),
            msg=f"{name}: volume changed ({expect['volume_mm3']} -> {actual['volume_mm3']} mm3)",
        )
        for i, axis in enumerate("xyz"):
            self.assertAlmostEqual(
                actual["bbox_size_mm"][i], expect["bbox_size_mm"][i],
                delta=BBOX_ABS_TOL_MM,
                msg=f"{name}: bbox {axis} size changed",
            )
        for i, (a, e) in enumerate(zip(actual["section_areas_mm2"], expect["section_areas_mm2"])):
            self.assertAlmostEqual(
                a, e, delta=max(e * VOLUME_REL_TOL, 1.0),
                msg=f"{name}: cross-section area at sample point {i} changed ({e} -> {a} mm2) "
                    "-- a feature likely moved to a different height without changing total volume/bbox",
            )


def _make_test(name):
    def test(self):
        self._check_case(name)
    return test


with open(FIXTURES_PATH, encoding="utf-8") as _f:
    for _name in json.load(_f):
        setattr(GeometryRegressionTestCase, f"test_{_name}", _make_test(_name))


if __name__ == "__main__":
    unittest.main()
