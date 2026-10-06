"""Class test for stabilizing pin rows across every model that places them.

Each pattern names a set of rows below the retention hooks, 1..L where L is the lowest row whose
pin fits the plate. A probe on every pin axis, mid-shank behind the plate, must be solid for the
expected rows and empty for every other row. A geometry fingerprint cannot see a pin changing rows;
this does.

Requires the `openscad` binary; skips when it isn't on PATH.
"""

import math
import os
import re
import shutil
import subprocess
import sys
import tempfile
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import detect_backend_flag, read_stl_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

LIB_PATH = os.path.join(REPO_ROOT, "lib")
FAST = {"$fn": "32"}
SHANK_MID_MM = 2.5
PATTERNS = ("all", "top_and_bottom", "top", "bottom", "none")

_ECHO = re.compile(r'ECHO: "PROBE (\w+)=([^"]*)"')
_cache = {}


def scad_string(value):
    return f'"{value}"'


def expected_rows(pattern, lowest, skip=()):
    rows = {
        "all": range(1, lowest + 1),
        "top_and_bottom": (1, lowest),
        "top": (1,),
        "bottom": (lowest,),
        "none": (),
    }[pattern]
    return sorted(set(rows) - set(skip))


def render(scad_path, echo_names, params):
    """Render scad_path with params; return (triangles, echoed values, process output)."""
    key = (scad_path, tuple(sorted(params.items())))
    if key not in _cache:
        echoes = "".join(f'echo(str("PROBE {n}=", {n}));\n' for n in echo_names)
        with tempfile.TemporaryDirectory() as tmp:
            wrapper = os.path.join(tmp, "wrapper.scad")
            with open(wrapper, "w", encoding="utf-8") as f:
                f.write(f"include <{scad_path}>\n{echoes}")
            out = os.path.join(tmp, "out.stl")
            cmd = ["openscad", "--render"] + detect_backend_flag()
            for k, v in {**FAST, **params}.items():
                cmd += ["-D", f"{k}={v}"]
            cmd += ["-o", out, wrapper]
            result = subprocess.run(cmd, env=dict(os.environ, OPENSCADPATH=LIB_PATH), capture_output=True, text=True)
            output = result.stdout + result.stderr
            tris = read_stl_triangles(out) if result.returncode == 0 else []
        values = {name: float(v) for name, v in _ECHO.findall(output)}
        _cache[key] = (tris, values, output)
    return _cache[key]


class Probe:
    """Pin probe points for one rendered model: columns as (x, is_center) and z per row."""

    def __init__(self, columns, row_z, y, lowest):
        self.columns = columns
        self.row_z = row_z
        self.y = y
        self.lowest = lowest


def lowest_row(z_top_peg, pin_d, hole_spacing):
    return max(math.floor((z_top_peg - pin_d / 2 - 2.0) / hole_spacing), 1)


def ryobi_probe(v):
    slots, per_slot = int(v["Battery_Count"]), int(v["Slot_Spacing_Holes"])
    max_x = v["total_width"] / 2 - v["Pin_Diameter"] / 2 - 2.0
    columns = []
    for i in range(slots):
        x_c = (i - (slots - 1) / 2) * v["slot_spacing"]
        for k in range(per_slot):
            offset = k - (per_slot - 1) / 2
            x = x_c + offset * v["Hole_Spacing"]
            if abs(x) <= max_x:
                columns.append((x, offset == 0))
    lowest = lowest_row(v["z_top_peg"], v["Pin_Diameter"], v["Hole_Spacing"])
    return Probe(columns, lambda k: v["z_top_peg"] - k * v["Hole_Spacing"], -SHANK_MID_MM, lowest)


def razor_probe(v):
    count, per_slot = int(v["actual_dispenser_count"]), int(v["Slot_Spacing_Holes"])
    max_x = v["total_width"] / 2 - v["Pin_Diameter"] / 2 - 1.0
    columns = []
    for i in range(count):
        x_c = ((count - 1) / 2 - i) * v["slot_spacing"]
        for k in range(per_slot):
            x = x_c + (k - (per_slot - 1) / 2) * v["Hole_Spacing"]
            if abs(x) <= max_x:
                columns.append((x, False))
    lowest = lowest_row(v["z_top_peg"], v["Pin_Diameter"], v["Hole_Spacing"])
    return Probe(columns, lambda k: v["z_top_peg"] - k * v["Hole_Spacing"], -SHANK_MID_MM, lowest)


