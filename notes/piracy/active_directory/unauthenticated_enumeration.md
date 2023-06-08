<p style="text-align: right">_- last update 08/06/2023 -_</p>

# Unauthenticated enumeration

## Find domain name

```bash
nmap --script broadcast-dhcp-discover
```

## Find domain controllers

```bash
nmap --script dns-srv-enum --script-args dns-srv-enum.domain=$DOMAIN
```

## Domain metadata

```bash
windapsearch -d $DOMAIN_FQDN -m metadata
```

extracting the functionality level for each DC

```bash
for host in $(cat ads.txt); do 
  printf "$host "
  timeout 3 windapsearch -d "$DOMAIN_FQDN" --dc "$host" -m metadata \
    | grep -e 'domainControllerFunctionality'
  echo; sleep 3
done | tee funclevel.txt
```
