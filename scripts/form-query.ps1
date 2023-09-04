# Init
. get-script jdeForm,jdeGridForm,qop,make-class

set-celin.ais.ui main (get-layout dark)
$search = convertFrom-celin.ais.ui.form (get-layout form-search)
$select = convertfrom-celin.ais.ui.gridform (get-content form-select)

do {
    $flt = show-celin.ais.ui.form $search
    $s = "f9865 (fmnm,md,fmpt,sy) all($(qop "fmnm" "^" $flt[0].value.toupper()) $(qop "md" "?" $flt[1].value) $(qop "fmpt" "=" $flt[2].value.toupper()) $(qop "sy" "^" $flt[3].value)".trim() + ")"
    
    $rs = submit-celin.ais.query $s
    $select.body.data = $rs.data.grid.detail

    remove-variable form, demo -errorAction silentlycontinue
    $form = show-celin.ais.ui.gridform $select
    if ($form) {
        $demo = new-celin.ais.ui $formsel[0].Row[0]
        if ($demo) {
            makeClass $form[0].row[0] $demo | out-file "$($form[0].row[0].tolower()).ps1"
        }
    }
} until(-not $form)
