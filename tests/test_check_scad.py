"""Tests for scripts/check_scad.py."""

import json
import os
import subprocess
import sys
import tempfile
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SCRIPT = os.path.join(REPO_ROOT, "scripts", "check_scad.py")

# Exits 0 and prints a WARNING, like OpenSCAD 2021.01 does for an unknown function.
FAKE_OPENSCAD = """#!/bin/sh
echo "WARNING: Ignoring unknown function 'object'" >&2
"""


class CheckScadTestCase(unittest.TestCase):
    def setUp(self):
        self.tmpdir = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmpdir.cleanup)
        self.fake = os.path.join(self.tmpdir.name, "openscad")
        with open(self.fake, "w", encoding="utf-8") as f:
            f.write(FAKE_OPENSCAD)
        os.chmod(self.fake, 0o755)

    def run_check(self, openscad):
        json_path = os.path.join(self.tmpdir.name, "model.json")
        with open(json_path, "w", encoding="utf-8") as f:
            json.dump({"parameterSets": {"Small": {}}}, f)
        return subprocess.run(
            [sys.executable, SCRIPT, "--model", "model", "--scad", "model.scad", "--json", json_path,
             "--build-dir", os.path.join(self.tmpdir.name, "build"), "--openscad", openscad],
            capture_output=True, text=True,
        )

    def test_warning_on_stderr_fails_despite_zero_exit(self):
        result = self.run_check(self.fake)
        self.assertEqual(result.returncode, 1)
        self.assertIn("unknown function", result.stderr)

    def test_clean_run_passes(self):
        result = self.run_check("true")
        self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
