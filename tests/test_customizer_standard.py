"""Every model's Customizer follows the repo standard; each rule lists every violating file:line."""

import glob
import os
import re
import sys
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "scripts"))

import customizer  # noqa: E402

MODEL_NOUNS = {
    "bora_centipede_riser": "Riser",
    "entryway_table": "Entryway",
    "keyhole_router_template": "Keyhole",
    "makita_hose_adapter": "Makita",
    "razor_blade_dispenser": "Razor",
    "ryobi_40v_battery_holder": "Ryobi",
    "shotgun_mini_shell_adapter": "Shotgun",
}

TAIL_GROUPS = ("Backplate", "Pegboard", "Screw Holes", "Preview")
NAME = re.compile(r"^[A-Z][a-z0-9]*(_[A-Z0-9][a-z0-9]*)*$")
SLIDER = re.compile(r"^\[\s*-?\d")
SLIDER_NAME = re.compile(r"^(\w+_Count|Rows|Columns|\w+_Angle)$")
ZERO = re.compile(r"(?<![\d.])0(?![\d.])")
MINOR_WORDS = ("and", "or", "to", "of", "the", "a", "for")
ZERO_WORDING = ("(0 to disable)", "(0 = auto)")


def _model_sources():
    paths = sorted(glob.glob(os.path.join(REPO_ROOT, "*", "*.scad")))
    return [p for p in paths if os.path.basename(os.path.dirname(p)) not in ("dist", "lib")]


def _all_scad_sources():
    paths = glob.glob(os.path.join(REPO_ROOT, "*", "*.scad")) + glob.glob(os.path.join(REPO_ROOT, "*", "components", "*.scad"))
    return sorted(p for p in paths if os.path.basename(os.path.dirname(p)) not in ("dist", "lib"))


def _model(path):
    return os.path.basename(os.path.dirname(path))


def _where(path, line):
    return f"{os.path.relpath(path, REPO_ROOT)}:{line}"


def _params():
    """Yield (path, group name, Param) for every Customizer parameter."""
    for path in _model_sources():
        for group in customizer.parse(path):
            for p in group.params:
                yield path, group.name, p


def _is_boolean(p):
    return p.default in ("true", "false")


def _is_slider(p):
    return bool(SLIDER.match(p.annotation))


def _enum_entries(p):
    """(key, label or None) for each entry of a non-slider annotation."""
    if not p.annotation or _is_slider(p):
        return []
    entries = []
    for item in p.annotation[1:-1].split(","):
        key, sep, label = item.partition(":")
        entries.append((key.strip(), label.strip() if sep else None))
    return entries


def _title_case(label):
    words = [w for w in re.split(r"[\s/-]+", label) if w]
    return all(w[:1].isupper() or not w[:1].isalpha() or (i and w in MINOR_WORDS) for i, w in enumerate(words))


def _assert_calls(text):
    """Yield (line, has_message) for each assert( call in OpenSCAD source."""
    for m in re.finditer(r"\bassert\s*\(", text):
        line_start = text.rfind("\n", 0, m.start()) + 1
        if "//" in text[line_start:m.start()]:
            continue
        depth, i, in_str, comma = 1, m.end(), False, False
        while i < len(text) and depth:
            c = text[i]
            if in_str:
                if c == "\\":
                    i += 1
                elif c == '"':
                    in_str = False
            elif c == '"':
                in_str = True
            elif c in "([{":
                depth += 1
            elif c in ")]}":
                depth -= 1
            elif c == "," and depth == 1:
                comma = True
            i += 1
        yield text.count("\n", 0, m.start()) + 1, comma


