$in = Get-Content .\input.txt

$done = $false
$i = 0
$j = 0
$acc = 0
$totals = @{ 0 = $true }

while ( -not $done ) {
	$acc += $in[$i]
	$done = ($totals[$acc] -eq $true)
	$totals[$acc] = $true
	$i++
	$i %= $in.Count
}

Write-Host $acc