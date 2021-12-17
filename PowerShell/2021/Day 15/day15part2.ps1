$in = Get-Content .\input.txt

for ($i = 0; $i -lt $in.Count; $i++) {
    $copy2 = ""; $copy3 = ""; $copy4 = ""; $copy5 = ""
    for ($j = 0; $j -lt $in[$i].Length; $j++) {
        $copy2 += [string]([int][string]$in[$i][$j] % 9 + 1)
        $copy3 += [string](([int][string]$in[$i][$j] + 1) % 9 + 1)
        $copy4 += [string](([int][string]$in[$i][$j] + 2) % 9 + 1)
        $copy5 += [string](([int][string]$in[$i][$j] + 3) % 9 + 1)
    }
    $in[$i] = $in[$i] + $copy2 + $copy3 + $copy4 + $copy5
}

$in = [System.Collections.ArrayList]$in

$origsize = $in.Count
for ($i = 0; $i -lt ($origsize * 4); $i++) {
    $nextline = ""
    for ($j = 0; $j -lt $in[$i].Length; $j++) {
        $nextline += [string]([int][string]$in[$i][$j] % 9 + 1)
    }
    [void]$in.Add($nextline)
}

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