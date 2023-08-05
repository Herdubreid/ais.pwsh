---
layout: default
title: Open in Excel
nav_order: 4
parent: How To's
---

## Open in Excel

When it comes to analysing data, it's hard to overlook Excel.  There are few options for loading PowerShell data into Excel and one of them is to used the [ImportExcel](https://www.powershellgallery.com/packages/ImportExcel/7.8.5) Module.

```powershell
install-module importexcel
```

Once installed, the quickest way is to convert the data to a `Table` and then open it in Excel.

```powershell
# Fetch Open Purchase Orders
$pos = submit-celin.ais.query "w4312f zjde0001 -max no"

# Convert the results into a table and then open in Excel
$pos.data.grid.detail.totable($pos.data.grid.header.names) | export-excel -show
```

The resulting `Detal` object is converted using the `ToTable(string[] columns)` method with the `Name` property of the `Header` object.
