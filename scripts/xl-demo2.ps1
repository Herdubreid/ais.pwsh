# Start Excel
xlStart
# Create JDE App
# (Work With Order Header)
$jde = new-celin.ais.script "w4310i,zjde0006"

# Populate the Worksheet
2xl

# Execute Find
$jde.find

# Refresh the Worksheet
2xl

# Select Row 10 (Order 32)
$jde.selectrow(10)

# Execute Select (opens Order Header)
$jde.select

# Refresh the Worksheet 
2xl

# Execute Ok (opens Order Detail)
$jde.ok()

# Refresh the Worksheet
2xl

# Execute Cancel
# (back to Work With Order Header)
$jde.cancel()

# Refresh the Woorksheet
2xl

# Exit the Session
$jde.exit()
