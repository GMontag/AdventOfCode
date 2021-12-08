$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$timestamp = [int]$in[0]
$buses = $in[1] | Select-String -Pattern "\d+" -AllMatches | % { $_.Matches } | % { [int]($_.Groups[0].Value) }

$longestbus = $buses | measure -Maximum | select Maximum -ExpandProperty Maximum
$earliesttime = $timestamp + $longestbus
$earliestbus = 0
foreach ($bus in $buses) {
    $time = $bus - ($timestamp % $bus) + $timestamp
    if ($time -lt $earliesttime) {
        $earliesttime = $time
        $earliestbus = $bus
    }
}

$answer = $earliestbus * ($earliesttime - $timestamp)

Write-Output "Part 1: $answer"