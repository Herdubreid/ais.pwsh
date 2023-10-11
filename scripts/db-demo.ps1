try {
    # Delete existing gl db
    if (Test-Path ./tmp/gl*.db) {
        Remove-Item ./tmp/gl*.db
    }
    # Create new LiteDB
    Import-Module Ldbc
    $Database = New-LiteDatabase ./tmp/gl.db

    # Get Ledger
    $rs = Submit-Celin.AIS.Query "f0911 -max no (kco,doc,dct,dgj,jeln,post,aid,mcu,fy,crcd,aa) all(fy=23 lt=AA post=P)"
    # Convert the Results to a Table with Alias as Field Name
    $t = $rs.data.grid.detail.toTable($rs.data.grid.header.names)
    # Convert the Table to LiteDB records with the index made up from KCO,DOC,DCT,JELN
    $d = $t | ForEach-Object { ($o = $_ | Select-Object post, aid, mcu, fy, crcd, aa) | Add-Member _id ($_ | Select-Object kco, doc, dct, jeln, dgj); $o }    
    # Create Collection
    $j = Get-LiteCollection Journal
    # Add the Table to the Collection
    $d | Add-LiteData $j
    
    # Get a Unique List of Business Units
    $r = Invoke-LiteCommand "SELECT first(map(* => @.mcu)) FROM Journal group by kco,mcu;"
    # Create Collection
    $a = Get-LiteCollection Accounts
    # Get Account Master for each BU's
    $h = $null
    foreach ($mcu in $r.mcu) {
        Write-Host "Fetch MCU: $mcu"
        $rs = Submit-Celin.AIS.Query "f0901 (aid,mcu,obj,sub,dl01,lda) all(mcu = $mcu)"
        if (-not $h) {
            # Set the Header
            Set-Variable h $rs.data.grid.header.names.toArray() -Scope Script
            # Replace AID with _id (the unique id)
            $h[0] = "_id"
        }
        # Convert the Results to a Table with Alias as Field Name
        $t = $rs.data.grid.detail.toTable($h)
        # Add the Table to the Collection
        $t | Add-LiteData $a 
    }
}
catch { $_ }
finally {
    # Release the db
    $Database.Dispose()
}