class CustomizerStandardTestCase(unittest.TestCase):
    def assertNoViolations(self, rule, violations):
        self.assertFalse(violations, f"{rule}: {len(violations)} violation(s)\n" + "\n".join(violations))

    def test_names_are_title_case(self):
        bad = [
            f"{_where(path, p.line)} {p.name}"
            for path, _group, p in _params()
            if not NAME.match(p.name)
        ]
        self.assertNoViolations("names are Title_Case", bad)

    def test_no_model_prefix(self):
        bad = []
        for path in _model_sources():
            noun = MODEL_NOUNS.get(_model(path))
            if not noun:
                continue
            for group in customizer.parse(path):
                if group.name.split()[0] == noun and group.params:
                    bad.append(f"{_where(path, group.params[0].line)} group [{group.name}]")
                bad.extend(
                    f"{_where(path, p.line)} {p.name}" for p in group.params if p.name.split("_")[0] == noun
                )
        self.assertNoViolations("no model prefix in names or groups", bad)

    def test_description_is_one_plain_sentence(self):
        bad = []
        for path, _group, p in _params():
            text = p.description
            problems = []
            if not text or "\n" in text:
                problems.append("not exactly one // line")
            else:
                if not text[0].isupper():
                    problems.append("not sentence case")
                if text.endswith("."):
                    problems.append("trailing period")
                if ";" in text:
                    problems.append("semicolon")
            bad.extend(f"{_where(path, p.line)} {p.name}: {x}" for x in problems)
        self.assertNoViolations("description is one plain sentence", bad)

    def test_group_order(self):
        bad = []
        for path in _model_sources():
            groups = [g for g in customizer.parse(path) if g.params]
            names = [g.name for g in groups]
            where = lambda g: _where(path, g.params[0].line)  # noqa: E731
            if "Part" in names and names[0] != "Part":
                bad.append(f"{where(groups[names.index('Part')])} [Part] is not first")
            tail = [n for n in names if n in TAIL_GROUPS]
            if tail != sorted(tail, key=TAIL_GROUPS.index):
                bad.append(f"{where(groups[names.index(tail[0])])} tail groups out of order: {', '.join(tail)}")
            if "Preview" in names and names[-1] != "Preview":
                bad.append(f"{where(groups[names.index('Preview')])} [Preview] is not last")
            first_tail = next((i for i, n in enumerate(names) if n in ("Backplate", "Screw Holes")), None)
            if first_tail is not None:
                bad.extend(
                    f"{where(g)} body group [{g.name}] after [{names[first_tail]}]"
                    for g in groups[first_tail + 1:]
                    if g.name not in TAIL_GROUPS
                )
        self.assertNoViolations("group order", bad)

    def test_sliders_only_on_counts_and_angles(self):
        bad = []
        for path, _group, p in _params():
            wants = bool(SLIDER_NAME.match(p.name))
            if wants and not _is_slider(p):
                bad.append(f"{_where(path, p.line)} {p.name}: missing slider")
            if _is_slider(p) and not wants:
                bad.append(f"{_where(path, p.line)} {p.name}: unexpected slider")
        self.assertNoViolations("sliders only on counts and angles", bad)

    def test_booleans_are_include_outside_preview(self):
        bad = [
            f"{_where(path, p.line)} {p.name}"
            for path, group, p in _params()
            if _is_boolean(p) and group != "Preview" and not p.name.startswith("Include_")
        ]
        self.assertNoViolations("booleans are Include_* outside [Preview]", bad)

    def test_enum_keys_lowercase_and_labels_title_case(self):
        bad = []
        for path, _group, p in _params():
            for key, label in _enum_entries(p):
                if key != key.lower():
                    bad.append(f"{_where(path, p.line)} {p.name}: key '{key}' not lowercase")
                if label is not None and not _title_case(label):
                    bad.append(f"{_where(path, p.line)} {p.name}: label '{label}' not Title Case")
        self.assertNoViolations("enum keys lowercase, labels Title Case", bad)

    def test_zero_wording(self):
        bad = [
            f"{_where(path, p.line)} {p.name}"
            for path, _group, p in _params()
            if ZERO.search(p.description) and not any(w in p.description for w in ZERO_WORDING)
        ]
        self.assertNoViolations('zero is described as "(0 to disable)" or "(0 = auto)"', bad)

    def test_stabilizing_pin_pattern_without_socket_mount_omits_peglock(self):
        bad = []
        for path in _model_sources():
            groups = customizer.parse(path)
            params = {p.name: p for g in groups for p in g.params}
            if "Pegboard" not in {g.name for g in groups} or "Mount_Type" in params:
                continue
            p = params.get("Stabilizing_Pin_Pattern")
            if p and "Peglock" in p.description:
                bad.append(f"{_where(path, p.line)} {p.name}: mentions Peglock without a socket mount")
        self.assertNoViolations("Stabilizing_Pin_Pattern omits Peglock where no socket mount exists", bad)

    def test_asserts_have_messages(self):
        bad = []
        for path in _all_scad_sources():
            with open(path, encoding="utf-8") as f:
                text = f.read()
            bad.extend(f"{_where(path, line)} assert without message" for line, ok in _assert_calls(text) if not ok)
        self.assertNoViolations("every assert has a message", bad)


if __name__ == "__main__":
    unittest.main()
