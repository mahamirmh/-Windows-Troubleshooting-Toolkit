import pathlib, unittest
ROOT = pathlib.Path(__file__).resolve().parents[1]
class ToolkitTests(unittest.TestCase):
    def test_entrypoints(self):
        for f in ("Toolkit.ps1","Start-Toolkit.cmd","Start-CLI.cmd"):
            self.assertTrue((ROOT/f).is_file(),f)
    def test_safe_defaults(self):
        s=(ROOT/"Toolkit.ps1").read_text(encoding="utf-8")
        self.assertIn("Confirm-Operation",s)
        self.assertIn("Export-Report",s)
if __name__=="__main__": unittest.main()
