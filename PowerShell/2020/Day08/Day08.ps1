$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$memory = $in
$pc = 0
$acc = 0
$halted = $false

$visited = @{}
while (-not $halted) {
    if ($pc -in $visited.Keys) {
        $halted = $true
        break
    } 
    $visited[$pc] = $true
    $null = $memory[$pc] -match "(\w{3}) \+?(-?\d*)"
    $instr = $Matches[1]
    $operand = [int]$Matches[2]

    switch ($instr) {
        "nop" {
            break
        }
        "acc" {
            $acc += $operand
            break
        }
        "jmp" {
            $pc += ($operand - 1)
            break
        }
    }

    $pc++
}

Write-Output "Part 1: $acc"