$in = Get-Content .\input.txt

$xsize = $in[0].Length
$ysize = $in.Count

$costs = New-Object int[][] $xsize,$ysize
$costs[0][0] = [int][string]$in[0][0]

$queue = New-Object System.Collections.Queue
$queue.Enqueue("0,0")

while ($queue.Count -ne 0) {
    $cell = $queue.Dequeue()
    $x = [int]($cell.Split(",")[0])
    $y = [int]($cell.Split(",")[1])
    if ($x -gt 0) {
        $newcost = $costs[$x][$y] + [int][string]$in[$y][$x-1]
        if ( ($costs[$x-1][$y] -gt $newcost) -or ($costs[$x-1][$y] -eq 0) ) {
            $costs[$x-1][$y] = $newcost
            $queue.Enqueue("$($x-1),$y")
        }
    }
    if ($y -gt 0) {
        $newcost = $costs[$x][$y] + [int][string]$in[$y-1][$x]
        if ( ($costs[$x][$y-1] -gt $newcost) -or ($costs[$x][$y-1] -eq 0) ) {
            $costs[$x][$y-1] = $newcost
            $queue.Enqueue("$x,$($y-1)")
        }
    }
    if ($x -lt ($xsize-1)) {
        $newcost = $costs[$x][$y] + [int][string]$in[$y][$x+1]
        if ( ($costs[$x+1][$y] -gt $newcost) -or ($costs[$x+1][$y] -eq 0) ) {
            $costs[$x+1][$y] = $newcost
            $queue.Enqueue("$($x+1),$y")
        }
    }
    if ($y -lt ($ysize-1)) {
        $newcost = $costs[$x][$y] + [int][string]$in[$y+1][$x]
        if ( ($costs[$x][$y+1] -gt $newcost) -or ($costs[$x][$y+1] -eq 0) ) {
            $costs[$x][$y+1] = $newcost
            $queue.Enqueue("$x,$($y+1)")
        }
    }
}

$answer = $costs[$xsize-1][$ysize-1] - $costs[0][0]

Write-Output ("Part 1: " + $answer)