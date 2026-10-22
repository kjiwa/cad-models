"""The wall_holder plate must join its side walls through a neck of at least half the thinner of wall and plate.

The cross-section a quarter of the way up the pockets of the whole part is rasterized from the mesh, eroded by a disc of a
quarter of that thickness less half a cell of raster slack (which removes any thinner neck), and must remain one piece.
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
from test_screw_access import FAST, scad_literal  # noqa: E402

SCAD = os.path.join(REPO_ROOT, "models", "wall_holder", "wall_holder.scad")
PRESETS_JSON = os.path.join(REPO_ROOT, "models", "wall_holder", "wall_holder.json")
DEFAULT_THICKNESS = 1.5875
CELL = 0.25
SLICE_OFFSET = 0.013


def section_height(tris):
    """A quarter up the solid in front of the plate (y < 0 in exported coordinates): inside the pockets and clear of a centred screw hole."""
    zs = [p[2] for t in tris for p in t if p[1] < -0.5]
    return min(zs) + (max(zs) - min(zs)) / 4 + SLICE_OFFSET


def slice_segments(tris, z):
    segments = []
    for tri in tris:
        pts = []
        for p, q in ((tri[0], tri[1]), (tri[1], tri[2]), (tri[2], tri[0])):
            if (p[2] - z) * (q[2] - z) < 0:
                t = (z - p[2]) / (q[2] - p[2])
                pts.append((p[0] + t * (q[0] - p[0]), p[1] + t * (q[1] - p[1])))
        if len(pts) == 2:
            segments.append(tuple(pts))
    return segments


def solid_cells(segments):
    """Cells (i, j) at CELL pitch whose centre is inside the section, by even-odd scanlines along x."""
    ys = [p[1] for s in segments for p in s]
    cells = set()
    for j in range(int(min(ys) / CELL) - 1, int(max(ys) / CELL) + 2):
        y = (j + 0.5) * CELL
        crossings = sorted(
            a[0] + (y - a[1]) / (b[1] - a[1]) * (b[0] - a[0])
            for a, b in segments
            if (a[1] - y) * (b[1] - y) < 0
        )
        for x0, x1 in zip(crossings[0::2], crossings[1::2]):
            cells.update((i, j) for i in range(math.ceil(x0 / CELL - 0.5), math.ceil(x1 / CELL - 0.5)))
    return cells


def erode(cells, radius):
    reach = int(radius / CELL)
    offsets = [(di, dj) for di in range(-reach, reach + 1) for dj in range(-reach, reach + 1) if (di * di + dj * dj) * CELL * CELL <= radius * radius]
    return {(i, j) for i, j in cells if all((i + di, j + dj) in cells for di, dj in offsets)}


def component_count(cells):
    remaining = set(cells)
    count = 0
    while remaining:
        count += 1
        stack = [remaining.pop()]
        while stack:
            i, j = stack.pop()
            for n in ((i + 1, j), (i - 1, j), (i, j + 1), (i, j - 1)):
                if n in remaining:
                    remaining.remove(n)
                    stack.append(n)
    return count


def configurations():
    yield "default", {}
    with open(PRESETS_JSON) as f:
        for name, params in json.load(f)["parameterSets"].items():
            yield name, params


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class HolderJointTestCase(unittest.TestCase):
    def test_plate_joins_walls_through_a_solid_neck(self):
        for name, params in configurations():
            with self.subTest(preset=name):
                literals = {k: scad_literal(k, v) for k, v in params.items()}
                tris = render_triangles(SCAD, {**FAST, **literals}, openscadpath=os.path.join(REPO_ROOT, "lib"))
                thickness = min(float(params.get("Wall_Thickness", DEFAULT_THICKNESS)), float(params.get("Backplate_Thickness", DEFAULT_THICKNESS)))
                cells = solid_cells(slice_segments(tris, section_height(tris)))
                self.assertGreater(len(cells), 0)
                pieces = component_count(erode(cells, thickness / 4 - CELL / 2))
                self.assertEqual(pieces, 1, f"section splits into {pieces} pieces: plate and walls lack a neck of {thickness / 2:.2f} mm")


if __name__ == "__main__":
    unittest.main()
