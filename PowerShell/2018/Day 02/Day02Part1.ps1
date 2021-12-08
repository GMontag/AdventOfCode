$in = Get-Content .\input.txt

$twos = 0
$threes = 0

for ($i = 0; $i -lt $in.Count; $i++) {
	$totals = @{}
	for ($j = 0; $j -lt $in[$i].Length; $j++) {
		$totals[$in[$i][$j]]++
	}
	if ( $totals.Keys | ? { $totals[$_] -eq 2 } ) { $twos++ }
	if ( $totals.Keys | ? { $totals[$_] -eq 3 } ) { $threes++ }
}

Write-Host $($twos * $threes)