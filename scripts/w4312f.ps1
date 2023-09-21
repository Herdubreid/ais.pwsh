# Work With Open PO's type
class w4312f : jdeGridForm {
  static [string] $ctrls = "97|85|1[16,41,25,10,11,14,91,92]"
  [void] find() {
    $rs = step-celin.ais.script "do(21)" -max -1 -returnControlIDs ([w4312f]::ctrls)
    [jdeForm]::update($rs)
  }
  [void] select([int]$row) {
    $rs = step-celin.ais.script "select(1.$row) do(4)" -returnControlIDs ([w4312a]::ctrls)
    [jdeForm]::update($rs)
  }
  static open() {
    $rs = open-celin.ais.script "w4312f zjde0006" "do(21)" -max -1 -returnControlIDs ([w4312f]::ctrls)
    [jdeForm]::update($rs)
  }
  w4312f($rs) : base($rs) {}
}
# Add the type
[jdeForm]::addType(@{ Name = "*W4312F*"; Type = [w4312f] })
