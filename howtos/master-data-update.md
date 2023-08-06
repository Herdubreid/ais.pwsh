---
layout: default
title: Master Data Update
nav_order: 4
parent: How To's
---

## Master Data Update

PowerShell is a very convenient tool when maintaining master data in Oracle E1/JDE.  The following example updates the Item Master Cat Code 4 for a item list where 'Touring' is in the description.

A more realistic example would be where the source data is extracted from an Excel spreadsheet or a 3rd party system.  But the Process would be the same:

- Format the Source into a List or an Array.
- Open the Relevant Work With Form `App Stack`.
- For Each Item.
  - Search for the Item in the Grid
  - Select the Item and open the Maintenance Form.
  - Update the Maintenance Form.
  - Close the Maintenance Form.
- Close the `App Stack`.

```powershell
# Sales Category Codes 4
$rq = submit-celin.ais.query "f0005 (dl01,ky) all(sy=41 rt=S4)"
# Get the grid
$lookup = $rq.data.grid
# Display the values
$lookup.detail.totable($lookup.header.titles)

# Item Master
$rq = submit-celin.ais.query "f4101 (litm,dsc1,srp4)
all(dsc1 ? Touring dsc1 ? Bike srp4 <> 888)"
$ims = $rq.data.grid
$ims.detail.totable($ims.header.titles)

clear

# Update the Cat Code to 888
$counter = 0
# Open a stack Work With Item Master Browse
$rq = open-celin.ais.script "w4101e,zjde0001"
write-host "Opened " $rq.app
foreach ($item in $ims.detail) {
  # Find the first item by using the QBE, returning Item Number, Description and Sales Code 4
  $rq = step-celin.ais.script "qbe(1[123],$($item[0])) do(22)" -returnControlIds "1[123,9,87]"
  # Display the grid result
  $rq.data.grid.detail.totable($rq.data.grid.header.titles) | ft
  # Select the Row and select the Category Codes Row Exit, returing only Sales Code 4
  $bf = step-celin.ais.script "select(1.0) do(133)" -returnControlIds "23"
  # Update Code to 888 and press the Ok button
  $af = step-celin.ais.script "set(23,888) do(11)" -returnControlIds "23"
  # Display the Before and After form values
  $bf.data.form + $af.data.form | ft
  # Close the form
  step-celin.ais.script "do(12)" | out-null
  $counter++
  if ($counter -gt 1) {
    # Only process the first two items
    break;
  }
}
# Close the stack
close-celin.ais.script | out-null

# Checck the Item Master
$rq = submit-celin.ais.query "f4101 (litm,dsc1,srp4)
all(dsc1 ? Touring dsc1 ? Bike srp4 = 888)"
$ims = $rq.data.grid
$ims.detail.totable($ims.header.titles)
```
