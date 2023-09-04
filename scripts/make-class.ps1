function makeClass {
  param(
    [string] $name,
    $demo
  )
  $s = ""
  foreach ($c in $demo.controls.getenumerator()) {
    $s += "# $($c.value.type) $($c.key), $($c.value.title)`n"
  }
  $s += "
class $name : jdeGridForm { `
  $name(`$rs) : base(`$rs) {}
}
`$ctrlIDs[`"$name`"] = `"$($demo.returnControlIDs)`"
[jdeForm]::types.add(@{ Name = `"*$($name.toupper())*`"; Type = [$name] })"
  return $s
}
