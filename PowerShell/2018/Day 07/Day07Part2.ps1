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

$seconds = 0
$donesteps = New-Object System.Collections.ArrayList
$workingsteps = New-Object System.Collections.ArrayList
$workers

$while ($donesteps.Count -lt 26) {
	
}

$timer.Stop()
Write-Host $timer.Elapsed