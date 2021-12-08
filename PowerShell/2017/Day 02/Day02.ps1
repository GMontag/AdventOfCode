$lines = Get-Content .\input.txt

$checksum = 0

foreach ($line in $lines) {
    $values = $line.Split().Foreach{$_ -as [int]}
    $smallest = $values | Measure-Object -Minimum | Select-Object Minimum -ExpandProperty Minimum
    $largest = $values | Measure-Object -Maximum | Select-Object Maximum -ExpandProperty Maximum

    $checksum += $largest - $smallest
}

"Part 1: $checksum"