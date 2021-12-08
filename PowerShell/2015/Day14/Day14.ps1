$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$reindeer = @{}

foreach ($line in $in) {
    $null = $line -match "(?<name>\w*) can fly (?<speed>\d*) km/s for (?<gotime>\d*) seconds, but then must rest for (?<resttime>\d*) seconds."
    $object = New-Object psobject -Property @{
        name        =   $Matches.name
        speed       =   [int]$Matches.speed
        gotime      =   [int]$Matches.gotime
        resttime    =   [int]$Matches.resttime
        totaltime   =   [int]$Matches.gotime + [int]$Matches.resttime
        distance    =   [int]$Matches.gotime * [int]$Matches.speed
    }
    $reindeer[$object.name] = $object
}

$bestdistance = 0
foreach ($deer in $reindeer.Keys) {
    $distance = 0
    $cycles = [int][Math]::Floor(2503 / $reindeer[$deer].totaltime)
    $distance = $cycles * $reindeer[$deer].distance
    $remainingtime = 2503 - ($cycles * $reindeer[$deer].totaltime)
    if ($remainingtime -ge $reindeer[$deer].gotime) {
        $distance += $reindeer[$deer].distance
    } else {
        $distance += $remainingtime * $reindeer[$deer].speed
    }

    if ($distance -gt $bestdistance) { $bestdistance = $distance }
}

Write-Output "Part 1: $bestdistance"