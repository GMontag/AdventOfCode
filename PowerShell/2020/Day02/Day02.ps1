$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$pattern = '(\d+)-(\d+) (\w): (.*)'
$part1 = 0
$part2 = 0
foreach ($line in $in) {
    $null = $line -match $pattern
    $min = [int]$Matches[1]
    $max = [int]$Matches[2]
    $letter = $Matches[3]
    $password = $Matches[4]

    $count = ($password.ToCharArray() | ? {$_ -eq $letter} | Measure-Object).Count
    if ($count -ge $min -and $count -le $max) { $part1++ }

    if ($password[$min-1] -eq $letter -xor $password[$max-1] -eq $letter) { $part2++ }
}

Write-Output "Part 1: $part1"
Write-Output "Part 2: $part2"