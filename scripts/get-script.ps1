function getScript {
  param([string[]] $names)
  foreach ($n in $names) {
    if (-not (Test-Path "./tmp/${n}.psm1")) {
      Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Herdubreid/ais.pwsh/main/scripts/${n}.ps1" -OutFile "./tmp/${n}.psm1"
    }
    remove-item function:\init -ErrorAction SilentlyContinue
    remove-item function:\g -ErrorAction SilentlyContinue
    remove-item function:\q -ErrorAction SilentlyContinue
    Import-Module ./tmp/${n}.psm1 -Force
    init
  }
}
