function evalExpression {
    param ([String]$expression)

    $result = 0
    $cursor = 0
    $operator = "+"
    while ($cursor -lt $expression.Length) {
        switch -regex ($expression[$cursor]) {
            " " { break }
            "\+" { $operator = "+" }
            "\*" { $operator = "*" }
            "\d" {
                switch ($operator) {
                    "+" { $result += [int][String]$expression[$cursor] }
                    "*" { $result *= [int][String]$expression[$cursor] }
                }
            }
            "\(" {
                $subexstart = $cursor+1
                $subexlength = 0
                $parencount = 1
                while ($parencount -gt 0) {
                    switch ($expression[$subexstart+$subexlength]) {
                        "(" { $parencount++ }
                        ")" { $parencount-- }
                    }
                    $subexlength++
                }
                $subex = $expression.Substring($subexstart,$subexlength-1)
                $subresult = evalExpression $subex
                switch ($operator) {
                    "+" { $result += $subresult }
                    "*" { $result *= $subresult }
                }
                $cursor += $subexlength
            }
        }
        $cursor++
    }
    return $result
}

$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$total = 0

foreach ($line in $in) {
    $total += (evalExpression $line)
}

Write-Output "Part 1: $total"