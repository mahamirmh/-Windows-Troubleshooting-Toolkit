@echo off
cd /d "%~dp0"
powershell.exe -NoProfile -STA -File "%~dp0Toolkit-GUI.ps1"
