"""Preset JSON string values are plain text.

OpenSCAD's -p/-P (local 2026.09 and apt 2021.01 alike) wraps a string parameter's value itself, so an
embedded quote ("\\"center\\"") arrives with the quotes in it and never matches the enum key; on current
OpenSCAD an enum value like that is dropped and the default is used. Quoting is for -D only.
"""

import glob
import json
import os
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
PRESET_FILES = sorted([p for p in glob.glob(os.path.join(REPO_ROOT, "*", "*.json")) if os.path.basename(os.path.dirname(p)) != "dist"])


class PresetQuotingTestCase(unittest.TestCase):
    def test_string_values_have_no_embedded_quotes(self):
        self.assertTrue(PRESET_FILES, "no preset files found")
        bad = []
        for path in PRESET_FILES:
            with open(path, encoding="utf-8") as f:
                data = json.load(f)
            for preset, params in data.get("parameterSets", {}).items():
                for key, value in params.items():
                    if '"' in value:
                        bad.append(f"{os.path.relpath(path, REPO_ROOT)}: {preset}.{key} = {value}")
        self.assertEqual(bad, [], "preset string values must not contain quotes:\n" + "\n".join(bad))


if __name__ == "__main__":
    unittest.main()
