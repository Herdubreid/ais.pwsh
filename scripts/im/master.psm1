function init {
    $Global:hint = "Item Master (enter go to start)"
    Clear-Host
}

function go {
    param (
        [string] $cmd        
    )

    $options = @("add", "edit", "list", "back")

    $add = [System.Func[bool]] {
        Write-Host "Add Item"
        $succes = $false
        $type = (Show-Menu @("base", "spread", "topping", "side", "drink")).ToUpper()
        Write-Host "Description (6-30 character, blank to cancel)"
        do {
            $desc = (Read-Host).ToUpper()
        } until(-not $desc -or $desc.Length -ge 6 -and $desc.Length -le 30)
        if ($desc) {
            $item = $desc -replace "[AEIOU\W]", ""
            $question = "Do you want to add item $item - ${desc}?"
            $choices = "&Yes", "&No"
            $choice = $Host.UI.PromptForChoice("Confirm", $question, $choices, 0)
            if ($choice -eq 0) {
                Write-Host "Adding Item..."
                try {
                    $rc = "13|23|24|25|26|27|28"
                    $global:rs = Open-Celin.AIS.Script "w4101e zjde0001" "do(17)" -returnControlIDs $rc
                    $p = @($item, $desc, $type, "FLF", "S", "IN30", "EA")
                    $s = ""
                    for ($i = 0; $i -lt $p.length; $i++) {
                        $s += "set($($rs.data.form[$i].Id),'$($p[$i])') "
                    }
                    $global:rs = Step-Celin.AIS.Script "${s}do(11)"  -returnControlIDs $rc
                    if ($rs.error) {
                        Write-Host ($rs.error) -ForegroundColor Red
                    }
                    else {
                        $succes = $true
                    }
                }
                catch {
                    Write-Host $_ -ForegroundColor Red
                }
                finally {
                    Close-Celin.AIS.Script -ErrorAction SilentlyContinue | Out-Null
                }
            }
        }
        return $succes
    }

    $edit = [System.Action] {
        write-host "Edit..."
    }

    $list = [System.Action] {
        Write-Host "Fetching Item List..."
        try {
            $Global:rs = Submit-Celin.AIS.Query "f4101 (litm,dsc1,dsc2) by[asc(dsc2)] all(srtx=FLF)"
            $a = $rs.data.grid.header | Select-Object -ExpandProperty Title
            Write-Host
            [console]::WriteLine("{0, -15} {1, -30} {2}", $a)
            [console]::WriteLine("".PadRight(75, '-'))
            foreach ($r in $rs.data.grid.detail) {
                [console]::WriteLine("{0,-15} {1, -30} {2, -10}", $r.toarray())
            }
            Write-Host "$($rs.data.grid.detail.count()) Item(s) returned"
        } catch {
            Write-Host $_ -ForegroundColor Red
        }
    }

    if (-not $cmd) {
        $cmd = Show-Menu $options
    }

    switch ($cmd.ToLower()) {
        $options[0] {
            if ($add.Invoke()) {
                Write-Host "Item Added." -ForegroundColor Green
            }
            else {
                Write-Host "Add Cancelled" -ForegroundColor Red
            }
        }
        $options[1] { $edit.Invoke() }
        $options[2] { $list.Invoke() }
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
