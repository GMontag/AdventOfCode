$in = Get-Content .\input.txt

$horizontal = 0
$depth = 0
$aim = 0

for ($i = 0; $i -lt $in.Length; $i++) {
    $direction = $in[$i].Split(" ")[0]
    $distance = [int]$in[$i].Split(" ")[1]

    switch ($direction) {
        "forward" { $horizontal += $distance; $depth += $aim * $distance }
        "down" { $aim += $distance }
        "up" { $aim -= $distance }
    }
}

Write-Output ("Part 2: " + ($horizontal * $depth))