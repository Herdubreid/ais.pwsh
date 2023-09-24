function test {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet("base", "spread", "topping", "side", "drink")]
        [string] $type,
        [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)]
        [string] $description
    )
    write-host $type, $description
    $trimmedWord = $description.ToUpper() -replace "[AEIOU\W]", ""
    Write-Host $trimmedWord    
}
