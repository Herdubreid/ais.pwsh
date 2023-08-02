---
layout: default
title: Getting Started
nav_order: 2
---

## Getting Started

### Install Module

```powershell
Install-Module celin.ais.pwsh
```

### Create to AIS Connection

```powershell
New-Celin.AIS Demo "https://demo.steltix.com"
```

This command will create a connection with the name `Demo` for  [Steltix's](https://steltix.com) [Demo](https://demo.steltix.com) AIS and prompt for User Name and Password (use 'demo', 'demo').

![Connect](/img/new-connection.png)

### Authenticate

```powershell
Connect-Celin.AIS
```

This command will use the previously created connection to authenticate using the provided user name and password.

### Submit Query

```powershell
$ab = Submit-Celin.AIS.Query "f0101 (an8,alph,at1) all(at1=C)"
```

Submit a query and store the results in variable `$ab`.

