# Windows validation plan

Status: **NOT EXECUTED ON WINDOWS**.

## Automated static checks

```bash
python -m unittest discover -s tests -v
```

## Manual Windows 10/11 acceptance checks

1. On a disposable Windows 10 VM and Windows 11 VM, start `Start-CLI.cmd` as a standard user.
2. Run systeminfo, ipconfig, DNS, ping, process and disk checks.
3. Confirm admin-only commands refuse standard-user execution.
4. Confirm changing commands demand the exact `YES` acknowledgement and cancel otherwise.
5. Test a repair operation in a disposable snapshot VM only; restore snapshot afterwards.
6. Export HTML, check HTML escaping and inspect for sensitive data.
7. Check behavior under missing executables, disconnected network, restricted policies, and timeouts.
8. Record Windows build, PowerShell version, command exit codes and redacted screenshots.

Never disable Defender, weaken execution policy or use a production machine for destructive tests.
