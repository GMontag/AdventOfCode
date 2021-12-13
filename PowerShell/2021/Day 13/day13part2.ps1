$in = Get-Content .\input.txt

$points = @{}
$pattern = "\d+,\d+$"
$match = $in[0] -match $pattern
$i = 0

while ($match) {
    $points[$in[$i]] = $true
    $i++
    $match = $in[$i] -match $pattern
}

for ($i++; $i -lt $in.Count; $i++) {
    $null = $in[$i] -match "fold along (.)=(\d+)$"
    $axis = $Matches[1]
    $value = [int]($Matches[2])

    $pointkeys = $points.Keys.Clone()
    foreach ($point in $pointkeys) {
        $xorig = [int]($point.Split(",")[0])
        $yorig = [int]($point.Split(",")[1])
        $newpoint = ""
        if ($axis -eq "x") {
            if ($xorig -gt $value) {
                $xnew = $value * 2 - $xorig
                $newpoint = "$xnew,$yorig"
            }
        } else {
            if ($yorig -gt $value) {
                $ynew = $value * 2 - $yorig
                $newpoint = "$xorig,$ynew"
            }
        }
        if ($newpoint) {
            $points[$newpoint] = $true
            $points.Remove($point)
        }
    }
}

$maxx = ($points.Keys | % { [int]($_.Split(",")[0]) } | measure -max).Maximum
$maxy = ($points.Keys | % { [int]($_.Split(",")[1]) } | measure -max).Maximum

for ($y = 0; $y -le $maxy; $y++) {
    $line = ""
    for ($x = 0; $x -le $maxx; $x++) {
        if ($points.Keys -contains "$x,$y") {
            $line += "#"
        } else {
            $line += "."
        }
    }
    Write-Output $line
}