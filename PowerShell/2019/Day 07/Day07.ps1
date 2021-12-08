$in = Get-Content "$PSScriptRoot\input.txt"

$program = [int[]]($in -split "," | % { [int]$_ })

function Run-Intcode {
    param ( [Int[]]$program,
            [Int[]]$inp,
            [Switch]$debug)
    
    $memory = $program.Clone()
    $inpcounter = 0
    $outp = 0

    $pc = 0
    while (-not $halt) {
        $instr = $memory[$pc]
        $opcode = $instr % 100
        $params = @($memory[$pc+1], $memory[$pc+2], $memory[$pc+3])
        $parammodes = @( (($instr % 1000 - $instr % 100)/100), (($instr % 10000 - $instr % 1000)/1000), (($instr % 100000 - $instr % 10000)/10000) )

        switch ($opcode) {
            1 {
                $asmstring = "ADD "
                $instrlength = 4
                switch ($parammodes[0]) {
                    0 {
                        $asmstring += "@$($params[0]) "
                        $params[0] = $memory[$params[0]]
                    }

                    1 {
                        $asmstring += "$($params[0]) "
                    }
                }
                switch ($parammodes[1]) {
                    0 {
                        $asmstring += "@$($params[1]) "
                        $params[1] = $memory[$params[1]]
                    }

                    1 {
                        $asmstring += "$($params[1]) "
                    }
                }
                switch ($parammodes[2]) {
                    0 {
                        $asmstring += "@$($params[2])"
                        $memory[$params[2]] = $params[0] + $params[1]
                        $asmstring += "`t; $($memory[$params[2]]) -> @$($params[2])"
                    }
                }
            }

            2 {
                $asmstring = "MUL "
                $instrlength = 4
                switch ($parammodes[0]) {
                    0 {
                        $asmstring += "@$($params[0]) "
                        $params[0] = $memory[$params[0]]
                    }

                    1 {
                        $asmstring += "$($params[0]) "
                    }
                }
                switch ($parammodes[1]) {
                    0 {
                        $asmstring += "@$($params[1]) "
                        $params[1] = $memory[$params[1]]
                    }

                    1 {
                        $asmstring += "$($params[1]) "
                    }
                }
                switch ($parammodes[2]) {
                    0 {
                        $asmstring += "@$($params[2])"
                        $memory[$params[2]] = $params[0] * $params[1]
                        $asmstring += "`t; $($memory[$params[2]]) -> @$($params[2])"
                    }
                }
            }

            3 {
                $asmstring = "INP "
                $instrlength = 2
                switch ($parammodes[0]) {
                    0 {
                        $asmstring += "@$($params[0])"
                        $memory[$params[0]] = $inp[$inpcounter]
                        $asmstring += "`t`t; $($inp[$inpcounter]) -> @$($params[0])"
                    }
                }
                $inpcounter++
            }

            4 {
                $asmstring = "OUT "
                $instrlength = 2
                switch ($parammodes[0]) {
                    0 {
                        $asmstring += "@$($params[0])"
                        $params[0] = $memory[$params[0]]
                    }
                    1 {
                        $asmstring += "$($params[0])"
                    }
                }
                $outp = $params[0]
                $asmstring += "`t`t; $outp -> OUT"
            }

            5 {
                $asmstring = "JNZ "
                $instrlength = 3
                switch ($parammodes[0]) {
                    0 {
                        $asmstring += "@$($params[0]) "
                        $params[0] = $memory[$params[0]]
                    }
                    1 {
                        $asmstring += "$($params[0]) "
                    }
                }
                switch ($parammodes[1]) {
                    0 {
                        $asmstring += "@$($params[1])"
                        $params[1] = $memory[$params[1]]
                    }

                    1 {
                        $asmstring += "$($params[1])"
                    }
                }
                if ($params[0]) {
                    $pc = $params[1]
                    $instrlength = 0
                    $asmstring += "`t; $pc -> PC"
                }
            }

            6 {
                $asmstring = "JZ "
                $instrlength = 3
                switch ($parammodes[0]) {
                    0 {
                        $asmstring += "@$($params[0]) "
                        $params[0] = $memory[$params[0]]
                    }
                    1 {
                        $asmstring += "$($params[0]) "
                    }
                }
                switch ($parammodes[1]) {
                    0 {
                        $asmstring += "@$($params[1])"
                        $params[1] = $memory[$params[1]]
                    }

                    1 {
                        $asmstring += "$($params[1])"
                    }
                }
                if (-not $params[0]) {
                    $pc = $params[1]
                    $instrlength = 0
                }
            }

            7 {
                $asmstring = "LT "
                $instrlength = 4
                switch ($parammodes[0]) {
                    0 {
                        $asmstring += "@$($params[0]) "
                        $params[0] = $memory[$params[0]]
                    }
                    1 {
                        $asmstring += "$($params[0]) "
                    }
                }
                switch ($parammodes[1]) {
                    0 {
                        $asmstring += "@$($params[1]) "
                        $params[1] = $memory[$params[1]]
                    }

                    1 {
                        $asmstring += "$($params[1]) "
                    }
                }
                switch ($parammodes[2]) {
                    0 {
                        $asmstring += "@$($params[2])"
                        if ($params[0] -lt $params[1]) { $memory[$params[2]] = 1 } else { $memory[$params[2]] = 0 }
                    }
                }
                
            }

            8 {
                $asmstring = "EQ "
                $instrlength = 4
                switch ($parammodes[0]) {
                    0 {
                        $asmstring += "@$($params[0]) "
                        $params[0] = $memory[$params[0]]
                    }
                    1 {
                        $asmstring += "$($params[0]) "
                    }
                }
                switch ($parammodes[1]) {
                    0 {
                        $asmstring += "@$($params[1]) "
                        $params[1] = $memory[$params[1]]
                    }

                    1 {
                        $asmstring += "$($params[1]) "
                    }
                }
                switch ($parammodes[2]) {
                    0 {
                        $asmstring += "@$($params[2])"
                        if ($params[0] -eq $params[1]) { $memory[$params[2]] = 1 } else { $memory[$params[2]] = 0 }
                    }
                }
            }

            99 {
                $asmstring = "HLT"
                $instrlength = 1
                $halt = $true
            }

            Default {
                Write-Error -ErrorAction Stop "Error - unknown opcode $($memory[$pc]) at $pc"
                break
            }
        }
        if ($debug) { Write-Host $asmstring }
        $pc += $instrlength
        if ($pc -ge $memory.Count) { $halt = $true }
    }
    return $outp
}

# code taken from rosettacode.org/wiki/Permutations#PowerShell
function permutation ($array) {
    function generate($n, $array, $A) {
        if($n -eq 1) {
            $array[$A] -join ''
        }
        else{
            for( $i = 0; $i -lt ($n - 1); $i += 1) {
                generate ($n - 1) $array $A
                if($n % 2 -eq 0){
                    $i1, $i2 = $i, ($n-1)
                    $A[$i1], $A[$i2] = $A[$i2], $A[$i1]
                }
                else{
                    $i1, $i2 = 0, ($n-1)
                    $A[$i1], $A[$i2] = $A[$i2], $A[$i1]
                }
            }
            generate ($n - 1) $array $A
        }
    }
    $n = $array.Count
    if($n -gt 0) {
        (generate $n $array (0..($n-1)))
    } else {$array}
}

$maxoutput = 0

foreach ($phases in permutation(0..4)) {
    # Write-Host $phases
    $outp = 0
    for ($i = 0; $i -lt 5; $i++) {
        $inp = @([int]("$($phases[$i])"), $outp)
        # Write-Host $inp
        $outp = Run-Intcode $program $inp
    }
    if ($outp -gt $maxoutput) { $maxoutput = $outp }
}

Write-Host $maxoutput