$in = Get-Content "$PSScriptRoot\input.txt"

$keypad = ("","","","","","",""),("","","","1","","",""),("","","2","3","4","",""),("","5","6","7","8","9",""),("","","A","B","C","",""),("","","","D","","",""),("","","","","","","")
$x = 1; $y = 3
for ($i = 0; $i -lt $in.Count; $i++) {
    for ($j = 0; $j -lt $in[$i].Length; $j++) {
        switch ($in[$i][$j]) {
            "U" { $newx = $x; $newy = $y - 1 }
            "D" { $newx = $x; $newy = $y + 1 }
            "L" { $newx = $x - 1; $newy = $y }
            "R" { $newx = $x + 1; $newy = $y }
        }
        if ($keypad[$newy][$newx] -ne "") { $x = $newx; $y = $newy}
    }
    Write-Host $keypad[$y][$x] -NoNewLine
}
Write-Host