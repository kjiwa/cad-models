"""Tests for lib/peglock stickout scaling and geometry."""

import os
import shutil
import subprocess
import sys
import tempfile
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import read_stl_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402


def _eval_scad_expr(expr):
    code = f"""
    include <peglock/peglock.scad>
    echo("EVAL=", {expr});
    """
    res = subprocess.run(
        ["openscad", "-o", "-", "--export-format", "echo", "-"],
        input=code,
        env=dict(os.environ, OPENSCADPATH=os.path.join(REPO_ROOT, "lib")),
        capture_output=True,
        text=True,
        check=True,
    )
    for line in (res.stdout + res.stderr).splitlines():
        if "EVAL=" in line:
            raw = line.split("EVAL=")[1].strip().strip('"').strip()
            if raw.startswith(","):
                raw = raw[1:].strip()
            return float(raw)
    raise ValueError(f"Could not find EVAL= in output:\n{res.stdout}\n{res.stderr}")


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class PeglockScalingTestCase(unittest.TestCase):
    def test_stickout_scaling_values(self):
        # Standard 1/4" board (>= 6.0mm) keeps reference dimensions
        self.assertAlmostEqual(_eval_scad_expr("scaled_lower_stickout(6.35)"), 8.0, places=4)
        self.assertAlmostEqual(_eval_scad_expr("scaled_upper_stickout(6.35)"), 4.6, places=4)

        # 1/16" thin metal preset (1.5875mm)
        self.assertAlmostEqual(_eval_scad_expr("scaled_lower_stickout(1.5875)"), 3.2375, places=4)
        self.assertAlmostEqual(_eval_scad_expr("scaled_upper_stickout(1.5875)"), 2.3875, places=4)

        # 3/64" board (1.19mm) scales below previous 2.0 / 3.0 clamp
        self.assertAlmostEqual(_eval_scad_expr("scaled_lower_stickout(1.19)"), 2.84, places=4)
        self.assertAlmostEqual(_eval_scad_expr("scaled_upper_stickout(1.19)"), 1.99, places=4)

        # 1/32" board (0.79mm) scales below previous 2.0 / 3.0 clamp
        self.assertAlmostEqual(_eval_scad_expr("scaled_lower_stickout(0.79)"), 2.44, places=4)
        self.assertAlmostEqual(_eval_scad_expr("scaled_upper_stickout(0.79)"), 1.59, places=4)

    def test_thin_board_stickouts_strictly_monotonic(self):
        t_thin = 0.79
        t_mid = 1.19
        t_thick = 1.5875

        up_thin = _eval_scad_expr(f"scaled_upper_stickout({t_thin})")
        up_mid = _eval_scad_expr(f"scaled_upper_stickout({t_mid})")
        up_thick = _eval_scad_expr(f"scaled_upper_stickout({t_thick})")
        self.assertLess(up_thin, up_mid)
        self.assertLess(up_mid, up_thick)

        low_thin = _eval_scad_expr(f"scaled_lower_stickout({t_thin})")
        low_mid = _eval_scad_expr(f"scaled_lower_stickout({t_mid})")
        low_thick = _eval_scad_expr(f"scaled_lower_stickout({t_thick})")
        self.assertLess(low_thin, low_mid)
        self.assertLess(low_mid, low_thick)

    def test_thin_metal_renders_distinct_geometry(self):
        from geometry_fingerprint import fingerprint

        scad_path = os.path.join(REPO_ROOT, "peglock_attachment", "peglock_attachment.scad")
        with tempfile.TemporaryDirectory() as tmpdir:
            stl_079 = os.path.join(tmpdir, "out_079.stl")
            stl_119 = os.path.join(tmpdir, "out_119.stl")

            subprocess.run(
                ["openscad", "-o", stl_079, "-D", "Pegboard_Thickness=0.79", scad_path],
                check=True,
                capture_output=True,
            )
            subprocess.run(
                ["openscad", "-o", stl_119, "-D", "Pegboard_Thickness=1.19", scad_path],
                check=True,
                capture_output=True,
            )

            fp_079 = fingerprint(read_stl_triangles(stl_079))
            fp_119 = fingerprint(read_stl_triangles(stl_119))

            # Bounding box along X expands due to mirrored peg reach difference
            self.assertNotEqual(fp_079["bbox_size_mm"][0], fp_119["bbox_size_mm"][0])
            self.assertNotEqual(fp_079["volume_mm3"], fp_119["volume_mm3"])
            self.assertGreater(fp_119["volume_mm3"], fp_079["volume_mm3"])


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class PeglockBaseSocketTestCase(unittest.TestCase):
    def test_socket_follows_base_depth(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            scad_path = os.path.join(tmpdir, "base.scad")
            stl_path = os.path.join(tmpdir, "base.stl")
            with open(scad_path, "w") as f:
                f.write("include <peglock/peglock.scad>\nPeglockBase(depth = 10);\n")
            subprocess.run(
                ["openscad", "-o", stl_path, scad_path],
                env=dict(os.environ, OPENSCADPATH=os.path.join(REPO_ROOT, "lib")),
                check=True,
                capture_output=True,
            )
            tris = read_stl_triangles(stl_path)
        self.assertFalse(contains(tris, (3.5, -7.0, -15.0)), "socket is shallower than the base")


if __name__ == "__main__":
    unittest.main()
