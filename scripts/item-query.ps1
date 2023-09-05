# Init
. getScript jde-form,jde-grid-form,qop
    
set-celin.ais.ui main (getLayout dark)
$search = convertFrom-celin.ais.ui.form (getLayout item-search)
$select = convertfrom-celin.ais.ui.gridform (getLayout item-select)

do {
    remove-variable flt,item -errorAction silentlycontinue
    $flt = show-celin.ais.ui.form $search
    if ($flt) {
        [w4101e]::open($flt)        
        $select.body.data = $jde.grid.detail
        $item = show-celin.ais.ui.gridform $select
        $jde.exit()
    }
} until (-not $item)
