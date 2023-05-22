# Find an LDAP domain and domain controllers

You may find the domain name in DHCP offers. Start wireshark and plug your host
on the network.

## Find domain controllers

```bash
nmap --script dns-srv-enum --script-args dns-srv-enum.domain=$DOMAIN
```
