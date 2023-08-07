---
layout: default
title: Interactive Script
nav_order: 5
parent: How To's
---

## Interactive Script

Often we want to interrupt a script for selection or error handling.

A `Terminal Console` doesn't have the interactive flexibility of `Windows` interface, but what it lacks in flexibility it makes up for with speed and ease of use.

The following example uses the [ConsoleGuiTools](https://www.powershellgallery.com/packages/Microsoft.PowerShell.ConsoleGuiTools/0.7.4) to first select a single purchase order and then one or more lines for receipting.

```powershell
# Install the Console Gui Module
Install-Module -Name Microsoft.PowerShell.ConsoleGuiTools

# Helper Functions
# Find the Index of Select Row
function find-SelectIndex {
  param ($find, $in)
  $found = -1
  $ndx = 0
  foreach ($e in $in) {
    if (-not (compare-object $e.psobject.properties $find.psobject.properties)) {
      $found = $ndx
      break
    }
    $ndx++
  }
  return $found
}
# Mark the Selected Lines for Receipting
function update-grid {
  param ($recs, $lines)
  $stms = ""
  foreach ($e in $recs) {
    $ndx = find-SelectIndex $e $lines
    if ($ndx -ne -1) {
      $stms += "${ndx}:(382:1)"
    }
  }
  return "update[1 $stms]"
}

# Open Purchase Orders App Stack and press Find
$rq = open-celin.ais.script "w4312f zjde0006" "do(21)" -max -1 -returnControlIDs "1[16,41,25,10,11,14,91,92]"

# Create a open pos variable
$pos = $rq.data.grid.detail.toTable($rq.data.grid.header.titles)

# Select the Order to Receipt
$po = $pos | out-consoleGridView -title "Open Orders" -outputmode single

# Select the Order by Index
$ndx = find-selectIndex $po $pos
$rq = Step-Celin.AIS.Script "select(1.$ndx) do(4)" -returnControlIDs "1[116,117,103,40,44]"

# Create a lines variable
$lines = $rq.data.grid.detail.toTable($rq.data.grid.header.titles)

# Select lines to Receive
$recs = $lines | out-consoleGridView -title "Lines to Receive"

# Update Receipt Flag for the lines
$rq = step-celin.ais.script (update-grid $recs $lines) -returnControlIDs "1[382]"

# Press the OK Button
$rq = step-celin.ais.script "do(4)" -returnControlIDs "7|9|11|27"

# Display the Receipt Document and Batch
$rq.data.form

# Close the App Stack
close-celin.ais.script | out-null
```
