# Init
$global:hint = "Item Search & Select (enter 'find' followed by search paramters)"

. getScript qop
$select = convertfrom-celin.ais.ui.gridform (getLayout item-select)
$select.many = $true
$select.title = "Select Items"

# Find & Select
function find {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]] $desc
    )

    try {

        foreach ($s in $desc) {
            $q += "any($(qop litm ? $s) $(qop dsc1 ? $s $(qop dsc2 ? $s)))"
        }
        $rs = Submit-Celin.AIS.Query "f4101 (litm,dsc1,dsc2,stkt,lnty) $q"
        if ($rs.data.grid.detail.length -gt 0) {
            $select.set($rs.data)
            $items = Show-Celin.AIS.Ui.GridForm $select
            $global:items = $items.data | Select-Object Row
        }
        else {
            Write-Output "No matching records!"
        }
    }
    catch {
        Write-Host $_ -ForegroundColor Red
    }
}
