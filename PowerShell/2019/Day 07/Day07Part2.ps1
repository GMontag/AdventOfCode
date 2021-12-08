class IntCodeProcessor {
    [int[]]$memory
    [int]$pc = 0
    [bool]$halted = $false
    [bool]$waiting = $false
    [System.Collections.Queue]$inputQueue
    [System.Collections.Queue]$outputQueue

    IntCodeProcessor(
        [int[]]$program,
        [System.Collections.Queue]$inputQueue,
        [System.Collections.Queue]$outputQueue
    ){
        $this.memory = $program.Clone()
        $this.inputQueue = $inputQueue
        $this.outputQueue = $outputQueue
    }

    [void] RunOne(){
        if ($this.halted -or ($this.waiting -and $this.inputQueue.Count -eq 0)) { return }

        $instr = $this.memory[$this.pc]
        $opcode = $instr % 100
        $params = @($this.memory[$this.pc+1], $this.memory[$this.pc+2], $this.memory[$this.pc+3])
        $parammodes = @( (($instr % 1000 - $instr % 100)/100), (($instr % 10000 - $instr % 1000)/1000), (($instr % 100000 - $instr % 10000)/10000) )
        $asmstring = ""
        $instrlength = 0

        switch ($opcode) {
            1 {
                $asmstring = "ADD "
                $instrlength = 4
                switch ($parammodes[0]) {
                    0 {
                        $asmstring += "@$($params[0]) "
                        $params[0] = $this.memory[$params[0]]
                    }

                    1 {
                        $asmstring += "$($params[0]) "
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $this.pc"
                        break
                    }
                }
                switch ($parammodes[1]) {
                    0 {
                        $asmstring += "@$($params[1]) "
                        $params[1] = $this.memory[$params[1]]
                    }

                    1 {
                        $asmstring += "$($params[1]) "
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $this.pc"
                        break
                    }
                }
                switch ($parammodes[2]) {
                    0 {
                        $asmstring += "@$($params[2])"
                        $this.memory[$params[2]] = $params[0] + $params[1]
                        $asmstring += "`t; $($this.memory[$params[2]]) -> @$($params[2])"
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $this.pc"
                        break
                    }
                }
            }

            2 {
                $asmstring = "MUL "
                $instrlength = 4
                switch ($parammodes[0]) {
                    0 {
                        $asmstring += "@$($params[0]) "
                        $params[0] = $this.memory[$params[0]]
                    }

                    1 {
                        $asmstring += "$($params[0]) "
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $this.pc"
                        break
                    }
                }
                switch ($parammodes[1]) {
                    0 {
                        $asmstring += "@$($params[1]) "
                        $params[1] = $this.memory[$params[1]]
                    }

                    1 {
                        $asmstring += "$($params[1]) "
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $this.pc"
                        break
                    }
                }
                switch ($parammodes[2]) {
                    0 {
                        $asmstring += "@$($params[2])"
                        $this.memory[$params[2]] = $params[0] * $params[1]
                        $asmstring += "`t; $($this.memory[$params[2]]) -> @$($params[2])"
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $this.pc"
                        break
                    }
                }
            }

            3 {
                $asmstring = "INP "
                $instrlength = 2
                if ($this.inputQueue.Count -eq 0) {
                    $this.waiting = $true
                    return
                } else {
                    $this.waiting = $false
                }
                switch ($parammodes[0]) {
                    0 {
                        $asmstring += "@$($params[0])"
                        $this.memory[$params[0]] = $this.inputQueue.Dequeue()
                        $asmstring += "`t`t; $($this.memory[$params[0]]) -> @$($params[0])"
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $this.pc"
                        break
                    }
                }
                
            }

            4 {
                $asmstring = "OUT "
                $instrlength = 2
                switch ($parammodes[0]) {
                    0 {
                        $asmstring += "@$($params[0])"
                        $params[0] = $this.memory[$params[0]]
                    }
                    1 {
                        $asmstring += "$($params[0])"
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $this.pc"
                        break
                    }
                }
                $this.outputQueue.Enqueue($params[0])
                $asmstring += "`t`t; $($params[0]) -> OUT"
            }

            5 {
                $asmstring = "JNZ "
                $instrlength = 3
                switch ($parammodes[0]) {
                    0 {
                        $asmstring += "@$($params[0]) "
                        $params[0] = $this.memory[$params[0]]
                    }
                    1 {
                        $asmstring += "$($params[0]) "
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $this.pc"
                        break
                    }
                }
                switch ($parammodes[1]) {
                    0 {
                        $asmstring += "@$($params[1])"
                        $params[1] = $this.memory[$params[1]]
                    }

                    1 {
                        $asmstring += "$($params[1])"
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $this.pc"
                        break
                    }
                }
                if ($params[0]) {
                    $this.pc = $params[1]
                    $instrlength = 0
                    $asmstring += "`t; $this.pc -> PC"
                } else {
                    $asmstring += "`t;"
                }
            }

            6 {
                $asmstring = "JZ "
                $instrlength = 3
                switch ($parammodes[0]) {
                    0 {
                        $asmstring += "@$($params[0]) "
                        $params[0] = $this.memory[$params[0]]
                    }
                    1 {
                        $asmstring += "$($params[0]) "
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $this.pc"
                        break
                    }
                }
                switch ($parammodes[1]) {
                    0 {
                        $asmstring += "@$($params[1])"
                        $params[1] = $this.memory[$params[1]]
                    }

                    1 {
                        $asmstring += "$($params[1])"
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $this.pc"
                        break
                    }
                }
                if (-not $params[0]) {
                    $this.pc = $params[1]
                    $instrlength = 0
                    $asmstring += "`t; $this.pc -> PC"
                } else {
                    $asmstring += "`t;"
                }
            }

            7 {
                $asmstring = "LT "
                $instrlength = 4
                switch ($parammodes[0]) {
                    0 {
                        $asmstring += "@$($params[0]) "
                        $params[0] = $this.memory[$params[0]]
                    }
                    1 {
                        $asmstring += "$($params[0]) "
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $this.pc"
                        break
                    }
                }
                switch ($parammodes[1]) {
                    0 {
                        $asmstring += "@$($params[1]) "
                        $params[1] = $this.memory[$params[1]]
                    }

                    1 {
                        $asmstring += "$($params[1]) "
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $this.pc"
                        break
                    }
                }
                switch ($parammodes[2]) {
                    0 {
                        $asmstring += "@$($params[2])"
                        if ($params[0] -lt $params[1]) {
                            $this.memory[$params[2]] = 1
                            $asmstring += "`t`t;1 -> @$($params[2])"
                        } else {
                            $this.memory[$params[2]] = 0
                            $asmstring += "`t`t;0 -> @$($params[2])"
                        }
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $this.pc"
                        break
                    }
                }
                
            }

            8 {
                $asmstring = "EQ "
                $instrlength = 4
                switch ($parammodes[0]) {
                    0 {
                        $asmstring += "@$($params[0]) "
                        $params[0] = $this.memory[$params[0]]
                    }
                    1 {
                        $asmstring += "$($params[0]) "
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $this.pc"
                        break
                    }
                }
                switch ($parammodes[1]) {
                    0 {
                        $asmstring += "@$($params[1]) "
                        $params[1] = $this.memory[$params[1]]
                    }

                    1 {
                        $asmstring += "$($params[1]) "
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $this.pc"
                        break
                    }
                }
                switch ($parammodes[2]) {
                    0 {
                        $asmstring += "@$($params[2])"
                        if ($params[0] -eq $params[1]) {
                            $this.memory[$params[2]] = 1
                            $asmstring += "`t`t;1 -> @$($params[2])"
                        } else {
                            $this.memory[$params[2]] = 0
                            $asmstring += "`t`t;0 -> @$($params[2])"
                        }
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $this.pc"
                        break
                    }
                }
            }

            99 {
                $asmstring = "HLT`t`t;"
                $instrlength = 1
                $this.halted = $true
            }

            Default {
                Write-Error -ErrorAction Stop "Error - invalid opcode $($this.memory[$this.pc]) at $this.pc"
                break
            }
        }
        Write-Debug $asmstring
        $this.pc += $instrlength
        if ($this.pc -ge $this.memory.Count) { $this.halted = $true }

    }

    [void] Run(){
        while (-not $this.halted) { $this.RunOne() }
    }
    #[void] Restart(){}
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

# Read input
$in = Get-Content "$PSScriptRoot\input.txt"

$program = [int[]]($in -split "," | % { [int]$_ })

# Part 1
$maxoutput = 0
foreach ($phases in permutation(0..4)) {
    $amplifiers = New-Object object[] 5
    $iq = New-Object System.Collections.Queue
    $oq = New-Object System.Collections.Queue
    for ($i = 0; $i -lt 5; $i ++) {
        $iq.Enqueue([int][string]$phases[$i])
        $amplifiers[$i] = [IntCodeProcessor]::New($program,$iq,$oq)
        $iq = $oq
        $oq = New-Object System.Collections.Queue
    }
    $amplifiers[0].inputQueue.Enqueue(0)
    for ($i = 0; $i -lt 5; $i++) {
        $amplifiers[$i].Run()
    }
    $out = $amplifiers[4].outputQueue.Dequeue()
    if ($out -gt $maxoutput) { $maxoutput = $out }
}

Write-Output "Part 1: $maxoutput"

# Part 2
$maxoutput = 0
foreach ($phases in permutation(5..9)) {
    $amplifiers = New-Object object[] 5
    $iq = New-Object System.Collections.Queue
    $oq = New-Object System.Collections.Queue
    for ($i = 0; $i -lt 5; $i ++) {
        $iq.Enqueue([int][string]$phases[$i])
        $amplifiers[$i] = [IntCodeProcessor]::New($program,$iq,$oq)
        $iq = $oq
        $oq = New-Object System.Collections.Queue
    }
    $amplifiers[4].outputQueue = $amplifiers[0].inputQueue
    $amplifiers[0].inputQueue.Enqueue(0)
    $allhalted = $false
    while (-not $allhalted) {
        $allhalted = $true
        for ($i = 0; $i -lt 5; $i++) {
            $amplifiers[$i].RunOne()
            $allhalted = $allhalted -and $amplifiers[$i].halted
        }
    }
    $out = $amplifiers[4].outputQueue.Dequeue()
    if ($out -gt $maxoutput) { $maxoutput = $out }
}

Write-Output "Part 2: $maxoutput"