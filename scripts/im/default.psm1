function init {
    $global:hint = "Item Maintenance (enter go start, q to quit)"
    $global:mod = "im/"

    Clear-Host
}

function go {
    param (
        [string] $cmd
    )

    $options = @("master", "bp")
    
    switch ($cmd.ToLower()) {
        $options[0] {
            getScript $options[0]
        }
        $options[1] {
            getScript $options[1]
        }
        Default {
            Write-Host "Options:"
            Write-Host $options
        }
    }
}

function q {
    Remove-Item function:/go
    $global:hint = $null
    Clear-Host
}
