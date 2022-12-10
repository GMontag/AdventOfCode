$in = Get-Content "$PSScriptRoot\input.txt"

$pc = 0
$instrpc = 0
$x = 1
$cycle = 1

$crt = ""

$executing = $true

while ($executing) {
    $drawpos = ($cycle - 1) % 40
    if ([math]::Abs($x - $drawpos) -le 1) { $crt += "#" } else { $crt += " " }
    if ($drawpos -eq 39) { $crt += "`n" } 
    $instr = $in[$pc].Substring(0,4)
    switch ($instr) {
        "noop" {
            $pc++
            $instrpc = 0
        }
        "addx" {
            if ($instrpc -eq 1) {
                $oper = [int]($in[$pc].Substring(5))
                $x += $oper
                $pc++
                $instrpc = 0
            } else {
                $instrpc++
            }
        }
    }
    $cycle++
    if ($pc -ge $in.Count) { $executing = $false}
}

Write-Host "Part 2:"
Write-Host $crt