$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

$in = Get-Content .\input.txt

function Reduce-Polymer ([String]$polymer, [char]$removechar = "?") {
	$units = [System.Collections.ArrayList]$polymer.ToCharArray()
	$removechar = [char]::ToLower($removechar)
	for ($i = 0; $i -lt $units.Count; $i++) {
		while ([char]::ToLower($units[$i]) -eq $removechar) { 
			$units.RemoveAt($i)
			$i--
		}
		if ( ([char]::ToLower($units[$i]) -eq [char]::ToLower($units[$i+1])) -and ([char]::IsLower($units[$i]) -xor [char]::IsLower($units[$i+1])) ) {
			$units.RemoveAt($i)
			$units.RemoveAt($i)
			$i += -2
			if ($i -lt -1) { $i = -1 }
		}
	}
	return $units -join ""
}

$reduced = Reduce-Polymer $in

$shortestlength = $reduced.Length

foreach ($letter in (65..90 | % { [char]$_ } )) {
	$testpolymer = Reduce-Polymer ($reduced, $letter)
	if ($testpolymer.Length -lt $shortestlength) { $shortestlength = $testpolymer.Length }
}

Write-Host $shortestlength

$timer.Stop()
Write-Host $timer.Elapsed