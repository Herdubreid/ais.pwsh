# Variables
$var = New-Celin.State ac rs, q, mcus, mcu, fromAc, toAc, lod, sum, rows, next -Force
# Fetch BU Master
Submit-Celin.AIS.Query "f0006 -max no (mcu,styl,ldm,co,dl01)" | cset rs
# Fetch the BU Account Stats
Submit-Celin.AIS.Query "f0901 [group(co,mcu) min(lda) max(lda) count(aid) asc(co,mcu)]" | cset rs
# Create a Joined Grid (using CO,MCU)
$var.values[1].rs.data.grid.join($var.values[0].rs.data.grid, @("CO", "MCU")) | cset mcus
# Use the Joined Detail
$mcuFrm.set($var.value.mcus.detail)
# Loop until Esc
# Show Form
Show-Celin.AIS.Ui.GridForm $mcuFrm | cset mcu
# Check if already labelled
$label = Get-Celin.State $var.value.mcu.data.row[0] -ErrorAction SilentlyContinue
if (-not $label) {
    # Default the to Account
    cset toAc @($var.value.mcu.data.row[3], $null, $var.value.mcu.data.row[0], "XXXX", "")
    # Set the query string (useful for debug)
    cset q "$($f0901) all(mcu=$($var.value.mcu.data.row[0].trim()) lda=$($var.value.mcu.data.row[7]) obj!blank)"
    # Fetch the First Level
    Submit-Celin.AIS.Query $var.value.q | cset rs
    # Sum the Level
    cset lod (sumAc $var.value.rs.data.grid.detail.toArray() $var.value.toAc) 
    # Format the rows for the Form
    cset rows @($var.value.lod | foreach-object $fmt)
    # Label the state wih the mcu
    $label = $var.setLabel($var.value.mcu.data.row[0])
}
$accFrm.set($label.rows)
# Set the Title
$accFrm.title = "$($var.value.mcu.data.row[0]) $($var.value.mcu.data.row[4])"
# Show Form
Show-Celin.AIS.Ui.GridForm $accFrm | cset next
if ($var.value.next) {
    # Check if already labelled
    $label = Get-Celin.State $var.value.next.data.row[0] -ErrorAction SilentlyContinue
    if (-not $label) {
        # Get the From Account
        cs fromAc $var.value.lod[$var.value.next.data.index]
        # Set to Account, if not last in the list
        for ($i = $var.value.next.data.index + 1; $i -lt $var.value.lod.length; $i++) {
            if ($var.value.lod[$i][1] -ne $var.value.lod[$var.value.next.data.index][1]) {
                cset toAc $var.value.lod[$i]
            }
        }
        cset q "lda=$([int]$var.value.fromAc[6] + 1) mcu=$($var.value.mcu.data.row[0].trim())"
        cset q (acFromToQ $var.value.q $var.value.fromAc[3].trim() $var.value.fromAc[4].trim() $var.value.toAc[3].trim() $var.value.toAc[4].trim())
        cset q "$($f0901) $($var.value.q)"
        # Submit the Query
        Submit-Celin.AIS.Query $var.value.q | cset rs
}
}