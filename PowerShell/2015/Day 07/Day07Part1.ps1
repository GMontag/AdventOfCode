$lines = Get-Content .\input.txt

class wire {
    [string]$name
    [wire]$input1
    [wire]$input2
    [string]$operation
    [int]$value
    hidden [Boolean]$evaled = $false

    wire ([String] $name) {
        $this.name = $name
        
        [Int32]$outnum = $null
        if ([Int32]::TryParse($name,[ref]$outnum)) {$this.value = $outnum; $this.evaled = $true}
    }

    [String] ToString() {return $this.name}

    [int]evalWire() {
        if ($this.evaled) { return $this.value }
        switch ($this.operation) {
            "THRU"      {$this.value = $this.input1.evalWire()}
            "AND"       {$this.value = $this.input1.evalWire() -band $this.input2.evalWire()}
            "OR"        {$this.value = $this.input1.evalWire() -bor $this.input2.evalWire()}
            "NOT"       {$this.value = -bnot $this.input1.evalWire()}
            "RSHIFT"    {$this.value = $this.input1.evalWire() -shr $this.input2.evalWire()}
            "LSHIFT"    {$this.value = $this.input1.evalWire() -shl $this.input2.evalWire()}
        }
        $this.evaled = $true
        return $this.value
    }
}

# parse input
$wires = @{}
$wirelist = $lines | % { $_.split() } | sort -unique | ? { ("AND","OR","NOT","RSHIFT","LSHIFT","->") -notcontains $_ }
foreach ($wirename in $wirelist) { $wires[$wirename] = [wire]::new($wirename) }

foreach ($line in $lines) {
    $tokens = $line.split()
    $wire = $wires[$tokens[-1]]
    switch ($tokens.Count) {
        3 {
            $wire.input1 = $wires[$tokens[0]]
            $wire.operation = "THRU"
        }
        4 {
            $wire.input1 = $wires[$tokens[1]]
            $wire.operation = $tokens[0]
        }
        5 {
            $wire.input1 = $wires[$tokens[0]]
            $wire.input2 = $wires[$tokens[2]]
            $wire.operation = $tokens[1]
        }
    }
}

# process wires
$wires["a"].evalWire()