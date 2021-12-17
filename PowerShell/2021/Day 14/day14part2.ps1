$in = Get-Content .\input.txt

$template = $in[0]

$rules = @{}

for ($i = 2; $i -lt $in.Count; $i++) {
    $null = $in[$i] -match "(\w\w) -> (\w)$"
    $rules[$Matches[1]] = @("$($Matches[1][0])$($Matches[2])","$($Matches[2])$($Matches[1][1])")
}

$paircounts = @{}

foreach ($pair in $rules.Keys) {
    $paircounts[$pair] = 0
}

for ($i = 1; $i -lt $template.Length; $i++) {
    $pair = $template.Substring($i-1,2)
    $paircounts[$pair]++
}

for ($i = 0; $i -lt 40; $i++) {
    $newpaircounts = @{}
    foreach ($pair in $rules.Keys) { $newpaircounts[$pair] = 0 }
    foreach ($pair in $paircounts.Keys) {
        $newpaircounts[$rules[$pair][0]] += $paircounts[$pair]
        $newpaircounts[$rules[$pair][1]] += $paircounts[$pair]
    }
    $paircounts = $newpaircounts
}

$letters = @{}

foreach ($pair in $rules.Keys) {
    $letters[$pair[0]] = 0
    $letters[$pair[1]] = 0
}

foreach ($pair in $paircounts.Keys) {
    $letters[$pair[0]] += $paircounts[$pair]
    $letters[$pair[1]] += $paircounts[$pair]
}

$letters[$template[0]]++
$letters[$template[-1]]++

$answer = ( ($letters.Values | measure -Maximum).Maximum - ($letters.Values | measure -Minimum).Minimum ) / 2

Write-Output ("Part 2: " + $answer)