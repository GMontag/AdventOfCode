$in = Get-Content "$PSScriptRoot\input.txt"

$memory = $in -split "," | % { [int]$_ }
$input = 5

$pc = 0
$halt = $false

while (-not $halt) {
    $instr = $memory[$pc]
    $params = @($memory[$pc+1], $memory[$pc+2], $memory[$pc+3])
    $opcode = $instr % 100
    $parammodes = @( (($instr % 1000 - $instr % 100)/100), (($instr % 10000 - $instr % 1000)/1000), (($instr % 100000 - $instr % 10000)/10000) )
    

    switch ($opcode) {
        1 {
            $instrlength = 4
            if ($parammodes[0] -eq 0) {$params[0] = $memory[$params[0]]}
            if ($parammodes[1] -eq 0) {$params[1] = $memory[$params[1]]}
            $memory[$params[2]] = $params[0] + $params[1]
        }

        2 {
            $instrlength = 4
            if ($parammodes[0] -eq 0) {$params[0] = $memory[$params[0]]}
            if ($parammodes[1] -eq 0) {$params[1] = $memory[$params[1]]}
            $memory[$params[2]] = $params[0] * $params[1]
        }

        3 {
            $instrlength = 2
            $memory[$params[0]] = $input
        }

        4 {
            $instrlength = 2
            if ($parammodes[0] -eq 0) {$params[0] = $memory[$params[0]]}
            Write-Host $params[0]
        }

        5 {
            $instrlength = 3
            if ($parammodes[0] -eq 0) {$params[0] = $memory[$params[0]]}
            if ($parammodes[1] -eq 0) {$params[1] = $memory[$params[1]]}
            if ($params[0]) {
                $pc = $params[1]
                $instrlength = 0
            }
        }

        6 {
            $instrlength = 3
            if ($parammodes[0] -eq 0) {$params[0] = $memory[$params[0]]}
            if ($parammodes[1] -eq 0) {$params[1] = $memory[$params[1]]}
            if (-not $params[0]) {
                $pc = $params[1]
                $instrlength = 0
            }
        }

        7 {
            $instrlength = 4
            if ($parammodes[0] -eq 0) {$params[0] = $memory[$params[0]]}
            if ($parammodes[1] -eq 0) {$params[1] = $memory[$params[1]]}
            if ($params[0] -lt $params[1]) { $memory[$params[2]] = 1 } else { $memory[$params[2]] = 0 }
        }

        8 {
            $instrlength = 4
            if ($parammodes[0] -eq 0) {$params[0] = $memory[$params[0]]}
            if ($parammodes[1] -eq 0) {$params[1] = $memory[$params[1]]}
            if ($params[0] -eq $params[1]) { $memory[$params[2]] = 1 } else { $memory[$params[2]] = 0 }
        }

        99 {
            $instrlength = 1
            $halt = $true
        }

        Default {
            "Error - unknown opcode at $pc"
            break
        }
    }

    $pc += $instrlength
    if ($pc -ge $memory.Count) { $halt = $true }
}