$in = Get-Content .\input.txt

# parse input
$gifts = New-Object Object[] $in.Count
$i = 0
foreach ($line in $in) {
	$null = $line -match '(?<x>\d+)x(?<y>\d+)x(?<z>\d+)'
	$gift = ([int]$Matches.x, [int]$Matches.y, [int]$Matches.z)
	$gifts[$i] = $gift
	$i++
}

$totalarea = 0
$totalribbon = 0
foreach ($gift in $gifts) {
	$smallestside = $gift | sort-object | select -first 2 | % {$result = 1} {$result *= $_} {$result}
	$area = ( (2 * $gift[0] * $gift[1]) + (2 * $gift[0] * $gift[2]) + (2 * $gift[1] * $gift[2]) + $smallestside )
	$ribbon = $gift | sort-object | select -first 2 | % {$result = 0} {$result += 2 * $_} {$result}
	$ribbon += $gift[0] * $gift[1] * $gift[2]
	$totalarea += $area
	$totalribbon += $ribbon
}

Write-Host $totalarea
Write-Host $totalribbon