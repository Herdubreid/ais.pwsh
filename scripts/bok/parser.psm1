function parser {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$list
    )
    # Results
    $result = @{
        failed  = ""
        success = @()
    }
    # Initialise the State
    $var = New-Celin.State shop match, caps, date -Force
    # RegEx Pattern
    $pat = "^(?:(?'items'\d*)\s+)?(?'volume'\d+g|\d+ml)\s+(?'text'(?:(?!^\d)\w+\s)+)(?'amount'\d+.\d+)$|^Date\s+(?'date'\d{1,2}\/\d{1,2})$"
    foreach ($line in ($list -split "`r`n|`n")) {
        cset match ($line | Select-String -Pattern $pat) -FalseIfNull
        if ($var.match) {
            # Get captured values
            cset caps ($var.match.matches.groups | Select-Object success, name, value -Skip 1 | Where-Object success -eq $true | ForEach-Object { , @{ $_.Name = $_.Value } })
            if ($var.caps.date) {
                # Date record
                $day, $month = $var.caps.date -split "/"
                cset date (Get-Date -Year (Get-Date).Year -Month $month -Day $day)
            }
            else {
                cset caps ($var.caps + @{date = $var.date })
                # Add to success
                $result.success += , ($var.caps | ForEach-Object -Begin {
                    $v = @{} } -Process {
                        $v | Add-Member -MemberType NoteProperty -Name
                    } -End { return $v } )
            }
        }
        else {
            # Add to failed match
            $result.failed += "$line`n"
        }
    }
    return $result
}
