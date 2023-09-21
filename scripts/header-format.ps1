function HeaderFormat{
    param(
        [string]$left,
        [string]$center,
        [string]$right
    )

    $sp = [Console]::BufferWidth - $center.Length;
    [int]$rpad = $sp / 2
    $s = $left.PadRight($sp - $rpad) + $center + $right.PadLeft($rpad)
    return $s
}
