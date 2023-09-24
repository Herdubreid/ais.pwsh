# Init
$global:hint = "Item Maintenance (enter 'go help' to start, 'q' to quit)"

function go {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet("help", "master", "bp")]
        [string] $cmd
    )
    
    switch ($cmd.ToUpper()) {
        "HELP" {  }
        "MASTER" {

        }
        "BP" {}
        Default {
            Write-Host "Invalid Option"
        }
    }
}

function q {
    Remove-Item function:/go
    $global:hint = $null
    Clear-Host
}

Clear-Host