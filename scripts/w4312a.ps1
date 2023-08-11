# Receipt a PO type
class w4312a : jdeGridForm {
  [void] receipt([int]$row) {
    $rs = step-celin.ais.script "update[1 ${row}:(382:1,117: )]" -returnControlIDs ($global:ctrlIDs["w4312a"])
    [jdeForm]::update($rs)
  }
  [void] ok() {
    $r = step-celin.ais.script "do(4)" -returnControlIDs ($global:ctrlIDs["w4312f"])
    [jdeForm]::update($r)
  }
  [void] cancel() {
    $r = step-celin.ais.script "do(5)" -returnControlIDs ($global:ctrlIDs["w4312f"])
    [jdeForm]::update($r)
  }
  w4312a($rs) : base($rs) {}
}
# Add the returnControlIDs
$ctrlIDs["w4312a"] = "1[382,116,117,103,40,44]"
# Add the type
[jdeForm]::types.add(@{ Name = "*W4312A*"; Type = [w4312a] })
