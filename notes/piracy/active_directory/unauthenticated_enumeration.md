<p style="text-align: right">_- last update 31/01/2023 -_</p>

# Unauthenticated enumeration

## Domain metadata

The following command extracts interesting informations on your AD.
The most useful is probably the "domainFunctionnality", which is showing the
compatibility level of your domain with old (and therefor vulnerable) microsoft
versions and protocoles.

```bash
windapsearch -d $DOMAIN_FQDN -m metadata
```

For exemple the following oneliner is extracting the functionality level for
each DC.

```bash
for host in $(cat ads.txt); do 
  printf "$host "
  timeout 3 windapsearch -d "$DOMAIN_FQDN" --dc "$host" -m metadata \
    | grep -e 'domainControllerFunctionality'
  echo; sleep 3
done | tee funclevel.txt
```
