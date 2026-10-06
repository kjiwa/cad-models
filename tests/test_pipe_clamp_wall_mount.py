"""Property tests for pipe_clamp_wall_mount: the socket clears the tongue so stacked blocks seat flush."""

import os
import shutil
import sys
import tempfile
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))
sys.path.insert(0, os.path.dirname(__file__))

from geometry_fingerprint import fingerprint, render_triangles  # noqa: E402
from mesh_probe import contains  # noqa: E402

CLAMP_SCAD = os.path.join(REPO_ROOT, "pipe_clamp_wall_mount", "pipe_clamp_wall_mount.scad")
FAST = {"$fn": "32"}
BOTTOM = 9.525
TOP = 6.35
HEIGHT = 4.7625
CLEARANCE = 0.2
WIDTH = 25.4
BACK_WALL = 12.7
PIPE_DIAMETER = 28.575
PIPE_SPACING = 12.7
CHAMFER = 1.5875
DEPTH = BACK_WALL + PIPE_DIAMETER
MID_Y = BACK_WALL / 2

_cache = {}


def render(params):
    key = tuple(sorted(params.items()))
    if key not in _cache:
        _cache[key] = render_triangles(CLAMP_SCAD, {**FAST, **params}, openscadpath=os.path.join(REPO_ROOT, "lib"))
    return _cache[key]


def render_stack(count, params):
    scad = "include <%s>\n%s\n" % (
        CLAMP_SCAD,
        "".join("translate([0, 0, %d * holder_height]) Holder();\n" % i for i in range(1, count)),
    )
    with tempfile.NamedTemporaryFile("w", suffix=".scad", delete=False) as f:
        f.write(scad)
    try:
        return render_triangles(f.name, {**FAST, **params}, openscadpath=os.path.join(REPO_ROOT, "lib"))
    finally:
        os.unlink(f.name)


def tongue_half(height):
    return (BOTTOM - (BOTTOM - TOP) * height / HEIGHT) / 2


@unittest.skipUnless(shutil.which("openscad"), "openscad binary not found on PATH")
class PipeClampTestCase(unittest.TestCase):
    def test_socket_clears_tongue_width(self):
        tris = render({"Holder_Count": "1"})
        edge = BOTTOM / 2 + CLEARANCE - 0.05
        self.assertFalse(contains(tris, (edge, MID_Y, 0.05)), "socket is not widened by Notch_Clearance")
        self.assertFalse(contains(tris, (-edge, MID_Y, 0.05)), "socket is not widened by Notch_Clearance")
        self.assertTrue(contains(tris, (BOTTOM / 2 + CLEARANCE + 0.3, MID_Y, 0.05)), "socket wider than expected")

    def test_socket_deeper_than_tongue(self):
        tris = render({"Holder_Count": "1"})
        z = HEIGHT + CLEARANCE - 0.05
        self.assertFalse(contains(tris, (0, MID_Y, z)), "socket is not deeper than the tongue by Notch_Clearance")
        self.assertTrue(contains(tris, (0, MID_Y, HEIGHT + CLEARANCE + 0.2)), "socket deeper than expected")

    def test_tongue_present(self):
        tris = render({"Holder_Count": "1"})
        holder_height = PIPE_SPACING + PIPE_SPACING + PIPE_DIAMETER
        self.assertTrue(contains(tris, (0, MID_Y, holder_height + HEIGHT / 2)), "tongue centre is empty")
        self.assertFalse(contains(tris, (0, MID_Y, holder_height + HEIGHT + 0.1)), "tongue taller than Notch_Height")

    def test_stacked_blocks_seat_flush(self):
        tris = render_stack(2, {"Holder_Count": "1"})
        holder_height = PIPE_SPACING + PIPE_SPACING + PIPE_DIAMETER
        corner = WIDTH / 2 - CHAMFER - 1
        for x in (-corner, corner):
            self.assertTrue(contains(tris, (x, MID_Y, holder_height - 0.05)), "lower block top face is empty")
            self.assertTrue(contains(tris, (x, MID_Y, holder_height + 0.05)), "upper block bottom face is empty")
        gap = tongue_half(0.5) + CLEARANCE / 2
        self.assertFalse(contains(tris, (gap, MID_Y, holder_height + 0.5)), "tongue touches the socket wall")
        self.assertFalse(
            contains(tris, (0, MID_Y, holder_height + HEIGHT + 0.1)), "tongue bottoms out in the socket"
        )

    def test_edge_chamfer_trims_corners(self):
        tris = render({"Holder_Count": "1"})
        z = PIPE_SPACING / 2
        self.assertFalse(
            contains(tris, (WIDTH / 2 - 0.1, MID_Y + DEPTH / 2 - 0.1, z)), "block corner is not chamfered"
        )
        self.assertTrue(contains(tris, (WIDTH / 2 - 0.1, MID_Y, z)), "block side face is empty")

    def test_edge_chamfer_disabled(self):
        tris = render({"Holder_Count": "1", "Edge_Chamfer": "0"})
        z = PIPE_SPACING / 2
        self.assertTrue(contains(tris, (WIDTH / 2 - 0.1, MID_Y + DEPTH / 2 - 0.1, z)), "corner is trimmed at 0")

    def test_opening_mouth_flared(self):
        probe = (WIDTH / 2 - 0.1, PIPE_DIAMETER / 2 + CHAMFER / 2, PIPE_SPACING + PIPE_DIAMETER / 2)
        self.assertFalse(contains(render({"Holder_Count": "1"}), probe), "opening mouth is not flared")
        self.assertTrue(contains(render({"Holder_Count": "1", "Edge_Chamfer": "0"}), probe), "probe should be solid")

    def test_opening_mouth_flare_is_confined_to_the_faces(self):
        flared = fingerprint(render({"Holder_Count": "1"}))["volume_mm3"]
        plain = fingerprint(render({"Holder_Count": "1", "Edge_Chamfer": "0"}))["volume_mm3"]
        self.assertLess(plain - flared, 0.02 * plain, "chamfer removes material away from the side faces")

    def test_opening_mouth_flared_on_both_faces(self):
        probe_y = PIPE_DIAMETER / 2 + CHAMFER / 2
        z = PIPE_SPACING + PIPE_DIAMETER / 2
        tris = render({"Holder_Count": "1"})
        for x in (WIDTH / 2 - 0.1, -WIDTH / 2 + 0.1):
            self.assertFalse(contains(tris, (x, probe_y, z)), f"opening mouth is not flared at x={x}")


if __name__ == "__main__":
    unittest.main()
