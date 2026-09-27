#!/usr/bin/env python3
"""Build OpenSCAD presets defined in a JSON parameter file."""

import argparse
import json
import os
import re
import shlex
import subprocess
import sys


def slugify(name: str) -> str:
    return re.sub(r"[^a-zA-Z0-9]+", "_", name).strip("_")


def main() -> None:
    parser = argparse.ArgumentParser(description="Build OpenSCAD presets")
    parser.add_argument("--model", required=True, help="Model name")
    parser.add_argument("--scad", required=True, help="Path to .scad file")
    parser.add_argument("--json", required=True, help="Path to .json parameter file")
    parser.add_argument("--build-dir", default="build", help="Output directory")
    parser.add_argument("--openscad", default="openscad", help="OpenSCAD binary")
    parser.add_argument("--openscad-flags", default="--render", help="OpenSCAD render flags")
    parser.add_argument("--render-flags", default="", help="OpenSCAD preview render flags")
    parser.add_argument("--target", choices=["all", "stl", "3mf", "preview"], default="all")

    args = parser.parse_args()

    if not os.path.exists(args.json):
        return

    try:
        with open(args.json, "r", encoding="utf-8") as f:
            data = json.load(f)
    except Exception as err:
        print(f"Warning: could not parse {args.json}: {err}", file=sys.stderr)
        return

    parameter_sets = data.get("parameterSets")
    if not isinstance(parameter_sets, dict) or not parameter_sets:
        return

    os.makedirs(args.build_dir, exist_ok=True)

    openscad_flags = shlex.split(args.openscad_flags)
    render_flags = shlex.split(args.render_flags)

    for preset_name in parameter_sets.keys():
        if not preset_name:
            continue
        slug = slugify(preset_name)
        preset_args = ["-p", args.json, "-P", preset_name]

        if args.target in ("all", "stl"):
            out_path = os.path.join(args.build_dir, f"{args.model}_{slug}.stl")
            print(f"==> Building preset STL [{preset_name}] -> {out_path}")
            cmd = [args.openscad] + openscad_flags + preset_args + ["-o", out_path, args.scad]
            subprocess.run(cmd, check=True)

        if args.target in ("all", "3mf"):
            out_path = os.path.join(args.build_dir, f"{args.model}_{slug}.3mf")
            print(f"==> Building preset 3MF [{preset_name}] -> {out_path}")
            cmd = [args.openscad] + openscad_flags + preset_args + ["-o", out_path, args.scad]
            subprocess.run(cmd, check=True)

        if args.target in ("all", "preview"):
            out_path = os.path.join(args.build_dir, f"{args.model}_{slug}_preview.png")
            print(f"==> Building preset preview [{preset_name}] -> {out_path}")
            cmd = [args.openscad] + render_flags + ["--render"] + preset_args + ["-o", out_path, args.scad]
            subprocess.run(cmd, check=True)


if __name__ == "__main__":
    main()
