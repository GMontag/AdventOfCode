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
        distance    =   0
        score       =   0
    }
    $reindeer[$object.name] = $object
}

for ($t = 0; $t -lt 2503; $t++) {
    foreach ($deer in $reindeer.Keys) {
        $cycletime = $t % $reindeer[$deer].totaltime
        $going = ($cycletime -lt $reindeer[$deer].gotime)
        if ($going) { $reindeer[$deer].distance += $reindeer[$deer].speed }
    }

    $leaddistance = ($reindeer.Keys | ForEach-Object {$reindeer[$_].distance} | Sort-Object -Descending)[0]
    $reindeer.Keys | Where-Object {$reindeer[$_].distance -eq $leaddistance} | ForEach-Object {$reindeer[$_].score++}
}

$leadscore = ($reindeer.Keys | ForEach-Object {$reindeer[$_].score} | Sort-Object -Descending)[0]

Write-Output "Part 2: $leadscore"