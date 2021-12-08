$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

# parse input

$bagcolors = @{}

foreach ($line in $in) {
    $words = $line -split " "
    $bagcolor = $words[0] + " " + $words[1]
    $containedbags = @()
    if ($words[4] -ne "no") {
        for ($i = 4; $i -lt $words.Count; $i += 4) {
            $quantity = [int]$words[$i]
            $color = $words[$i+1] + " " + $words[$i+2]
            $containedbags += New-Object PSObject -Property @{
                quantity = $quantity
                color = $color
            }
        }
    }
    $bagcolors[$bagcolor] = $containedbags
}

function Get-Total {
    param([string]$color)
    $total = 1
    foreach ($containedbag in $bagcolors[$color]) {
        $total += $containedbag.quantity * (Get-Total $containedbag.color)
    }
    return $total
}

Write-Output ("Part 2: " + ((Get-Total "shiny gold") - 1))