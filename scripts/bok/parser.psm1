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
        try {
            cstate match ($line | Select-String -Pattern $pat) -FalseIfNull
            if ($var.match) {
                # Get captured values
                cstate caps ($var.match.matches.groups | `
                        Select-Object success, name, value -Skip 1 | `
                        Where-Object success -eq $true)
                cstate caps (cpo $var.caps -NameValuePair)
                if ($var.caps.date) {
                    # Date record
                    $day, $month = $var.caps.date -split "/"
                    cstate date (Get-Date -Year (Get-Date).Year -Month $month -Day $day -Hour 0 -Minute 0 -Second 0)
                }
                else {
                    cstate caps (cpo $var.caps, (@{date = $var.date }))
                    # Add to success
                    $result.success += , $var.caps
                }
            }
            else {
                # Add to failed match
                $result.failed += "$line`n"
            }
        }
        catch {
            write-host $_ -ForegroundColor Red
            break           
        }
    }
    return $result
}
