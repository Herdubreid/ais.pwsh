function init {
    param (
        [string] $branch
    )
    $global:hint = "Branch/Plant $branch Maintenance (enter go start)"
    $global:branch = $branch

    Clear-Host
}

function go {
    param (
        [string] $cmd,
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]] $params
    )
    
    Write-Host "Branch: $branch"
    $options = @("list", "add", "price", "back")

    if (-not $cmd) {
        $cmd = Show-Menu $options
    }
    
    switch ($cmd.ToLower()) {
        $options[0] {
            #use $options[0]
        }
        $options[1] {
            #use $options[1]
        }
        $options[2] {

        }
        $options[3] {
            $Global:mod = $null
            use im
        }
        Default {
            Write-Host "Options:"
            Write-Host $options
        }
    }
}
