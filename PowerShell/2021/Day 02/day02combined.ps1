$in = Get-Content .\input.txt

$part1horizontal = 0
$part1depth = 0
$part2horizontal = 0
$part2depth = 0
$part2aim = 0

for ($i = 0; $i -lt $in.Length; $i++) {
    $direction = $in[$i].Split(" ")[0]
    $distance = [int]$in[$i].Split(" ")[1]

    switch ($direction) {
        "forward" { 
            $part1horizontal += $distance
            $part2horizontal += $distance
            $part2depth += $part2aim * $distance
        }
        "down" {
            $part1depth += $distance
            $part2aim += $distance
        }
        "up" {
            $part1depth -= $distance
            $part2aim -= $distance
        }
    }
}

Write-Output ("Part 1: " + ($part1horizontal * $part1depth))
Write-Output ("Part 2: " + ($part2horizontal * $part2depth))