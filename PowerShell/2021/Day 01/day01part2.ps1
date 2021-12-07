$in = Get-Content .\input.txt
$increased = 0
for ($i = 3; $i -lt $in.Length; $i++) {
    if ([int]$in[$i] -gt [int]$in[$i-3]) { $increased++ }
}
Write-Output $increased