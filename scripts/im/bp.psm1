function init {
    param (
        [string] $branch
    )
    $global:hint = "Branch/Plant $branch Maintenance (enter go start)"
    $global:bpState = @{}

    $bpState.rc = "15|16|145|151"

    $bpState.branch = $branch

    $bpState.select = convertfrom-celin.ais.ui.gridform (getLayout base-grid)
    $bpState.select.many = $true
    $bpState.select.options = [char[]]@('1')
    $bpState.select.statusbar.add("Select Items with 1")
    $bpState.select.body.format = "{0, -15} {1, -30} {2}"
    $bpState.select.header.format = "{0, -15} {1}"
    $bpState.select.header.data = @("Item", "Description")

    $bpState.edit = ConvertFrom-Celin.AIS.Ui.Form (Get-Content ../layouts/bp-edit.json -Raw)

    Clear-Host
}

function go {
    param (
        [string] $cmd,
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]] $params
    )
    
    $options = @("list", "add", "price", "back")

    $list = [System.Action] {
        Write-Host "Fetching Item/BP List..."
        try {
            $Global:rs = Submit-Celin.AIS.Query "v4101n (f4102.litm,f4102.mcu,f4101.dsc1,f4101.dsc2) all(f4101.srtx=FLF f4102.mcu=$branch)"
            Write-Host
            [console]::WriteLine("{0, -15} {1, -12} {2, -30} {3}", `
                @("Item", "Branch", "Description", "Type"))
            [console]::WriteLine("".PadRight(80, '-'))
            foreach ($r in $rs.data.grid.detail) {
                [console]::WriteLine("{3,-15} {2, -12} {0, -30} {1}", $r.toarray())
            }
            Write-Host "$($rs.data.grid.detail.count()) Item(s) returned"
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
            $bpState.bp = Submit-Celin.AIS.Query "v4101n (f4102.litm) all(f4101.srtx=FLF f4102.mcu=$branch)"
            $bpState.available = @()
            foreach ($itm in $bpState.master.data.grid.detail) {
                $find = $bpState.bp.data.grid.detail | Where-Object { $_[0] -eq $itm[0] }
                if (-not $find) {
                    $bpState.available += , $itm
                }
            }
            if ($bpState.available.Length -gt 0) {
                $bpState.select.title = "Add Items to Branch $branch"
                $bpState.select.set($available)
                $bpState.toAdd = Show-Celin.AIS.Ui.GridForm $bpState.select
                if ($bpState.toAdd) {
                    if ($bpState.toAdd.data.toarray().length -gt 0) {
                        foreach ($item in $bpState.toAdd.data) {
                            try {
                                Write-Host "Adding $($item.row[0]) $($item.row[1])"
                                $bpState.rs = open-celin.ais.script "w41026e zjde0001" "do(47)" -returnControlIDs $bpState.rc
                                $bpState.rs = step-celin.ais.script "set(15,$branch) set(16,$($item.row[0])) set(145,3104) set(151,4242) do(11)" -returnControlIDs $bpState.rc
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

<#
$bpState.edit.title = "Add Item to $branch"
$bpState.edit.panes[0].fields[0].value = $branch
$bpState.rs = open-celin.ais.script "w41026e zjde0001"
foreach ($item in $bpState.toAdd.data) {
    $bpState.edit.panes[0].fields[1].value = $item.row[0]
    $bpState.edit.panes[0].fields[2].value = $item.row[1]
    Remove-Variable add -ErrorAction SilentlyContinue
    $bpState.add = Show-Celin.AIS.Ui.Form $bpState.edit
    $bpState.set = ($bpState.add.data | foreach-object { "set($($_.id),$($_.value))" }) -join " "
    $bpState.rs = Step-Celin.AIS.Script "do(47)"  -returnControlIDs $bpState.rc
    $bpState.rs = Step-Celin.AIS.Script $bpState.set -returnControlIDs $bpState.rc
}
#>