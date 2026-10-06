"""Every model README's generated Parameters/Presets block matches its Customizer block."""

import glob
import os
import sys
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "scripts"))

import readme_params  # noqa: E402

ROOT = readme_params.REPO_ROOT
MODELS = sorted(os.path.basename(os.path.dirname(p)) for p in glob.glob(os.path.join(ROOT, "*", "Makefile")))


class ReadmeParamsTest(unittest.TestCase):
    def test_generated_blocks_are_current(self):
        self.assertEqual(readme_params.drifted(MODELS), [], "run `make readme`")

    def test_options_formats(self):
        self.assertEqual(readme_params._options("[1:1:6]"), "1 to 6, step 1")
        self.assertEqual(readme_params._options("[0:10]"), "0 to 10")
        self.assertEqual(readme_params._options("[a: Alpha, b: Beta]"), "Alpha, Beta")
        self.assertEqual(readme_params._options("[x, y]"), "x, y")
        self.assertEqual(readme_params._options(""), "")


if __name__ == "__main__":
    unittest.main()
