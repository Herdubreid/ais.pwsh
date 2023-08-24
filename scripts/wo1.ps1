# Init
. get-script jdeForm,jdeGridForm,w48201f,w17714a
$pb = convert-celin.ais.ui.progressbar (get-layout pb)
$errorMsg = convert-celin.ais.ui.prompt (get-layout error-msg)
$w48201f = convert-celin.ais.ui.gridform (get-layout w48201f)
$w17714a = convert-celin.ais.ui.gridform (get-layout w17714a)

# Receipting Routine
$pb.title = "Fetching WO's..."
show-celin.ais.ui.progressbar { [w48201f]::open() } $pb

do {
  remove-variable sel,rec,opt -errorAction silentlycontinue

  $w48201f.child.body.data = $jde.grid.detail
  $sel = show-celin.ais.ui.gridform $w48201f
  
  if ($sel) {
    $pb.title = "Select WO..."
    show-celin.ais.ui.progressbar { $jde.select($sel[0].index) } $pb
    
    if ($jde.error) {
      $errorMsg.child.message.text = $jde.rs.error
      $opt = show-celin.ais.ui.prompt $errorMsg
    }
    
    if ($opt -eq 0) {
      $pb.title = "Cancel..."
      show-celin.ais.ui.progressbar { $jde.cancel() } $pb      
    } else {
      $w17714a.child.body.data = $jde.grid.detail
      $rec = show-celin.ais.ui.gridform $w17714a
      
      if (-not $rec) {
        $pb.title = "Cancel..."
        show-celin.ais.ui.progressbar { $jde.cancel() } $pb
      }  else {
        $pb.title = "Receipting..."
        show-celin.ais.ui.progressbar {
          $jde.receipt($rec[0].index)
          $jde.ok()
        } $pb
        if ($jde.error) {
          $errorMsg.child.message.text = $jde.rs.error
          show-celin.ais.ui.prompt $errorMsg
          $pb.title = "Receipting Failed..."
          show-celin.ais.ui.progressbar { $jde.cancel() } $pb          
        } else {
          $pb.title = "Refreshing Order List..."
          show-celin.ais.ui.progressbar { $jde.find() } $pb          
        }
      }
    }
  }
} until (-not $sel)
