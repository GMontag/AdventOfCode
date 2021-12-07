$in = Get-Content .\input.txt

$bitcounts = New-Object int[] ($in[0].Length*2)

for ($i = 0; $i -lt $in.Count; $i++) {
    for ($j = 0; $j -lt $in[$i].Length; $j++) {
        $bitcounts[($j * 2) + [int]$in[$i][$j] - 48]++
    }
}

$gamma = ""
$epsilon = ""

for ($k = 0; $k -lt $bitcounts.Length; $k += 2) {
    if ($bitcounts[$k] -gt $bitcounts[$k+1]) {
        $gamma += "0"
        $epsilon += "1"
    } else {
        $gamma += "1"
        $epsilon += "0"
    }
}

$gamma = [Convert]::ToInt32($gamma,2)
$epsilon = [Convert]::ToInt32($epsilon,2)

Write-Output ("Part 1: " + $gamma * $epsilon)