def holder_probe(v):
    cols, spacing = int(v["holeColumns"]), v["Hole_Spacing"]
    lowest = max(math.floor((v["backerHeight"] - 10) / spacing), 1)
    z_top = lowest * spacing / 2
    columns = [(-(c - (cols - 1) / 2) * spacing, False) for c in range(cols)]
    # The model is rotated 180 degrees about Z, so pins sit at +Y.
    return Probe(columns, lambda k: z_top - k * spacing, v["Backplate_Thickness"] + SHANK_MID_MM, lowest)


class Model:
    def __init__(self, scad, params, echo_names, probe):
        self.scad = os.path.join(REPO_ROOT, scad)
        self.params = params
        self.echo_names = echo_names
        self.probe = probe

    def render(self, pattern, **extra):
        params = {**self.params, **extra, "Stabilizing_Pin_Pattern": scad_string(pattern)}
        return render(self.scad, self.echo_names, params)


RYOBI = Model(
    "ryobi_40v_battery_holder/ryobi_40v_battery_holder.scad",
    {"Battery_Count": "2", "Rail_Length": "110"},
    ("z_top_peg", "Pin_Diameter", "Hole_Spacing", "Slot_Spacing_Holes", "Battery_Count", "slot_spacing", "total_width"),
    ryobi_probe,
)
RAZOR = Model(
    "razor_blade_dispenser/razor_blade_dispenser.scad",
    {"Tower_Height": "150"},
    ("z_top_peg", "Pin_Diameter", "Hole_Spacing", "Slot_Spacing_Holes", "actual_dispenser_count", "slot_spacing", "total_width"),
    razor_probe,
)
HOLDER = Model(
    "peglock_holder/peglock_holder.scad",
    {"Mount_Type": scad_string("monolithic"), "Pocket_Height": "100"},
    ("holeColumns", "backerHeight", "Hole_Spacing", "Backplate_Thickness"),
    holder_probe,
)
MODELS = {"ryobi": RYOBI, "razor": RAZOR, "peglock_holder": HOLDER}


class PinRowChecks(unittest.TestCase):
    def _row_problems(self, tris, probe, rows_by_center):
        problems = []
        for x, is_center in probe.columns:
            wanted = rows_by_center(is_center)
            for k in range(1, probe.lowest + 1):
                solid = contains(tris, (x, probe.y, probe.row_z(k)))
                if solid != (k in wanted):
                    problems.append(f"x={x:.1f} row {k}: {'solid' if solid else 'empty'}, wanted {'solid' if k in wanted else 'empty'}")
        return problems

    def _check_pattern(self, model, pattern, skip_center=(), **extra):
        tris, values, output = model.render(pattern, **extra)
        self.assertTrue(tris, f"render failed:\n{output}")
        probe = model.probe(values)
        self.assertTrue(probe.columns, "no pin columns found")
        problems = self._row_problems(
            tris,
            probe,
            lambda is_center: expected_rows(pattern, probe.lowest, skip_center if is_center else ()),
        )
        self.assertEqual(problems, [], f"{pattern} (lowest row {probe.lowest})")

    def _check_unknown_pattern(self, model):
        _, _, output = model.render("bogus")
        self.assertIn("ERROR", output)
        self.assertIn("bogus", output)


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class PinRowsTestCase(PinRowChecks):
    pass


def _pattern_test(name, pattern):
    def test(self):
        self._check_pattern(MODELS[name], pattern)
    return test


def _unknown_test(name):
    def test(self):
        self._check_unknown_pattern(MODELS[name])
    return test


for _name in MODELS:
    for _pattern in PATTERNS:
        setattr(PinRowsTestCase, f"test_{_name}_{_pattern}", _pattern_test(_name, _pattern))
    setattr(PinRowsTestCase, f"test_{_name}_unknown_pattern", _unknown_test(_name))


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class RyobiCenterColumnTestCase(PinRowChecks):
    """An odd Slot_Spacing_Holes puts a column on the slot centre, where row 1 is the screw hole."""

    def test_center_column_skips_row_one_with_screw_holes(self):
        self._check_pattern(RYOBI, "all", skip_center=(1,), Slot_Spacing_Holes="3", Include_Screw_Holes="true")


if __name__ == "__main__":
    unittest.main()
