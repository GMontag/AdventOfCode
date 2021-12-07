$in = Get-Content .\input.txt
$increased = 0
$current = [int]$in[0]
for ($i = 1; $i -lt $in.Length; $i++) {
    if ([int]$in[$i] -gt $current) { $increased++ }
    $current = [int]$in[$i]
}

Write-Output "Part 1: " + $increased