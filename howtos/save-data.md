---
layout: default
title: Save Data
nav_order: 2
parent: How To's
---

## Save Data

Saving data to a file, instead of always requesting it from AIS can be convenient, for example for master data like address book.  It's can also be necessary for keeping a history of previous state, for example to report on daily changes in number of open purchase orders.

### To and From JSON

The `Grid` and `Data` types of the `Celin.AIS.Query` and `Celin.AIS.Script` commands offer a JSON conversion methods for export and restoration.

#### Save/Restore Grid as JSON File

Using our `$ab` variable with the address book query result, we can save the `Grid` to a file called `ab.json`.

```powershell
$ab.data.grid.tojson() | out-file ./ab.json
```

Later we can restore the `Grid` into a variable called `$abg`.

```powershell
$abg = [celin.ais.pwsh.types.grid]::fromjson((get-content ./ab.json))
```

Here we use the `static FromJson` function of the type [Celin.AIS.Pwsh.Type.Grid] to construct the `Grid` with JSON data read by the `Get-Content` command.

This is made possible by the fact that PowerShell is a native of .NET and understand its types.
