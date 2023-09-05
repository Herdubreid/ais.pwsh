# Receipt a PO type
class w4312a : jdeGridForm {
  static [string] $ctrls = "1[382,116,117,103,40,44]"
  [void] receipt([int]$row) {
    $rs = step-celin.ais.script "update[1 ${row}:(382:1,117: )]" -returnControlIDs ($global:ctrlIDs["w4312a"])
    [jdeForm]::update($rs)
  }
  [void] ok() {
    $r = step-celin.ais.script "do(4)" -returnControlIDs ([w4312f]::ctrls)
    [jdeForm]::update($r)
  }
  [void] cancel() {
    $r = step-celin.ais.script "do(5)" -returnControlIDs ([w4312f]::ctrls)
    [jdeForm]::update($r)
  }
  w4312a($rs) : base($rs) {}
}
# Add the type
[jdeForm]::types.add(@{ Name = "*W4312A*"; Type = [w4312a] })
