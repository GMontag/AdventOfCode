function day9([int]$knots, [string[]]$in) {

    $x = @(0) * $knots
    $y = @(0) * $knots

    $tailpositions = @{}

    for ($i = 0; $i -lt $in.Count; $i++) {
        $direction = $in[$i][0]
        $distance = [int]($in[$i].Substring(2))
        for ($j = 0; $j -lt $distance; $j++) {
            switch ($direction) {
                "U" { $y[0]++ }
                "D" { $y[0]-- }
                "L" { $x[0]-- }
                "R" { $x[0]++ }
            }
            for ($k = 1; $k -lt $knots; $k++) {
                $xdist = $x[$k-1] - $x[$k]
                $ydist = $y[$k-1] - $y[$k]
    
                if ( ([math]::Abs($xdist) -gt 1) -or ([math]::Abs($ydist) -gt 1) ) {
                    if ($xdist -eq 0) {
                        $y[$k] += ($ydist/[math]::Abs($ydist))
                    } elseif ($ydist -eq 0) {
                        $x[$k] += ($xdist/[math]::Abs($xdist))
                    } else {
                        $x[$k] += ($xdist/[math]::Abs($xdist))
                        $y[$k] += ($ydist/[math]::Abs($ydist))
                    }
                }
            }
            $tailpositions["$($x[-1]),$($y[-1])"] = $true
        }
    }

    $totalpositions = $tailpositions.Keys.Count
    return $totalpositions
}

$in = Get-Content "$PSScriptRoot\input.txt"

$part1 = day9 -knots 2 -in $in
Write-Host "Part 1: $part1"

$part2 = day9 -knots 10 -in $in
Write-Host "Part 2: $part2"