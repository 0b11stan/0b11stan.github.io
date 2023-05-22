## Unquoted Service Paths

Look at the service executable path

```bash
sc qc VulnerableService
```

If the path has spaces, you can inject malicious exe in PATH

```powershell
C:\my program\path\has\spaces.exe # service binary
C:\my.exe                         # malicious binary
```
