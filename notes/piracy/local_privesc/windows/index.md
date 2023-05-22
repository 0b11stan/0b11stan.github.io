<p style="text-align: right">_- last update 31/01/2023 -_</p>

# Local Privilege Escalation - Windows

## Summary

* [Automated Enumeration](./automated_enumeration.md)
* [Manual Enumeration](./manual_enumeration.md)
* [Stored Credentials](./stored_credentials.md)
* [Unattended Windows Installations](./unattended_windows_installations.md)
* [Powershell and cmd History](./history.md)
* [Credentials in Software](./software_credentials.md)
* [Windows Kernel Exploits](./software_credentials.md)
* [DLL Hijacking](./dll_hijacking.md)
* [Weak user privileges](./weak_user_privileges.md)
* [Scheduled Tasks](./vulnerable_software.md)
* [Insecure Service Permission](./insecure_service_permission.md)
* [Unquoted Service Paths](./unquoted_service_path.md)


## Ressources

* [PayloadAllTheThings - Windows Privilege Escalation](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Windows%20-%20Privilege%20Escalation.md)
* [Priv2Admin - Abusing Windows Privileges](https://github.com/gtworek/Priv2Admin)
* [RogueWinRM Exploit](https://github.com/antonioCoco/RogueWinRM)
* [Potatoes](https://jlajara.gitlab.io/others/2020/11/22/Potatoes_Windows_Privesc.html)
* [Decoder's Blog](https://decoder.cloud/)
* [Token Kidnapping](https://dl.packetstormsecurity.net/papers/presentations/TokenKidnapping.pdf)
* [Hacktricks - Windows Local Privilege Escalation](https://book.hacktricks.xyz/windows-hardening/windows-local-privilege-escalation)

### Basics

There are 2 main groups on a local windows system :

* `Administrators`
* `Standard Users`

But there are 3 "hidden" built-in accounts that are important:

* `SYSTEM / LocalSystem`: which is more powerfull than a common administrator
* `Local Service`: run Windows services
* `Network Service`: run Windows services, use computer credentials to authenticate through the network

**WARNING :** on powershell, commands should always be exe if not aliases (for exemple `sc.exe` instead of `sc`)

Usefull: the following command is creating a `pwnd` user with a sample password and adding it to administrators.

```bash
net user pwnd SamplePass123 /add & net localgroup administrators pwnd /add
```
