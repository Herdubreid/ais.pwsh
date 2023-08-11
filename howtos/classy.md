---
layout: default
title: Classy Script
nav_order: 6
parent: How To's
---

## Classy Script

Programming and housekeeping have a lot in common<sup>1</sup>.  Like a housekeeper putting stuff away in drawers, programmers use libraries<sup>2</sup>, or what can be generalised as `types`.

The concept of a `type` is similar to a drawer, reduce clutter.

For example, how about doing the PO Receipting like this.

```powershell
# Open Purchase Orders
[w4312f]::open()

# Select a Line
$po = $jde.list | out-consoleGridView -title "Open Orders" -outputmode single | find-selectIndex -in $jde.list
  
# Select the Line
$jde.select($po)
  
# List the Lines
$jde.list
  
# Select the first Row for Receipting
$jde.receipt(0)
$jde.list

# Press Ok
$jde.ok()

# List the Receipt Doc
$jde.form

# Exit the App Stack
$jde.exit()
```

### Encapsulate Forms

Here we have encapsulated the functions to use in the `W4312F` and `W4312A` forms.

```powershell
# Work With Open PO's type
class w4312f : jdeGridForm {
  [void] select([int]$row) {
    $rs = step-celin.ais.script "select(1.$row) do(4)" -returnControlIDs ($global:ctrlIDs["w4312a"])
    [jdeForm]::update($rs)
  }
  static open() {
    $rs = open-celin.ais.script "w4312f zjde0006" "do(21)" -max -1 -returnControlIDs ($global:ctrlIDs["w4312f"])
    [jdeForm]::update($rs)
  }
  w4312f($rs) : base($rs) {}
}
# Add the returnControlIDs
$ctrlIDs["w4312f"] = "97|85|1[16,41,25,10,11,14,91,92]"
# Add the type
[jdeForm]::types.add(@{ Name = "*W4312F*"; Type = [w4312f] })
# Receipt a PO type
class w4312a : jdeGridForm {
  [void] receipt([int]$row) {
    $rs = step-celin.ais.script "update[1 ${row}:(382:1,117: )]" -returnControlIDs ($global:ctrlIDs["w4312a"])
    [jdeForm]::update($rs)
  }
  [void] ok() {
    $r = step-celin.ais.script "do(4)" -returnControlIDs ($global:ctrlIDs["w4312f"])
    [jdeForm]::update($r)
  }
  [void] cancel() {
    $r = step-celin.ais.script "do(5)" -returnControlIDs ($global:ctrlIDs["w4312f"])
    [jdeForm]::update($r)
  }
  w4312a($rs) : base($rs) {}
}
# Add the returnControlIDs
$ctrlIDs["w4312a"] = "1[382,116,117,103,40,44]"
# Add the type
[jdeForm]::types.add(@{ Name = "*W4312A*"; Type = [w4312a] })
```

### Encapsulate Base

The common elements of the forms are encapsulated in the `class jdeForm` and its derivative `class jdeGridForm`.

```powershell
# Declare the ctrlIDs hashtable
$ctrlIDs = @{}
# The base form class
class jdeForm {
  $rs
  # Type Array
  static $types = (new-object System.Collections.ArrayList)
  # Close the session
  [void] exit() {
    $r = close-celin.ais.script
    [jdeForm]::update($r)
  }
  # Write form info
  [object] info() {
    return @(
      $this.rs.app
      $this | get-member
    )
  }
  jdeForm($rs) {
    $this.rs = $rs
    # Members
    $this | add-member name -memberType scriptProperty -value {
      $this.rs.app
    }
    $this | add-member form -memberType scriptProperty -value {
      $this.rs.data.form
    }
    $this | add-member error -memberType scriptProperty -value {
      $null -ne $this.rs.error
    }
    $this | add-member errorText -memberType scriptProperty -value {
      if ($null -ne $this.rs.error) {
        write-host $this.rs.error -foregroundColor red
      }
    }
  }
  [void] static update($rs) {
    # Write any error text
    if ($null -ne $rs.error) {
      write-host $rs.error -foregroundColor red
    }
    # Update the connection object
    set-variable $env:CELIN_DEFAULT_AIS (get-variable $env:CELIN_DEFAULT_AIS).value -scope Global
    # Get the type
    $type = [jdeForm]
    foreach ($t in [jdeForm]::types) {
      if ($rs.app -like $t.Name) {
        $type = $t.Type
        break
      }
    }
    $global:jde = $type::new($rs)
  }
}
# A form with grid
class jdeGridForm : jdeForm {
  $useNames = $false
  jdeGridForm($rs) : base($rs) {
    # Members
    $this | add-member grid -MemberType ScriptProperty -Value {
      $this.rs.data.grid
    }
    $this | add-member list -MemberType ScriptProperty -Value {
      if ($this.useNames) {
        $this.rs.data.grid.detail.toTable($this.rs.data.grid.header.names)
      }
      else {
        $this.rs.data.grid.detail.toTable($this.rs.data.grid.header.titles)
      }
    }
  }
}
```

### Updated Find-SelectionIndex function

Accept the value to find from the pipeline (the `Out-ConsoleGridView` command).

```powershell
function find-SelectIndex {
  param (
    [Parameter(ValueFromPipeline = $true)]
    $find,
    $in)
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
```

> <sup>1</sup> With apology to housekeepers, the argument is about tidiness.

> <sup>2</sup> Ok, maybe a librarian is better analogy.
