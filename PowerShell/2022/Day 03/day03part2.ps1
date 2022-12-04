$in = Get-Content "$PSScriptRoot\input.txt"

$total = 0
for ($i = 0; $i -lt $in.Count; $i += 3) {
    $badge = $in[$i].ToCharArray() | ? { ($_ -cin $in[$i+1].ToCharArray()) -and ($_ -cin $in[$i+2].ToCharArray()) }

    $value = [int][char]$badge[0]
    if ($value -gt 90) { $value -= 96 } else { $value -= 38 }
    $total += $value
}

Write-Output "Part 2: $total"