function getScript {
  param([string[]] $names)
  foreach ($n in $names) {
    if (-not (Test-Path "./$tmp$n.psm1")) {
      Invoke-WebRequest -Uri "$source/$mod$n.psm1" -OutFile "./$tmp$n.psm1"
    }
    Import-Module ./$tmp$n.psm1 -Force -Global
  }
}
