$in = Get-Content "$PSScriptRoot\input.txt"

for ($i = 13; $i -lt $in.Length; $i++) {
    $marker = $in.Substring($i-13,14).ToCharArray()
    if ( ($marker | Sort-Object -Unique).Count -eq 14 ) { break }
}

$i+1