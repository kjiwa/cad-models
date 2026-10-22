"""Every screw hole of the wall_hook and wall_holder presets, and of the ear models, must have a clear driver-side axis.

In exported STL coordinates the plate spans y 0..thickness and the model extends toward -Y,
so the screwdriver approaches each hole from -Y.
"""

import json
import math
import os
import shutil
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

FAST = {"$fn": "32"}
ALWAYS_STRING = {"Pocket_Widths", "Pocket_Depths"}
PLATE_PROBE_Y = 0.4
SCAN_STEP = 2.0
REACH = 80.0
RAY_STEP = 0.5
DEFAULT_HEAD = 9.525
RING_MARGIN = 1.0
RING_POINTS = 12
RING_DEPTH = 10.0
DRIVER_MARGIN = 3.0
ARM_ROOT_PROBE_Y = -0.3


def scad_literal(name, value):
    if name not in ALWAYS_STRING and value in ("true", "false"):
        return value
    try:
        float(value)
        if name not in ALWAYS_STRING:
            return value
    except ValueError:
        pass
    return f'"{value}"'


def screw_presets():
    for model in ("wall_hook", "wall_holder"):
        scad = os.path.join(REPO_ROOT, "models", model, f"{model}.scad")
        with open(os.path.join(REPO_ROOT, "models", model, f"{model}.json")) as f:
            sets = json.load(f)["parameterSets"]
        for name, params in sets.items():
            if params.get("Mount_Type") == "screws":
                yield model, name, scad, params


def hole_centres(tris):
    """Centres of empty regions inside the plate mid-plane that do not reach the scan border."""
    xs = [p[0] for t in tris for p in t]
    zs = [p[2] for t in tris for p in t]
    nx = int((max(xs) - min(xs)) / SCAN_STEP) + 1
    nz = int((max(zs) - min(zs)) / SCAN_STEP) + 1
    x0, z0 = min(xs), min(zs)
    empty = {
        (i, k)
        for i in range(nx)
        for k in range(nz)
        if not contains(tris, (x0 + i * SCAN_STEP, PLATE_PROBE_Y, z0 + k * SCAN_STEP))
    }
    centres = []
    while empty:
        stack = [empty.pop()]
        cluster = list(stack)
        while stack:
            i, k = stack.pop()
            for n in ((i + 1, k), (i - 1, k), (i, k + 1), (i, k - 1)):
                if n in empty:
                    empty.remove(n)
                    stack.append(n)
                    cluster.append(n)
        on_border = any(i in (0, nx - 1) or k in (0, nz - 1) for i, k in cluster)
        if not on_border:
            centres.append((
                x0 + SCAN_STEP * sum(i for i, _ in cluster) / len(cluster),
                z0 + SCAN_STEP * sum(k for _, k in cluster) / len(cluster),
            ))
    return centres


EAR_MODELS = ("wall_bit_holder", "wall_magnet_mount")
EAR_CONFIGS = (
    ("rows_1", {"Screw_Hole_Rows": "1"}),
    ("rows_2", {"Screw_Hole_Rows": "2", "Screw_Hole_Inset": "6.35"}),
)


def blocked_y(tris, x, z):
    for n in range(1, int(REACH / RAY_STEP) + 1):
        y = -n * RAY_STEP
        if contains(tris, (x, y, z)):
            return y
    return None


def ring_blocked(tris, x, z, radius):
    for n in range(RING_POINTS):
        angle = 2 * math.pi * n / RING_POINTS
        for step in range(1, int(RING_DEPTH / RAY_STEP) + 1):
            point = (x + radius * math.cos(angle), -step * RAY_STEP, z + radius * math.sin(angle))
            if contains(tris, point):
                return point
    return None


