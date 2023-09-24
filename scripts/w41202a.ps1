# Menu 4, Select
# Menu 14, Find
# Menu 5, Close
# Form 131, Item Master
# Form 128, Item Search
# Form 135, Item Notes
# Form 138, Cross Reference
# Form 126, Customer Service
# Form 127, Open PO
# Form 136, Price/Availability
# Form 137, Location Revisions
# Form 140, Lot Availability
# Form 139, BOM Inquiry
# Form 165, Supply and Demand
# Form 166, Scheduling Wrkbnch
# Row 121, Detail Avail
# Row 120, Item Branch
# Row 122, Item Ledger
# Row 123, Item Cost
# Row 124, Location Detail
# Row 274, Configuration
# Row 342, Evaluate Inquiry
# Row 143, Attachments

class w41202a : jdeGridForm { 
  static [string] $rc = "17|30|319[9,10,13,33,36,46]"
  [void] openPo() {
    $rs = step-celin.ais.script "do(127)"
    [jdeForm]::update($rs)
  }
  [void] find([string]$item) {
    $rs = step-celin.ais.script "set(17,$item) do(14)" -returnControlIDs ([w41202a]::rc)
    [jdeForm]::update($rs)
  }
  static open() {
    $rs = Open-Celin.AIS.Script "w41202a zjde0001" -returnControlIDs ([w41202a]::rc)
    [jdeForm]::update($rs)
  }
  w41202a($rs) : base($rs) {}
}
[jdeForm]::types.add(@{ Name = "*W41202A*"; Type = [w41202a] })
