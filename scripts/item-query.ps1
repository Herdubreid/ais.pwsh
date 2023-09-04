# Init
. get-script qop
    
set-celin.ais.ui main (get-layout dark)
$search = convertFrom-celin.ais.ui.form (get-layout item-search)
$select = convertfrom-celin.ais.ui.gridform (get-layout item-select)

$flt = show-celin.ais.ui.form $search
$q = "all($(qop "1[123]" "?" $flt[0].value.toupper())) "
$q += ($flt[1].value.split(' ') | foreach-object {
     "any($(qop "1[9]" "?" $_) $(qop "1[82]" "?" $_))"
    }) -join ' '

$rs = submit-celin.ais.query $s
$select.body.data = $rs.data.grid.detail
    
remove-variable form, demo -errorAction silentlycontinue
$form = show-celin.ais.ui.gridform $select
if ($form) {
    $demo = new-celin.ais.ui $form[0].row[0]
    if ($demo) {
        makeClass $form[0].row[0] $demo | out-file "$($form[0].row[0].tolower()).ps1"
    }
}
