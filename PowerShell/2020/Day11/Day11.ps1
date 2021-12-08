$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$currentseats = $in.Clone()
$maxX = $in[0].Length
$maxy = $in.Count
$generationcount = 0

$nochange = $false

while (-not $nochange) {
    $nextseats = @("") * $maxy
    $nochange = $true
    for ($y = 0; $y -lt $maxY; $y++) {
        for ($x = 0; $x -lt $maxX; $x++) {
            # count occupied adjacent seats
            $occupiedadjacent = 0
            if ($x -gt 0 -and $y -gt 0 -and $currentseats[$y-1][$x-1] -eq "#") { $occupiedadjacent++ }
            if ($y -gt 0 -and $currentseats[$y-1][$x] -eq "#") { $occupiedadjacent++ }
            if ($x -lt ($maxX-1) -and $y -gt 0 -and $currentseats[$y-1][$x+1] -eq "#") { $occupiedadjacent++ }
            if ($x -gt 0 -and $currentseats[$y][$x-1] -eq "#") { $occupiedadjacent++ }
            if ($x -lt ($maxX-1) -and $currentseats[$y][$x+1] -eq "#") { $occupiedadjacent++ }
            if ($x -gt 0 -and $y -lt ($maxY-1) -and $currentseats[$y+1][$x-1] -eq "#") { $occupiedadjacent++ }
            if ($y -lt ($maxY-1) -and $currentseats[$y+1][$x] -eq "#") { $occupiedadjacent++ }
            if ($x -lt ($maxX-1) -and $y -lt ($maxY-1) -and $currentseats[$y+1][$x+1] -eq "#") { $occupiedadjacent++ }

            switch ($currentseats[$y][$x]) {
                "." {
                    $nextseats[$y] += "."
                }
                "L" {
                    if ($occupiedadjacent -eq 0) {
                        $nextseats[$y] += "#"
                        $nochange = $false
                    } else {
                        $nextseats[$y] += "L"
                    }
                }
                "#" {
                    if ($occupiedadjacent -ge 4) {
                        $nextseats[$y] += "L"
                        $nochange = $false
                    } else {
                        $nextseats[$y] += "#"
                    }
                }
            }
        }
    }
    $currentseats = $nextseats
    $generationcount++
}

$totaloccupied = 0

for ($y = 0; $y -lt $maxY; $y++) {
    for ($x = 0; $x -lt $maxX; $x++) {
        if ($currentseats[$y][$x] -eq "#") { $totaloccupied++ }
    }
}

Write-Output "Part 1: $totaloccupied"