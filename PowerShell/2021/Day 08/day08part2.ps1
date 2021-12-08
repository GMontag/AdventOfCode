$in = Get-Content .\input.txt

$sum = 0
for ($i = 0; $i -lt $in.Count; $i++) {
    $line = $in[$i]
    $digits = $line.Split("|")[0].Trim().Split(" ") | % { ($_.ToCharArray() | sort) -join ""}
    $outputnumbers = $line.Split("|")[1].Trim().Split(" ") | % { ($_.ToCharArray() | sort) -join ""}

    $digithash = @{}
    $digithash[($digits | ? { $_.Length -eq 2 })] = "1"
    $digithash["1"] = ($digits | ? { $_.Length -eq 2 })
    $digithash[($digits | ? { $_.Length -eq 4 })] = "4"
    $digithash["4"] = ($digits | ? { $_.Length -eq 4 })
    $digithash[($digits | ? { $_.Length -eq 3 })] = "7"
    $digithash["7"] = ($digits | ? { $_.Length -eq 3 })
    $digithash[($digits | ? { $_.Length -eq 7 })] = "8"
    $digithash["8"] = ($digits | ? { $_.Length -eq 7 })
    $digithash[($digits | ? { ($_.Length -eq 6) -and ( (Compare-Object $_.ToCharArray() $digithash["4"].ToCharArray() -IncludeEqual -ExcludeDifferent).Count -eq 4) })] = "9"
    $digithash["9"] = ($digits | ? { ($_.Length -eq 6) -and ( (Compare-Object $_.ToCharArray() $digithash["4"].ToCharArray() -IncludeEqual -ExcludeDifferent).Count -eq 4) })
    $digithash[($digits | ? { ($_.Length -eq 6) -and ( (Compare-Object $_.ToCharArray() $digithash["1"].ToCharArray() -IncludeEqual -ExcludeDifferent).Count -eq 2) -and ($_ -ne $digithash["9"]) })] = "0"
    $digithash["0"] = ($digits | ? { ($_.Length -eq 6) -and ( (Compare-Object $_.ToCharArray() $digithash["1"].ToCharArray() -IncludeEqual -ExcludeDifferent).Count -eq 2) -and ($_ -ne $digithash["9"]) })
    $digithash[($digits | ? { ($_.Length -eq 6) -and ($_ -ne $digithash["0"]) -and ($_ -ne $digithash["9"]) })] = "6"
    $digithash["6"] = ($digits | ? { ($_.Length -eq 6) -and ($_ -ne $digithash["0"]) -and ($_ -ne $digithash["9"]) })
    $digithash[($digits | ? { ($_.Length -eq 5) -and ( (Compare-Object $_.ToCharArray() $digithash["6"].ToCharArray() -IncludeEqual -ExcludeDifferent).Count -eq 5) })] = "5"
    $digithash["5"] = ($digits | ? { ($_.Length -eq 5) -and ( (Compare-Object $_.ToCharArray() $digithash["6"].ToCharArray() -IncludeEqual -ExcludeDifferent).Count -eq 5) })
    $digithash[($digits | ? { ($_.Length -eq 5) -and ( (Compare-Object $_.ToCharArray() $digithash["1"].ToCharArray() -IncludeEqual -ExcludeDifferent).Count -eq 2) })] = "3"
    $digithash["3"] = ($digits | ? { ($_.Length -eq 5) -and ( (Compare-Object $_.ToCharArray() $digithash["1"].ToCharArray() -IncludeEqual -ExcludeDifferent).Count -eq 2) })
    $digithash[($digits | ? { ($_.Length -eq 5) -and ($_ -ne $digithash["5"]) -and ($_ -ne $digithash["3"]) })] = "2"
    $digithash["2"] = ($digits | ? { ($_.Length -eq 5) -and ($_ -ne $digithash["5"]) -and ($_ -ne $digithash["3"]) })

    $outputstring = ""
    for ($j = 0; $j -lt $outputnumbers.Count; $j++) {
        $outputstring += $digithash[$outputnumbers[$j]]
    }
    $sum += [int]$outputstring
}

Write-Output ("Part 2: " + $sum)