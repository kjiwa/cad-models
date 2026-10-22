"""Every symlink under models/ resolves, so a model opens in OpenSCAD without OPENSCADPATH."""

import os
import subprocess
import unittest

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))


class LibraryLinksTest(unittest.TestCase):
    def test_links_resolve(self):
        tracked = subprocess.run(
            ["git", "ls-files", "-s", "models"], cwd=REPO_ROOT, check=True, capture_output=True, text=True
        ).stdout.splitlines()
        links = [line.split("\t", 1)[1] for line in tracked if line.startswith("120000")]
        self.assertTrue(links)
        dangling = [p for p in links if not os.path.exists(os.path.join(REPO_ROOT, p))]
        self.assertEqual(dangling, [])


if __name__ == "__main__":
    unittest.main()
