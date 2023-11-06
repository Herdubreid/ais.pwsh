# Construct a Hashtable
$ht = @{ a = "This is a in Hashtable" }
$ht.GetType()
# Construct a PSCustomObject
$po = [PSCustomObject]@{ b = "This b in PSCustomObject" }
$po.GetType()
# Members can be accessed with the dot syntax
$ht.a
$po.b
# By default, the Hashtable is displayed vertically
$ht
# But the PSCustomObject horizontally
$po
# Members can be appended to Hashtable
$ht += @{ c = "This is added member c in Hashtable" }
$ht
# But fails with PSCustomObject
$poToAdd = [PSCustomObject]@{ d = "Try to add member d to PSCustomObject" }
$po += $poToAdd
# Instead, this is the recommended method!
$poToAdd.PSObject.Properties | ForEach-Object { $po | Add-Member -MemberType NoteProperty -Name $_.Name -Value $_.Value }
$po
