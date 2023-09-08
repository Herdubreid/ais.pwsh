# Init
. getScript qop, make-class

set-celin.ais.ui main (getLayout green)
set-celin.ais.ui high (getLayout green-high)
$search = convertFrom-celin.ais.ui.form (getLayout form-search)
$select = convertfrom-celin.ais.ui.gridform (getLayout form-select)
$pb = ConvertFrom-celin.ais.ui.progressbar (getLayout pb)

function go {
    try {
        $flt = show-celin.ais.ui.form $search
        $s = "f9865 (fmnm,md,fmpt,sy) all($(qop "fmnm" "^" $flt.data[0].value.toupper()) $(qop "md" "?" $flt.data[1].value) $(qop "fmpt" "=" $flt.data[2].value.toupper()) $(qop "sy" "^" $flt.data[3].value)".trim() + ")"

        show-celin.ais.ui.progressbar { $global:rs = submit-celin.ais.query $s } $pb
        $select.set($rs.data)
        
        remove-variable form, demo -errorAction silentlycontinue
        $form = show-celin.ais.ui.gridform $select
        if ($form) {
            $demo = get-celin.ais.ui $form.value[0].row[0]
            if ($demo) {
                return makeClass $form.value[0].row[0] $demo
            }
        }
    }
    catch {
        write-host $_ -ForegroundColor Red
    }
}
