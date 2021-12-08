$in = Get-Content .\input.txt

$sum = 0
for ($i = 0; $i -lt $in.Length; $i++) {
    $next = ($i + 1) % $in.Length
    if ($in[$i] -eq $in[$next]) { $sum += [Int32]::Parse($in[$i]) }
}
"Part 1: $sum"

$half = $in.Length / 2

$sum = 0
for ($i = 0; $i -lt $in.Length; $i++) {
    $next = ($i + $half) % $in.Length
    if ($in[$i] -eq $in[$next]) { $sum += [Int32]::Parse($in[$i]) }
}
"Part 2: $sum"