$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$adapters = $in | ForEach-Object { [int]$_ } | Sort-Object
$adapters = @(0) + $adapters
$adapters += ($adapters[-1] + 3)

$diff1 = 0
$diff3 = 0

for ($i = 1; $i -lt $adapters.Count; $i++) {
    if (($adapters[$i] - $adapters[$i-1]) -eq 1) { $diff1++ }
    if (($adapters[$i] - $adapters[$i-1]) -eq 3) { $diff3++ }
}

Write-Output ("Part 1: " + ($diff1 * $diff3))

$paths = @{}
foreach ($adapter in $adapters) { $paths[$adapter] = 0 }
$paths[0] = 1

for ($i = 0; $i -lt $adapters.Count; $i++) {
    if ( ($adapters[$i] + 1) -in $paths.Keys ) { $paths[$adapters[$i] + 1] += $paths[$adapters[$i]] }
    if ( ($adapters[$i] + 2) -in $paths.Keys ) { $paths[$adapters[$i] + 2] += $paths[$adapters[$i]] }
    if ( ($adapters[$i] + 3) -in $paths.Keys ) { $paths[$adapters[$i] + 3] += $paths[$adapters[$i]] }
}

Write-Output ("Part 2: " + $paths[$adapters[-1]])