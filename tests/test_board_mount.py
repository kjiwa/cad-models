"""Property tests for the shared board mount column rule (lib/pegboard/mount.scad).

Auto columns are the most holes whose Peglock base fits within the body, so the plate never shows
beyond it. An explicit Hole_Columns overrides the rule.
"""

import os
import shutil
import subprocess
import sys
import tempfile
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402

LIB_PATH = os.path.join(REPO_ROOT, "lib")
FAST = {"$fn": "32"}

# Each config has a body width where the old rule floor(body / 22) made the plate wider than the body.
# (model, params, body width, old plate width)
OVERSHOOT_CASES = (
    ("peglock_holder", {"Columns": "3"}, 44.45, 47.4),
    ("peglock_hook", {"Arm_Width": "45"}, 45.0, 47.4),
    ("peglock_magnet_mount", {"Columns": "3"}, 44.0, 47.4),
    ("peglock_bit_holder", {"Columns": "7"}, 7 * (2 * 6.75 / 3**0.5 + 2 * 2.68), 98.2),
)

CLASS_CHECK = """
include <pegboard/mount.scad>
for (spacing = [25.4, 15.875])
  for (w = [22 : 0.25 : 400]) {
    n = board_hole_columns("peglock", 0, w, spacing, 5.7);
    assert(peglock_base_width(n, SOCKET_WIDTH, spacing) <= w, str("base for ", n, " columns exceeds width ", w, " at spacing ", spacing));
    assert(peglock_base_width(n + 1, SOCKET_WIDTH, spacing) > w, str("column ", n + 1, " also fits width ", w, " at spacing ", spacing));
  }
assert(board_hole_columns("peglock", 4, 100, 25.4, 5.7) == 4, "explicit request must win");
"""

MONOLITHIC_CHECK = """
include <pegboard/mount.scad>
pin_d = 5.7;
for (spacing = [25.4, 15.875])
  for (w = [10 : 0.25 : 400]) {
    old_plate = max(w, spacing);
    old_cols = max(floor((old_plate - pin_d) / spacing) + 1, 1);
    n = board_hole_columns("monolithic", 0, w, spacing, pin_d);
    assert(n == old_cols, str("monolithic auto columns ", n, " != ", old_cols, " at width ", w, " spacing ", spacing));
    assert(board_mount_size("monolithic", [w, 10], n, spacing, pin_d)[0] == old_plate, str("monolithic plate width changed at width ", w, " spacing ", spacing));
    for (req = [1 : 10])
      assert(board_mount_size("monolithic", [w, 10], req, spacing, pin_d)[0] >= (req - 1) * spacing + pin_d, str("plate misses ", req, " pegs at width ", w, " spacing ", spacing));
  }
"""

VALIDATION_CASES = (("1.5", "Hole_Columns must be an integer"), ("11", "Hole_Columns must be at most 10"))


def model_scad(model):
    return os.path.join(REPO_ROOT, model, f"{model}.scad")


def plate_width(model, params):
    tris = render_triangles(model_scad(model), {**FAST, **params}, openscadpath=LIB_PATH)
    return fingerprint(tris)["bbox_size_mm"][0]


def run_echo(source):
    """Evaluate source with echo export, which exits 0 on a failed assert; asserts surface as ERROR text."""
    with tempfile.TemporaryDirectory() as tmp:
        scad = os.path.join(tmp, "check.scad")
        with open(scad, "w", encoding="utf-8") as f:
            f.write(source)
        out = os.path.join(tmp, "check.echo")
        env = dict(os.environ, OPENSCADPATH=LIB_PATH)
        result = subprocess.run(["openscad", "-o", out, scad], env=env, capture_output=True, text=True)
        with open(out, encoding="utf-8") as f:
            return result.stdout + result.stderr + f.read()


def render_output(model, hole_columns):
    """Render a model with Hole_Columns set and return stderr, where a failed assert surfaces."""
    with tempfile.TemporaryDirectory() as tmp:
        env = dict(os.environ, OPENSCADPATH=LIB_PATH)
        cmd = ["openscad", "-o", os.path.join(tmp, "out.stl"), "-D", f"Hole_Columns={hole_columns}", "-D", "$fn=8", model_scad(model)]
        result = subprocess.run(cmd, env=env, capture_output=True, text=True)
        return result.stdout + result.stderr


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class BoardMountTestCase(unittest.TestCase):
    def test_auto_columns_fit_within_width(self):
        output = run_echo(CLASS_CHECK)
        self.assertNotIn("ERROR", output)

    def test_class_check_detects_a_violation(self):
        self.assertIn("ERROR: Assertion", run_echo(CLASS_CHECK.replace("<= w", "< 0")))

    def test_monolithic_keeps_its_own_fit_rule(self):
        self.assertNotIn("ERROR", run_echo(MONOLITHIC_CHECK))

    def test_hole_columns_validation(self):
        for model in ("peglock_holder", "peglock_hook", "peglock_magnet_mount", "peglock_bit_holder"):
            for value, message in VALIDATION_CASES:
                with self.subTest(model=model, value=value):
                    output = render_output(model, value)
                    self.assertIn(message, output)

    def test_plate_never_exceeds_body(self):
        for model, params, body, old_plate in OVERSHOOT_CASES:
            with self.subTest(model=model):
                self.assertAlmostEqual(plate_width(model, params), body, delta=0.05)

    def test_explicit_columns_override_auto(self):
        for model, params, body, old_plate in OVERSHOOT_CASES:
            if body >= 47.4:
                continue
            with self.subTest(model=model):
                self.assertAlmostEqual(plate_width(model, {**params, "Hole_Columns": "2"}), 47.4, delta=0.05)

    def test_explicit_columns_can_widen_plate_past_body(self):
        self.assertAlmostEqual(plate_width("peglock_holder", {"Columns": "3", "Hole_Columns": "3"}), 72.8, delta=0.05)


if __name__ == "__main__":
    unittest.main()
