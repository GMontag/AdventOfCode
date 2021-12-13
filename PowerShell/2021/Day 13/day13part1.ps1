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

$i++
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

Write-Output ("Part 1: " + $points.Keys.Count)