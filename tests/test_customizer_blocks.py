"""The [Pegboard] Customizer block must read identically in every model that declares it.

Customizer lists only variables declared in the main file, not those from included
files (verified with `openscad --export-format param`), so the block cannot be shared
by `include` and is copied into each model. This test keeps the copies from drifting.
"""

import glob
import os
import re
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

SHARED_NAMES = (
    "Mount_Type",
    "Hole_Columns",
    "Hole_Spacing",
    "Pin_Diameter",
    "Pegboard_Thickness",
    "Retention_Hook_Rise",
)

# (model, name) pairs whose default value is meant to differ from the other models.
INTENTIONAL_VALUE_DIFFERENCES = {
    ("peglock_attachment", "Retention_Hook_Rise"): "attachment hook tab is taller (6.0) than the 3.5 of the pegboard holders",
}

DECLARATION = re.compile(r"^(?P<name>\w+) = (?P<value>[^;]+);(?P<tail>.*)$")


def _model_sources():
    paths = sorted(glob.glob(os.path.join(REPO_ROOT, "*", "*.scad")))
    return [p for p in paths if os.path.basename(os.path.dirname(p)) not in ("dist", "lib")]


def _declarations(path):
    """Map each shared name to (comment line, value, text after the semicolon)."""
    with open(path, encoding="utf-8") as f:
        lines = f.read().splitlines()
    found = {}
    for i, line in enumerate(lines):
        m = DECLARATION.match(line)
        if m and m["name"] in SHARED_NAMES and m["name"] not in found:
            comment = lines[i - 1].strip() if i > 0 else ""
            found[m["name"]] = (comment, m["value"], m["tail"])
    return found


class PegboardBlockTestCase(unittest.TestCase):
    def test_shared_declarations_are_identical(self):
        by_name = {name: {} for name in SHARED_NAMES}
        for path in _model_sources():
            model = os.path.basename(os.path.dirname(path))
            for name, decl in _declarations(path).items():
                by_name[name][model] = decl

        problems = []
        for name, models in by_name.items():
            self.assertTrue(models, f"{name} declared in no model")
            reference_model, (ref_comment, ref_value, ref_tail) = next(
                (m, d) for m, d in models.items() if (m, name) not in INTENTIONAL_VALUE_DIFFERENCES
            )
            for model, (comment, value, tail) in models.items():
                if comment != ref_comment:
                    problems.append(f"{name}: comment in {model} differs from {reference_model}")
                if tail != ref_tail:
                    problems.append(f"{name}: trailing text in {model} differs from {reference_model}")
                if (model, name) not in INTENTIONAL_VALUE_DIFFERENCES and value != ref_value:
                    problems.append(f"{name}: default in {model} ({value}) differs from {reference_model} ({ref_value})")
        self.assertFalse(problems, "\n".join(problems))

    def test_models_found(self):
        models = {os.path.basename(os.path.dirname(p)) for p in _model_sources()}
        self.assertTrue({"peglock_holder", "peglock_hook", "peglock_magnet_mount", "peglock_attachment"} <= models)


if __name__ == "__main__":
    unittest.main()
