$in = Get-Content .\input.txt

$energylevels = New-Object int[][] 10,10
for ($i = 0; $i -lt 10; $i++) {
    for ($j = 0; $j -lt 10; $j++) {
        $energylevels[$i][$j] = [int][string]$in[$i][$j]
    }
}

$totalflashes = 0
for ($step = 0; $true; $step++) {
    $toFlash = New-Object System.Collections.Queue
    $flashed = New-Object System.Collections.ArrayList
    for ($i = 0; $i -lt 10; $i++) {
        for ($j = 0; $j -lt 10; $j++) {
            $energylevels[$i][$j]++
            if ($energylevels[$i][$j] -gt 9) {
                $toFlash.Enqueue("$i,$j")
            }
        }
    }
    while ($toFlash.Count -gt 0) {
        $cell = $toFlash.Dequeue()
        $i = [int]($cell.Split(",")[0])
        $j = [int]($cell.Split(",")[1])
        if (($i -gt 0) -and ($j -gt 0)) {
            $energylevels[$i-1][$j-1]++
            if ( ($energylevels[$i-1][$j-1] -gt 9) -and (-not $flashed.Contains("$($i-1),$($j-1)")) -and (-not $toFlash.Contains("$($i-1),$($j-1)")) ) {
                $toFlash.Enqueue("$($i-1),$($j-1)")
            }
        }
        if ($i -gt 0) {
            $energylevels[$i-1][$j]++
            if ( ($energylevels[$i-1][$j] -gt 9) -and (-not $flashed.Contains("$($i-1),$j")) -and (-not $toFlash.Contains("$($i-1),$j")) ) {
                $toFlash.Enqueue("$($i-1),$j")
            }
        }
        if (($i -gt 0) -and ($j -lt 9)) {
            $energylevels[$i-1][$j+1]++
            if ( ($energylevels[$i-1][$j+1] -gt 9) -and (-not $flashed.Contains("$($i-1),$($j+1)")) -and (-not $toFlash.Contains("$($i-1),$($j+1)")) ) {
                $toFlash.Enqueue("$($i-1),$($j+1)")
            }
        }
        if ($j -gt 0) {
            $energylevels[$i][$j-1]++
            if ( ($energylevels[$i][$j-1] -gt 9) -and (-not $flashed.Contains("$i,$($j-1)")) -and (-not $toFlash.Contains("$i,$($j-1)")) ) {
                $toFlash.Enqueue("$i,$($j-1)")
            }
        }
        if ($j -lt 9) {
            $energylevels[$i][$j+1]++
            if ( ($energylevels[$i][$j+1] -gt 9) -and (-not $flashed.Contains("$i,$($j+1)")) -and (-not $toFlash.Contains("$i,$($j+1)")) ) {
                $toFlash.Enqueue("$i,$($j+1)")
            }
        }
        if (($i -lt 9) -and ($j -gt 0)) {
            $energylevels[$i+1][$j-1]++
            if ( ($energylevels[$i+1][$j-1] -gt 9) -and (-not $flashed.Contains("$($i+1),$($j-1)")) -and (-not $toFlash.Contains("$($i+1),$($j-1)")) ) {
                $toFlash.Enqueue("$($i+1),$($j-1)")
            }
        }
        if ($i -lt 9) {
            $energylevels[$i+1][$j]++
            if ( ($energylevels[$i+1][$j] -gt 9) -and (-not $flashed.Contains("$($i+1),$j")) -and (-not $toFlash.Contains("$($i+1),$j")) ) {
                $toFlash.Enqueue("$($i+1),$j")
            }
        }
        if (($i -lt 9) -and ($j -lt 9)) {
            $energylevels[$i+1][$j+1]++
            if ( ($energylevels[$i+1][$j+1] -gt 9) -and (-not $flashed.Contains("$($i+1),$($j+1)")) -and (-not $toFlash.Contains("$($i+1),$($j+1)")) ) {
                $toFlash.Enqueue("$($i+1),$($j+1)")
            }
        }
        $null = $flashed.Add("$i,$j")
    }
    foreach ($cell in $flashed) {
        $i = [int]($cell.Split(",")[0])
        $j = [int]($cell.Split(",")[1])
        $energylevels[$i][$j] = 0
        $totalflashes++
    }
    if ($step -eq 99) { $part1answer = $totalflashes }
    if ($flashed.Count -eq 100) { $part2answer = $step + 1; break }
}

Write-Output ("Part 1: " + $part1answer)
Write-Output ("Part 2: " + $part2answer)