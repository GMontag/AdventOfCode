$in = Get-Content .\input.txt

$remaining = $in

for ($bit = 0; $bit -lt $in[0].Length; $bit++) {
    $sum = 0;
    $remaining | % { $sum += ([int]$_[$bit] - 48) }
    if ( ($sum * 2) -ge $remaining.Count ) { $mostcommon = "1" } else { $mostcommon = "0" }
    $remaining = $remaining | ? {$_[$bit] -eq $mostcommon}
    if ($remaining.Count -eq 1) { break; }
}

$oxygen = [Convert]::ToInt32($remaining,2)

$remaining = $in

for ($bit = 0; $bit -lt $in[0].Length; $bit++) {
    $sum = 0;
    $remaining | % { $sum += ([int]$_[$bit] - 48) }
    if ( ($sum * 2) -ge $remaining.Count ) { $mostcommon = "0" } else { $mostcommon = "1" }
    $remaining = $remaining | ? {$_[$bit] -eq $mostcommon}
    if ($remaining.Count -eq 1) { break; }
}

$co2 = [Convert]::ToInt32($remaining,2)

Write-Output ("Part 2: " + $oxygen * $co2)