$in = Get-Content .\input.txt

$graph = @{}

for ($i = 0; $i -lt $in.Count; $i++) {
    $a,$b = $in[$i].Split("-")
    if ($graph.Keys -notcontains $a) {
        $graph[$a] = [System.Collections.ArrayList]@($b)
    } else {
        $null = $graph[$a].Add($b)
        $graph[$a].Sort()
    }
    if ($graph.Keys -notcontains $b) {
        $graph[$b] = [System.Collections.ArrayList]@($a)
    } else {
        $null = $graph[$b].Add($a)
        $graph[$b].Sort()
    }
}

$totalpaths = 0
$done = $false
$path = New-Object System.Collections.Stack
$path.Push("start")
$last = ""
while (-not $done) {
    $current = $path.Peek()
    if ($current -eq "end") {
        $totalpaths++
        Write-Output ($path.ToArray()[-1..-$path.Count] -join "-")
        $last = $path.Pop()
        continue
    }
    if ($last -eq "") {
        $next = ""
        foreach ($node in $graph[$current]) {
            if ( ($node.ToLower() -cne $node) -or ($path -notcontains $node) ) {
                $next = $node
                break
            }
        }
        if ($next) {
            $path.Push($next)
            continue
        } else {
            $last = $path.Pop()
            continue
        }
    } else {
        if ($last -eq $graph[$current][-1]) {
            if ($current -eq "start") {
                $done = $true
                continue
            } else {
                $last = $path.Pop()
                continue
            }
        } else {
            $lastpos = $graph[$current].IndexOf($last)
            $nodes = $graph[$current][($lastpos+1)..$graph[$current].Count]
            $next = ""
            foreach ($node in $nodes) {
                if ( ($node.ToLower() -cne $node) -or ($path -notcontains $node) ) {
                    $next = $node
                    break
                }
            }
            if ($next) {
                $path.Push($next)
                $last = ""
                continue
            } else {
                $last = $path.Pop()
                continue
            }
        }
    }
}

Write-Output ("Part 1: " + $totalpaths)