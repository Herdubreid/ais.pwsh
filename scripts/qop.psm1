function qop {
    param($fop, $value)

    return -not $value ? $null : " ${fop}'${value}'"
}
