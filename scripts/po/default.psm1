function init {
    $global:hint = "App/Ube PO's.  Enter 'go <object name>'"
}

function go {
    param (
        [Parameter(Mandatory = $true)]
        [string] $obnm        
    )
    $po = New-Celin.State po obnm, vers, po, rs -Force

    try {
        $po.obnm = $obnm.ToUpper()
        # Fetch Versions
        $po.rs = Submit-Celin.AIS.Query "f983051 (pid, vers, jd) all(pid=$($po.obnm))"
        if ($po.rs.data.grid.detail.length -gt 0) {
            foreach ($ver in $po.rs.data.grid.detail) {
                [System.Console]::Write("{0}|{1}`r", $ver[0], $ver[1])
                # Fetch the Version
                $po.vers = $ver[1]
                if ($po.obnm.StartsWith('R')) {
                    # Ube
                    $po.po = Get-Celin.AIS.Ube $po.obnm $po.vers
                }
                else {
                    # App
                    $po.po = Get-Celin.AIS.Po $po.obnm $po.vers -WithApp
                }
                # Label the version
                $po.setLabel("$($po.obnm)|$($po.vers)", $false, $true) | Out-Null
            }
            [System.Console]::WriteLine("`r");
        }
        else {
            Write-Host "No versions for $($po.obnm)" -ForegroundColor Red
        }
    }
    catch {
        # Report error to the console
        throw
    }
}
