$in = Get-Content .\input.txt

Function Parse-Instruction {
	Param ([String]$instruction)
	
	$null = $instruction -match '(?<action>.+) (?<startx>\d+),(?<starty>\d+) through (?<endx>\d+),(?<endy>\d+)'
	return New-Object PSObject -Property @{
		action	= $Matches.action
		startx	= [int]$Matches.startx
		starty	= [int]$Matches.starty
		endx	= [int]$Matches.endx
		endy	= [int]$Matches.endy
	}
}

$lights = @{}

foreach ($line in $in) {
	$instruction = Parse-Instruction $line
	for ($x = $instruction.startx; $x -le $instruction.endx; $x++) {
		for ($y = $instruction.starty; $y -le $instruction.endy; $y++) {
			if ($instruction.action -eq "turn on") {
				$lights["$x,$y"]++
			} elseif ($instruction.action -eq "turn off") {
				$lights["$x,$y"]--
				if ($lights["$x,$y"] -lt 0) { $lights["$x,$y"] = 0 }
			} elseif ($instruction.action -eq "toggle") {
				$lights["$x,$y"] += 2
			}
		}
	}
}

Write-Host ( $lights.Values | Measure-Object -Sum | Select Sum -ExpandProperty Sum )