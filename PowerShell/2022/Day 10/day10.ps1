$in = Get-Content "$PSScriptRoot\input.txt"

$pc = 0
$instrpc = 0
$x = 1
$cycle = 1

$cyclecounts = @(20,60,100,140,180,220)
$signaltotal = 0

$executing = $true

while ($executing) {
    if ($cycle -in $cyclecounts) { $signaltotal += $cycle * $x }
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

Write-Host "Part 1: $signaltotal"