$rangemin = 246515
$rangemax = 739105

$passwordcount = 0

for ($i = $rangemin; $i -le $rangemax; $i++) {
    $password = [string]$i
    $increasing = $true
    $adjacent = $false
    for ($j = 1; $j -lt 6; $j++) {
        if ($password[$j] -eq $password[$j-1]) { $adjacent = $true }
        if ($password[$j] -lt $password[$j-1]) { $increasing = $false }
    }
    if ($adjacent -and $increasing) { $passwordcount++ }
}

"Part 1: $passwordcount"