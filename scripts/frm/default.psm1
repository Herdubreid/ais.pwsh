function init {
    $Global:hint = "Form Query (enter 'go' to start, 'q' to quit)"

    # Set Constants
    New-Variable search (convertFrom-celin.ais.ui.form (getLayout form-search)) -Option ReadOnly -Force -Scope Global
    New-Variable select (convertfrom-celin.ais.ui.gridform (getLayout form-select)) -Option ReadOnly -Force -Scope Global
    New-Variable pb (ConvertFrom-celin.ais.ui.progressbar (getLayout pb)) -Option ReadOnly -Force -Scope Global
    New-Variable prompt (ConvertFrom-Celin.AIS.Ui.Prompt (getLayout error-msg)) -Option ReadOnly -Force -Scope Global
    $prompt.message.text = "No Forms found!"
    
    # Helpers
    getScript qop
}

function go {
    # Variables
    $var = New-Celin.State frm filter, cql, rs, form, demo -Force
    
    try {
        while ($true) {
            # Prompt for Filter Paramters
            Show-Celin.AIS.Ui.Form $search | cstate filter -FalseIfNull
            if ($var.filter) {
                $v = $var.filter.data
                # Build the cql statement (this looks a bit ugly)
                cstate cql "f9865 (fmnm,md,fmpt,sy) all($(qop fmnm^ $v[0].value.toupper())$(qop md? $v[1].value)$(qop fmpt= $v[2].value.toupper())$(qop sy^ $v[3].value))"
                # Submit the query with Progress Bar
                Show-Celin.AIS.Ui.ProgressBar {
                    submit-celin.ais.query $var.cql | cstate rs
                } $pb

                if ($var.rs.data.grid.detail.length -gt 0) {
                    # Select a Form
                    $select.set($var.rs.data)
                    Show-Celin.AIS.Ui.GridForm $select | cstate form -FalseIfNull
                    if ($var.form) {
                        # Get the Demo def
                        Get-Celin.AIS.Ui $var.form.data[0].row[0] | cstate demo
                        # Label the result with the Form name (clear and force override, 4th parameter)
                        $var.setLabel($var.form.data[0].row[0], $true, $true)
                    }
                    else {
                        # Labe the state as done
                        $var.setLabel("done", 0, $true, $true)
                    }
                } else {
                    show-celin.ais.ui.prompt $prompt | Out-Null
                }
            }
            else {
                break
            }
        }
    }
    catch {
        Write-Host $_ -ForegroundColor Red
    }
}
