function init {
    $global:hint = "App PO's.  Enter 'go <app>'"
}

function go {
    param (
        [Parameter(Mandatory = $true)]
        [string] $app        
    )
    $po = New-Celin.State po app, vers, po, rs -Force -UseIfExist

    try {
        cstate app $app.ToUpper()
        # Fetch Versions
        Submit-Celin.AIS.Query "f983051 (pid, vers, jd) all(pid=$($po.app))" | cstate rs
        if ($po.rs.data.grid.detail.length -gt 0) {
            foreach ($ver in $po.rs.data.grid.detail) {
                [System.Console]::Write("{0}|{1}`r", $ver[0], $ver[1])
                # Fetch the Version
                cstate vers $ver[1]
                Get-Celin.AIS.Po $po.app $po.vers -WithApp | cstate po
                # Label the version
                $po.setLabel("$($po.app)|$($po.vers)", $false, $true) | Out-Null
            }
            [System.Console]::WriteLine("`r");
        } else {
            Write-Host "No versions for $($po.app)" -ForegroundColor Red
        }
    } catch {
        # Report error to the console
        throw
    }
}
