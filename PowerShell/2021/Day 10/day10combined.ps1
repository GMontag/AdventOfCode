$in = Get-Content .\input.txt

$stack = New-Object System.Collections.Stack

$part1total = 0
$part2totals = [System.Collections.ArrayList]@()
for ($i = 0; $i -lt $in.Count; $i++) {
    $stack.Clear()
    $stack.Push($in[$i][0])
    for ($j = 1; $j -lt $in[$i].Length; $j++) {
        $illegal = ""
        switch ($in[$i][$j]) {
            "(" { $stack.Push("(") }
            "[" { $stack.Push("[") }
            "{" { $stack.Push("{") }
            "<" { $stack.Push("<") }
            ")" { if ($stack.Peek() -eq "(") { $null = $stack.Pop() } else { $illegal = ")"; $part1total += 3 } }
            "]" { if ($stack.Peek() -eq "[") { $null = $stack.Pop() } else { $illegal = "]"; $part1total += 57 } }
            "}" { if ($stack.Peek() -eq "{") { $null = $stack.Pop() } else { $illegal = "}"; $part1total += 1197 } }
            ">" { if ($stack.Peek() -eq "<") { $null = $stack.Pop() } else { $illegal = ">"; $part1total += 25137 } }
        }
        if ($illegal -ne "") { break }
    }
    if ($illegal -eq "") {
        $part2 = 0
        while ($stack.Count -gt 0) {
            $part2 *= 5
            $character = $stack.Pop()
            switch ($character) {
                "(" { $part2 += 1 }
                "[" { $part2 += 2 }
                "{" { $part2 += 3 }
                "<" { $part2 += 4 }
            }
        }
        $null = $part2totals.Add($part2)
    }
}

$part2answer = ($part2totals | Sort-Object)[$part2totals.Count/2]
Write-Output ("Part 1: " + $part1total)
Write-Output ("Part 2: " + $part2answer)