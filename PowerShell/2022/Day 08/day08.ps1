$in = Get-Content "$PSScriptRoot\input.txt"

$visible = New-Object 'bool[,]' $in[0].Length,$in.Count

#left to right
for ($y = 0; $y -lt $in.Count; $y++) {
    $max = -1
    for ($x = 0; $x -lt $in[0].Length; $x++) {
        $height = [int]$in[$y][$x]
        if ($height -gt $max) {
            $visible[$x,$y] = $true
            $max = $height
        }
    }
}

#right to left
for ($y = 0; $y -lt $in.Count; $y++) {
    $max = -1
    for ($x = $in[0].Length - 1; $x -ge 0; $x--) {
        $height = [int]$in[$y][$x]
        if ($height -gt $max) {
            $visible[$x,$y] = $true
            $max = $height
        }
    }
}

#top to bottom
for ($x = 0; $x -lt $in[0].Length; $x++) {
    $max = -1
    for ($y = 0; $y -lt $in.Count; $y++) {
        $height = [int]$in[$y][$x]
        if ($height -gt $max) {
            $visible[$x,$y] = $true
            $max = $height
        }
    }
}

#bottom to top
for ($x = 0; $x -lt $in[0].Length; $x++) {
    $max = -1
    for ($y = $in.Count - 1; $y -ge 0; $y--) {
        $height = [int]$in[$y][$x]
        if ($height -gt $max) {
            $visible[$x,$y] = $true
            $max = $height
        }
    }
}

#get total
$total = 0
for ($x = 0; $x -lt $in[0].Length; $x++) {
    for ($y = 0; $y -lt $in.Count; $y++) {
        if ($visible[$x,$y]) { $total++ }
    }
}

Write-Host "Part 1: $total"