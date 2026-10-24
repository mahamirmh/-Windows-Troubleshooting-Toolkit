# Original v3 source import

The original distributed `RISHEH-Windows-Toolkit-Pro-v3.zip` contains `Toolkit.ps1` with the Windows Forms GUI, worker mode, health summary, privacy-safe report, and repair confirmations, plus `Start-Toolkit.cmd`, `Start-CLI.cmd`, `README-fa.md`, and `tests/test_static.py`.

**The current repository's `Toolkit.ps1` is NOT this original file.** The separate `Toolkit-GUI.ps1` is an independently developed limited preview.

To finish source parity, extract the original ZIP, replace the repository's `Toolkit.ps1`, entrypoints and tests with the original files, and commit the diff. Do not label source parity complete until SHA-256 checksums of extracted files and repository files match. Then run Windows integration tests and publish a GitHub Release.

This file documents the gap; it does not claim the original v3 GUI is published.
