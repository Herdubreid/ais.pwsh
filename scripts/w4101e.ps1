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
    static [string] $ctrls = "1[123,9,82,113,114]" 
    w4101e($rs) : base($rs) {}
    [void] select([int]$row) {
        $rs = step.celin.ais.script "select(1.$row) do(4)"
        [jdeForm]::update($rs)
    }
    static open($flt) {
        $q = "all($(qop "1[123]" "?" $flt[0].value.toupper())) "
        $q += ($flt[1].value.split(' ') | foreach-object {
                "any($(qop "1[9]" "?" $_) $(qop "1[82]" "?" $_))"
            }) -join ' '
  
        $rs = open-celin.ais.script "w4101e" -query $q -returnControlIDs [w4101e]::$ctrls
        [jdeForm]::update($rs)
    }
}
[jdeForm]::types.add(@{ Name = "*W4101E*"; Type = [w4101e] })
