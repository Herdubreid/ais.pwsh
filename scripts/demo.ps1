# Display the 
# Get the state, the match displays matched string or False
$shop = Use-Celin.State shop
# Dump state trace
$shop.trace
# Use the ExpandProperty to display captured values
$shop.trace | Select-Object -ExpandProperty caps | more
# Use foreach to display the Matches.Groups values
$shop.trace | ForEach-Object { $_.match.matches.groups } | more
# Select captured fields and export them to Excel
$shop.trace | ForEach-Object { $_.match.matches.groups } | Select-Object success, name, value | export-excel

$shop.caps | ForEach-Object -Begin {
    $v = @{} } -Process {
    $v | Add-Member -MemberType NoteProperty -Name $_.Name -Value $_.Value
} -End { return $v }
    