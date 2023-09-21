function prompt {
    $buf = $null
    # Test the input command
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$buf, [ref]$null)
    if (-not $buf -or $buf -eq "last") {
        # If blank, then clear the screen
        [Console]::Clear()
    }
    # Get the cursor line
    $top = [Console]::CursorTop
    if ($top -eq 0) {
        # If in the first line, write header
        $h = "No Host`n"
        if ($env:CELIN_DEFAULT_AIS) {
            # Get the current variable
            $var = get-variable $env:CELIN_DEFAULT_AIS
            $center = "Not Connected"
            $right = ""
            if ($var.Value.AuthResponse) {
                # If get the environment and user
                $center = $var.Value.AuthResponse.environment
                $right = $var.Value.AuthResponse.username
            }
            # Build the header string
            $sp = [Console]::BufferWidth - $center.Length;
            [int]$rpad = $sp / 2        
            $h = $var.Name.PadRight($sp - $rpad) `
                + $center `
                + $right.PadLeft($rpad) + "`n"
        }
    }
    return "$h$(Split-Path -Path (Get-Location) -Leaf) : "
}
