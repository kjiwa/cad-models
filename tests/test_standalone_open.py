"""Every model main file must open with no warning when only its own directory resolves includes.

OPENSCADPATH holds only lib/ and HOME is empty, so no user library can mask a bad include.
Exports CSG, which evaluates includes without rendering geometry and covers every model in seconds.
"""

import glob
import os
import shutil
import subprocess
import tempfile
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
EXCLUDED_DIRS = {"dist", "lib"}


def _model_files():
    for path in sorted(glob.glob(os.path.join(REPO_ROOT, "models", "*", "*.scad"))):
        directory = os.path.basename(os.path.dirname(path))
        if directory not in EXCLUDED_DIRS and os.path.basename(path) == f"{directory}.scad":
            yield directory, path


def _open_model(scad_path, home):
    env = dict(os.environ, HOME=home, OPENSCADPATH=os.path.join(REPO_ROOT, "lib"))
    out = os.path.join(home, "out.csg")
    res = subprocess.run(
        ["openscad", "-o", out, scad_path],
        env=env,
        capture_output=True,
        text=True,
        check=True,
    )
    return res.stdout + res.stderr


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class StandaloneOpenTestCase(unittest.TestCase):
    def test_models_open_without_warnings(self):
        for directory, path in _model_files():
            with self.subTest(model=directory), tempfile.TemporaryDirectory() as home:
                lines = _open_model(path, home).splitlines()
                problems = [ln for ln in lines if "WARNING" in ln or "ERROR" in ln]
                self.assertEqual(problems, [])


if __name__ == "__main__":
    unittest.main()
