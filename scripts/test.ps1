# Init
$Global:ac = @{}
# Fetch BU Master
$ac.rs = Submit-Celin.AIS.Query "f0006 -max no (mcu,styl,ldm,co,dl01)"
# Store the Grid
$ac.mcus = $ac.rs.data.grid
# Fetch the BU Account Stats
$ac.rs = Submit-Celin.AIS.Query "f0901 [group(co,mcu) min(lda) max(lda) count(aid) asc(co,mcu)]"
# Store the Grid
$ac.g = $ac.rs.data.grid
# Create a Joined Grid (using CO,MCU)
$ac.j = $ac.mcus.join($ac.g, @("CO","MCU"))
# Display the Heading
$ac.j.header
# Get a base Grid Form
$ac.mcuFrm = ConvertFrom-Celin.AIS.Ui.GridForm (getLayout base-grid)
# Set Title and Color
$ac.mcuFrm.title = "Business Unit"
$ac.mcuFrm.color = "high"
# Set the Header
$ac.mcuFrm.header.format = "{0,12} {1,7} {2,-30} {3,-4} {4,-3} {5,-8} {6,-8} {7,12}"
$ac.mcuFrm.header.data = @("BU#","Company","Description","Type","LOD","From LOD", "To LOD","No.Accounts")
# Set the Body Format
$ac.mcuFrm.body.format = "{0,12} {3,7} {4,-30} {1,-4} {2,-3} {7,-8} {8,-8} {9,12}"
# Use the Joined Detail
$ac.mcuFrm.set($ac.j.detail)
# Show the form
Show-Celin.AIS.Ui.GridForm $ac.mcuFrm
