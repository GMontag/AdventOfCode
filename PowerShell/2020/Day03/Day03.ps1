$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$xmax = $in[0].Length
$slopes = @( @(1,1), @(3,1), @(5,1), @(7,1), @(1,2) )
$treecounts = @(0,0,0,0,0)

for ($i = 0; $i -lt $slopes.Count; $i++) {
    $x = 0
    for ($y = 0; $y -lt $in.Count; ) {
        if ($in[$y][$x] -eq "#") { $treecounts[$i]++ }
        $x += $slopes[$i][0]
        $x %= $xmax
        $y += $slopes[$i][1]
    }
}

Write-Output "Part 1: $($treecounts[1])"
Write-Output ("Part 2: " + ( $treecounts | foreach {$total = 1} {$total *= $_} {$total}))