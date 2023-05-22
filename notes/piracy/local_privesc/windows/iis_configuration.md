# IIS Configuration

The configuration of IIS can store passwords for databases or configured authentication mechanisms.

Look for the following locations

* `C:\inetpub\wwwroot\web.config`
* `C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\web.config`

Here is a quick way to find database connection strings on the file:

```powershell
type C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\web.config | findstr connectionString
```

