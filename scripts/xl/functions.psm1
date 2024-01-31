function j2m {
    param (
        $jaggedArray
    )
    # Get the dimensions of the jagged array
    $dim1 = $jaggedArray.Count
    $dim2 = ($jaggedArray | Measure-Object -Property Count -Maximum).Maximum

    # Create a multidimensional array with the same dimensions
    $multiArray = New-Object 'object [,]' $dim1, $dim2
    
    # Copy the elements from the jagged array to the multidimensional array
    for ($i = 0; $i -lt $dim1; $i++) {
        for ($j = 0; $j -lt $jaggedArray[$i].Count; $j++) {
            $multiArray[$i, $j] = $jaggedArray[$i][$j]
        }
    }
    
    # Return the multidimensional array
    return , $multiArray
}
function e2m {
    param(
        [System.Collections.IEnumerable]$enumerable,
        [int]$cols
    )

    # Get the dimensions
    try {
        $rows = $enumerable.Count()
    }
    catch {
        $rows = 0
    }

    # Create a 2D array
    $array2D = New-Object 'object[,]' $rows, $cols

    # Fill the 2D array
    for ($i = 0; $i -lt $rows; $i++) {
        for ($j = 0; $j -lt $cols; $j++) {
            $array2D[$i, $j] = $enumerable[$i][$j]
        }
    }

    return , $array2D
}
function tryDelete {
    param(
        $ws,
        $name
    )
    try {
        $t = $ws.listobjects[$name]
        $t.Delete()
    }
    catch {}
}
function xlStart {
    # Load the base assemblies into the environment
    Add-Type -Path $env:WINDIR\\assembly\\GAC_MSIL\\office\\*\\office.dll -PassThru | Out-Null
    # Add the target Excel assembly
    Get-ChildItem -Path $env:windir\\assembly -Recurse -Filter Microsoft.Office.Interop.Excel* -File | ForEach-Object {
        Add-Type -LiteralPath ($_.FullName) -PassThru | Out-Null
    }
    New-Variable xl (New-Object -comobject Excel.Application) -Force -Scope Global
    $xl.Visible = $true
    # Create new workbook
    New-Variable wb ($xl.Workbooks.Add()) -Force -Scope Global
}
function xlParse {
    param (
        [Parameter(Mandatory = $true)]
        $jde
    )
    $var = New-Celin.State xl ws, range, formTable, qbeRange, gridTable -Force
    try {
        $formTableName = $jde.formresponse.currentApp + "_FormFields"
        $gridTableName = $jde.formresponse.currentApp + "_Grid"
        try {
            $var.ws = $wb.worksheets.item($jde.formresponse.currentApp)
            $var.ws.Activate()
            tryDelete $var.ws $formTableName
            tryDelete $var.ws $gridTableName
        }
        catch {
            $var.ws = $wb.worksheets.add()
            $var.ws.name = $jde.formresponse.currentApp
        }
        # Create Form Fields Table
        $var.range = $var.ws.cells.range("A3", "D$($jde.FormFields.length + 1)")
        $var.formTable = $var.ws.listobjects.add([Microsoft.Office.Interop.Excel.XlListObjectSourceType]::xlSrcRange, $var.range, $null, [Microsoft.Office.Interop.Excel.XlYesNoGuess]::xlYes)
        $var.formTable.name = $formTableName
        $var.formTable.HeaderRowRange.value2 = @("Id", "Alias", "Title", "Value")
        $a = $jde.formfields | ForEach-Object { , @($_.Id, $_.Alias, $_.Title, $_.Value) }
        $var.formTable.dataBodyRange.value2 = j2m $a

        # Create QBE Range
        $var.range = $var.ws.cells.range("F2")
        $var.qbeRange = $var.range.resize(1, $jde.header.count())
        $var.qbeRange.Interior.ThemeColor = 3
        $var.qbeRange.value2 = $jde.qbe | ForEach-Object value

        # Create Grid Table
        $var.range = $var.ws.cells.range("F3")
        $var.range = $var.range.resize($jde.Detail.Count() + 1, $jde.header.count())
        if ($jde.Detail.Count() -gt 0) {
            $var.range.value = e2m $jde.Detail $jde.header.count()
        }
        $var.gridTable = $var.ws.listobjects.add([Microsoft.Office.Interop.Excel.XlListObjectSourceType]::xlSrcRange, $var.range, $null, [Microsoft.Office.Interop.Excel.XlYesNoGuess]::xlYes)
        $var.gridTable.name = $gridTableName
        $var.gridTable.HeaderRowRange.value2 = $jde.header.titles.toarray()
    }
    catch {
        Write-Host $_ -ForegroundColor Red
    }
}
