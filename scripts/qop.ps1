function qop {
    param($field, $op, $value)

    return -not $value ? $null : "${field}${op}'${value}'"
}
