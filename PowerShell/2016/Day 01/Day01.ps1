$in = Get-Content .\input.txt

$directions = $in.Split(",").Trim()

$curx = 0;
$cury = 0;
$curdir = 90
$locations = @{}
$locations["0,0"] = $true
$twicelocation = $false

foreach ($direction in $directions) {
    $turn = $direction[0]
    $steps = [int]($direction.Substring(1))

    switch ($turn) {
        "R" { $curdir += 270 }
        "L" { $curdir += 90 }
    }
    $curdir %= 360

    for ($i = 0; $i -lt $steps; $i++) {
        switch ($curdir) {
            0   { $curx++ }
            90  { $cury++ }
            180 { $curx-- }
            270 { $cury-- }
        }

        if ($locations["$curx,$cury"] -and (-not $twicelocation)) { $twicelocation = $curx + $cury } else { $locations["$curx,$cury"] = $true }
    }
}

"Part 1: $($curx + $cury)"
"Part 2: $twicelocation"
