# Read Input
$in = Get-Content "$PSScriptRoot\input.txt"

# Parse input into layers
$layerwidth = 25
$layerheight = 6
$layerlength = $layerwidth * $layerheight
$layercount = $in.Length / $layerlength

$layers = New-Object string[] $layercount
for ($i = 0; $i -lt $layercount; $i++) {
    $layers[$i] = $in.Substring( $i * $layerlength, $layerlength)
}

# Find layer with fewest 0s
$fewestzeroes = $layerlength
$fewestzeroeslayer = -1

for ($i = 0; $i -lt $layercount; $i++) {
    $zeroes = 0;
    for ($j = 0; $j -lt $layerlength; $j++) {
        if ($layers[$i][$j] -eq "0") {
            $zeroes++
        }
    }
    if ($zeroes -lt $fewestzeroes) {
        $fewestzeroes = $zeroes
        $fewestzeroeslayer = $i
    }
}

# Calculate 1s count times 2s count
$ones = 0
$twos = 0

for ($i = 0; $i -lt $layerlength; $i++) {
    if ($layers[$fewestzeroeslayer][$i] -eq "1") {
        $ones++
    }
    if ($layers[$fewestzeroeslayer][$i] -eq "2") {
        $twos++
    }
}

# Output
Write-Output "Part 1: $($ones*$twos)"

# Calculate composited image
$image = ""
for ($i = 0; $i -lt $layerlength; $i++) {
    for ($j = 0; $j -lt $layercount; $j++) {
        $pixel = $layers[$j][$i]
        if ($pixel -ne "2") { break }
    }
    $image += $pixel
}

# Print image
Write-Output "Part 2:"
for ($i = 0; $i -lt $layerheight; $i++) {
    for ($j = 0; $j -lt $layerwidth; $j++) {
        if ($image[$i*$layerwidth + $j] -eq "0") {
            Write-Host " " -BackgroundColor Black -NoNewline
        } else {
            Write-Host " " -BackgroundColor White -NoNewline
        }
    }
    Write-Host ""
}