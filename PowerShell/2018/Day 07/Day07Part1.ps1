$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

$in = Get-Content .\input.txt

# parse input
$steps = @($false)*26
for ($i = 0; $i -lt 26; $i++) {
	$steps[$i] = New-Object PSObject @{
		step = $i
		prereqs = New-Object System.Collections.ArrayList
	}
}
	
foreach ($line in $in) {
	$null = $line -match 'Step (.) must be finished before step (.) can begin.'
	$step = [int][char]$matches[2] - 65
	$prereq = [int][char]$matches[1] - 65
	$null = $steps[$step].prereqs.Add($prereq)
}

$donesteps = New-Object System.Collections.ArrayList

while ($donesteps.Count -lt 26) {
	for ($i = 0; $i -lt 26; $i++) {
		if ($i -in $donesteps) { continue }
		if ( ($steps[$i].prereqs | ? { $_ -notin $donesteps }).Count -eq 0 ) {
			$null = $donesteps.Add($i)
			break
		}
	}
}

$donestepsstring = ( $donesteps | % { [char]($_ + 65) } ) -join ''

Write-Host $donestepsstring

$timer.Stop()
Write-Host $timer.Elapsed