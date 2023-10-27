function init {
    # Set Constants
    New-Variable search (convertFrom-celin.ais.ui.form (getLayout form-search)) -Option ReadOnly -Force -Scope Global
    New-Variable select (convertfrom-celin.ais.ui.gridform (getLayout form-select)) -Option ReadOnly -Force -Scope Global
    New-Variable pb (ConvertFrom-celin.ais.ui.progressbar (getLayout pb)) -Option ReadOnly -Force -Scope Global
    
    # Helpers
    getScript qop
}

function go {
    # Variables
    $var = New-Celin.State frm filter, cql, rs, form, demo -Force
    
    try {
        while ($true) {
            # Prompt for Filter Paramters
            Show-Celin.AIS.Ui.Form $search | cset filter
            if ($var.values.filter) {
                $v = $var.value.filter.data
                # Build the cql statement (this looks a bit ugly)
                cset cql "f9865 (fmnm,md,fmpt,sy) all($(qop fmnm^ $v[0].value.toupper())$(qop md? $v[1].value)$(qop fmpt= $v[2].value.toupper())$(qop sy^ $v[3].value))"
                # Submit the query with Progress Bar
                Show-Celin.AIS.Ui.ProgressBar {
                    submit-celin.ais.query $var.value.cql | cset rs
                } $pb
                # Select a Form
                $select.set($var.value.rs.data)
                Show-Celin.AIS.Ui.GridForm $select | cset form
                if ($var.value.form) {
                    # Get the Demo def
                    Get-Celin.AIS.Ui $var.value.form.data[0].row[0] | cset demo
                    # Label the result with the Form name (clear and force override, 4th parameter)
                    $var.setLabel($var.value.form.data[0].row[0], 0, $true, $true)
                }
                else {
                    # Labe the state as done
                    $var.setLabel("done", 0, $true, $true)
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
