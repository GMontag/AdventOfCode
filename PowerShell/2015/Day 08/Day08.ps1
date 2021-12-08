$lines = Get-Content .\input.txt

# Part 1

$codelength = 0
foreach ($line in $lines) { $codelength += $line.Length}

$memorylength = 0
foreach ($line in $lines) {
    $escapes = 2
    for ($i = 1; $i -lt ($line.Length - 1); $i++) {
        if ($line[$i] -eq '\') {
            if ($line[$i+1] -eq 'x') {
                $escapes += 3
                $i += 3
            } else {
                $escapes++
                $i++
            }
        }
    }
    $memorylength += ($line.Length - $escapes)
}

"Part 1: " + ($codelength - $memorylength)

$encodedlength = 0
foreach ($line in $lines) {
    $escapes = 2
    for ($i = 0; $i -lt $line.Length; $i++) {
        if ($line[$i] -eq '"') { $escapes++ }
        if ($line[$i] -eq '\') { $escapes++ }
    }
    $encodedlength += ($line.Length + $escapes)
}

"Part 2: " + ($encodedlength - $codelength)