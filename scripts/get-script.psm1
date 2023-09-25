function getScript {
  param([string[]] $names)
  foreach ($n in $names) {
    if (-not (Test-Path "./$tmp$n.psm1")) {
      Invoke-WebRequest -Uri "$source/$mod$n.psm1" -OutFile "./$tmp$n.psm1"
    }
    remove-item function:\init -ErrorAction SilentlyContinue
    remove-item function:\go -ErrorAction SilentlyContinue
    remove-item function:\q -ErrorAction SilentlyContinue
    Import-Module ./$tmp$n.psm1 -Force -Global
    init
  }
}
