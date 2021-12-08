$in = Get-Content .\input.txt

Write-Host $( ($in | Measure-Object -Sum).Sum )