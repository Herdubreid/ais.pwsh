function ConsoleProps{
    Write-Host "Width:         $([Console]::BufferWidth)"
    Write-Host "Height:        $([Console]::BufferHeight)"
    Write-Host "Cursor Line:   $([Console]::CursorTop)"
    Write-Host "Cursor Column: $([Console]::CursorLeft)"
}
