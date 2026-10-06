"""Generate the Parameters and Presets sections of each model README from its Customizer block.

Usage: readme_params.py [--check] <model>...
"""

import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(__file__))

from customizer import parse  # noqa: E402

BEGIN = "<!-- BEGIN GENERATED -->"
END = "<!-- END GENERATED -->"
HEADER = "| Parameter | Default | Options | Description |\n| --- | --- | --- | --- |"
SLIDER = re.compile(r"^\[\s*(-?[\d.]+)\s*:\s*(-?[\d.]+)\s*(?::\s*(-?[\d.]+)\s*)?\]$")
REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))


def _options(annotation):
    if not annotation:
        return ""
    m = SLIDER.match(annotation)
    if m:
        if m[3] is None:
            return f"{m[1]} to {m[2]}"
        return f"{m[1]} to {m[3]}, step {m[2]}"
    return ", ".join(item.split(":", 1)[-1].strip() for item in annotation[1:-1].split(","))


def _cell(text):
    return text.replace("|", "\\|").replace("\n", " ")


def _row(param):
    return f"| `{param.name}` | `{_cell(param.default)}` | {_cell(_options(param.annotation))} | {_cell(param.description)} |"


def _parameters(groups):
    sections = ["## Parameters"]
    for group in groups:
        if group.params:
            sections.append(f"### {group.name}\n\n{HEADER}\n" + "\n".join(_row(p) for p in group.params))
    return "\n\n".join(sections)


def _presets(model_dir, model):
    path = os.path.join(model_dir, model + ".json")
    if not os.path.exists(path):
        return ""
    with open(path, encoding="utf-8") as f:
        names = list(json.load(f)["parameterSets"])
    return "## Presets\n\n" + "\n".join(f"- `{n}`" for n in names)


def generate(model, root=REPO_ROOT):
    model_dir = os.path.join(root, model)
    groups = parse(os.path.join(model_dir, model + ".scad"))
    blocks = [_parameters(groups), _presets(model_dir, model)]
    return "\n\n".join(b for b in blocks if b)


def render(model, root=REPO_ROOT):
    """Return the model's README text with the generated region refreshed."""
    path = os.path.join(root, model, "README.md")
    with open(path, encoding="utf-8") as f:
        text = f.read()
    head, sep, rest = text.partition(BEGIN)
    _, end, tail = rest.partition(END)
    if not sep or not end:
        raise SystemExit(f"{path}: missing {BEGIN} / {END} markers")
    return f"{head}{BEGIN}\n\n{generate(model, root)}\n\n{END}{tail}"


def _current(model, root):
    with open(os.path.join(root, model, "README.md"), encoding="utf-8") as f:
        return f.read()


def drifted(models, root=REPO_ROOT):
    return [m for m in models if render(m, root) != _current(m, root)]


def main(argv):
    check = "--check" in argv
    models = [a for a in argv if a != "--check"]
    if check:
        stale = drifted(models)
        for m in stale:
            print(f"{m}/README.md: generated block out of date")
        return 1 if stale else 0
    for m in models:
        text = render(m)
        with open(os.path.join(REPO_ROOT, m, "README.md"), "w", encoding="utf-8") as f:
            f.write(text)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
