#!/usr/bin/env python3
"""Render an OpenSCAD model to STL and summarize it as a small geometric fingerprint.

Used by the golden-file regression test (tests/test_geometry_regression.py) to catch
unintended geometry drift in shared libraries (e.g. lib/pegboard) without checking
binary STL files into the repository.
"""

import argparse
import json
import os
import struct
import subprocess
import sys
import tempfile


def read_stl_triangles(path):
    with open(path, "rb") as f:
        data = f.read()
    if data[:5] == b"solid" and b"facet" in data[:1024]:
        tris, cur = [], []
        for line in data.decode("ascii", "replace").splitlines():
            parts = line.split()
            if parts and parts[0] == "vertex":
                cur.append(tuple(float(x) for x in parts[1:4]))
                if len(cur) == 3:
                    tris.append(tuple(cur))
                    cur = []
        return tris
    n = struct.unpack_from("<I", data, 80)[0]
    tris = []
    for i in range(n):
        v = struct.unpack_from("<12f", data, 84 + 50 * i)
        tris.append((v[3:6], v[6:9], v[9:12]))
    return tris



# Fixed fractions of the part's own Z extent to sample cross-sectional area at.
# Total volume and bbox are both blind to a feature (e.g. a peg) sliding to a
# different height within an otherwise-unchanged part; a Z-sliced area profile
# is not, which is what a golden file here needs to catch.
SECTION_Z_FRACTIONS = (0.05, 0.15, 0.30, 0.50, 0.70, 0.85, 0.95)


def _section_area(tris, z):
    # Signed area (Green's theorem) of the polygon(s) formed by slicing all
    # triangles at height z, oriented from each facet's own edge direction.
    area = 0.0
    for a, b, c in tris:
        pts = []
        for p, q in ((a, b), (b, c), (c, a)):
            if (p[2] - z) * (q[2] - z) < 0:
                t = (z - p[2]) / (q[2] - p[2])
                pts.append((p[0] + t * (q[0] - p[0]), p[1] + t * (q[1] - p[1])))
        if len(pts) != 2:
            continue
        (x0, y0), (x1, y1) = pts
        area += (x0 * y1 - x1 * y0) / 2
    return abs(area)


def fingerprint(tris):
    vol = 0.0
    lo = [float("inf")] * 3
    hi = [float("-inf")] * 3
    for a, b, c in tris:
        vol += (
            a[0] * (b[1] * c[2] - b[2] * c[1])
            - a[1] * (b[0] * c[2] - b[2] * c[0])
            + a[2] * (b[0] * c[1] - b[1] * c[0])
        ) / 6
        for p in (a, b, c):
            for i in range(3):
                lo[i] = min(lo[i], p[i])
                hi[i] = max(hi[i], p[i])

    z_lo, z_hi = lo[2], hi[2]
    sections = [
        round(_section_area(tris, z_lo + f * (z_hi - z_lo)), 1)
        for f in SECTION_Z_FRACTIONS
    ]

    return {
        "triangles": len(tris),
        "volume_mm3": round(abs(vol), 1),
        "bbox_size_mm": [round(hi[i] - lo[i], 2) for i in range(3)],
        "section_areas_mm2": sections,
    }


def detect_backend_flag(openscad="openscad"):
    # Mirrors common.mk's OPENSCAD_BACKEND detection: older OpenSCAD builds
    # (e.g. the apt package on Ubuntu CI runners) support neither --backend
    # nor --enable=manifold, so probe --help rather than assuming Manifold.
    result = subprocess.run([openscad, "--help"], capture_output=True, text=True)
    help_text = result.stdout + result.stderr
    if "--backend" in help_text:
        return ["--backend=Manifold"]
    if "manifold" in help_text:
        return ["--enable=manifold"]
    return []


def render_triangles(scad_path, params, openscad="openscad", openscadpath=None):
    env = dict(os.environ)
    if openscadpath:
        env["OPENSCADPATH"] = openscadpath
    with tempfile.TemporaryDirectory() as tmp:
        out = os.path.join(tmp, "out.stl")
        cmd = [openscad, "--render"] + detect_backend_flag(openscad)
        for k, v in params.items():
            cmd += ["-D", f"{k}={v}"]
        cmd += ["-o", out, scad_path]
        result = subprocess.run(cmd, env=env, capture_output=True, text=True)
        if result.returncode != 0:
            raise RuntimeError(
                f"openscad failed ({' '.join(cmd)}):\nstdout: {result.stdout}\nstderr: {result.stderr}"
            )
        return read_stl_triangles(out)


def render_fingerprint(scad_path, params, openscad="openscad", openscadpath=None):
    return fingerprint(render_triangles(scad_path, params, openscad, openscadpath))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--scad", required=True)
    parser.add_argument("--param", action="append", default=[], help="key=value, repeatable")
    parser.add_argument("--openscad", default="openscad")
    parser.add_argument("--openscadpath")
    args = parser.parse_args()

    params = {}
    for p in args.param:
        k, v = p.split("=", 1)
        params[k] = v

    print(json.dumps(render_fingerprint(args.scad, params, args.openscad, args.openscadpath), indent=2))


if __name__ == "__main__":
    main()
