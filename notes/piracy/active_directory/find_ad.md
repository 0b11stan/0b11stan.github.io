<p style="text-align: right">_- last update 31/01/2023 -_</p>

# Find an Active Directory

## Find domain name

You may find the domain name in DHCP offers. Start wireshark and plug your host
on the network.

## Find domain controllers

```bash
nmap --script dns-srv-enum --script-args dns-srv-enum.domain=$DOMAIN
```
