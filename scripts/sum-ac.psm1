function sumAc {
    param (
        $data
    )
    $rows = @()
    $f0911 = "f0911 [group(crcd) sum(aa) count(aa)]"

    for ($cnt = 0; $cnt -lt $data.count(); $cnt++) {
        $r1 = $data[$cnt]
        $mcuQ = "fy=23 lt=AA post=P mcu=$($r1[2].trim())"
        $q = "all($mcuQ"
        if ($cnt -lt $data.count() - 1) {
            $q += " obj=$($r1[3].trim())"
            if ($r1[4].trim()) {
                $q += " sub>=$($r1[4].trim())"
            }
            $r2 = $data[$cnt + 1]
            $q += ") or all($mcuQ obj>$($r1[3].trim()) obj<$($r2[3].trim())"
            if ($r2[4].trim()) {
                $q += ") or all($mcuQ obj=$($r2[3].trim()) sub<$($r2[4].trim())"
            }
        }
        else {
            $q += " obj>=$($r1[3].trim())"
            if ($r1[4].trim()) {
                $q += " sub>=$($r1[4].trim())"
            }
        }
        try {
            [System.Console]::Write("`rSum {0} of {1}", @($cnt, $data.count()))
            $rs = Submit-Celin.AIS.Query "$f0911 $q)"
            if ($rs.data.grid.detail.count() -gt 0) {
                foreach ($r in $rs.data.grid.detail) {
                    $row = $data[$cnt] + $r
                    $rows += , @($row)
                }
            }
            else {
                $row = $data[$cnt] + @($null, $null, $null)
                $rows += , @($row)
            }
        }
        catch {
            write-host "$f0911 $q)"
            Write-Host $_ -ForegroundColor Red
            return $rows
        }
    }
    return $rows
}
