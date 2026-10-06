"""Every parameter documented as "(0 to disable)" or "(0 = auto)" renders cleanly at 0.

Renders each model's defaults with the one parameter set to 0 and requires a zero exit, no
OpenSCAD WARNING or ERROR, and a single shell. `$fn` is lowered to keep the sweep fast.
"""

import glob
import os
import shutil
import subprocess
import sys
import tempfile
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

import customizer  # noqa: E402
from geometry_fingerprint import detect_backend_flag, read_stl_triangles  # noqa: E402
from mesh_probe import shell_count  # noqa: E402

ZERO_WORDING = ("(0 to disable)", "(0 = auto)")
FAST = {"$fn": "32"}


def _model_sources():
    paths = sorted(glob.glob(os.path.join(REPO_ROOT, "*", "*.scad")))
    return [p for p in paths if os.path.basename(os.path.dirname(p)) not in ("dist", "lib")]


def _zero_params():
    """(path, name) for every parameter whose description promises 0 is meaningful."""
    return [
        (path, p.name)
        for path in _model_sources()
        for group in customizer.parse(path)
        for p in group.params
        if any(w in p.description for w in ZERO_WORDING)
    ]


def _render_zero(path, name):
    """Return (returncode, stderr, triangles) for the model with `name` = 0."""
    env = dict(os.environ, OPENSCADPATH=os.path.join(REPO_ROOT, "lib"))
    with tempfile.TemporaryDirectory() as tmp:
        out = os.path.join(tmp, "out.stl")
        cmd = ["openscad", "--render"] + detect_backend_flag("openscad")
        for k, v in {**FAST, name: "0"}.items():
            cmd += ["-D", f"{k}={v}"]
        cmd += ["-o", out, path]
        result = subprocess.run(cmd, env=env, capture_output=True, text=True)
        tris = read_stl_triangles(out) if result.returncode == 0 and os.path.exists(out) else []
        return result.returncode, result.stderr, tris


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class ZeroDisableTestCase(unittest.TestCase):
    def test_zero_renders_one_clean_shell(self):
        pairs = _zero_params()
        self.assertTrue(pairs, "no zero-wording parameters found")
        for path, name in pairs:
            model = os.path.basename(os.path.dirname(path))
            with self.subTest(model=model, param=name):
                code, stderr, tris = _render_zero(path, name)
                self.assertEqual(code, 0, f"{model} {name} = 0 exits {code}:\n{stderr}")
                noisy = [l for l in stderr.splitlines() if l.startswith(("WARNING", "ERROR"))]
                self.assertFalse(noisy, f"{model} {name} = 0 logs:\n" + "\n".join(noisy))
                self.assertEqual(shell_count(tris), 1, f"{model} {name} = 0 does not render as one shell")


if __name__ == "__main__":
    unittest.main()
