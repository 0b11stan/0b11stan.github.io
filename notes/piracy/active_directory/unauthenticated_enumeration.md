<p style="text-align: right">_- last update 08/06/2023 -_</p>

# Unauthenticated enumeration

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
