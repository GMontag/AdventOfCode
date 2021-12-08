$in = Get-Content .\input.txt

$memory = $in -split "," | % { [int]$_ }

$memory[1] = 12
$memory[2] = 2

for ($i = 0; $i -lt $memory.Count; $i += 4) {
    switch ($memory[$i]) {
        1 {
            $memory[$memory[$i + 3]] = $memory[$memory[$i + 1]] + $memory[$memory[$i + 2]]
        }

        2 {
            $memory[$memory[$i + 3]] = $memory[$memory[$i + 1]] * $memory[$memory[$i + 2]]
        }

        99 {
            $i = $memory.Count
        }
        Default {
            "Error - unknown opcode at $i"
            break
        }
    }
}

"Part 1: $($memory[0])"


for ($noun = 0; $noun -lt 100; $noun++) {
    for ($verb = 0; $verb -lt 100; $verb++) {
        $memory = $in -split "," | % { [int]$_ }
        $memory[1] = $noun
        $memory[2] = $verb

        for ($i = 0; $i -lt $memory.Count; $i += 4) {
            switch ($memory[$i]) {
                1 {
                    $memory[$memory[$i + 3]] = $memory[$memory[$i + 1]] + $memory[$memory[$i + 2]]
                }
        
                2 {
                    $memory[$memory[$i + 3]] = $memory[$memory[$i + 1]] * $memory[$memory[$i + 2]]
                }
        
                99 {
                    $i = $memory.Count
                }
                Default {
                    "Error - unknown opcode at $i"
                    break
                }
            }
        }
        
        if ($memory[0] -eq 19690720) {
            "Part 2: $noun $verb"
            $noun = 100
            $verb = 100
        }
    }
}

