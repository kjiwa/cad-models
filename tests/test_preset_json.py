"""Preset JSON files are well-formed: plain string values, standard names, real keys, non-default and distinct sets.

OpenSCAD's -p/-P (local 2026.09 and apt 2021.01 alike) wraps a string parameter's value itself, so an
embedded quote ("\\"center\\"") arrives with the quotes in it and never matches the enum key; on current
OpenSCAD an enum value like that is dropped and the default is used. Quoting is for -D only.
"""

import glob
import json
import os
import re
import sys
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "scripts"))

from build_presets import slugify  # noqa: E402
from customizer import parse  # noqa: E402

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
PRESET_FILES = sorted([p for p in glob.glob(os.path.join(REPO_ROOT, "*", "*.json")) if os.path.basename(os.path.dirname(p)) != "dist"])
NAME = re.compile(r"^[A-Z][A-Za-z0-9]*(_[A-Za-z0-9]+)*$")


def _load(path):
    with open(path, encoding="utf-8") as f:
        return json.load(f)["parameterSets"]


def _defaults(path):
    scad = os.path.join(os.path.dirname(path), os.path.basename(os.path.dirname(path)) + ".scad")
    return {p.name: p.default for g in parse(scad) for p in g.params}


def _same(value, default):
    default = default.strip('"')
    try:
        return float(value) == float(default)
    except ValueError:
        return value == default


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


class PresetContentTestCase(unittest.TestCase):
    def _each(self):
        for path in PRESET_FILES:
            yield os.path.relpath(path, REPO_ROOT), path, _load(path)

    def test_names_are_title_case_slugs(self):
        bad = [f"{rel}: {n}" for rel, _, sets in self._each() for n in sets if not NAME.match(n) or n != slugify(n)]
        self.assertEqual(bad, [])

    def test_keys_are_customizer_parameters(self):
        bad = []
        for rel, path, sets in self._each():
            known = _defaults(path)
            bad += [f"{rel}: {n}.{k}" for n, params in sets.items() for k in params if k not in known]
        self.assertEqual(bad, [])

    def test_no_preset_equals_defaults(self):
        bad = []
        for rel, path, sets in self._each():
            known = _defaults(path)
            bad += [
                f"{rel}: {n}"
                for n, params in sets.items()
                if all(k in known and _same(v, known[k]) for k, v in params.items())
            ]
        self.assertEqual(bad, [])

    def test_presets_are_distinct(self):
        bad = []
        for rel, _, sets in self._each():
            seen = {}
            for n, params in sets.items():
                key = json.dumps(params, sort_keys=True)
                if key in seen:
                    bad.append(f"{rel}: {seen[key]} == {n}")
                seen[key] = n
        self.assertEqual(bad, [])


if __name__ == "__main__":
    unittest.main()
