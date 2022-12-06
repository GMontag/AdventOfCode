$lines = Get-Content .\input.txt

foreach ($line in $lines) {
    $values = $line.Split().Foreach{$_ -as [int]}
}