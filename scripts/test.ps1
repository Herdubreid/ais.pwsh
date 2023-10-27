# Get the state variable
$var = use-celin.state frm
# Display states
$var.states
# Get AB def
$f = Get-Celin.State W01012B
$f.demo
$f.demo.controls
# Get SO def
$f = Get-Celin.State W42025A
$f.demo
$f.demo.controls
