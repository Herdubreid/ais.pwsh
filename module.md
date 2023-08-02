---
layout: default
title: Celin.AIS
nav_order: 3
has_children: false
---

## Celin.AIS Module

The basic module maintains the connection variable.

### New-Celin.AIS

Create a new AIS connection variable.

_VariableName_
: The PowerShell variable that will store the connection parameters.  This name must be unique for the session.

_BaseUrl_
: The Base URL of the AIS Server.  The Module requires version 2 of AIS.

_Credential_
: A User/Password PowerShell `Credential` object.

_Log_ (Optional)
: Turn on `Warning`, `Error`, `Critical`, `Debug` or `Trace` Logging for AIS Requests/Response.

The `$env:CELIN_DEFAULT_AIS` will be assigned the new variable name.

### Connect-Celin.AIS

Authenticate connection.

_Credential_ (Optional)
: Override default PowerShell Credentials for authentication.

### Use-Celin.AIS

Set a new default connection variable.

_VariableName_
: The name of the new default variable (excluding the `$` sign).

### Save-Celin.AIS

Export the default connection variable for saving with the `Export-Clixml` command.

For example, a connection variable saved with:

```powershell
Save-Celin.AIS | export-clixml ./demo.xml
```

Can be restored with: 

```powershell
Restore-Celin.AIS Demo (import-clixml ./demo.xml)
```

### Restore-Celin.AIS

Restore default connection from an exported connection.

_VariableName_
: The name of the restored default variable.

_SavedServer_
: The exported connection variable.
