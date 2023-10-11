# Fetch BU Master
$rs = Submit-Celin.AIS.Query "f0006 -max no (mcu,styl,ldm,co,dl01)"
# Store the Grid
$mcus = $rs.data.grid
# Fetch the BU Account Stats
$rs = Submit-Celin.AIS.Query "f0901 [group(co,mcu) min(lda) max(lda) count(aid) asc(co,mcu)]"
# Store the Grid
$g = $rs.data.grid
# Create a Joined Grid (using MCU)
$j = $mcus.join($g, "MCU")
# Display the Heading
$j.header
# Get a base Grid Form
$gf = ConvertFrom-Celin.AIS.Ui.GridForm (getLayout base-grid)
# Set Title and Color
$gf.title = "Business Unit Accounts"
$gf.color = "high"
# Set the Header
$gf.header.format = "{0,12} {1,7} {2,-30} {3,-4} {4,-3} {5,-8} {6,-8} {7,12}"
$gf.header.data = @("BU#","Company","Description","Type","LOD","From LOD", "To LOD","No.Accounts")
# Set the Body Format
$gf.body.format = "{0,12} {3,7} {4,-30} {1,-4} {2,-3} {7,-8} {8,-8} {9,12}"
# Use the Joined Detail
$gf.set($j.detail)
# Show the form
Show-Celin.AIS.Ui.GridForm $gf
