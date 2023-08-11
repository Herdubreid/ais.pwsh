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
