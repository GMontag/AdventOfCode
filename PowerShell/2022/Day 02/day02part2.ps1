$in = Get-Content "$PSScriptRoot\input.txt"

$totalscore = 0

for ($i = 0; $i -lt $in.Count; $i++) {
    $score = 0
    $opponent = [int][char]($in[$i][0]) - [int][char]'@'
    $result = [int][char]($in[$i][2]) - [int][char]'W'

    if ($result -eq 1) {
        $you = ($opponent + 2) % 3
        if ($you -eq 0) { $you = 3 }
        $score += $you
    }
    if ($result -eq 2) {
        $you = $opponent
        if ($you -eq 0) { $you = 3 }
        $score += $you + 3
    }
    if ($result -eq 3) {
        $you = ($opponent + 1) % 3
        if ($you -eq 0) { $you = 3 }
        $score += $you + 6
    }
    $totalscore += $score
}

Write-Output "Part 2: $totalscore"