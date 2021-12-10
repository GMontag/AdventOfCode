$in = Get-Content .\input.txt

$maxi = $in.Count - 1
$maxj = $in[0].Length - 1

$basinlows = @{}
$cells = @{}

function markCell {
    param([int]$i, [int]$j, [string]$basin)
    $cells["$i,$j"] = $basin
    $basinlows[$basin] += 1
    if ( ($i -ne 0) -and ($cells.Keys -notcontains "$($i-1),$j") -and $in[$i-1][$j] -ne "9" ) { markCell ($i-1) $j $basin }
    if ( ($i -ne $maxi) -and ($cells.Keys -notcontains "$($i+1),$j") -and $in[$i+1][$j] -ne "9" ) { markCell ($i+1) $j $basin }
    if ( ($j -ne 0) -and ($cells.Keys -notcontains "$i,$($j-1)") -and $in[$i][$j-1] -ne "9" ) { markCell $i ($j-1) $basin }
    if ( ($j -ne $maxj) -and ($cells.Keys -notcontains "$i,$($j+1)") -and $in[$i][$j+1] -ne "9" ) { markCell $i ($j+1) $basin }
}

function isLow {
    param([int]$i,[int]$j)
    $low = $true
    if ( ($i -ne 0) -and ($in[$i][$j] -ge $in[$i-1][$j]) ) { $low = $false }
    if ( ($j -ne $maxj) -and ($in[$i][$j] -ge $in[$i][$j+1]) ) { $low = $false }
    if ( ($i -ne $maxi) -and ($in[$i][$j] -ge $in[$i+1][$j]) ) { $low = $false }
    if ( ($j -ne 0) -and ($in[$i][$j] -ge $in[$i][$j-1]) ) { $low = $false }
    return $low
}

for ($i = 0; $i -le $maxi; $i++) {
    for ($j = 0; $j -le $maxj; $j++) {
        if ($cells.Keys -notcontains "$i,$j") {
            if ($in[$i][$j] -eq "9") {
                $cells["$i,$j"] = "9"
                continue
            }
            if (isLow $i $j) {
                $basinlows["$i,$j"] = 0
                markCell $i $j "$i,$j"
            }
        }
    }
}

$answer = $basinlows.Values | Sort-Object -Descending | Select-Object -First 3 | Foreach-Object { $product = 1 } { $product *= $_ } { $product }

Write-Output ("Part 2: " + $answer)
