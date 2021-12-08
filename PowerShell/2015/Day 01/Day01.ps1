$in = Get-Content .\input.txt

$floor = 0
$basement = -1

for ($i = 0; $i -lt $in.Length; $i++) {
	if ($in[$i] -eq '(') { $floor++ }
	if ($in[$i] -eq ')') { $floor-- }
	if ( ($basement -eq -1) -and ($floor -eq -1) ) { $basement = $i + 1 } 
}

Write-Host $floor
Write-Host $basement