$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

# parse input

$bagcolors = @{}

foreach ($line in $in) {
    $words = $line -split " "
    $bagcolor = $words[0] + " " + $words[1]
    $containedbags = @()
    for ($i = 4; $i -lt $words.Count; $i += 4) {
        $containedbags += $words[($i+1)..($i+2)] -join " "
    }
    foreach ($bag in $containedbags) {
        if ($bag -notin $bagcolors.Keys) { $bagcolors[$bag] = @() }
        $bagcolors[$bag] += $bagcolor
    }
}

$processingqueue = New-Object System.Collections.Queue
$processingqueue.Enqueue("shiny gold")
$containablecolors = @{}

while ($processingqueue.Count -ne 0) {
    $currentcolor = $processingqueue.Dequeue()
    
    foreach ($color in $bagcolors[$currentcolor]) {
        $containablecolors[$color] = $true
        $processingqueue.Enqueue($color)
    }
}

Write-Output ("Part 1: " + $containablecolors.Keys.Count)