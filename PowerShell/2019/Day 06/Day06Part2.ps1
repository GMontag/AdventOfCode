$in = Get-Content "$PSScriptRoot\input.txt"

$objects = @{}

foreach ($line in $in) {
    $object,$orbiter = $line -split ')',0,"simplematch"
    
    if (-not $objects[$object]) {
        $objects[$object] = New-Object PSObject @{
            indirectlevel = -1
            orbiters = New-Object System.Collections.ArrayList
            orbiting = ""
        }
    }
    $null = $objects[$object].orbiters.Add($orbiter)
    if (-not $objects[$orbiter]) {
        $objects[$orbiter] = New-Object PSObject @{
            indirectlevel = -1
            orbiters = New-Object System.Collections.ArrayList
            orbiting = ""
        }
    }
    $objects[$orbiter].orbiting = $object
}

$youpath = "YOU"
$current = "YOU"
while ($current -ne "COM") {
    $youpath = $objects[$current].orbiting + "-" + $youpath
    $current = $objects[$current].orbiting
}
$sanpath = "SAN"
$current = "SAN"
while ($current -ne "COM") {
    $sanpath = $objects[$current].orbiting + "-" + $sanpath
    $current = $objects[$current].orbiting
}

for ($i = 0; $youpath[$i] -eq $sanpath[$i]; $i++) {}
Write-Host ( (($sanpath.Length - $i) + ($youpath.Length - $i) - 6 )/4 )