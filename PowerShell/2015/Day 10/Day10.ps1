$in = Get-Content .\input.txt
$curstring = $in

for ($j = 0; $j -lt 50; $j++) {
    "Pass $j"
    if ($j -eq 40) { "Part 1: $($curstring.Length)" }

    $curstring = ( ($curstring | Select-String -Pattern "(\d)\1*" -AllMatches).Matches | % { $_.Groups[0].Value } | % { "$($_.Length)" + $_[0] } ) -join ''
}
"Part 2: $($curstring.Length)"