$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$shipx = 0
$shipy = 0
$waypointx = 10
$waypointy = 1

foreach ($line in $in) {
    #Write-Host "$line`t" -NoNewline
    $action = $line[0]
    $value = [int]($line.Substring(1))

    if ($action -eq "R") { $action = "L"; $value = 360 - $value }

    switch ($action) {
        "N" { $waypointy += $value }
        "S" { $waypointy -= $value }
        "E" { $waypointx += $value }
        "W" { $waypointx -= $value }
        "L" {
            switch ($value) {
                90  { $newx = 0 - $waypointy; $newy = $waypointx; $waypointx = $newx; $waypointy = $newy }
                180 { $newx = 0 - $waypointx; $newy = 0 - $waypointy; $waypointx = $newx; $waypointy = $newy }
                270 { $newx = $waypointy; $newy = 0 - $waypointx; $waypointx = $newx; $waypointy = $newy }
            }
        }
        "F" { $shipx += ($waypointx * $value); $shipy += ($waypointy * $value) }
    }

    #Write-Host "x: $shipx, y: $shipy"
}

$distance = [Math]::Abs($shipx) + [Math]::Abs($shipy)

Write-Host "Part 1: $distance"