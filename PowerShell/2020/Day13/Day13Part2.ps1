function modpow {
    param([int64]$base, [int64]$exponent, [int64]$modulo)
    $exponentstring = [Convert]::ToString($exponent,2)
    $reducedbase = $base % $modulo
    $result = $reducedbase
    for ($i = 1; $i -lt $exponentstring.Length; $i++){
        $result = ($result * $result) % $modulo
        if ($exponentstring[$i] -eq "1") { $result = ($result * $reducedbase) % $modulo }
    }
    return $result
}

function modinv {
    param([int64]$num,[int64]$modulo)
    return modpow $num ($modulo-2) $modulo
}

$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$buses = @()
$offsets = @()

$minute = 0
foreach ($entry in ($in[1] -split ",")) {
    if ($entry -match "\d+") {
        $buses += [int]$entry
        $offsets += (((0 - $minute) % $entry) + $entry) % $entry
    }
    $minute++
}

$product = [int64]1
$buses | % { $product *= $_ }

$sum = [int64]0
for ($i = 0; $i -lt $buses.Count; $i++) {
    $a = $offsets[$i]
    $b = $product / $buses[$i]
    $c = modinv $b $buses[$i]
    $sum = ($sum + ($a * $b * $c)) % $product
    Write-Host $sum, $a, $b, $c, $buses[$i], $offsets[$i]
}

Write-Output "Part 2: $sum"