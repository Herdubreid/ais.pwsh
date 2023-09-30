function init {
    param (
        [string] $branch
    )
    $global:hint = "Branch/Plant $branch Maintenance (enter go start)"
    $global:bpState = @{}

    $bpState.rc = "15|16|145|151"

    $bpState.branch = $branch

    $bpState.itms = convertfrom-celin.ais.ui.gridform (getLayout base-grid)
    $bpState.itms.many = $true
    $bpState.itms.options = [char[]]@('1')
    $bpState.itms.statusbar.add("Select Items with 1")
    $bpState.itms.body.format = "{0, -15} {1, -30} {2}"
    $bpState.itms.header.format = "{0, -15} {1}"
    $bpState.itms.header.data = @("Item", "Description")

    $bpState.bps = convertfrom-celin.ais.ui.gridform (getLayout base-grid)
    $bpState.bps.color = "high"
    $bpState.bps.body.format = "{4, -15} {1, -30} {2}"
    $bpState.bps.header.format = "{0, -15} {1}"
    $bpState.bps.header.data = @("Item", "Description")

    $bpState.edit = ConvertFrom-Celin.AIS.Ui.Form (getLayout bp-edit)

    Clear-Host
}

function go {
    param (
        [string] $cmd,
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]] $params
    )
    
    $options = @("list", "add", "edit", "back")

    $edit = [System.Func[bool]] {
        $success = $false
        Write-Host "Fetching Item/BP List..."
        try {
            $bpState.rs = Submit-Celin.AIS.Query "v4101n (f4101.itm,f4102.litm,f4102.mcu,f4101.dsc1,f4101.dsc2) all(f4101.srtx=FLF f4102.mcu=$($bpState.branch))"
            $bpState.bps.title = "Select $($bpState.branch) Item to Edit"
            $bpState.bps.set($bpState.rs.data.grid.detail)
            $bpState.bp = Show-Celin.AIS.Ui.GridForm $bpState.bps
            if ($bpState.bp) {
                $q = "all(itm=$($bpState.bp.data.row[0]))"
                Write-Host $q
                $bpState.f4102 = Submit-Celin.AIS.Query "f4102 (vend,roqi,safe) $q"
                $bpState.f4105 = "f4105 (litm,mcu,ledg,uncs,cspo,csin) $q"
                $bpState.f4106 = "f4106 (litm,mcu,mcu,eftj,exdj,an8,uprc) $q"
                $success = $true
            }            
        }
        catch {
            Write-Host $_ -ForegroundColor Red
        }

        return $success
    }

    $list = [System.Action] {
        Write-Host "Fetching Item/BP List..."
        try {
            $bpState.rs = Submit-Celin.AIS.Query "v4101n (f4101.itm,f4102.litm,f4102.mcu,f4101.dsc1,f4101.dsc2) all(f4101.srtx=FLF f4102.mcu=$($bpState.branch))"
            Write-Host
            [console]::WriteLine("{0, -15} {1, -12} {2, -30} {3}", `
                @("Item", "Branch", "Description", "Type"))
            [console]::WriteLine("".PadRight(80, '-'))
            foreach ($r in $bpState.rs.data.grid.detail) {
                [console]::WriteLine("{4,-15} {3, -12} {1, -30} {2}", $r.toarray())
            }
            Write-Host "$($bpState.rs.data.grid.detail.count()) Item(s) returned"
        }
        catch {
            Write-Host $_ -ForegroundColor Red
        }
    }

    $add = [System.Func[bool]] {
        Write-Host "Fetching Availble Items..."
        $success = $false
        try {
            $bpState.master = Submit-Celin.AIS.Query "f4101 (litm,dsc1,dsc2) by[asc(dsc2)] all(srtx=FLF)"
            $bpState.bp = Submit-Celin.AIS.Query "v4101n (f4102.litm) all(f4101.srtx=FLF f4102.mcu=$($bpState.branch))"
            $bpState.available = @()
            foreach ($itm in $bpState.master.data.grid.detail) {
                $find = $bpState.bp.data.grid.detail | Where-Object { $_[0] -eq $itm[0] }
                if (-not $find) {
                    $bpState.available += , $itm
                }
            }
            if ($bpState.available.Length -gt 0) {
                $bpState.itms.title = "Add Items to Branch $($bpState.branch)"
                $bpState.itms.set($bpState.available)
                $bpState.toAdd = Show-Celin.AIS.Ui.GridForm $bpState.itms
                if ($bpState.toAdd) {
                    if ($bpState.toAdd.data.toarray().length -gt 0) {
                        foreach ($item in $bpState.toAdd.data) {
                            try {
                                Write-Host "Adding $($item.row[0]) $($item.row[1])"
                                $bpState.rs = open-celin.ais.script "w41026e zjde0001" "do(47)" -returnControlIDs $bpState.rc
                                $bpState.rs = step-celin.ais.script "set(15,$($bpState.branch)) set(16,$($item.row[0])) set(145,3104) set(151,4242) do(11)" -returnControlIDs $bpState.rc
                                if ($bpState.rs.error) {
                                    throw $bpState.rs.error
                                }
                                $success = $true
                            }
                            catch {
                                Write-Host $_ -ForegroundColor Red
                            }
                            finally {
                                Close-Celin.AIS.Script | Out-Null
                            }
                        }
                    }
                    else {
                        Write-Host "No Items Selected"
                    }
                }
            }
            else {
                Write-Host "No Items to Add..."
            }
        }
        catch {
            Write-Host $_ -ForegroundColor Red
        }
        return $success
    }

    if (-not $cmd) {
        $cmd = Show-Menu $options
    }
    
    switch ($cmd.ToLower()) {
        $options[0] { $list.Invoke() }
        $options[1] {
            if ($add.Invoke()) {
                Write-Host "Item Added." -ForegroundColor Green
            }
            else {
                Write-Host "Add Cancelled" -ForegroundColor Red
            }
        }
        $options[2] {
            if ($edit.Invoke()) {
                Write-Host "Edit Successful." -ForegroundColor Green
            }
            else {
                Write-Host "Edit Cancelled" -ForegroundColor Red
            }            
        }
        $options[3] {
            $Global:mod = $null
            use im
        }
        Default {
            Write-Host "Options:"
            Write-Host $options
        }
    }
}
