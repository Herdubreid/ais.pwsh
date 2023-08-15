# Work With Open PO's type
class w4312f : jdeGridForm {
  [void] find() {
    $rs = step-celin.ais.script "do(21)" -returnControlIDs ($global:ctrlIDs["w4312f"])
    [jdeForm]::update($rs)
  }
  [void] select([int]$row) {
    $rs = step-celin.ais.script "select(1.$row) do(4)" -returnControlIDs ($global:ctrlIDs["w4312a"])
    [jdeForm]::update($rs)
  }
  static open() {
    $rs = open-celin.ais.script "w4312f zjde0006" "do(21)" -max -1 -returnControlIDs ($global:ctrlIDs["w4312f"])
    [jdeForm]::update($rs)
  }
  w4312f($rs) : base($rs) {}
}
# Add the returnControlIDs
$ctrlIDs["w4312f"] = "97|85|1[16,41,25,10,11,14,91,92]"
# Add the type
[jdeForm]::types.add(@{ Name = "*W4312F*"; Type = [w4312f] })
