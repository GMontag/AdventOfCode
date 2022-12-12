$in = Get-Content "$PSScriptRoot\input.txt"

$maxx = $in[0].Length
$maxy = $in.Count

$elevations = New-Object 'int[,]' $maxx,$maxy
$steps = New-Object 'int[,]' $maxx,$maxy
$visited = New-Object 'bool[,]' $maxx,$maxy

$startx = -1
$starty = -1
$endx = -1
$endy = -1

for ($i = 0; $i -lt $maxx; $i++) {
    for ($j = 0; $j -lt $maxy; $j++) {
        if ($in[$j][$i] -ceq 'S') {
            $startx = $i
            $starty = $j
            $elevations[$i,$j] = 1
        } elseif ($in[$j][$i] -ceq 'E') {
            $endx = $i
            $endy = $j
            $elevations[$i,$j] = 26
        } else { 
            $elevations[$i,$j] = ([int][char]($in[$j][$i])) - 96
        }
    }
}

$nextsteps = New-Object System.Collections.Queue
$nextsteps.Enqueue(@{X=$endx; Y=$endy})
$steps[$endx,$endy] = 0
$visited[$endx,$endy] = $true

while ($nextsteps.Count -gt 0) {
    $currentstep = $nextsteps.Dequeue()
    $x = $currentstep.X
    $y = $currentstep.Y
    #Write-Host "Looking at $x,$y"
    $currentelevation = $elevations[$x,$y]
    $stepcount = $steps[$x,$y]

    #look left
    if ( ($x -gt 0) -and ($elevations[($x-1),$y] -ge ($currentelevation - 1)) ) {
        if ((-not $visited[($x-1),$y]) -or ($steps[($x-1),$y] -gt $stepcount + 1)) {
            $visited[($x-1),$y] = $true
            $steps[($x-1),$y] = $stepcount + 1
            $nextsteps.Enqueue(@{X=($x-1); Y=$y})
            #Write-Host "Queuing left"
        } 
    }

    #look right
    if ( ($x -lt $maxx-1) -and ($elevations[($x+1),$y] -ge ($currentelevation - 1)) ) {
        if ((-not $visited[($x+1),$y]) -or ($steps[($x+1),$y] -gt $stepcount + 1)) {
            $visited[($x+1),$y] = $true
            $steps[($x+1),$y] = $stepcount + 1
            $nextsteps.Enqueue(@{X=($x+1); Y=$y})
            #Write-Host "Queueing right"
        } 
    }

    #look up
    if ( ($y -gt 0) -and ($elevations[$x,($y-1)] -ge ($currentelevation - 1)) ) {
        if ((-not $visited[$x,($y-1)]) -or ($steps[$x,($y-1)] -gt $stepcount + 1)) {
            $visited[$x,($y-1)] = $true
            $steps[$x,($y-1)] = $stepcount + 1
            $nextsteps.Enqueue(@{X=$x; Y=($y-1)})
            #Write-Host "Queueing up"
        } 
    }

    #look down
    if ( ($y -lt $maxy-1) -and ($elevations[$x,($y+1)] -ge ($currentelevation - 1)) ) {
        if ((-not $visited[$x,($y+1)]) -or ($steps[$x,($y+1)] -gt $stepcount + 1)) {
            $visited[$x,($y+1)] = $true
            $steps[$x,($y+1)] = $stepcount + 1
            $nextsteps.Enqueue(@{X=$x; Y=($y+1)})
            #Write-Host "Queueing down"
        } 
    }

}

$minsteps = $maxx * $maxy

for ($i = 0; $i -lt $maxx; $i++) {
    for ($j = 0; $j -lt $maxy; $j++) {
        if ( ($elevations[$i,$j] -eq 1) -and $visited[$i,$j] -and ($steps[$i,$j] -lt $minsteps)) {
            $minsteps = $steps[$i,$j]
            Write-Host "$minsteps $i $j"
        }
    }
}

Write-Host "Part 2: $minsteps"