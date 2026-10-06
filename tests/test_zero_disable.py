"""Every parameter documented as "(0 to disable)" or "(0 = auto)" renders cleanly at 0.

Renders each model's defaults with the one parameter set to 0 and requires a zero exit and
no OpenSCAD WARNING or ERROR, and a single shell. A parameter whose default is already 0 is
held to the model's own default render instead, since some OpenSCAD backends flag defaults the
model cannot fix. `$fn` is lowered to keep the sweep fast.
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
    """(path, name, default) for every parameter whose description promises 0 is meaningful."""
    return [
        (path, p.name, p.default)
        for path in _model_sources()
        for group in customizer.parse(path)
        for p in group.params
        if any(w in p.description for w in ZERO_WORDING)
    ]


def _render(path, overrides):
    """Return (returncode, stderr, triangles) for the model with `overrides` applied."""
    env = dict(os.environ, OPENSCADPATH=os.path.join(REPO_ROOT, "lib"))
    with tempfile.TemporaryDirectory() as tmp:
        out = os.path.join(tmp, "out.stl")
        cmd = ["openscad", "--render"] + detect_backend_flag("openscad")
        for k, v in {**FAST, **overrides}.items():
            cmd += ["-D", f"{k}={v}"]
        cmd += ["-o", out, path]
        result = subprocess.run(cmd, env=env, capture_output=True, text=True)
        tris = read_stl_triangles(out) if result.returncode == 0 and os.path.exists(out) else []
        return result.returncode, result.stderr, tris


def _noise(stderr):
    return {l for l in stderr.splitlines() if l.startswith(("WARNING", "ERROR", "EXPORT-WARNING"))}


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class ZeroDisableTestCase(unittest.TestCase):
    def test_zero_renders_one_clean_shell(self):
        pairs = _zero_params()
        self.assertTrue(pairs, "no zero-wording parameters found")
        baselines = {}
        for path, name, default in pairs:
            model = os.path.basename(os.path.dirname(path))
            if path not in baselines:
                _, base_err, base_tris = _render(path, {})
                baselines[path] = (_noise(base_err), shell_count(base_tris))
            base_noise, base_shells = baselines[path] if default.strip() == "0" else (set(), 1)
            with self.subTest(model=model, param=name):
                code, stderr, tris = _render(path, {name: "0"})
                self.assertEqual(code, 0, f"{model} {name} = 0 exits {code}:\n{stderr}")
                new_noise = _noise(stderr) - base_noise
                self.assertFalse(new_noise, f"{model} {name} = 0 logs:\n" + "\n".join(sorted(new_noise)))
                self.assertEqual(shell_count(tris), base_shells, f"{model} {name} = 0 shell count")

if __name__ == "__main__":
    unittest.main()
