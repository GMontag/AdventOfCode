$in = Get-Content .\input.txt

$houses = @{}

$x = 0
$y = 0

$houses["$x,$y"]++

for ($i = 0;$i -lt $in.Length; $i++) {
	if ($in[$i] -eq '^') {$y++}
	if ($in[$i] -eq '>') {$x++}
	if ($in[$i] -eq 'v') {$y--}
	if ($in[$i] -eq '<') {$x--}
	$houses["$x,$y"]++
}

Write-Host $houses.Keys.Count