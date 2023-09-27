foreach ($itm in $rs1.data.grid.detail) {
    $find = $rs2.data.grid.detail | Where-Object { $_[0] -eq $itm[0] }
    Write-Host $find
    if (-not $find) {
        $global:toAdd += ,$itm
    }
}
