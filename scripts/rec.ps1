# Init
$global:hint = "PO Receipting routine (enter 'go' to start, 'q' to quit)"

. getScript jde-base, w4312f

set-celin.ais.ui main (getLayout green)
set-celin.ais.ui high (getLayout green-high)

$pb = convertFrom-celin.ais.ui.progressbar (getLayout pb)
$errorMsg = convertFrom-celin.ais.ui.prompt (getLayout error-msg)
$w4312f = convertFrom-celin.ais.ui.gridform (getLayout w4312f)
$w4312a = convertFrom-celin.ais.ui.gridform (getLayout w4312a)

# Receipting Routine
function go {

  try {
    
    $pb.title = "Fetching Open PO's..."
    show-celin.ais.ui.progressbar { [w4312f]::open() } $pb
    
    do {
      remove-variable sel, rec, opt -errorAction silentlycontinue
      
      $w4312f.body.data = $jde.grid.detail
      $sel = show-celin.ais.ui.gridform $w4312f
      
      if ($sel) {
        $pb.title = "Select Row..."
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
          $w4312a.body.data = $jde.grid.detail
          $rec = show-celin.ais.ui.gridform $w4312a
          
          if (-not $rec) {
            $pb.title = "Cancel..."
            show-celin.ais.ui.progressbar { $jde.cancel() } $pb
          }
          else {
            $pb.title = "Receipting..."
            show-celin.ais.ui.progressbar {
              $jde.receipt($rec.data[0].index)
              $jde.ok()
            } $pb
            if ($jde.error) {
              $errorMsg.message.text = $jde.rs.error
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
    write-host $_ -ForegroundColor Red   
  }
}

function q {
  Remove-Item function:\go
  $global:hint = $null
  $jde.exit()
  Clear-Host
}
