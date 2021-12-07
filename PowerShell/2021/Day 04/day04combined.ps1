$in = Get-Content .\input.txt

$numbers = $in[0].Split(",")

$boards = New-Object int[][] (($in.Count - 1)/6),25
$boardmarks = New-Object int[] (($in.Count - 1)/6)
$winmasks = @(31,992,31744,1015808,32505856,1082401,2164802,4329604,8659208,17318416)

for ($i=0; $i -lt $boards.Count; $i++) {
    for ($j=0; $j -lt 5; $j++) {
        $line = (6*$i + 2 + $j)
        for ($k=0; $k -lt 5; $k++) {
            $boards[$i][5*$j + $k] = [int]($in[$line].Trim() -split "\s+")[$k]
        }
    }
}

$won = ,$false * $boards.Count
$woncount = 0;
$firstboard = -1
$firstnumber = -1
$lastboard = -1
$lastnumber = -1
for ($i = 0; $i -lt $numbers.Count; $i++) {
    for ($j = 0; $j -lt $boards.Count; $j++) {
        if ($won[$j]) { continue }
        for ($k = 0; $k -lt 25; $k++) {
            if ([int]$numbers[$i] -eq $boards[$j][$k]) {
                $boardmarks[$j] += [Math]::Pow(2,$k)
            }
        }
    }

    for ($j = 0; $j -lt $boardmarks.Count; $j++) {
        if ($won[$j]) { continue }
        for ($k = 0; $k -lt $winmasks.Count; $k++) {
            if ( ($boardmarks[$j] -band $winmasks[$k]) -eq $winmasks[$k]) {
                $won[$j] = $true
                if ($woncount -eq 0) { $firstboard = $j; $firstnumber = [int]$numbers[$i] }
                $lastboard = $j; $lastnumber = [int]$numbers[$i]
                $woncount++
            }
        }
    }
}

$firstsum = 0
for ($i = 0; $i -lt 25; $i++) {
    if (-not ($boardmarks[$firstboard] -band [Math]::Pow(2,$i))) { $firstsum += $boards[$firstboard][$i] }
}

$lastsum = 0
for ($i = 0; $i -lt 25; $i++) {
    if (-not ($boardmarks[$lastboard] -band [Math]::Pow(2,$i))) { $lastsum += $boards[$lastboard][$i] }
}

Write-Output ("Part 1: " + $firstsum * $firstnumber)
Write-Output ("Part 2: " + $lastsum * $lastnumber)