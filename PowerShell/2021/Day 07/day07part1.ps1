$in = Get-Content .\input.txt

$positions = $in.Split(",") | % { [int]$_ }

$maxposition = ($positions | Measure-Object -Maximum).Maximum
$minfuel = $maxposition * $positions.Count
$minposition = 0;

for ($i = 0; $i -le $maxposition; $i++) {
    $totalfuel = 0
    for ($j = 0; $j -lt $positions.Count; $j++) {
        $totalfuel += [Math]::Abs($positions[$j] - $i)
    }
    if ($totalfuel -lt $minfuel) { $minfuel = $totalfuel; $minposition = $i }
}

Write-Output ("Part 1: " + $minfuel + " , " + $minposition)