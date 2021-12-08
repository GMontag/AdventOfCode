$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$list = $in | % { [int64]$_ }

$preamble = @{}

for ($i = 0; $i -lt 25; $i++) {
    $preamble[$list[$i]] = $true
}

for ($i = 25; $i -lt $in.Count; $i++) {
    $nosum = $true

    for ($j = $i-25; $j -lt $i; $j++) {
        $target = $list[$i] - $list[$j]
        if ($preamble[$target]) {
            $nosum = $false
            break
        }
    }

    if ($nosum) {
        $nosumnum = $list[$i]
        Write-Output "Part 1: $nosumnum"
        break
    }

    $preamble[$list[$i]] = $true
    $preamble.Remove($list[$i-25])
}

$start = 0
$end = 0
$total = $list[0]

while ($total -ne $nosumnum) {
    if ($total -lt $nosumnum) {
        $end++
        $total += $list[$end]
    }
    if ($total -gt $nosumnum) {
        $total -= $list[$start]
        $start++
    }
}

$smallest = $list[$start]
$largest = $list[$end]
for ($i = $start; $i -le $end; $i++) {
    if ($list[$i] -lt $smallest) { $smallest = $list[$i] }
    if ($list[$i] -gt $largest) { $largest = $list[$i] }
}
$weakness = $smallest + $largest
Write-Output "Part 2: $weakness"