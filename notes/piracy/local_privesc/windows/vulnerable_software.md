# Vulnerable privileged Software

List install softaware with

```bash
wmic.exe product get name,version,vendor
```

However, this is slow and may not return all installed programs. It is always
worth checking desktop shortcuts, available services or generally any trace that
indicates the existence of additional software that might be vulnerable.

Then search the software and version on [exploitdb](https://www.exploit-db.com/), [packet storm](https://packetstormsecurity.com/), [google](google.com).
