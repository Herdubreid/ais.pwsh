# The base form class
class jdeForm {
  $rs
  # Type Array
  static $types = (new-object System.Collections.ArrayList)
  static [void] addType($t) {
    if (-not ([jdeForm]::types | Where-Object { $_.Name -eq $t.Name })) {
      [jdeForm]::types.add($t)
    }
  }
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
  # Map parameters
  [void] mapFields($fields) {
    foreach ($field in $fields) {
      $fld = $this.rs.data.form | Where-Object Id -eq $field.Id
    }
  }
  [void] mapPanes($panes) {
    foreach ($pane in $panes) {
      foreach ($item in $pane.fields) {
        $fld = $this.rs.data.form | Where-Object Id -eq $item.Id
        if ($null -ne $fld) {
          $item.value = $fld.value
        }
      }        
    }
  }
  # Format the value
  [string] toValue($value) {
    if (-not $value) {
      return " "
    }
    $to = switch ($value.gettype()) {
      { $_ -eq [String] } { `"$value`" }
      { $_ -eq [DateOnly] } { "`"" + $($value.tostring($global:datefmt)) + "`"" }
      default { $value }
    }
    return $to
  }
  # Create set string
  [string] set($fm) {
    $a = $fm | foreach-object { "set($($_.id), $($this.toValue($_.value)))" }
    return $a -join " "
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

