# Init
$datefmt = "MM/dd/yyyy"
. getScript jde-form, jde-grid-form, w17714a, w48201f, w004201b

set-celin.ais.ui main (getLayout green)
set-celin.ais.ui high (getLayout green-high)
$pb = convertFrom-celin.ais.ui.progressbar (getLayout pb)
$errorMsg = convertFrom-celin.ais.ui.prompt (getLayout error-msg)
$w48201f = convertFrom-celin.ais.ui.gridform (getLayout w48201f)
$w17714a = convertFrom-celin.ais.ui.form (getLayout w17714a)


# WO Entry Routine
$pb.title = "Fetching WO's..."
show-celin.ais.ui.progressbar { [w48201f]::open() } $pb
$w48201f.body.data = $jde.grid.detail

# Call
function go {
  try {

    remove-variable sel, rec, opt -errorAction silentlycontinue
    
    $sel = show-celin.ais.ui.gridform $w48201f
    
    if ($sel) {
      $pb.title = "Select WO..."
      show-celin.ais.ui.progressbar { $jde.select($sel.data[0].index) } $pb
      
      if ($jde.error) {
        $errorMsg.message.text = $jde.rs.error
        $opt = show-celin.ais.ui.prompt $errorMsg
      }
      
      if ($opt -eq 0) {
        $pb.title = "Cancel..."
        show-celin.ais.ui.progressbar { $jde.cancel() } $pb      
      }
      else {
        $jde.map($w17714a.panes)
        $fm = show-celin.ais.ui.form $w17714a
      
        if (-not $fm) {
          $pb.title = "Cancel..."
          show-celin.ais.ui.progressbar { $jde.cancel() } $pb
        }
        else {
          $pb.title = "Saving Changes..."
          show-celin.ais.ui.progressbar {
            $jde.ok($fm.data)
          } $pb
          if ($jde.error) {
            $errorMsg.message.text = $jde.rs.error
            show-celin.ais.ui.prompt $errorMsg
            $pb.title = "Error..."
            show-celin.ais.ui.progressbar { $jde.cancel() } $pb          
          }
          else {
            if ($jde -isnot [w48201f]) {
              $jde.cancel()
            }
          }
        }
      }
    }
  }
  catch {
    write-host $_ -ForegroundColor Red   
  }
}
