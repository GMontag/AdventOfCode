class IntCodeProcessor {
    [System.Collections.Hashtable]$memory
    [int64]$pc = 0
    [int64]$rb = 0
    [bool]$halted = $false
    [bool]$waiting = $false
    [System.Collections.Queue]$inputQueue
    [System.Collections.Queue]$outputQueue

    IntCodeProcessor(
        [int64[]]$program,
        [System.Collections.Queue]$inputQueue,
        [System.Collections.Queue]$outputQueue
    ){
        $this.memory = New-Object System.Collections.Hashtable
        for ($i = [int64]0; $i -lt $program.Count; $i++){
            $this.memory[$i] = $program[$i]
        }
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
                    2 {
                        $asmstring += "@RB,$($params[0]) "
                        $params[0] = $this.memory[$this.rb + $params[0]]
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $($this.pc)"
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
                    2 {
                        $asmstring += "@RB,$($params[1]) "
                        $params[1] = $this.memory[$this.rb + $params[1]]
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $($this.pc)"
                        break
                    }
                }
                switch ($parammodes[2]) {
                    0 {
                        $asmstring += "@$($params[2])"
                        $this.memory[$params[2]] = $params[0] + $params[1]
                        $asmstring += "`t; $($this.memory[$params[2]]) -> @$($params[2])"
                    }
                    2 {
                        $asmstring += "@RB,$($params[2])"
                        $this.memory[$this.rb + $params[2]] = $params[0] + $params[1]
                        $asmstring += "`t; $($this.memory[$this.rb + $params[2]]) -> @$($this.rb + $params[2])"
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $($this.pc)"
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
                    2 {
                        $asmstring += "@RB,$($params[0]) "
                        $params[0] = $this.memory[$this.rb + $params[0]]
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $($this.pc)"
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
                    2 {
                        $asmstring += "@RB,$($params[1]) "
                        $params[1] = $this.memory[$this.rb + $params[1]]
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $($this.pc)"
                        break
                    }
                }
                switch ($parammodes[2]) {
                    0 {
                        $asmstring += "@$($params[2])"
                        $this.memory[$params[2]] = $params[0] * $params[1]
                        $asmstring += "`t; $($this.memory[$params[2]]) -> @$($params[2])"
                    }
                    2 {
                        $asmstring += "@RB,$($params[2]) "
                        $this.memory[$this.rb + $params[2]] = $params[0] * $params[1]
                        $asmstring += "`t; $($this.memory[$this.rb + $params[2]]) -> @$($this.rb + $params[2])"
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $($this.pc)"
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
                    2 {
                        $asmstring += "@RB,$($params[0])"
                        $this.memory[$this.rb + $params[0]] = $this.inputQueue.Dequeue()
                        $asmstring += "`t`t; $($this.memory[$this.rb + $params[0]]) -> @$($this.rb + $params[0])"
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $($this.pc)"
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
                    2 {
                        $asmstring += "@RB,$($params[0])"
                        $params[0] = $this.memory[$this.rb + $params[0]]
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $($this.pc)"
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
                    2 {
                        $asmstring += "@RB,$($params[0]) "
                        $params[0] = $this.memory[$this.rb + $params[0]]
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $($this.pc)"
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
                    2 {
                        $asmstring += "@RB,$($params[1]) "
                        $params[1] = $this.memory[$this.rb + $params[1]]
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $($this.pc)"
                        break
                    }
                }
                if ($params[0]) {
                    $this.pc = $params[1]
                    $instrlength = 0
                    $asmstring += "`t; $($this.pc) -> PC"
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
                    2 {
                        $asmstring += "@RB,$($params[0]) "
                        $params[0] = $this.memory[$this.rb + $params[0]]
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $($this.pc)"
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
                    2 {
                        $asmstring += "@RB,$($params[1]) "
                        $params[1] = $this.memory[$this.rb + $params[1]]
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $($this.pc)"
                        break
                    }
                }
                if (-not $params[0]) {
                    $this.pc = $params[1]
                    $instrlength = 0
                    $asmstring += "`t; $($this.pc) -> PC"
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
                    2 {
                        $asmstring += "@RB,$($params[0]) "
                        $params[0] = $this.memory[$this.rb + $params[0]]
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $($this.pc)"
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
                    2 {
                        $asmstring += "@RB,$($params[1]) "
                        $params[1] = $this.memory[$this.rb + $params[1]]
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $($this.pc)"
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
                    2 {
                        $asmstring += "@RB,$($params[2])"
                        if ($params[0] -lt $params[1]) {
                            $this.memory[$this.rb + $params[2]] = 1
                            $asmstring += "`t`t;1 -> @$($this.rb + $params[2])"
                        } else {
                            $this.memory[$this.rb + $params[2]] = 0
                            $asmstring += "`t`t;0 -> @$($this.rb + $params[2])"
                        }
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $($this.pc)"
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
                    2 {
                        $asmstring += "@RB,$($params[0]) "
                        $params[0] = $this.memory[$this.rb + $params[0]]
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $($this.pc)"
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
                    2 {
                        $asmstring += "@RB,$($params[1]) "
                        $params[1] = $this.memory[$this.rb + $params[1]]
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $($this.pc)"
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
                    2 {
                        $asmstring += "@RB,$($params[2])"
                        if ($params[0] -eq $params[1]) {
                            $this.memory[$this.rb + $params[2]] = 1
                            $asmstring += "`t`t;1 -> @$($this.rb + $params[2])"
                        } else {
                            $this.memory[$this.rb + $params[2]] = 0
                            $asmstring += "`t`t;0 -> @$($this.rb + $params[2])"
                        }
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $($this.pc)"
                        break
                    }
                }
            }

            9 {
                $asmstring = "ARB "
                $instrlength = 2
                switch ($parammodes[0]) {
                    0 {
                        $asmstring += "@$($params[0]) "
                        $params[0] = $this.memory[$params[0]]
                    }
                    1 {
                        $asmstring += "$($params[0]) "
                    }
                    2 {
                        $asmstring += "@RB,$($params[0]) "
                        $params[0] = $this.memory[$this.rb + $params[0]]
                    }
                    Default {
                        Write-Error -ErrorAction Stop "Error - invalid parameter mode $($this.memory[$this.pc]) at $($this.pc)"
                        break
                    }
                }
                $this.rb += $params[0]
                $asmstring += "`t`t; $($this.rb) -> RB"
            }

            99 {
                $asmstring = "HLT`t`t;"
                $instrlength = 1
                $this.halted = $true
            }

            Default {
                Write-Error -ErrorAction Stop "Error - invalid opcode $($this.memory[$this.pc]) at $($this.pc)"
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

# Read input
$in = Get-Content "$PSScriptRoot\input.txt"
$program = [int64[]]($in -split "," | % { [int64]$_ })

# Part 1
$iq = New-Object System.Collections.Queue
$iq.Enqueue(1)
$oq = New-Object System.Collections.Queue
$computer = [IntCodeProcessor]::New($program,$iq,$oq)
$computer.Run()
$out = $computer.outputQueue.Dequeue()

Write-Output "Part 1: $out"

# Part 2
$iq = New-Object System.Collections.Queue
$iq.Enqueue(2)
$oq = New-Object System.Collections.Queue
$computer = [IntCodeProcessor]::New($program,$iq,$oq)
$computer.Run()
$out = $computer.outputQueue.Dequeue()

Write-Output "Part 2: $out"