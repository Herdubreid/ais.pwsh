function init {
    $global:hint = "Account Query (enter 'go' to start, 'q' to quit)"

    # Get a base Grid Form
    New-Variable mcuFrm (ConvertFrom-Celin.AIS.Ui.GridForm (getLayout base-grid)) -Option ReadOnly -Force -Scope Global
    # Set Title and Color
    $mcuFrm.title = "Business Unit"
    $mcuFrm.color = "high"
    # Set the Header
    $mcuFrm.header.format = "{0,12} {1,7} {2,-30} {3,-4} {4,-3} {5,-8} {6,-8} {7,12}"
    $mcuFrm.header.data = @("BU#", "Company", "Description", "Type", "LOD", "From LOD", "To LOD", "No.Accounts")
    # Set the Body Format
    $mcuFrm.body.format = "{0,12} {3,7} {4,-30} {1,-4} {2,-3} {7,-8} {8,-8} {9,12}"

    # Init Accounts
    New-Variable f0901 "f0901 -max no (co,aid,mcu,obj,sub,dl01,lda,pec,crcd) by[asc(obj,sub)]" -Option ReadOnly -Force -Scope Global
    New-Variable fmt { , @(("{0}{1}.{2}.{3}" -f "".PadRight($_[6], ' '), $_[2].trim(), $_[3], $_[4].trim()).trimEnd('.'), $_[10], $_[9], $_[5], $_[11], $_[12], $_[6], $_[7]) }  -Option ReadOnly -Force -Scope Global
    # Get Msg Form
    New-Variable msg (ConvertFrom-Celin.AIS.Ui.Prompt (getLayout error-msg)) -Option ReadOnly -Force -Scope Global
    # Get a base Grid Form
    New-Variable accFrm (ConvertFrom-Celin.AIS.Ui.GridForm (getLayout base-grid)) -Option ReadOnly -Force -Scope Global
    # Set Title and Color
    $accFrm.title = "Accounts"
    $accFrm.color = "high"
    # Set Keys
    $accFrm.statusbar.add("Esc - Back to BU's")
    $accFrm.statusbar.add("Previous", "Alt-P")
    $accFrm.statusbar.add("To Excel", "Alt-X")
    # Set the Header
    $accFrm.header.format = "{0,-20} {1, 17:N2} {2,3} {3,-30} {4,6} {5,4} {6,3} {7,3}"
    $accFrm.header.data = @("     Account    ", "Balance", "CUR", "Description", "Trx", "Accs", "LOD", "PEC")
    # Set the Body
    $accFrm.body.format = "{0,-20} {1, 17:N2} {2,3} {3,-30} {4,6} {5,4} {6,3} {7,3}"

    # Get Helpers
    getScript ac-from-to-q
    getScript sum-ac
    getScript to-table
}
function go {
    param (
        [bool]$clear
    )
    # Variables
    $var = New-Celin.State ac rs, q, mcus, mcu, fromAc, toAc, lod, rows, next, prev -Force -UseIfExist:(-not $clear)
    try {
        # Check if MCU's already populated
        if (-not $var.value.mcus) {
            # Fetch BU Master
            Submit-Celin.AIS.Query "f0006 -max no (mcu,styl,ldm,co,dl01)" | cset rs
            # Fetch the BU Account Stats
            Submit-Celin.AIS.Query "f0901 [group(co,mcu) min(lda) max(lda) count(aid) asc(co,mcu)]" | cset rs
            # Create a Joined Grid (using CO,MCU)
            $var.values[1].rs.data.grid.join($var.values[0].rs.data.grid, @("CO", "MCU")) | cset mcus
        }
        # Use the Joined Detail
        $mcuFrm.set($var.value.mcus.detail)
        # Loop until Esc
        while ($true) {
            # Show Form
            Show-Celin.AIS.Ui.GridForm $mcuFrm | cset mcu -FalseIfNull
            if ($var.value.mcu) {
                # Default the to Account
                cset toAc @($var.value.mcu.data.row[3], $null, $var.value.mcu.data.row[0], "XXXX", "")
                # Check if already labelled
                $label = Get-Celin.State $var.value.mcu.data.row[0] -FalseIfNone
                if (-not $label) {
                    # Set the query string (useful for debug)
                    cset q "$f0901 all(mcu=$($var.value.mcu.data.row[0].trim()) lda=$($var.value.mcu.data.row[7]) obj!blank)"
                    # Fetch the First Level
                    Submit-Celin.AIS.Query $var.value.q | cset rs
                    # Sum the Level
                    cset lod @(sumAc $var.value.rs.data.grid.detail.toArray() $var.value.toAc) 
                    # Format the rows for the Form
                    cset rows @($var.value.lod | foreach-object $fmt)
                    # Label the state wih the mcu
                    cset next $var.value.mcu
                    $label = $var.setLabel($var.value.mcu.data.row[0])
                }
                else {
                    # Default required values
                    cset lod $label.lod
                }
                # Store mcu as previous
                cset prev $label.mcu
                $accFrm.set($label.rows)
                # Set the Title
                $accFrm.title = "$($var.value.mcu.data.row[0]) $($var.value.mcu.data.row[4])"
                # Show Form
                while ($true) {
                    # Loop until Esc
                    # Display Accounts
                    Show-Celin.AIS.Ui.GridForm $accFrm | cset next -FalseIfNull
                    if ($var.value.next.key -eq "P, AltMask") {
                        cset next $label.prev -FalseIfNull
                    }
                    if ($var.value.next) {
                        if ($var.value.next.key -eq "X, AltMask") {
                            # Excel Export
                            toTable $accFrm.header.data $accFrm.body.data | Export-Excel -NoNumberConversion *
                        }
                        else {
                            # Check if already labelled
                            $label = Get-Celin.State $var.value.next.data.row[0] -FalseIfNone
                            if (-not $label) {
                                # Get the From Account
                                cs fromAc $var.value.lod[$var.value.next.data.index]
                                # Set To Account, if not last in the list
                                for ($i = $var.value.next.data.index + 1; $i -lt $var.value.lod.length; $i++) {
                                    if ($var.value.lod[$i][1] -ne $var.value.lod[$var.value.next.data.index][1]) {
                                        cset toAc $var.value.lod[$i]
                                        break
                                    }
                                }
                                cset q "lda<=$([int]$var.value.fromAc[6] + 1) mcu=$($var.value.mcu.data.row[0].trim())"
                                cset q (acFromToQ $var.value.q $var.value.fromAc[3].trim() $var.value.fromAc[4].trim() $var.value.toAc[3].trim() $var.value.toAc[4].trim())
                                cset q "$($f0901) $($var.value.q)"
                                # Submit the Query
                                Submit-Celin.AIS.Query $var.value.q | cset rs
                                if ($var.value.rs.data.grid.detail.count() -gt 0) {
                                    # Sum the Level
                                    cset lod @(sumAc $var.value.rs.data.grid.detail.toArray() $var.value.toAc)
                                    cset rows @($var.value.lod | foreach-object $fmt) 
                                    $label = $var.setLabel($var.value.next.data.row[0])
                                    # Store next as previous
                                    cset prev $label.next
                                }
                                else {
                                    $msg.Message.Text = "No records returned!"
                                    Show-Celin.AIS.Ui.Prompt $msg | Out-Null
                                }
                            }
                            else {
                                # Default required values from the label
                                cset lod $label.lod
                                cset toAc $label.toAc
                                cset prev $label.next -FalseIfNull
                            }
                            if ($label) {
                                $accFrm.set($label.rows)
                                $accFrm.title = "$($var.value.mcu.data.row[0]) $($var.value.mcu.data.row[4]) - $($var.value.next.data.row[0]) $($var.value.next.data.row[3])"
                            }
                        }
                    }
                    else {
                        break
                    }
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
