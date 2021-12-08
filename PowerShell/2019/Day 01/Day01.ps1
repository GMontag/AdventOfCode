$in = Get-Content .\input.txt

$sum = 0

foreach ($module in $in) {
    $sum += ([Math]::Floor([decimal]$module/3) - 2)
}

"Part 1: $sum"

$sum = 0

foreach ($module in $in) {
    $modulesum = 0
    $fuel = ([Math]::Floor([decimal]$module/3) - 2)
    while ($fuel -gt 0) {
        $modulesum += $fuel
        $fuel = ([Math]::Floor([decimal]$fuel/3) - 2)
    }
    $sum += $modulesum
}

"Part 2: $sum"