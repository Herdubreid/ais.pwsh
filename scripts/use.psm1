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
      [string] $name
  )

  $Global:source = "https://raw.githubusercontent.com/Herdubreid/ais.pwsh/main/scripts";
  $global:tmp = "tmp/"

  try {
    $ProgressPreference = 'SilentlyContinue' # Subsequent calls do not display UI.
    remove-item function:\init -ErrorAction SilentlyContinue
    remove-item function:\go -ErrorAction SilentlyContinue

    $from = "$source/$mod$name"
    $to = "./$tmp$mod$name"
    if (-not $mod) {
      if (-not (Test-Path $to)) {
        New-Item $to -ItemType Directory | Out-Null
      }
      $from += "/default"
      $to += "/default"
    }
    $to += ".psm1"
    $from += ".psm1"

    if (-not (Test-Path $to)) {
      Invoke-WebRequest -Uri $from -OutFile $to
    }
    
    Import-Module $to -Force -Global
    
    init
  } catch {
    Write-Host "'$name' not available"
  } finally {
    $ProgressPreference = 'Continue' # Subsequent calls do display UI.
  }
}

function q {
  remove-item function:\init -ErrorAction SilentlyContinue
  remove-item function:\go -ErrorAction SilentlyContinue
  $Global:hint = $null
  $Global:mod = $null
  Clear-Host
}
