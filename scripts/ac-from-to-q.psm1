function acFromToQ {
    param (
        $fixed,
        $fromObj,
        $fromSub,
        $toObj,
        $toSub
    )
    $q = "all($fixed"
    if ($toObj) {
        $q += " obj=$fromObj"
        if ($fromSub) {
            $q += " sub>=$fromSub"
        }
        $q += ") or all($fixed obj>$fromObj obj<$toObj"
        if ($toSub) {
            $q += ") and all($fixed obj=$toObj sub<$toSub"
        }
    }
    else {
        $q += " obj>=$fromObj"
        if ($fromSub) {
            $q += " sub>=$fromSub"
        }
    }
    return "$q)"
}
