$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$part1 = 0
$part2 = 0
for ($i = 0; $i -lt $in.Count; $i++) {
    for ($j = $i + 1; $j -lt $in.Count; $j++) {
        if ([int]$in[$i] + [int]$in[$j] -eq 2020) {
            $part1 = [int]$in[$i] * [int]$in[$j]
        }
        for ($k = $j + 1; $k -lt $in.Count; $k++) {
            if ([int]$in[$i] + [int]$in[$j] + [int]$in[$k] -eq 2020) {
                $part2 = [int]$in[$i] * [int]$in[$j] * [int]$in[$k]
            }
        }
    }
}

Write-Output ("Part 1: " + $part1)
Write-Output ("Part 2: " + $part2)