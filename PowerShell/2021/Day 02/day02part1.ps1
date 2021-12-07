$in = Get-Content .\input.txt

$horizontal = 0
$depth = 0

for ($i = 0; $i -lt $in.Length; $i++) {
    $direction = $in[$i].Split(" ")[0]
    $distance = [int]$in[$i].Split(" ")[1]

    switch ($direction) {
        "forward" { $horizontal += $distance }
        "down" { $depth += $distance }
        "up" { $depth -= $distance }
    }
}

Write-Output ("Part 1: " + ($horizontal * $depth))