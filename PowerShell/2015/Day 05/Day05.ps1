$in = Get-Content .\input.txt

Function Test-IsNiceString1 {
	Param ([String] $string)
	
	$nice = $true
	
	$vowels = ('a','e','i','o','u')
	$nice = $nice -and ( ([char[]]$string | ? {$_ -in $vowels}).Count -ge 3)
	
	$twice = $false
	for ($i = 0; $i -lt $string.Length - 1; $i++) {
		if ($string[$i] -eq $string[$i+1]) {$twice = $true; break}
	}
	$nice = $nice -and $twice
	
	$bad = ('ab','cd','pq','xy')
	$nobad = $true
	for ($i = 0; $i -lt $string.Length - 1; $i++) {
		if ($string[$i] + $string[$i+1] -in $bad) {$nobad = $false; break}
	}
	$nice = $nice -and $nobad
	
	return $nice
}

Function Test-IsNiceString2 {
	Param ([String] $string)
	
	$nice = $true
	
	$nice = $nice -and $string -match '([a-z][a-z])[a-z]*\1'
	
	$nice = $nice -and $string -match '([a-z])[a-z]\1'
	
	return $nice
}

Write-Host ($in | ? { Test-IsNiceString1 $_ }).Count
Write-Host ($in | ? { Test-IsNiceString2 $_ }).Count