$in = Get-Content "$PSScriptRoot\input.txt"

$totalscore = 0

for ($i = 0; $i -lt $in.Count; $i++) {
    $score = 0
    $opponent = [int][char]($in[$i][0]) - [int][char]'@'
    $you = [int][char]($in[$i][2]) - [int][char]'W'

    $score += $you
    if ($you -eq $opponent) { $score += 3 }
    if ( ($you % 3) -eq (($opponent + 1) % 3) ) { $score += 6 }
    $totalscore += $score
}

Write-Output "Part 1: $totalscore"