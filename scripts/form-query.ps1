# Init
. get-script jdeForm,jdeGridForm

set-celin.ais.ui main (get-layout dark)
$fm = convertFrom-celin.ais.ui.form (get-layout form-search)

$flt = show-celin.ais.ui.form $fm

$s = "f9865 (fmnm,md,fmpt,sy) all($(qop "fmnm" "^" $flt[0].value.toupper()) $(qop "md" "?" $flt[1].value) $(qop "fmpt" "=" $flt[2].value.toupper()) $(qop "sy" "^" $flt[3].value)".trim() + ")"