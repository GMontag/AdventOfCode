$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$ids = @{}

foreach ($line in $in) {
    $id = $line.Replace("F","0").Replace("B","1").Replace("R","1").Replace("L","0")
    $idnum = [Convert]::ToInt32($id,2)

    $ids[$idnum] = $true
}

$largestid = ($ids.Keys | Measure-Object -Maximum).Maximum
$smallestid = ($ids.Keys | Measure-Object -Minimum).Minimum

$missingid = 0
$seatsstarted = $false
for ($i = $smallestid; $i -lt $largestid; $i++) {
    if ($i -notin $ids.Keys) {
        $missingid = $i
        break
    }
}

Write-Output "Part 1: $largestid"
Write-Output "Part 2: $missingid"