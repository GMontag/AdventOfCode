$in = Get-Content "$PSScriptRoot\input.txt"

$currentpath = ""
$sizes = @{}

for ($i = 0; $i -lt $in.Count; $i++) {
    $line = $in[$i]
    if ($line[0] -eq "$") {
        $command = $line.Substring(2,2)
        if ($command -eq "cd") {
            $path = $line.Substring(5)
            if ($path -eq "/") {
                $currentpath = "/"
            } elseif ($path -eq "..") {
                $last = $currentpath.LastIndexOf("/")
                $currentpath = $currentpath.Substring(0,$last)
                if ($currentpath -eq "") { $currentpath = "/" }
            } else {
                if ($currentpath -eq "/") {
                    $currentpath += $path
                } else {
                    $currentpath += "/$path"
                }
            }
        }
    } else {
        if ($line.Substring(0,3) -eq "dir") {
            $dirname = $line.Substring(4)
            $path = $currentpath + "/$dirname"
            if (-not $sizes[$path]) { $sizes[$path] = 0 }
        } else {
            $null = $line -match "(\d+)"
            $size = [int]($Matches[1])
            $temp = $currentpath
            while ( $temp.LastIndexOf("/") -gt 0) {
                $sizes[$temp] += $size
                $temp = $temp.Substring(0,$temp.LastIndexOf("/"))
            }
            $sizes["/"] += $size
        }
    }
}

$total = ($sizes.Values | ? { $_ -le 100000 } | Measure-Object -Sum).Sum

Write-Host "Part 1: $total"

$rootsize = $sizes["/"]
$unusedspace = 70000000 - $rootsize
$neededspace = 30000000 - $unusedspace

$sortedsizes = $sizes.Values | Sort-Object

for ($i = 0; $i -lt $sortedsizes.Count; $i++) {
    if ($sortedsizes[$i] -gt $neededspace) {
        $part2total = $sortedsizes[$i]
        break
    }
}

Write-Host "Part 2: $part2total"