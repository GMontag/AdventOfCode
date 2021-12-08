$in = Get-Content "$PSScriptRoot\input.txt"

$objects = @{}

foreach ($line in $in) {
    $object,$orbiter = $line -split ')',0,"simplematch"
    
    if (-not $objects[$object]) {
        $objects[$object] = New-Object PSObject @{
            indirectlevel = -1
            orbiters = New-Object System.Collections.ArrayList
        }
    }
    $null = $objects[$object].orbiters.Add($orbiter)
    if (-not $objects[$orbiter]) {
        $objects[$orbiter] = New-Object PSObject @{
            indirectlevel = -1
            orbiters = New-Object System.Collections.ArrayList
        }
    }
}

$parentlevel = 0
$processingqueue = New-Object System.Collections.Queue
$processingqueue.Enqueue("COM")
$processingqueue.Enqueue(-1)

while ($processingqueue.Count -ne 0) {
    $current = $processingqueue.Dequeue()
    if ( $current -eq -1 ) { if ($processingqueue.Count -ne 0) {$processingqueue.Enqueue(-1)}; $parentlevel++; continue }
    $objects[$current].indirectlevel = $parentlevel
    foreach ($object in $objects[$current].orbiters) { $processingqueue.Enqueue($object) }
}

Write-Host ($objects.Values.indirectlevel | measure -sum | select sum -ExpandProperty sum)