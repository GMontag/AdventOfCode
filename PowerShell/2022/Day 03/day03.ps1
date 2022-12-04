$in = Get-Content "$PSScriptRoot\input.txt"

$total = 0
foreach ($line in $in) {
    $half = $line.Length/2
    $comp1 = $line.Substring(0,$half)
    $comp2 = $line.Substring($half)
    $match = $comp1.ToCharArray() | ? { $_ -cin $comp2.ToCharArray() }
    $value = [int][char]$match[0]
    if ($value -gt 90) { $value -= 96 } else { $value -= 38 }
    $total += $value
}

Write-Output "Part 1: $total"