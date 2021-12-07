$in = Get-Content .\input.txt

$fish = [System.Collections.ArrayList]($in.Split(",") | % { [uint64]$_ })

$agecounts = New-Object uint64[] 9

for ($i = 0; $i -lt $fish.Count; $i++) {
    $agecounts[$fish[$i]]++
}

$part1count = 0
for ($i = 0; $i -lt 256; $i++) {
    $temp = $agecounts[0]
    for ($j = 0; $j -lt 8; $j++) {
        $agecounts[$j] = $agecounts[$j+1]
    }
    $agecounts[6] += $temp
    $agecounts[8] = $temp

    if ($i -eq 79) {
        $part1count = ($agecounts | Measure-Object -Sum).Sum
    }
}

$part2count = ($agecounts | Measure-Object -Sum).Sum

Write-Output ("Part 1: " + $part1count)
Write-Output ("Part 2: " + $part2count)