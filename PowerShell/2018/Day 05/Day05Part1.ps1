$timer = New-Object System.Diagnostics.Stopwatch
$timer.Start()

$in = Get-Content .\input.txt

$polymers = [System.Collections.ArrayList]$in.ToCharArray()

for ($i = 0; $i -lt $polymers.Count; $i++) {
	if ( ([char]::ToLower($polymers[$i]) -eq [char]::ToLower($polymers[$i+1])) -and ([char]::IsLower($polymers[$i]) -xor [char]::IsLower($polymers[$i+1])) ) {
		$polymers.RemoveAt($i)
		$polymers.RemoveAt($i)
		$i += -2
		if ($i -lt -1) { $i = -1 }
	}
}

Write-Host $polymers.Count

$timer.Stop()
Write-Host $timer.Elapsed