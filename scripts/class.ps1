# Menu 11, OK
# Menu 12, Cancel
# Form 194, AAI's
# Form 201, Conversions
# Form 196, Internal Attachment
# Form 202, Item Notes
# Form 199, Item Availability
# Form 200, Regional Info.

class w4101a : jdeGridForm { 
  static [string] $rc = "13|23|24|25|26|27|28|29"
  [void] ok($fm) {
    $s = $this.set($fm)
    $rs = Step-Celin.AIS.Script "$s do(11)"
    [jdeForm]::update($rs)
  }
  [void] cancel() {
    $rs = Step-Celin.AIS.Script "do(12)"
    [jdeForm]::update($rs)
  }
  w4101a($rs) : base($rs) {}
}
[jdeForm]::addType(@{ Name = "*W4101A*"; Type = [w4101a] })

# Menu 4, Select
# Menu 22, Find
# Menu 17, Add
# Menu 75, Copy
# Menu 19, Delete
# Menu 5, Close
# Form 129, Item Word Search
# Row 153, Item Features
# Row 132, Item Revisions
# Row 133, Category Codes
# Row 134, Addl System Info
# Row 135, Storage/Shipping
# Row 139, Cost Revisions
# Row 69, Price Revisions
# Row 71, Item Availability
# Row 72, Item Branch
# Row 108, Item Notes
# Row 70, Internal Attachment
# Row 77, Item Alt Desc
# Row 137, Segmented Itm Avai
# Row 124, Product Mix
# Row 130, Regional Info
class w4101e : jdeGridForm { 
  static [string] $rc = "1[9,31,82,89,123]"
  [void] add() {
    $rs = Step-Celin.AIS.Script "do(17)" -returnControlIDs ([w4101a]::rc)
    [jdeForm]::update($rs)
  }
  [void] select([int]$row) {    
    $rs = Step-Celin.AIS.Script "select(1.$row) do(4)" -returnControlIDs ([w4101a]::rc)
    [jdeForm]::update($rs)
  }
  static [void] open($qry) {
    $rs = Open-Celin.AIS.Script "w4101e zjde0001" $qry -returnControlIDs ([w4101e]::rc)
    [jdeForm]::update($rs)
  }
  w4101e($rs) : base($rs) {}
}
[jdeForm]::addType(@{ Name = "*W4101E*"; Type = [w4101e] })
