function State {
    $var = get-variable $env:CELIN_DEFAULT_AIS
    if ($var) {
        HeaderFormat ($var.Name) ($var.Value.AuthResponse.environment) ($var.Value.AuthResponse.username)
    }
}
