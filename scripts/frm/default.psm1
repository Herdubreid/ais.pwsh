function init {
    $global:hint = "Form Query (enter 'go' to start, 'q' to quit)"
    getScript qop

    $global:frm = @{}
    $frm.search = convertFrom-celin.ais.ui.form (getLayout form-search)
    $frm.select = convertfrom-celin.ais.ui.gridform (getLayout form-select)
    $frm.pb = ConvertFrom-celin.ais.ui.progressbar (getLayout pb)
}

function go {
    try {
        $flt = show-celin.ais.ui.form $frm.search
        if ($flt) {
            $s = "f9865 (fmnm,md,fmpt,sy) all($(qop "fmnm" "^" $flt.data[0].value.toupper()) $(qop "md" "?" $flt.data[1].value) $(qop "fmpt" "=" $flt.data[2].value.toupper()) $(qop "sy" "^" $flt.data[3].value)".trim() + ")"
            
            show-celin.ais.ui.progressbar { $frm.rs = submit-celin.ais.query $s } $frm.pb
            
            $frm.select.set($frm.rs.data)
            $form = show-celin.ais.ui.gridform $frm.select
            if ($form) {
                $frm.demo = get-celin.ais.ui $form.data[0].row[0]
            }
        }
    }
    catch {
        write-host $_ -ForegroundColor Red
    }
}

function q {
    Remove-Item function:\go
    $global:hint = $null
    Clear-Host
}
