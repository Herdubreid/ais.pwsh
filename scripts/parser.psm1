function parser {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$list,
        [bool]$trace
    )
    # Results
    $result = @{
        failed  = ""
        success = @()
    }
    # Initialise the State
    $var = New-Celin.State shop match, caps, date -Force -Trace:$trace
    # RegEx Pattern
    $pat = "^(?:(?'items'\d*)\s+)?(?'volume'\d+g|\d+ml)\s+(?'text'(?:(?!^\d)\w+\s)+)(?'amount'\d+.\d+)$|^Date\s+(?'date'\d{1,2}\/\d{1,2})$"
    foreach ($line in ($list -split "`r`n|`n")) {
        try {
            $var.match = ($line | Select-String -Pattern $pat)
            if ($var.match) {
                # Create an array of successfully captured values
                $var.caps = ($var.match.matches.groups | `
                        Select-Object success, name, value -Skip 1 | `
                        Where-Object success -eq $true)
                # Convert the array to PSCustomObject using the NameValuePair options
                $var.caps = (cpo $var.caps -NameValuePair)
                if ($var.caps.date) {
                    # This is a record with date, split the day and month
                    $day, $month = $var.caps.date -split "/"
                    # Set the date variable
                    cstate date (Get-Date -Year (Get-Date).Year -Month $month -Day $day -Hour 0 -Minute 0 -Second 0)
                }
                else {
                    # Append the date to captured values
                    $var.caps = (cpo $var.caps, (@{date = $var.date }))
                    # Add to success
                    $result.success += , $var.caps
                }
            }
            else {
                # Add to failed match
                $result.failed += "$line`n"
            }
            # Label done (don't clear and force)
            $var.setLabel("done", $false, $true) | Out-Null
        }
        catch {
            write-host $_ -ForegroundColor Red
            break           
        }
    }
    return $result
}
