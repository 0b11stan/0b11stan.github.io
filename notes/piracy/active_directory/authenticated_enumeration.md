<p style="text-align: right">_- last update 31/01/2023 -_</p>

# Authenticated Enumeration

## Extract common informations

Dump computers

```bash
windapsearch -d $DOMAIN -u $USER -p $PASSWORD -m computers \
  | grep -i dnshostname \
  | cut -d ' ' -f 2 \
  | tr '[:upper:]' '[:lower:]' \
  | sort -u \
  | tee computers.txt
```

Dump users and computes

```bash
windapsearch -d $DOMAIN -u $USER -p $PASSWORD -m users
```

Dump password policy

```bash
cme smb $DOMAIN_CONTROLLER -d $DOMAIN -u $USER -p $PASSWORD --pass-pol
```

## Dump the whole forest

Use either

* [SharpHound](https://github.com/BloodHoundAD/SharpHound)
* [Bloodhound python](https://github.com/fox-it/BloodHound.py).

Put the `bloodhound-python` command in your current path :

```bash
#!/bin/sh

DOCKERFILE=$(mktemp)

cat > $DOCKERFILE <<EOF
FROM python:3
RUN pip install bloodhound
CMD bloodhound-python
EOF

podman build -t bloodhound-python -f $DOCKERFILE

alias bloodhound-python='podman run bloodhound-python'
```

Extract the forest

```bash
bloodhound-python --zip -c All -d $DOMAIN_FQDN -u $USER -p "$PASSWORD" -dc $DOMAIN_CONTROLER --disable-pooling -w 1
```

## Extract informations from bloodhound dump

Once you have the data, you can freely query the LDAP database offline. Here are
some examples.

Passwords not required

```bash
cat *users* | jq -r '.data | .[] | select(.Properties.passwordnotreqd) | .Properties.name'
```

Passwords that never expires

```bash
cat *users* | jq -r '.data | .[] | select(.Properties.pwdneverexpires) | .Properties.name'
```

Protected users

```bash
cat *groups* | jq -r '.data[] | select(.Properties.name == "PROTECTED USERS@CNED.ORG") | .Members | .[].ObjectIdentifier' | wc -l
```

Generate a json with only the juicy informations about each users.

```bash
jq '.data | .[].Properties | {name: .name, display: .displayname, title: .title, desc: .description}' users.json | tee filtered_users.json
```

Look for a user using it's ID.

```bash
jq '.data | .[].Properties | select(.name == "<user-id>@<domain-fqdn>")' users.json
```

Extract usernames.

```bash
jq -r '.data | .[].Properties.name' input.json | cut -d '@' -f 1 | tr '[:upper:]' '[:lower:]' | tee usernames.json
```

Get all computers and their operating system version

```bash
jq '[.data[].Properties | {name: .name, os: .operatingsystem}] ' computers.json
```

Find all windows servers (see [wikipedia](https://en.wikipedia.org/wiki/List_of_Microsoft_Windows_versions) for all versions)

```bash
jq '[.data[].Properties | select(.operatingsystem and (.operatingsystem | test("Windows Server"; "i"))) | {name: .name, os: .operatingsystem}] ' computers.json | tee outdated_computers.json
```

Count outdated computers

```bash
jq '.data[].Properties | select(.operatingsystem and (.operatingsystem | test("Windows"; "i")) and (.operatingsystem | test("Windows (10|11)|Windows Server (2019|2022)"; "i") | not)) | .operatingsystem' computers.json | wc -l
```

Show vulnerable hosts

```bash
import json

with open("outdated_computers.json") as f:
    computers = f.read()

computers = json.loads(computers)

output = {}

for computer in computers:
    if not output.get(computer["os"]):
        output[computer["os"]] = []
        # print(computer['os'])
    output[computer["os"]].append(computer["name"])

for version in output:
    nbversion = len(output[version])
    ratioparc = round((nbversion * 100) / len(computers))
    print(f"{nbversion:>4} ({ratioparc:>3}%) - {version}")

with open("outdated_computers_by_version.json", "w") as f:
    f.write(json.dumps(output))
```

## Find exploitation paths using bloodhound

Upload your `*.json` files to bloodhound for him to build a graph. You can then
search for specific targets or use the pre-defined queries.

Look for the query called "shortest path to admin" and export the graph.

_TODO : screenshot_

Extract every ldap objects from the graph into a `graph_objects.txt`.

```bash
sed -n 's/^[ ]*"\(.*\)@SAMPLE.DOMAIN.LOCAL.*/\1/p' graph.json | sort -u | tee graph_objects.txt
```

At this point the `graph_objects.txt` contains users, laptops and groups. You
can use the following python script to cross reference object that are only
users (using the extracted informations from previous section).

This python script takes a `graph_objects.txt` and a `all_users.txt` and stores
only real users inside `graph_users.txt`.

```python
valid_users = []

with open('all_users.txt', 'r') as f_all_users:
  all_users = f_all_users.read().split('\n')

with open('graph_objects.txt', 'r') as f_graph_users:
  graph_object = f_graph_object.read().split('\n')

for obj in graph_object:
  if obj in all_users:
    print(f'{obj} is a valid user')
    valid_users.append(obj)

with open('graph_users.txt', 'w') as f_graph_users:
  f_graph_users.write('\n'.join(valid_users))
```

You can then focus your attacks ([spraying](../smb) or phishing for example) on these users only.

## Tracking changes in the forest

Use [LDAPmonitor](https://github.com/p0dalirius/LDAPmonitor).

You can detect locked accounts, privilege escalations and see best activity peak
to launch poisonning.
