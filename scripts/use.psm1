<#
.SYNOPSIS
    Start action.
.DESCRIPTION
    Loads script for action.
.PARAMETER name
    Name of action.
.EXAMPLE
    use <action name>.
#>
function use {
  [CmdletBinding()]
  param (
      [Parameter(Mandatory=$true, HelpMessage="Enter action name")]
      [string]
      $name
  )

  $Global:source = "https://raw.githubusercontent.com/Herdubreid/ais.pwsh/main/scripts";

  try {
    $path = "./tmp/${name}"
    if (-not (Test-Path $path)) {
      New-Item $path -ItemType Directory
      Invoke-WebRequest -Uri "$source/$name/default.psm1" -OutFile "$path/default.psm1"
    }
    
    remove-item function:\init -ErrorAction SilentlyContinue
    remove-item function:\go -ErrorAction SilentlyContinue
    remove-item function:\q -ErrorAction SilentlyContinue
    Import-Module $path/default.psm1 -Force -Global
    
    init
  } catch {
    Write-Host "'$name' not available"
  }
}
