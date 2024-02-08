
# Fetch PO's for P01012
go P01012
# Get the State Variable
$po = Use-Celin.State po
# The PO for each Version has a label, so we can collect them
# in one go and export to excel
$po.getLabels.po | Export-Excel

# Fetch Specs for R42565
go r42565
# Get the State Variable
$po = Use-Celin.State po
# Get the Tab Page's Controls with the Fields we want
# We only need this once
$controls = $po.po.data.poprompt.tabpages.controls | Select-Object pageNumber, title, memberName, idObject
# Get the PO values for each version
$pos = $po.getLabels.po.data | Select-Object reportVersion, poValues
# Define PoValue lookup
$poLookup = { param($id) $pos | ForEach-Object {@{ $_.reportVersion = $_.poValues.where({$_.id -eq $id }).value }}}
# Add version PO values
$vers = $controls | ForEach-Object { cpo $_, (cpo $poLookup.Invoke($_.idObject)) }
# Export to Excel
$vers | Export-Excel
