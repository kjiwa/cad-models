"""Tests for scripts/build_presets.py."""

import json
import os
import stat
import subprocess
import sys
import tempfile
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SCRIPT = os.path.join(REPO_ROOT, "scripts", "build_presets.py")

FAKE_OPENSCAD = """#!/bin/sh
# Fake OpenSCAD stand-in: just create the requested output file.
out=""
prev=""
for arg in "$@"; do
    if [ "$prev" = "-o" ]; then
        out="$arg"
    fi
    prev="$arg"
done
if [ -n "$out" ]; then
    : > "$out"
fi
"""


class BuildPresetsTestCase(unittest.TestCase):
    def setUp(self):
        self.tmpdir = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmpdir.cleanup)

        self.fake_openscad = os.path.join(self.tmpdir.name, "openscad")
        with open(self.fake_openscad, "w", encoding="utf-8") as f:
            f.write(FAKE_OPENSCAD)
        os.chmod(
            self.fake_openscad,
            os.stat(self.fake_openscad).st_mode | stat.S_IEXEC | stat.S_IXGRP | stat.S_IXOTH,
        )

        self.scad_path = os.path.join(self.tmpdir.name, "model.scad")
        with open(self.scad_path, "w", encoding="utf-8") as f:
            f.write("// empty model\n")

    def _run(self, json_path, build_dir):
        return subprocess.run(
            [
                sys.executable,
                SCRIPT,
                "--model",
                "model",
                "--scad",
                self.scad_path,
                "--json",
                json_path,
                "--build-dir",
                build_dir,
                "--openscad",
                self.fake_openscad,
                "--target",
                "stl",
            ],
            capture_output=True,
            text=True,
        )

    def _write_json(self, data):
        json_path = os.path.join(self.tmpdir.name, "model.json")
        with open(json_path, "w", encoding="utf-8") as f:
            f.write(data)
        return json_path

    def test_invalid_json_exits_nonzero(self):
        json_path = self._write_json("{not valid json")
        build_dir = os.path.join(self.tmpdir.name, "build")

        result = self._run(json_path, build_dir)

        self.assertNotEqual(result.returncode, 0)

    def test_slug_collision_exits_nonzero(self):
        json_path = self._write_json(
            json.dumps(
                {
                    "parameterSets": {
                        "A B": {},
                        "A-B": {},
                    }
                }
            )
        )
        build_dir = os.path.join(self.tmpdir.name, "build")

        result = self._run(json_path, build_dir)

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("collide", result.stderr)

    def test_distinct_presets_build_successfully(self):
        json_path = self._write_json(
            json.dumps(
                {
                    "parameterSets": {
                        "Small": {},
                        "Large": {},
                    }
                }
            )
        )
        build_dir = os.path.join(self.tmpdir.name, "build")

        result = self._run(json_path, build_dir)

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue(os.path.exists(os.path.join(build_dir, "model_Small.stl")))
        self.assertTrue(os.path.exists(os.path.join(build_dir, "model_Large.stl")))


if __name__ == "__main__":
    unittest.main()
