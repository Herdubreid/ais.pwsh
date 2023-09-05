function getScript {
  param([string[]] $names)
  foreach ($n in $names) {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Herdubreid/ais.pwsh/main/scripts/${n}.ps1" | Invoke-Expression
  }
}
