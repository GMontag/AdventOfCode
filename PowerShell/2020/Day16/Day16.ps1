$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$validnums = @{}
$i = 0
while ($in[$i] -match "\w+: (\d+)-(\d+) or (\d+)-(\d+)") {
    for ($j = [int]$Matches[1]; $j -lt [int]$Matches[2]; $j++) { $validnums[$j] = $true }
    for ($j = [int]$Matches[3]; $j -lt [int]$Matches[4]; $j++) { $validnums[$j] = $true }
    $i++
}

$i += 6
$total = 0
for (; $i -lt $in.Count; $i++) {
    $numbers = [int[]]($in[$i] -split ",")
    foreach ($num in $numbers) {
        if ($validnums[$num] -eq $null) { $total += $num }
    }
}

Write-Output "Part 1: $total"