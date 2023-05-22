# Automated enumeration

## WinPEAS

[LINK](https://github.com/carlospolop/PEASS-ng/tree/master/winPEAS)

Send the long output to a file:

```bash
winpeas.exe > outputfile.txt
```

## PrivescCheck

[LINK](https://github.com/itm4n/PrivescCheck)

Bypass execution policy

```powershell
Set-ExecutionPolicy Bypass -Scope process -Force
```

Run the ps1 file

```powershell
. .\PrivescCheck.ps1
Invoke-PrivescCheck
```

## WES-NG

[LINK](https://github.com/bitsadmin/wesng)

Store the output of `systeminfo` on the target host

```bash
systeminfo > systeminfo.txt
```

Update the tool's database

```bash
wes.py --update
```

Run the exploit suggester (locally)

```bash
wes.py systeminfo.txt
```

## Metasploit

```bash
use multi/recon/local_exploit_suggester
```

