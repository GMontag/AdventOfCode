$in = Get-Content "$PSScriptRoot\input.txt"

for ($i = 3; $i -lt $in.Length; $i++) {
    $marker = $in.Substring($i-3,4).ToCharArray()
    if ( ($marker | Sort-Object -Unique).Count -eq 4 ) { break }
}

$i+1