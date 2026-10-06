"""Parse the OpenSCAD Customizer parameters declared in a model's main file."""

import re
from dataclasses import dataclass, field

GROUP = re.compile(r"^/\*\s*\[(?P<name>[^\]]*)\]\s*\*/\s*$")
DECLARATION = re.compile(r"^(?P<name>\w+)\s*=\s*(?P<value>[^;]+);(?P<tail>.*)$")
COMMENT = re.compile(r"^//\s?(?P<text>.*)$")
ANNOTATION = re.compile(r"^\s*//\s*(?P<text>\[.*\])\s*$")
HIDDEN = "Hidden"


@dataclass(frozen=True)
class Param:
    name: str
    default: str
    description: str
    annotation: str
    line: int


@dataclass
class Group:
    name: str
    params: list = field(default_factory=list)


def _description(lines, index):
    """Consecutive `//` lines directly above lines[index], joined by newlines."""
    found = []
    i = index - 1
    while i >= 0 and (m := COMMENT.match(lines[i].strip())):
        found.append(m["text"].strip())
        i -= 1
    return "\n".join(reversed(found))


def _annotation(tail):
    m = ANNOTATION.match(tail)
    return m["text"] if m else ""


def parse(path):
    """Return the ordered Customizer groups of `path`, stopping at `[Hidden]`.

    Variables declared before the first group land in a group named "Parameters".
    """
    with open(path, encoding="utf-8") as f:
        lines = f.read().splitlines()
    groups = []
    for i, line in enumerate(lines):
        g = GROUP.match(line.strip())
        if g:
            if g["name"].strip() == HIDDEN:
                break
            groups.append(Group(g["name"].strip()))
            continue
        d = DECLARATION.match(line)
        if d:
            if not groups:
                groups.append(Group("Parameters"))
            groups[-1].params.append(
                Param(d["name"], d["value"].strip(), _description(lines, i), _annotation(d["tail"]), i + 1)
            )
    return groups
