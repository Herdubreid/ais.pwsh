# Init
. get-script jdeForm, jdeGridForm, w4312f, w4312a
$pb = convert-celin.ais.ui.progressbar (get-layout pb)
$errorMsg = convert-celin.ais.ui.prompt (get-layout error-msg)
$w4312f = convert-celin.ais.ui.gridform (get-layout w4312f)
$w4312a = convert-celin.ais.ui.gridform (get-layout w4312a)

try {

  # Receipting Routine
  $pb.title = "Fetching Open PO's..."
  show-celin.ais.ui.progressbar { [w4312f]::open() } $pb
  
  do {
    remove-variable sel, rec, opt -errorAction silentlycontinue
    
    $w4312f.child.body.data = $jde.grid.detail
    $sel = show-celin.ais.ui.gridform $w4312f
    
    if ($sel) {
      $pb.title = "Select Row..."
      show-celin.ais.ui.progressbar { $jde.select($sel[0].index) } $pb
    
      if ($jde.error) {
        $errorMsg.child.message.text = $jde.rs.error
        $opt = show-celin.ais.ui.prompt $errorMsg
      }
    
      if ($opt -eq 0) {
        $pb.title = "Cancel..."
        show-celin.ais.ui.progressbar { $jde.cancel() } $pb      
      }
      else {
        $w4312a.child.body.data = $jde.grid.detail
        $rec = show-celin.ais.ui.gridform $w4312a
      
        if (-not $rec) {
          $pb.title = "Cancel..."
          show-celin.ais.ui.progressbar { $jde.cancel() } $pb
        }
        else {
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
          }
          else {
            $pb.title = "Refreshing Order List..."
            show-celin.ais.ui.progressbar { $jde.find() } $pb          
          }
        }
      }
    }
  } until (-not $sel)
} catch {
  trhow $_
}
