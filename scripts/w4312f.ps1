# Work With Open PO's type
class w4312f : jdeGridForm {
  static [string] $rc = "97|85|1[16,41,25,10,11,14,91,92]"
  [void] find() {
    $rs = step-celin.ais.script "do(21)" -max -1 -returnControlIDs ([w4312f]::rc)
    [jdeForm]::update($rs)
  }
  [void] select([int]$row) {
    $rs = step-celin.ais.script "select(1.$row) do(4)" -returnControlIDs ([w4312a]::rc)
    [jdeForm]::update($rs)
  }
  static open() {
    $rs = open-celin.ais.script "w4312f zjde0006" "do(21)" -max -1 -returnControlIDs ([w4312f]::rc)
    [jdeForm]::update($rs)
  }
  w4312f($rs) : base($rs) {}
}
# Add the type
[jdeForm]::addType(@{ Name = "*W4312F*"; Type = [w4312f] })

# Receipt a PO type
class w4312a : jdeGridForm {
  static [string] $rc = "1[382,116,117,103,40,44]"
  [void] receipt([int]$row) {
    $rs = step-celin.ais.script "update[1 ${row}:(382:1,117: )]" -returnControlIDs ([w4312a]::rc)
    [jdeForm]::update($rs)
  }
  [void] ok() {
    $r = step-celin.ais.script "do(4)" -returnControlIDs ([w4312f]::rc)
    [jdeForm]::update($r)
  }
  [void] cancel() {
    $r = step-celin.ais.script "do(5)" -returnControlIDs ([w4312f]::rc)
    [jdeForm]::update($r)
  }
  w4312a($rs) : base($rs) {}
}
# Add the type
[jdeForm]::addType(@{ Name = "*W4312A*"; Type = [w4312a] })
