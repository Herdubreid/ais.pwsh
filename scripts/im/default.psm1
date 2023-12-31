function init {
    $global:hint = "Item Maintenance (enter go start)"
    $global:mod = "im/"

    Clear-Host
}

function go {
    param (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string] $cmd
    )
    
    $options = @("master", "bp 30", "bp m30")

    if (-not $cmd) {
        $cmd = Show-Menu $options
    }
    
    switch ($cmd.ToLower()) {
        $options[0] {
            use $options[0]
        }
        $options[1] {
            use bp 30
        }
        $options[2] {
            use bp M30
        }
        Default {
            Write-Host "Options:"
            Write-Host $options
        }
    }
}
