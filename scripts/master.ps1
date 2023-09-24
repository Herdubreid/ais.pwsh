# Init
$Global:hint = "Item Master (enter 'go help' to start, 'q' to quit)"



function go {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet("help", "edit", "add")]
        [string] $cmd        
    )    
}

function q {
    Remove-Item function:/go
    . ./im
}