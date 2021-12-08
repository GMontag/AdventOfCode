$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$x = 0
$y = 0
$angle = 0

foreach ($line in $in) {
    Write-Host "$line`t" -NoNewline
    $action = $line[0]
    $value = [int]($line.Substring(1))

    if ($action -eq "F") {
        switch ($angle) {
            0   { $action = "E" }
            90  { $action = "N" }
            180 { $action = "W" }
            270 { $action = "S" }
        }
    }

    switch ($action) {
        "N" { $y += $value }
        "S" { $y -= $value }
        "E" { $x += $value }
        "W" { $x -= $value }
        "L" { $angle += $value; $angle = ($angle + 360) % 360 }
        "R" { $angle -= $value; $angle = ($angle + 360) % 360 }
    }

    Write-Host "x: $x, y: $y"
}

$distance = [Math]::Abs($x) + [Math]::Abs($y)

Write-Host "Part 1: $distance"