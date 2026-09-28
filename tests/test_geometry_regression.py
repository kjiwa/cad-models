"""Golden-file geometry regression tests for models sharing lib/pegboard.

Renders a small, representative parameter matrix for ryobi_40v_battery_holder and
razor_blade_dispenser and compares each against a checked-in fingerprint (triangle
count as a coarse sanity bound, volume and bbox as the real signal). Exists because
commit e55c1f6 silently changed span_2 lower-pin placement while extracting
lib/pegboard/pegs.scad, and the STL-diff check relied on at the time only covered each
model's default configuration.

Known gap: a feature (e.g. a peg) relocating to a different height within an
otherwise-unchanged part conserves volume and bbox, so this test as it stands would
NOT catch a repeat of that exact regression -- see the section_areas_mm2 note in
GeometryRegressionTestCase._check_case for why that metric exists in the fingerprint
but isn't asserted yet, and what it needs before it can be.

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

# Volume/bbox come from a floating-point boolean render; allow a tight relative
# tolerance for solver/version drift while still catching real geometry changes
# (the span_2 regression this test guards against moved a pin by several mm,
# changing volume by well over 1%). Confirmed robust against real cross-environment
# drift: these two passed cleanly on GitHub's actual runner even where triangle
# count and section-area sampling (below) did not.
VOLUME_REL_TOL = 0.005
BBOX_ABS_TOL_MM = 0.05

# Triangle count is NOT a reliable cross-environment signal: two different Ubuntu
# noble CGAL/OpenSCAD apt package snapshots (a local `docker run ubuntu:noble` pull
# vs. GitHub's actual ubuntu-latest runner image) triangulated the same geometry with
# a consistent ~3-5% difference (e.g. 9426 vs 9762 triangles for the same part), even
# though volume/bbox agreed to within a fraction of a percent between them. Kept only
# as a coarse sanity bound (catches a doubled or missing mesh, not a precise
# regression) -- volume/bbox are the real signal.
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

        # section_areas_mm2 is deliberately NOT asserted here. It samples the
        # cross-sectional area at fixed *fractions* of the part's bbox height, which
        # is landmine-prone: any small cross-environment jitter in the bbox (still
        # within BBOX_ABS_TOL_MM) shifts every sample point, and a sample landing a
        # fraction of a mm from a feature edge (a peg, a hole boundary) swings that
        # slice's area by 100%+ even though nothing regressed -- confirmed against
        # GitHub's real runner, where triangle count and volume/bbox all held within
        # tolerance but several section samples did not, on unchanged geometry. It
        # would need sampling over a band and averaging (or a feature-aware, not
        # bbox-fraction-based, sample position) to be a reliable gate; until then it
        # stays in the fingerprint as diagnostic data only, not asserted.

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
