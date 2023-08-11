# Receipt a PO type
class w4312a : jdeGridForm {
  [void] receipt([int]$row) {
    $rs = step-celin.ais.script "update[1 ${row}:(382:1,117: )]" -returnControlIDs ([w4312a]::ctrlIds)
    [jdeForm]::update($rs)
  }
  [void] ok() {
    $r = step-celin.ais.script "do(4)" -returnControlIDs ([w4312f]::ctrlIds)
    [jdeForm]::update($r)
  }
  [void] cancel() {
    $r = step-celin.ais.script "do(5)" -returnControlIDs ([w4312f]::ctrlIds)
    [jdeForm]::update($r)
  }
  w4312a($rs) : base($rs) {}
  #  Set the returnControlIDs
  static [string] $ctrlIds = "1[382,116,117,103,40,44]"
}
# Add the type
[jdeForm]::types.add(@{ Name = "*W4312A*"; Type = [w4312a] })
