# Restore connection
restore-celin.ais steltix (import-clixml steltix.xml)
# Start the Form Query
use frm
# Run
go
w4102
# Display the Selected Fields
$frm.demo.form | Select-Object id, text | format-table
# Namespace shortcut
using namespace Celin.AIS.Pwsh.Ui
# Create a new Form
$form = New-Object FormUi
# Add Pane
$form.addPane()
# Populate the Form
foreach ($fld in $frm.demo.form) {
    Write-Host "Adding $($fld.text)..."
    $form.panes[0].add($fld)
}
# Show the Form
Show-Celin.AIS.Ui.Form $form
# Convert the Form to Json
ConvertTo-Celin.AIS.Ui.Form $form | Out-File test.json
# Display the json layout
more test.json
