function toTable {
    param($h, $d)
    $index = 0
    $d | select-object ($h | foreach-object {
            $expr = [ScriptBlock]::Create("`$_[$index]")
            $index++
            @{ Name = [string]$_; Expression = $expr }
        })
}
