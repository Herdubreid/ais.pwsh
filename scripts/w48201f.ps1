# Work With Open PO's type
class w48201f : jdeGridForm {
  [void] find() {
    $rs = step-celin.ais.script "do(6)" -max -1 -returnControlIDs ($global:ctrlIDs["w48201f"])
    [jdeForm]::update($rs)
  }
  [void] select([int]$row) {
    $rs = step-celin.ais.script "select(1.$row) do(4)" -returnControlIDs ($global:ctrlIDs["w17714a"])
    [jdeForm]::update($rs)
  }
  static open() {
    $rs = open-celin.ais.script "w48201f zjde0002" "do(6)" -max -1 -returnControlIDs ($global:ctrlIDs["w48201f"])
    [jdeForm]::update($rs)
  }
  w48201f($rs) : base($rs) {}
}
# Add the returnControlIDs
$ctrlIDs["w48201f"] = "1[7,217,447,448,129,487,18]"
# Add the type
[jdeForm]::types.add(@{ Name = "*W48201F*"; Type = [w48201f] })
