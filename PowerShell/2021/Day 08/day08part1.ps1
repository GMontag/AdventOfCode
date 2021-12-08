$in = Get-Content .\input.txt

$digitcount = 0
for ($i = 0; $i -lt $in.Count; $i++) {
    $line = $in[$i]
    $digits = $line.Split("|")[1].Trim().Split(" ")
    for ($j = 0; $j -lt $digits.Count; $j++) {
        if ( @(2,3,4,7) -contains $digits[$j].Length) { $digitcount++ }
    }
}

Write-Output ("Part 1: " + $digitcount)