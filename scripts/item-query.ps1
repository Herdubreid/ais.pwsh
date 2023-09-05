# Init
. getScript qop, jde-form, jde-grid-form, w4101e
    
set-celin.ais.ui main (getLayout dark)
$search = convertFrom-celin.ais.ui.form (getLayout item-search)
$select = convertfrom-celin.ais.ui.gridform (getLayout item-select)
$pb = convertfrom-celin.ais.ui.progressbar (getLayout pb)

# Call
function go {
    try {
        do {
            remove-variable flt, item -errorAction silentlycontinue
            $flt = show-celin.ais.ui.form $search
            $search.set($flt.data)
            if ($flt) {
                show-celin.ais.ui.progressbar { [w4101e]::open($flt.data) } $pb
                $select.body.data = $jde.grid.detail
                $item = show-celin.ais.ui.gridform $select
                $jde.exit()
            }
        } until ($item.key -ne "S")
    }
    catch {
        write-host $_
    }
    return $item
}
