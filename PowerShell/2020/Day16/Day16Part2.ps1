$startTime = (Get-Date)

$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$fields = @{}
$validnums = @{}

$i = 0
while ($in[$i] -match "\w+: (\d+)-(\d+) or (\d+)-(\d+)") {
    $fieldname = ($in[$i] -split ":")[0]
    $low1 = [int]($Matches[1])
    $high1 = [int]($Matches[2])
    $low2 = [int]($Matches[3])
    $high2 = [int]($Matches[4])
    $object = New-Object PSObject -Property @{
        fieldname = $fieldname
        low1 = $low1
        high1 = $high1
        low2 = $low2
        high2 = $high2
        fieldnum = $null
    }
    $fields[$fieldname] = $object
    for ($j = $low1; $j -lt $high1; $j++) { $validnums[$j] = $true }
    for ($j = $low2; $j -lt $high2; $j++) { $validnums[$j] = $true }
    $i++
}


$i += 2
$yourticket = [int[]]($in[$i] -split ",")

$validtickets = @()
$i += 3
for (; $i -lt $in.Count; $i++) {
    $ticket = [int[]]($in[$i] -split ",")
    $valid = $true
    foreach ($num in $ticket) {
        if ($validnums[$num] -eq $null) {
            $valid = $false
            break
        }
    }
    if ($valid) {$validtickets += (,$ticket)}
}

$fieldnames = @($null) * $fields.Keys.Count

while ($null -in $fieldnames) {
    for ($i = 0; $i -lt $fieldnames.Count; $i++) {
        $fieldnums = $validtickets | ForEach-Object {$_[$i]}
        $uniquecorrect = $null
        foreach ($fieldname in $fields.Keys) {
            if ($fieldname -in $fieldnames) { continue }
            $field = $fields[$fieldname]
            $validforfield = $true
            foreach ($num in $fieldnums) {
                if (-not (($num -ge $field.low1 -and $num -le $field.high1) -or ($num -ge $field.low2 -and $num -le $field.high2))) {
                    $validforfield = $false
                    break
                }
            }
            if ($validforfield) {
                if (-not $uniquecorrect) {
                    $uniquecorrect = $fieldname
                } else {
                    $uniquecorrect = $null
                    break
                }
            }
        }
        if ($uniquecorrect) {
            $fieldnames[$i] = $uniquecorrect
            $fields[$uniquecorrect].fieldnum = $i
        }
    }
    Write-Output "$(($fieldnames | ? { $_ -ne $null }).Count) fields determined"
}

$answer = 1
foreach ($fieldname in ($fields.Keys | Where-Object {$_ -match "departure"})) {
    Write-Output "$fieldname`t$($yourticket[$fields[$fieldname].fieldnum])"
    $answer *= $yourticket[$fields[$fieldname].fieldnum]
}

Write-Output "Part 2: $answer"

$endTime = (Get-Date)

Write-Output "Time taken: $($endTime - $startTime)"