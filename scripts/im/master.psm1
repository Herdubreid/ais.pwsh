
function init {
    $Global:hint = "Item Master (enter go to start, q to quit)"
    Clear-Host
}

function go {
    param (
        [string] $cmd        
    )    
}

function q {
    getScript im
}
