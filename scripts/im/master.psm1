
function init {
    $Global:hint = "Item Master (enter go to start, q to quit)"
    Clear-Host
}

function go {
    param (
        [string] $cmd        
    )

    $options = @("add", "edit", "back")

    $add = [System.Action] {
        Write-Host "Add Item"
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
                Write-Host "Continue..."
                try {
                    $rc = "13|23|24|25|26|27|28"
                    $global:rs = Open-Celin.AIS.Script "w4101e zjde0001" "do(17)" -returnControlIDs $rc
                    $p = @($item, $desc, $type, "FLF", "S", "IN30", "EA")
                    $s = ""
                    for ($i = 0; $i -lt $p.length; $i++) {
                        $s += "set($($rs.data.form[$i].Id),$($p[$i])) "
                    }
                    $global:rs = Step-Celin.AIS.Script "${s}do(11)"  -returnControlIDs $rc
                }
                catch {
                    Write-Host $_ -ForegroundColor Red
                } finally {
                    Close-Celin.AIS.Script -ErrorAction SilentlyContinue | Out-Null
                }
            }
            else {
                Write-Host "Cancelled..."
            }
        }
        else {
            Write-Host "Cancelled..."
        }
    }

    $edit = [System.Action] {
        write-host "Edit..."
    }

    if (-not $cmd) {
        $cmd = Show-Menu $options
    }

    switch ($cmd.ToLower()) {
        $options[0] { $add.Invoke() }
        $options[1] { $edit.Invoke() }
        $options[2] {
            $Global:mod = $null
            use im
        }
        Default {
            Write-Host "Options:"
            Write-Host $options
        }
    }

}
