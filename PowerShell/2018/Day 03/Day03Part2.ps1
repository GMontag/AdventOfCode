$in = Get-Content .\input.txt

# Process text lines into objects

$claims = New-Object Object[] $in.Count

foreach ($line in $in) {
	$return = $line -match '#(?<ID>\d+)\s@\s(?<x>\d+),(?<y>\d+):\s(?<w>\d+)x(?<h>\d+)'
	$claim = New-Object PSObject -Property @{
		ID	= $Matches.ID
		x	= $Matches.x
		y	= $Matches.y
		w	= $Matches.w
		h	= $Matches.h
	}
	$claims[$claim.ID - 1] = $claim
}

# Mark claims on fabric

$fabric = @{}

foreach ($claim in $claims) {
	for ($x = [int]$claim.x; $x -lt ([int]$claim.x + [int]$claim.w); $x++) {
		for ([int]$y = [int]$claim.y; $y -lt ([int]$claim.y + [int]$claim.h); $y++) {
			$fabric["$x,$y"]++
		}
	}
}

# Find claim that doesn't overlap

:outer foreach ($claim in $claims) {
	for ($x = [int]$claim.x; $x -lt ([int]$claim.x + [int]$claim.w); $x++) {
		for ([int]$y = [int]$claim.y; $y -lt ([int]$claim.y + [int]$claim.h); $y++) {
			if ($fabric["$x,$y"] -gt 1) { continue outer }
		}
	}
	Write-Host $claim.ID
}