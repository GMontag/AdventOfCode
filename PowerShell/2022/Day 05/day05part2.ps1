$in = Get-Content "$PSScriptRoot\input.txt"

$stacks = [object[]]::new(9)
foreach ($i in 0..8) { $stacks[$i] = New-Object System.Collections.Stack }

for ($i = 7; $i -ge 0; $i--) {
    for ($j = 0; $j -le 8; $j++) {
        $crate = $in[$i][4*$j + 1]
        if ($crate -ne " ") { $stacks[$j].Push($crate) }
    }
}

for ($i = 10; $i -lt $in.Count; $i++) {
    $null = $in[$i] -match "move (\d+) from (\d+) to (\d+)"
    $quant = [int]$Matches[1]
    $source = [int]$Matches[2] - 1
    $dest = [int]$Matches[3] - 1
    
    $temp = New-Object System.Collections.Stack
    for ($j = 0; $j -lt $quant; $j++) {
        $crate = $stacks[$source].Pop()
        $temp.Push($crate)
    }
    for ($j = 0; $j -lt $quant; $j++) {
        $crate = $temp.Pop()
        $stacks[$dest].Push($crate)
    }
}

Write-Host "Part 1: " -NoNewline
for ($i = 0; $i -lt 9; $i++) { Write-Host $stacks[$i].Peek() -NoNewline }
Write-Host