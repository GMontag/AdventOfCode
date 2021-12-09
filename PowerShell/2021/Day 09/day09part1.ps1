$in = Get-Content .\input.txt

$total = 0
for ($i = 0; $i -lt $in.Count; $i++) {
    for ($j = 0; $j -lt $in[$i].Length; $j++) {
        $low = $true
        if ( ($i -ne 0) -and ($in[$i][$j] -ge $in[$i-1][$j])) { $low = $false }
        if ( ($j -ne ($in[$i].Length - 1)) -and ($in[$i][$j] -ge $in[$i][$j+1]) ) { $low = $false }
        if ( ($i -ne ($in.Count - 1)) -and ($in[$i][$j] -ge $in[$i+1][$j]) ) { $low = $false }
        if ( ($j -ne 0) -and ($in[$i][$j] -ge $in[$i][$j-1]) ) { $low = $false }
        if ($low) { $total += ([int]$in[$i][$j] - 47) }
    }
}

Write-Output ("Part 1: " + $total)