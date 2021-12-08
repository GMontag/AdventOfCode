$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$cubes = @{}

for ($x = -6; $x -lt $in[0].Length + 6; $x++) {
    for ($y = -6; $y -lt $in.Count + 6; $y++) {
        for ($z = -6; $z -le 6; $z++) {
            for ($w = -6; $w -le 6; $w++) {
                $cubes["$x,$y,$z,$w"] = "."
            }
        }
    }
}

$z = 0
$w = 0
for ($y = 0; $y -lt $in.Count; $y++) {
    for ($x = 0; $x -lt $in[0].Length; $x++) {
        $cubes["$x,$y,$z,$w"] = $in[$y][$x]
    }
}

$cycle = 0
$changequeue = New-Object System.Collections.Queue

while ($cycle -lt 6) {
    foreach ($location in $cubes.Keys) {
        ($x,$y,$z,$w) = $location -split ","
        $x = [int]$x; $y = [int]$y; $z = [int]$z; $w = [int]$w
        $activeneighbors = 0
        for ($xn = $x-1; $xn -le $x+1; $xn++) {
            for ($yn = $y-1; $yn -le $y+1; $yn++) {
                for ($zn = $z-1; $zn -le $z+1; $zn++) {
                    for ($wn = $w-1; $wn -le $w+1; $wn++) {
                        if (($xn -eq $x) -and ($yn -eq $y) -and ($zn -eq $z) -and ($wn -eq $w)) { continue }
                        if ($cubes["$xn,$yn,$zn,$wn"] -eq "#") { $activeneighbors++ }
                    }
                }
            }
        }
        if ($cubes["$x,$y,$z,$w"] -eq "#" -and $activeneighbors -ne 2 -and $activeneighbors -ne 3) { $changequeue.Enqueue("$x,$y,$z,$w") }
        if ($cubes["$x,$y,$z,$w"] -eq "." -and $activeneighbors -eq 3) { $changequeue.Enqueue("$x,$y,$z,$w") }
    }
    while ($changequeue.Count -ne 0) {
        $location = $changequeue.Dequeue()
        if ($cubes[$location] -eq "#") { $cubes[$location] = "." } else { $cubes[$location] = "#" }
    }
    $cycle++
}

$answer = ($cubes.Values | Where-Object { $_ -eq "#" }).Count
Write-Output "Part 2: $answer"