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
				$lights["$x,$y"] = $true
			} elseif ($instruction.action -eq "turn off") {
				$lights.Remove("$x,$y")
			} elseif ($instruction.action -eq "toggle") {
				if ($lights["$x,$y"]) {
					$lights.Remove("$x,$y")
				} else {
					$lights["$x,$y"] = $true
				}
			}
		}
	}
}

Write-Host $lights.Keys.Count