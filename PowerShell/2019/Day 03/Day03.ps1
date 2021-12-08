$in = Get-Content .\input.txt

$numwires = 2
$wires = 0..($numwires-1)
$wires | % { $wires[$_] = $in[$_].Split(',') }

$coords = 0..($numwires-1) | % { @{} }

for ($i = 0; $i -lt $numwires; $i++) {
    $curx = 0
    $cury = 0
    $steps = 0
    for ($j = 0; $j -lt $wires[$i].Count; $j++) {
        switch ($wires[$i][$j][0]) {
            "R" {
                for ($k = 0; $k -lt [int]($wires[$i][$j].Substring(1)); $k++) {
                    $steps++
                    $curx++
                    $coords[$i]["$curx,$cury"] = $steps
                }
            }
            "L" {
                for ($k = 0; $k -lt [int]($wires[$i][$j].Substring(1)); $k++) {
                    $steps++
                    $curx--
                    $coords[$i]["$curx,$cury"] = $steps
                }
            }
            "U" {
                for ($k = 0; $k -lt [int]($wires[$i][$j].Substring(1)); $k++) {
                    $steps++
                    $cury++
                    $coords[$i]["$curx,$cury"] = $steps
                }
            }
            "D" {
                for ($k = 0; $k -lt [int]($wires[$i][$j].Substring(1)); $k++) {
                    $steps++
                    $cury--
                    $coords[$i]["$curx,$cury"] = $steps
                }
            }
        }
    }
}

$crossings = $coords[0].Keys | ? { $coords[1].ContainsKey($_) }
$sums = $crossings | % { [int]($_.Split(",")[0]) + [int]($_.Split(",")[1]) }
$closestsum = ($sums | measure -Minimum).Minimum

"Part 1: $closestsum"

$stepsums = $crossings | % { $coords[0][$_] + $coords[1][$_] }
$closeststeps = ($stepsums | measure -Minimum).Minimum

"Part 2: $closeststeps"