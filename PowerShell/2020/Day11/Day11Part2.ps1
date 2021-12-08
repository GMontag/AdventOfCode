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
            $directions = @(@(-1,-1),@(-1,0),@(-1,1),@(0,-1),@(0,1),@(1,-1),@(1,0),@(1,1))
            foreach ($direction in $directions) {
                $testx = $x
                $testy = $y
                $seatseen = $false
                while (-not $seatseen) {
                    $testx += $direction[0]
                    $testy += $direction[1]
                    if ($testx -lt 0 -or $testx -ge $maxX -or $testy -lt 0 -or $testy -ge $maxY) {
                        $seatseen = $true
                        break
                    }
                    if ($currentseats[$testy][$testx] -eq "L") {
                        $seatseen = $true
                        break
                    }
                    if ($currentseats[$testy][$testx] -eq "#") {
                        $occupiedadjacent++
                        $seatseen = $true
                        break
                    }
                }
            }

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
                    if ($occupiedadjacent -ge 5) {
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

Write-Output "Part 2: $totaloccupied"