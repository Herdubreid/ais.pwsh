function init {
    $global:hint = "Item Maintenance (enter go start)"
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
            use $options[0]
        }
        $options[1] {
            use $options[1]
        }
        Default {
            Write-Host "Options:"
            Write-Host $options
        }
    }
}
