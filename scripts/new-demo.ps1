# Create a new W01012B 'Work With Addresses' app
$ab = new-celin.ais.script "w01012b"
$ab.title
# Display available fields
$ab.formfields
# Display available menu options
$ab.controls
# Execute Find
$ab.find
# The grid results are stored in Detail and Header properties
# and have the same functionality as Query and Script results
$ab.detail.count()
# Send the grid results to Excel
$ab.detail.totable($ab.header.titles) | export-excel
# Select grid row 24
# Rows are zero-indexed so use the Excel row -2
$ab.selectrow(24)
# Execute select (the Select/OK button)
$ab.select
# The Revision form is opened
$ab.title
# Display available menu options
$ab.controls
# Send the fields to Excel
$ab.formfields | export-excel
# Update "Address Line 2" using the Id
$ab[42] = "In the Basement"
# Verify the field has been updated
$ab.formfields | export-excel
# Save the changes (press the Ok button)
# By appending '()' we mark this as an Action
$ab.ok()
# Close the form with cancel action
$ab.cancel()
# We are now back in 'Work With Addresses'
$ab.title
# Exit the statck
$ab.exit()
