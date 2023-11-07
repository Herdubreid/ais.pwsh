# Install cpo
install-Module celin.po -AllowPrerelease
# Construct couple of Hashtables
$ht1 = @{ a = "This is a in Hashtable" }
$ht2 = @{ b = "This is b in Hashtable" }
# Construct couple of PSCustomObjects
$po1 = [PSCustomObject]@{ b = "This b in PSCustomObject" }
$po2 = [PSCustomObject]@{ c = "This c in PSCustomObject" }
# Create a new PSCustomObject with cpo (Alias for Add-Celin.Po)
$o = cpo $po1, $ht1, $ht2, $po2
$o.gettype()
# Display the values.  Note that b is from $ht2, since it follows $po1
# Similar to JavaScript's { ...po1, ...ht1, ...ht2, ...po2 }
$o
