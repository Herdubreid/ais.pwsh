class w17714a : jdeGridForm {
  [void] ok() {
    $r = step-celin.ais.script "do(11)"
    [jdeForm]::update($r)
  }
  [void] cancel() {
    $r = step-celin.ais.script "do(12)"
    [jdeForm]::update($r)
  }
  w4312a($rs) : base($rs) {}
}
# Add the returnControlIDs
$ctrlIDs["w17714a"] = "508|510|208|210|400"
# Add the type
[jdeForm]::types.add(@{ Name = "*W17714A*"; Type = [w1774a] })
