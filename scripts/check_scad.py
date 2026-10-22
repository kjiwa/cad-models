#!/usr/bin/env python3
"""Evaluate a model's default and every preset without rendering geometry; fail on any WARNING or ERROR.

Older OpenSCAD builds report unknown functions and failed assertions on stderr yet exit 0, so
stderr is scanned rather than trusting the exit code.
"""

import argparse
import json
import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(__file__))

from build_presets import slugify  # noqa: E402

NOISE_PREFIXES = ("WARNING", "ERROR", "EXPORT-WARNING")


def evaluate(openscad, scad, out_path, preset_args):
    result = subprocess.run([openscad] + preset_args + ["-o", out_path, scad], capture_output=True, text=True)
    noise = [line for line in result.stderr.splitlines() if line.startswith(NOISE_PREFIXES)]
    if result.returncode != 0 or noise:
        print(f"Error: {out_path} failed (exit {result.returncode})", file=sys.stderr)
        print("\n".join(noise or result.stderr.splitlines()[-10:]), file=sys.stderr)
        return False
    return True


def preset_names(json_path):
    if not os.path.exists(json_path):
        return []
    with open(json_path, "r", encoding="utf-8") as f:
        return [name for name in json.load(f).get("parameterSets", {}) if name]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--model", required=True)
    parser.add_argument("--scad", required=True)
    parser.add_argument("--json", required=True)
    parser.add_argument("--build-dir", default="build")
    parser.add_argument("--openscad", default="openscad")
    args = parser.parse_args()

    os.makedirs(args.build_dir, exist_ok=True)
    jobs = [(f"{args.model}.csg", [])]
    jobs += [(f"{args.model}_{slugify(n)}.csg", ["-p", args.json, "-P", n]) for n in preset_names(args.json)]
    results = [evaluate(args.openscad, args.scad, os.path.join(args.build_dir, out), pargs) for out, pargs in jobs]
    sys.exit(0 if all(results) else 1)


if __name__ == "__main__":
    main()
