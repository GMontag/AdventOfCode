$in = Get-Content .\input.txt
$part1 = 0
$part2 = 0
if ([int]$in[1] -gt [int]$in[0]) { $part1++ }
if ([int]$in[2] -gt [int]$in[1]) { $part1++ }
for ($i = 3; $i -lt $in.Length; $i++) {
    if ([int]$in[$i] -gt [int]$in[$i-1]) { $part1++ }
    if ([int]$in[$i] -gt [int]$in[$i-3]) { $part2++ }
}

Write-Output ("Part 1: " + $part1)
Write-Output ("Part 2: " + $part2)