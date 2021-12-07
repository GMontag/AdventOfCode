$in = Get-Content .\input.txt

$map1 = New-Object int[][] 1000,1000
$map2 = New-Object int[][] 1000,1000


$pattern = "(\d+),(\d+) -> (\d+),(\d+)"

for ($i = 0; $i -lt $in.Count; $i++) {
    $null = $in[$i] -match $pattern
    if ($Matches.1 -eq $Matches.3) {
        $x = [int]$Matches.1
        $starty = if ([int]$Matches.2 -lt [int]$Matches.4) { [int]$Matches.2 } else { [int]$Matches.4 }
        $endy = if ([int]$Matches.2 -lt [int]$Matches.4) { [int]$Matches.4 } else { [int]$Matches.2 }
        for ($y = $starty; $y -le $endy; $y++) {
            $map1[$x][$y]++
            $map2[$x][$y]++
        }
    } elseif ($Matches.2 -eq $Matches.4) {
        $y = [int]$Matches.2
        $startx = if ([int]$Matches.1 -lt [int]$Matches.3) { [int]$Matches.1 } else { [int]$Matches.3 }
        $endx = if ([int]$Matches.1 -lt [int]$Matches.3) { [int]$Matches.3 } else { [int]$Matches.1 }
        for ($x = $startx; $x -le $endx; $x++) {
            $map1[$x][$y]++
            $map2[$x][$y]++
        }
    } else {
        if ([int]$Matches.1 -lt [int]$Matches.3) {
            $startx = [int]$Matches.1
            $starty = [int]$Matches.2
            $endx = [int]$Matches.3
            $endy = [int]$Matches.4
        } else {
            $startx = [int]$Matches.3
            $starty = [int]$Matches.4
            $endx = [int]$Matches.1
            $endy = [int]$Matches.2
        }
        $stepy = if ($starty -lt $endy) { 1 } else { -1 }
        for (($x = $startx),($y = $starty); $x -le $endx; ($x++),($y += $stepy)) {
            $map2[$x][$y]++
        }

    }
}

$countpoint1 = 0
for ($i = 0; $i -lt 1000; $i++) {
    for ($j = 0; $j -lt 1000; $j++) {
        if ($map1[$i][$j] -gt 1) {
            $countpoint1++
        }
    }
}

$countpoint2 = 0
for ($i = 0; $i -lt 1000; $i++) {
    for ($j = 0; $j -lt 1000; $j++) {
        if ($map2[$i][$j] -gt 1) {
            $countpoint2++
        }
    }
}

Write-Output ("Part 1: " + $countpoint1)
Write-Output ("Part 1: " + $countpoint2)