$in = Get-Content .\input.txt

$set = @{}

:outer for ($i = 0; $i -lt $in.Count; $i++) {
	for ($j = 0; $j -lt ($in[$i].Length); $j++) {
		$string = $in[$i].Substring(0,$j) + '_' + $in[$i].Substring($j+1,($in[$i].Length - ($j+1)))
		if ( $set[$string] -eq $true ) {
			Write-Host $($string.Replace('_',''))
			break outer
		} else {
			$set[$string] = $true
		}
	}
}