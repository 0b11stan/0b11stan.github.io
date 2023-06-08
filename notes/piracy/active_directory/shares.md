<p style="text-align: right">- last update 08/06/2023 -</p>

# CIFS Shares

## Find shares

Récupérer la liste des shares

```bash
FindUncommonShares.py -d "$DOMAIN" -u "$USER" -p "$PASSWORD" --dc-ip "$DCIP" --export-json shares.json --export-xlsx shares.xlsx
```

The following :

* List shares from json
* Only keep uncommon ones (without `$` at the end)
* Write them to "unix" format (change `\` to `/`)
* Sort them by share name
* Store them

```bash
jq -r '.[] | .[].share.uncpath' shares.json \
  | grep -v '\$' \
  | tr '\' '/' 2>/dev/null \
  | sort --field-separator=/ --key=4 uncommon-shares.txt \
  | tee uncommon-shares.txt
```

## Spidering shares

Use [man-spider](https://github.com/blacklanternsecurity/MANSPIDER) to grep into
shares.

With `mount`

```bash
PATTERN='kdbx|pass|conf|xlsx|docx'
INFILE='uncommon-shares.txt'

for SHARE in $(cat $INFILE); do
  echo ">> $SHARE"
  mount -o username="tpinaudeau" -o password="WKwN6UhPpRB&" -t cifs "$SHARE" /mnt 2>/dev/null
  find /mnt 2>/dev/null | egrep "$PATTERN"
  umount /mnt 2>/dev/null
done
```
