# Fetch PO's for P01012
go P01012
# Get the State Variable
$po = Use-Celin.State po
# The PO for each Version has a label, so we can collect them
# in one go and export to excel
$po.labels.po | Export-Excel
