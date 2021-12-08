$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$part1total = 0
$part2total = 0
$people = 0
$questions = @{}
foreach ($line in $in) {
    if ($line -eq "") {
        $part1total += $questions.Keys.Count
        $part2total += ($questions.Keys | ? { $questions[$_] -eq $people }).Count
        $questions = @{}
        $people = 0
        continue
    }

    foreach ($question in $line.ToCharArray()) {
        if ($question -notin $questions.Keys) {
            $questions[$question] = 1
        } else {
            $questions[$question]++
        }
    }
    $people++
}
$part1total += $questions.Keys.Count
$part2total += ($questions.Keys | ? { $questions[$_] -eq $people }).Count

Write-Output "Part 1: $part1total"
Write-Output "Part 1: $part2total"