def arm_extent(tris):
    """Lowest and highest solid z of the part in front of the plate; the root is probed just off the plate face."""
    high = max(p[2] for t in tris for p in t if p[1] < -0.01)
    z_min = min(p[2] for t in tris for p in t)
    z = z_min
    while not contains(tris, (0, ARM_ROOT_PROBE_Y, z)):
        z += 0.25
    low = z
    return low, high


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class ScrewAccessTestCase(unittest.TestCase):
    def assert_axis_clear(self, tris, x, z, head):
        reach = 0.8 * head / 2
        blocked = ring_blocked(tris, x, z, head / 2 + RING_MARGIN)
        self.assertIsNone(blocked, f"head clearance ring around x={x:.1f} z={z:.1f} blocked at {blocked}")
        for dx, dz in ((0, 0), (reach, 0), (-reach, 0), (0, reach), (0, -reach)):
            y = blocked_y(tris, x + dx, z + dz)
            self.assertIsNone(y, f"axis at x={x:.1f} z={z:.1f} (offset {dx:.1f},{dz:.1f}) blocked at y={y}")

    def test_ear_models_have_reachable_holes_in_ears(self):
        for model in EAR_MODELS:
            scad = os.path.join(REPO_ROOT, "models", model, f"{model}.scad")
            for config, params in EAR_CONFIGS:
                with self.subTest(model=model, config=config):
                    tris = render_triangles(scad, {**FAST, "Mount_Type": '"screws"', **params}, openscadpath=os.path.join(REPO_ROOT, "lib"))
                    centres = hole_centres(tris)
                    rows = int(params["Screw_Hole_Rows"])
                    self.assertGreaterEqual(len(centres), 2, f"holes found: {centres}")
                    self.assertEqual(len(centres), 2 * rows, f"holes found: {centres}")
                    head = DEFAULT_HEAD
                    content_half = max(abs(p[0]) for t in tris for p in t if p[1] < -0.01)
                    plate_half = max(abs(p[0]) for t in tris for p in t)
                    plate_bottom = min(p[2] for t in tris for p in t)
                    plate_top = max(p[2] for t in tris for p in t if p[1] > 0.01)
                    for x, z in centres:
                        self.assertGreaterEqual(abs(x) - head / 2, content_half - 0.01, f"hole at x={x:.1f} is not in an ear")
                        self.assertLessEqual(abs(x) + head / 2, plate_half + 0.01, f"head at x={x:.1f} overhangs the ear")
                        self.assertGreaterEqual(z - head / 2, plate_bottom - 0.01, f"head at z={z:.1f} overhangs the plate")
                        self.assertLessEqual(z + head / 2, plate_top + 0.01, f"head at z={z:.1f} overhangs the plate top")
                        self.assert_axis_clear(tris, x, z, head)

    def test_every_screw_axis_is_clear(self):
        found = 0
        for model, name, scad, params in screw_presets():
            with self.subTest(model=model, preset=name):
                literals = {k: scad_literal(k, v) for k, v in params.items()}
                tris = render_triangles(scad, {**FAST, **literals}, openscadpath=os.path.join(REPO_ROOT, "lib"))
                centres = hole_centres(tris)
                rows = int(params.get("Screw_Hole_Rows", 1))
                columns = int(params.get("Screw_Hole_Columns", 1))
                self.assertEqual(len(centres), rows * columns, f"holes found: {centres}")
                head = float(params.get("Screw_Head_Diameter", DEFAULT_HEAD))
                plate_bottom = min(p[2] for t in tris for p in t)
                for x, z in centres:
                    found += 1
                    self.assertGreaterEqual(z - head / 2, plate_bottom - 0.01, f"head at z={z:.1f} overhangs the plate")
                    if model == "wall_hook":
                        low, high = arm_extent(tris)
                        margin = head / 2 + DRIVER_MARGIN
                        self.assertTrue(z + margin <= low + 0.6 or z - margin >= high, f"arm {low:.2f}..{high:.2f} reaches head at z={z:.1f}")
                    self.assert_axis_clear(tris, x, z, head)
        self.assertGreater(found, 0)


if __name__ == "__main__":
    unittest.main()
