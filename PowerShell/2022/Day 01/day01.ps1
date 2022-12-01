$in = Get-Content "$PSScriptRoot\input.txt"

$most = 0
$second = 0
$third = 0
$current = 0

for ($i = 0; $i -lt $in.Count; $i++) {
    if ($in[$i] -eq "") {
        $current = 0
        continue
    }
    $current += [int]$in[$i]
    if ($current -gt $most) {
        $third = $second
        $second = $most
        $most = $current
    } elseif ( $current -gt $second) {
        $third = $second
        $second = $current
    } elseif ( $current -gt $third ) {
        $third = $current
    }
}

Write-Output "Part 1: $most"
$total = $most + $second + $third
Write-Output "Part 2: $total"