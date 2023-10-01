function getLayout {
  param([string] $name)
  $fn = "./tmp/${name}.json"
  if (-not (Test-Path $fn)) {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Herdubreid/ais.pwsh/main/layouts/${name}.json" -OutFile $fn
  }
  return Get-Content $fn -Raw
}
