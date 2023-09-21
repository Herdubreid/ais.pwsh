# Receipt a PO type
class w4312a : jdeGridForm {
  static [string] $ctrls = "1[382,116,117,103,40,44]"
  [void] receipt([int]$row) {
    $rs = step-celin.ais.script "update[1 ${row}:(382:1,117: )]" -returnControlIDs ([w4312a]::ctrls)
    [jdeForm]::update($rs)
  }
  [void] ok() {
    $r = step-celin.ais.script "do(4)"
    [jdeForm]::update($r)
  }
  [void] cancel() {
    $r = step-celin.ais.script "do(5)"
    [jdeForm]::update($r)
  }
  w4312a($rs) : base($rs) {}
}
# Add the type
[jdeForm]::types.add(@{ Name = "*W4312A*"; Type = [w4312a] })
