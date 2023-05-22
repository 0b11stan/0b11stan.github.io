# Common Enumeration

Automated: [Winpeas](https://github.com/carlospolop/PEASS-ng/tree/master/winPEAS).

List local users.

```bash
net users
```

List sensitiv system informations to look for public vulns.

```bash
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
```

List services:

```bash
wmic service list
```
