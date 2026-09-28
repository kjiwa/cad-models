"""Golden-file geometry regression tests for models sharing lib/pegboard.

Renders a small, representative parameter matrix for ryobi_40v_battery_holder and
razor_blade_dispenser and compares each against a checked-in fingerprint (triangle
count, volume, bbox). Exists because commit e55c1f6 silently changed span_2 lower-pin
placement while extracting lib/pegboard/pegs.scad, and the STL-diff check relied on at
the time only covered each model's default configuration.

Requires the `openscad` binary; skips (not fails) when it isn't on PATH, so this file
must run after OpenSCAD is installed in CI, not before.

Fixture values are generated against the OpenSCAD version CI installs (apt on Ubuntu
noble, currently 2021.01, no Manifold backend -- CGAL only). A local OpenSCAD build new
enough to support `--backend=Manifold` triangulates differently and will show spurious
triangle-count/section-area diffs even on unchanged geometry; volume still agrees to
within a fraction of a percent across backends. Regenerate fixtures inside a matching
container (`docker run -v $(pwd):/repo ubuntu:noble ...`, install openscad via apt) when
intentionally updating them, not with a newer local OpenSCAD.
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

# Volume/bbox/section-area come from a floating-point boolean render; allow a tight
# relative tolerance for solver/version drift while still catching real geometry
# changes (the span_2 regression this test guards against moved a pin by several mm,
# changing volume and section areas by well over 1%).
VOLUME_REL_TOL = 0.005
BBOX_ABS_TOL_MM = 0.05
SECTION_AREA_REL_TOL = 0.03

# Triangle count is NOT a reliable cross-environment signal: two different Ubuntu
# noble CGAL/OpenSCAD apt package snapshots (a local `docker run ubuntu:noble` pull
# vs. GitHub's actual ubuntu-latest runner image) triangulated the same geometry with
# a consistent ~3-5% difference (e.g. 9426 vs 9762 triangles for the same part), even
# though volume/bbox/section-area all agreed to within a fraction of a percent between
# them. Kept only as a coarse sanity bound (catches a doubled or missing mesh, not a
# precise regression) -- volume/bbox/section-area are the real signal.
TRIANGLE_REL_TOL = 0.25


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
        problems = []

        if abs(actual["triangles"] - expect["triangles"]) > max(expect["triangles"] * TRIANGLE_REL_TOL, 10):
            problems.append(f"triangle count changed ({expect['triangles']} -> {actual['triangles']})")

        if abs(actual["volume_mm3"] - expect["volume_mm3"]) > max(expect["volume_mm3"] * VOLUME_REL_TOL, 1.0):
            problems.append(f"volume changed ({expect['volume_mm3']} -> {actual['volume_mm3']} mm3)")

        for i, axis in enumerate("xyz"):
            if abs(actual["bbox_size_mm"][i] - expect["bbox_size_mm"][i]) > BBOX_ABS_TOL_MM:
                problems.append(
                    f"bbox {axis} size changed "
                    f"({expect['bbox_size_mm'][i]} -> {actual['bbox_size_mm'][i]} mm)"
                )

        for i, (a, e) in enumerate(zip(actual["section_areas_mm2"], expect["section_areas_mm2"])):
            if abs(a - e) > max(e * SECTION_AREA_REL_TOL, 1.0):
                problems.append(
                    f"cross-section area at sample point {i} changed ({e} -> {a} mm2) "
                    "-- a feature likely moved to a different height without changing total volume/bbox"
                )

        if problems:
            self.fail(f"{name}: " + "; ".join(problems))


def _make_test(name):
    def test(self):
        self._check_case(name)
    return test


with open(FIXTURES_PATH, encoding="utf-8") as _f:
    for _name in json.load(_f):
        setattr(GeometryRegressionTestCase, f"test_{_name}", _make_test(_name))


if __name__ == "__main__":
    unittest.main()
