$in = Get-Content -Path ($PSScriptRoot + "\testinput.txt")

$memory = @{}
$mask = ""

foreach ($line in $in) {
    if ($line -match "mask = (.*)") {
        $rawmask = $Matches[1]
        $mask0 = [Convert]::ToUInt64($rawmask.Replace("X","1"),2)
        $mask1 = [Convert]::ToUInt64($rawmask.Replace("X","0"),2)
    } elseif ($line -match "mem\[(\d+)\] = (\d+)") {
        $address = [uint64]$Matches[1]
        $rawvalue = [uint64]$Matches[2]
        $maskedvalue = ($rawvalue -band $mask0) -bor $mask1
        $memory[$address] = $maskedvalue
    }
}

$total = $memory.Values | Measure-Object -Sum | Select-Object -Property Sum -ExpandProperty Sum

Write-Output "Part 1: $total"