function init {
    param (
        [string] $branch
    )
    $global:hint = "Branch/Plant $branch Maintenance (enter go start)"
    $global:branch = $branch

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
            $Global:rs1 = Submit-Celin.AIS.Query "f4101 (litm,dsc1,dsc2) by[asc(dsc2)] all(srtx=FLF)"
            $Global:rs2 = Submit-Celin.AIS.Query "v4101n (f4102.litm) all(f4101.srtx=FLF f4102.mcu=$branch)"
            $toAdd = @()
            foreach ($itm in $rs1.data.grid.detail) {
                $find = $rs2.data.grid.detail | Where-Object { $_[0] -eq $itm[0] }
                Write-Host $find
                if (-not $find) {
                    $global:toAdd += ,$itm
                }
            }
            if ($toAdd.Length -gt 0) {

            }
            $success = $true
        } catch {
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
