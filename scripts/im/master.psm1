
function init {
    $Global:hint = "Item Master (enter go to start, q to quit)"
    Clear-Host
}

function go {
    param (
        [string] $cmd        
    )

    $options = @("add", "edit", "back")

    switch ($cmd.ToLower()) {
        options[0] {

        }
        options[1] {}
        options[2] {
            $Global:mod = $null
            use im
        }
        Default {
            Write-Host "Optins:"
            Write-Host $options
        }
    }
}
