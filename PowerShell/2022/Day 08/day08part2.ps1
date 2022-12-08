$in = Get-Content "$PSScriptRoot\input.txt"

$maxscore = 0
for ($x = 1; $x -lt $in[0].Length-1; $x++) {
    for ($y = 1; $y -lt $in.Count-1; $y++) {
        $height = [int]$in[$y][$x]
        $score = 1
        #check right
        $distance = 1;
        for (; $x + $distance -lt $in[0].Length-1; $distance++) {
            if ([int]$in[$y][$x + $distance] -ge $height) { break }
        }
        $score *= $distance

        #check left
        $distance = 1;
        for (; $x - $distance -gt 0; $distance++) {
            if ([int]$in[$y][$x - $distance] -ge $height) { break }
        }
        $score *= $distance

        #check down
        $distance = 1;
        for (; $y + $distance -lt $in.Count-1; $distance++) {
            if ([int]$in[$y + $distance][$x] -ge $height) { break} 
        }
        $score *= $distance

        #check up
        $distance = 1;
        for (; $y - $distance -gt 0; $distance++) {
            if ([int]$in[$y - $distance][$x] -ge $height) { break}
        }
        $score *= $distance

        if ($score -gt $maxscore) { $maxscore = $score }
    }
}

Write-Host "Part 2: $maxscore"