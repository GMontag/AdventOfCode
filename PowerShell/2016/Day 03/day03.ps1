$in = Get-Content "$PSScriptRoot\input.txt"

$count = 0
for ($i = 0; $i -lt $in.Count; $i++) {
    $sides = $in[$i] -split '\s+' | ? { $_ -ne '' } | % { [int]$_ }
    if ( ($sides[0] + $sides[1] -gt $sides[2]) -and 
         ($sides[0] + $sides[2] -gt $sides[1]) -and 
         ($sides[1] + $sides[2] -gt $sides[0])     ) { $count++ }
}

Write-Host $count