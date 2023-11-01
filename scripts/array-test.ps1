# Create a simple one-dimensonal array of 10 numbers
$onedim = @(0..9)
$onedim.Length
$onedim[0]
# Create a two-dimensonal array with two rows of the onedim array
$twodim = @($onedim, $onedim)
$twodim.Length
$twodim[0]
# Simple so far
# Now create the two-dimensional array with one row
$twodim = @($onedim)
$twodim.Length
$twodim[0]
# Powershell automatically transposes it to a one-dimensional array
# The safe syntax is to use a comma
$twodim = , @($onedim)
$twodim.Length
$twodim[0]
# Ok, something to keep in mind
# Now create a function that returns an array of arrays
function foo {
    param (
        $rows
    )
    # Declare the array of arrays of int
    [int[][]]$a = @()
    # Add onedim rows to the array
    1..$rows | ForEach-Object { $a += , $onedim }
    return $a
}
# Create two rows
$a = foo 2
$a.Length
$a[0]
# No problem here
# No let's create one row
$a = foo 1
$a.Length
$a[0]
# Again Powershell transposes it to a one-dimensonal array
# Use the safe syntax
$a = , (foo 1)
$a.Length
$a[0]
# Alternative syntax
$a = @(foo 1)
$a.Length
$a[0]
