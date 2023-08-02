---
layout: default
title: Getting Started
nav_order: 2
---

# Getting Started

## Install Module

```powershell
PS > Install-Module celin.ais.pwsh
```

## Create to AIS Connection

```powershell
PS > New-Celin.AIS Demo "https://demo.steltix.com"
```

This command will create a connection with the name `Demo` and AIS URL of [Steltix's](https://steltix.com) [Demo](https://demo.steltix.com) and prompt for User Name and Password (use 'demo', 'demo').

![Connect](/img/new-connection.png)

## Authenticate

```powershell
PS > Connect-Celin.AIS
```

This command will use the previously created connection to authenticate using the provided user name and password.

## Submit Query

```powershell
PS > $ab = Submit-Celin.AIS.Query "f0101 (an8,alph,at1) all(at1=C)"
```

Submit a query and store the results in variable `$ab`.

