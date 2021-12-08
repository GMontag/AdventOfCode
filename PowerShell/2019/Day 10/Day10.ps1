function gcd( $x, $y ) {
    while ($y -ne 0) {
        $x, $y = $y, ($x % $y)
    }
    [Math]::abs($x)
}

# Read input
$in = Get-Content "$PSScriptRoot\input.txt"

$rows = $in.Count
$columns = $in[0].Length

for ($i = 0; $i -lt $rows; $i++) {
    for ($j = 0; $j -lt $columns; $j++) {

    }
}