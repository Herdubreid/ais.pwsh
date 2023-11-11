# Install State and CPO (both are in beta)
install-Module celin.state -AllowPrerelease
install-Module celin.po -AllowPrerelease
# import the parser module
import-module ./parser -scope Global -Force
# Set the Shopping list date (later used to cause exception)
$date = "4/10"
# Display the shopping list
./shopping-list
# Parse it
$result = parser (./shopping-list)
# Display the successfully parsed list
$result.success
# Display the failed lines
$result.failed
# Now invalidate the date to cause exception
$date = "11/23"
# Display the shopping list
./shopping-list
# Parse it
$result = parser (./shopping-list)
# Get the state variable for debugging
$shop = Use-Celin.State shop
# Only the last label and state appear in the trace
$shop.trace
# Expand the RegEx Matches results for more details
$shop.match.matches.groups | Select-Object success, name, value
# Parse the Shopping list witht the Trace flag
$result = parser (./shopping-list) $true
# Get the state variable for debugging
# The $shop variable holds the previous state
$shop = Use-Celin.State shop
# The trace has now keeps all the states so all the steps leading
# up to the exception can be examined
$shop.trace
# The trace can also be exported to Excel for analysis
$shop.trace | Export-Excel
