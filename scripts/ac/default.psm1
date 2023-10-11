function init {
    $global:hint = "Account Query (enter 'go' to start, 'q' to quit)"
    $global:ac = @{}

    $ac.gf = ConvertFrom-Celin.AIS.Ui.GridForm (getLayout base-grid)
    
    $rs = 
}

function go {
    param (
        [string] $cmd
    )
        
    if (-not $ac.mcus) {
        $ac.rs = Submit-Celin.AIS.Query "f0006 (mcu,styl,ldm,co,dl01)"
        $mcus = $ac.rs.data.detail
        $ac.rs = Submit-Celin.AIS.Query "f0901 [group(co,mcu) min(lda) max(lda) count(aid) asc(co,mcu)]"

    }
    
    $options = @("top")

    switch ($ac.next) {
        condition {  }
        Default {

        }
    }
}
