$in = Get-Content .\input.txt

# Parse text lines into objects

$records = New-Object object[] $in.Count

$i = 0
foreach ($line in $in) {
	$result = $line -match '\[(?<time>.*)\]\s(?<action>.*)$'
	$record = New-Object PSObject @{
		time	= [datetime]::ParseExact($Matches.time, 'yyyy-MM-dd HH:mm', $null)
		action	= $Matches.action
	}
	$records[$i++]=$record
}

# Sort records chronologically

$records = $records | Sort-Object {$_.time}


$guardid = 0
$guards = @{}
$asleepminute = 0
for ($i=0; $i -lt $records.Count; $i++) {
	if ($records[$i].action -match 'Guard #(?<guardid>\d+) begins shift') { $guardid = $Matches.guardid.ToInt32($null) }
	if ($records[$i].action -match 'falls asleep') {
		$asleepminute = $records[$i].time.Minute
	}
	if ($records[$i].action -match 'wakes up') {
		if ( -not $guards[$guardid] ) { $guards[$guardid] = @(0) * 60 }
		for ($minute = $asleepminute; $minute -lt $records[$i].time.Minute; $minute++) {
			$guards[$guardid][$minute]++
		}
	}
}

$sleepiestguard = ( $guards.Keys | % { [PSCustomObject]@{Key = $_; total = ($guards[$_] | Measure-Object -Sum).Sum} } | Sort-Object -Property total)[-1].Key
$sleepiestminute = [array]::IndexOf($guards[$sleepiestguard], ($guards[$sleepiestguard] | Measure-Object -Maximum).Maximum.ToInt32($null))
Write-Host ($sleepiestguard * $sleepiestminute)