$in = Get-Content .\input.txt

$houses = @{}

$x1 = 0
$y1 = 0
$x2 = 0
$y2 = 0

$houses["$x1,$y1"]++
$houses["$x2,$y2"]++

for ($i = 0;$i -lt $in.Length; $i++) {
	if ($i % 2 -eq 0) {
		if ($in[$i] -eq '^') {$y1++}
		if ($in[$i] -eq '>') {$x1++}
		if ($in[$i] -eq 'v') {$y1--}
		if ($in[$i] -eq '<') {$x1--}
		$houses["$x1,$y1"]++
	} else {
		if ($in[$i] -eq '^') {$y2++}
		if ($in[$i] -eq '>') {$x2++}
		if ($in[$i] -eq 'v') {$y2--}
		if ($in[$i] -eq '<') {$x2--}
		$houses["$x2,$y2"]++
	}
}

Write-Host $houses.Keys.Count