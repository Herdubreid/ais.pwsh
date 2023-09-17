# Init
. getScript qop
$select = convertfrom-celin.ais.ui.gridform (getLayout item-select)

# Call
function find {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]] $desc
    )

    foreach ($s in $desc) {
        $q += "any($(qop litm ? $s) $(qop dsc1 ? $s $(qop dsc2 ? $s)))"
    }
    $rs = Submit-Celin.AIS.Query "f4101 (litm,dsc1,dsc2,stkt,lnty) $q"
    if ($rs.data.grid.detail.length -gt 0) {
        $select.set($rs.data)
        Show-Celin.AIS.Ui.GridForm $select | Out-Null
    }
    else {
        Write-Output "No matching records!"
    }
}
