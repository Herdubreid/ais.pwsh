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
    # if ($null -ne $rs.error) {
    #  write-host $rs.error -foregroundColor red
    #}
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
