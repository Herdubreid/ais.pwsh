class w004201b : jdeGridForm {
  static [string] $ctrls = ""
  [void] ok() {
    $r = step-celin.ais.script "do(12)"
    [jdeForm]::update($r)
  }
  [void] cancel() {
    $r = step-celin.ais.script "do(13)"
    [jdeForm]::update($r)
  }
  w004201b($rs) : base($rs) {}
}
# Add the type
[jdeForm]::types.add(@{ Name = "*W004201B*"; Type = [w004201b] })
