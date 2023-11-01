
totable @('Label','From','To') ($var.labels | foreach {,@($_.'#'; $_.fromAc -join ','; $_.toAc -join ',')})