# Init
. get-script jdeForm,jdeGridForm,w48201f,w17714a,w004201b

set-celin.ais.ui main (get-layout main)
$pb = convertFrom-celin.ais.ui.progressbar (get-layout pb)
$errorMsg = convertFrom-celin.ais.ui.prompt (get-layout error-msg)
$w48201f = convertFrom-celin.ais.ui.gridform (get-layout w48201f)
$w17714a = convertFrom-celin.ais.ui.form (get-layout w17714a)

# WO Entry Routine
$pb.text = "Fetching WO's..."
show-celin.ais.ui.progressbar { [w48201f]::open() } $pb

do {
  remove-variable sel,rec,opt -errorAction silentlycontinue

  $w48201f.child.body.data = $jde.grid.detail
  $sel = show-celin.ais.ui.gridform $w48201f
  
  if ($sel) {
    $pb.text = "Select WO..."
    show-celin.ais.ui.progressbar { $jde.select($sel[0].index) } $pb
    
    if ($jde.error) {
      $errorMsg.child.message.text = $jde.rs.error
      $opt = show-celin.ais.ui.prompt $errorMsg
    }
    
    if ($opt -eq 0) {
      $pb.text = "Cancel..."
      show-celin.ais.ui.progressbar { $jde.cancel() } $pb      
    } else {
      $jde.map($w17714a.child.panes)
      $fm = show-celin.ais.ui.form $w17714a
      
      if (-not $fm) {
        $pb.text = "Cancel..."
        show-celin.ais.ui.progressbar { $jde.cancel() } $pb
      }  else {
        $pb.text = "Saving Changes..."
        show-celin.ais.ui.progressbar {
          $jde.ok($fm)
        } $pb
        if ($jde -is [w004201b]) {
          $jde.cancel()
        }
        if ($jde.error) {
          $errorMsg.child.message.text = $jde.rs.error
          show-celin.ais.ui.prompt $errorMsg
          $pb.text = "Error..."
          show-celin.ais.ui.progressbar { $jde.cancel() } $pb          
        }
      }
    }
  }
} until (-not $sel)
