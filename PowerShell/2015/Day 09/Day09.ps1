# code taken from rosettacode.org/wiki/Permutations#PowerShell
function permutation ($array) {
    function generate($n, $array, $A) {
        if($n -eq 1) {
            $array[$A] -join ' '
        }
        else{
            for( $i = 0; $i -lt ($n - 1); $i += 1) {
                generate ($n - 1) $array $A
                if($n % 2 -eq 0){
                    $i1, $i2 = $i, ($n-1)
                    $A[$i1], $A[$i2] = $A[$i2], $A[$i1]
                }
                else{
                    $i1, $i2 = 0, ($n-1)
                    $A[$i1], $A[$i2] = $A[$i2], $A[$i1]
                }
            }
            generate ($n - 1) $array $A
        }
    }
    $n = $array.Count
    if($n -gt 0) {
        (generate $n $array (0..($n-1)))
    } else {$array}
}

$lines = Get-Content .\input.txt

# parse locations
$locations = $lines | % { $_.split()[0,2] } | sort -unique

# parse distances
$distances = @{}
foreach ($line in $lines) {
    $tokens = $line.split()
    $distances[($tokens[0] + $tokens[2])] = [int]$tokens[4]
}

$routes = permutation($locations)

$shortestroute = 1600; # no distance is larger than 200
$longestroute = 0
foreach ($route in $routes) {
    $distance = 0
    $stops = $route.split()
    for ($i=0; $i -lt $stops.Count - 1; $i++) {
        $distance += $distances[$stops[$i]+$stops[$i+1]] + $distances[$stops[$i+1]+$stops[$i]]
    }
    if ($distance -lt $shortestroute) {$shortestroute = $distance}
    if ($distance -gt $longestroute) {$longestroute = $distance}
}

"Part One: " + $shortestroute
"Part Two: " + $longestroute