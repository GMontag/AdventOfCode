$StartTime = Get-Date

$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$startingnumbers = [int[]]($in -split ",")

$numberturns = @{}

for ($turn = 1; $turn -le 30000000; $turn++) {
    if ($turn -le $startingnumbers.Count) {
        $currentnumber = $startingnumbers[$turn -1]
    } elseif ($firstspoken) {
        $currentnumber = 0
    } else {
        $currentnumber = $turn - $lastturn - 1
    }

    $firstspoken = -not ($numberturns.ContainsKey($currentnumber))
    if (-not $firstspoken) { $lastturn = $numberturns[$currentnumber] }
    $numberturns[$currentnumber] = $turn
}

Write-Output "Part 2: $currentnumber"

$EndTime = (Get-Date).Millisecond
Write-Host ($EndTime - $StartTime)