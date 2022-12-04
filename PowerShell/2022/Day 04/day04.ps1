$in = Get-Content "$PSScriptRoot\input.txt"

$count = 0
foreach ($line in $in) {
    $numbers = $line -split "," -split "-" | % { [int]$_ }

    if ( (($numbers[0] -le $numbers[2]) -and ($numbers[1] -ge $numbers[3])) -or (($numbers[0] -ge $numbers[2]) -and ($numbers[1] -le $numbers[3])) ) { $count++ }
}

$count