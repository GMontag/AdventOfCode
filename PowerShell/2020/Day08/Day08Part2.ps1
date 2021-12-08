$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

for ($i = 0; $i -lt $in.Count; $i++) {
    if ($in[$i][0..3] -eq "acc") { continue }

    $memory = $in.Clone()
    if ($memory[$i][0..3] -eq "nop") {
        $memory[$i] = $memory[$i] -replace "nop", "jmp"
    } else {
        $memory[$i] = $memory[$i] -replace "jmp", "nop"
    }
    $pc = 0
    $acc = 0
    $halted = $false
    $haltednaturally = $false

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
        if ($pc -eq $memory.Count) {
            $halted = $true
            $haltednaturally = $true
        }
    }

    if ($halted -and $haltednaturally) { break }
}

Write-Output "Part 2: $acc"