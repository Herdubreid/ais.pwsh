# Create a new Excel application object
$excel = New-Object -ComObject Excel.Application

# Optionally, make the Excel application visible (for debugging)
# $excel.Visible = $true

# Add a new workbook
$workbook = $excel.Workbooks.Add()

# Select the first sheet
$sheet = $workbook.Worksheets.Item(1)

# Set values in the cells
$sheet.Cells.Item(1, 1) = "Hello"
$sheet.Cells.Item(1, 2) = "World!"

# Save the workbook
$filePath = "$pwd/test.xlsx"
$workbook.SaveAs($filePath)

# Close the workbook and Excel application
$workbook.Close()
$excel.Quit()

# Release COM objects
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($sheet) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null

# Remove variable references
Remove-Variable sheet, workbook, excel
