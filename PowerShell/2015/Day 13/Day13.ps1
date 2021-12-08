$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

# parse input
$happiness = @{}
foreach ($line in $in) {
    $null = $line -match '(?<subject>\w+) would (?<gainlose>gain|lose) (?<quantity>\d+) happiness units by sitting next to (?<neighbor>\w+)\.'
    $object = New-Object psobject -Property @{
        subject     =   $Matches.subject
        neighbor    =   $Matches.neighbor
        quantity    =   [int]$Matches.quantity
    }
    if ($Matches.gainlose -eq "lose") { $object.quantity = 0 - $object.quantity }
    $happiness[$object.subject + $object.neighbor] = $object
}

$guests = $happiness.Keys | % { $happiness[$_].subject } | Sort-Object -Unique

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

$besthappiness = 0

foreach ($permutation in permutation($guests)) {
    $permutation = $permutation -split " "
    $totalhappiness = 0
    for ($i = 0; $i -lt $permutation.Count; $i++) {
        $leftneighbor = ($i + 1 + $permutation.Count) % $permutation.Count
        $rightneighbor = ($i - 1 + $permutation.Count) % $permutation.Count
        $totalhappiness += $happiness[$permutation[$i] + $permutation[$leftneighbor]].quantity
        $totalhappiness += $happiness[$permutation[$i] + $permutation[$rightneighbor]].quantity
    }
    if ($totalhappiness -gt $besthappiness) {
        $besthappiness = $totalhappiness
        #Write-Output "Current best happiness $totalhappiness"
        #Write-Output ($permutation -join " ")
        #Write-Output ""
    }
}

Write-Output "Part 1: $besthappiness"

foreach ($guest in $guests) {
    $object = New-Object psobject -Property @{
        subject     =   "You"
        neighbor    =   $guest
        quantity    =   0
    }
    $happiness[$object.subject + $object.neighbor] = $object

    $object = New-Object psobject -Property @{
        subject     =   $guest
        neighbor    =   "You"
        quantity    =   0
    }
    $happiness[$object.subject + $object.neighbor] = $object
}

$guests += "You"

$besthappiness = 0

foreach ($permutation in permutation($guests)) {
    $permutation = $permutation -split " "
    $totalhappiness = 0
    for ($i = 0; $i -lt $permutation.Count; $i++) {
        $leftneighbor = ($i + 1 + $permutation.Count) % $permutation.Count
        $rightneighbor = ($i - 1 + $permutation.Count) % $permutation.Count
        $totalhappiness += $happiness[$permutation[$i] + $permutation[$leftneighbor]].quantity
        $totalhappiness += $happiness[$permutation[$i] + $permutation[$rightneighbor]].quantity
    }
    if ($totalhappiness -gt $besthappiness) {
        $besthappiness = $totalhappiness
        #Write-Output "Current best happiness $totalhappiness"
        #Write-Output ($permutation -join " ")
        #Write-Output ""
    }
}

Write-Output "Part 2: $besthappiness"