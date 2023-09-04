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
class $($name.tolower()) : jdeGridForm { `
  $($name.tolower())(`$rs) : base(`$rs) {}
}
`$ctrlIDs[`"$($name.tolower())`"] = `"$($demo.returnControlIDs)`"
[jdeForm]::types.add(@{ Name = `"*$($name.toupper())*`"; Type = [$($name.tolower())] })"
  return $s
}
