# Saved Windows Credentials

There is a feature that allow us to store other user's credentials.

List de available credentials

```powershell
cmdkey /list
```

You can then login with:

```powershell
runas /savecred /user:admin cmd.exe
```

# Stored Credentials

**SAM (Security Accounts Manager)**: It's a system database that store authentication related data (mdp, hash, ...).

There are 2 types of hash to autenticate users:

* **LM (LAN Manager)**: old, vulnerable to full brute-force
* **NTLMv1 (NT LAN Manager)**: modern, vulnerable to pass the hash and dictionnary attacks
* **NTLMv2 (NT LAN Manager)**: modern, robust

**LSASS (Local Security Authority Subsystem Service)**: process that talks to the **SAM** to compare hashes / get mdps.

**LSASS** temporary store passwords in plaintext. To allow kind of an SSO.

You can use [mimikatz](https://github.com/gentilkiwi/mimikatz) to dump **SAM**'s hashes and break them with [John the Ripper](https://www.openwall.com/john/) !
