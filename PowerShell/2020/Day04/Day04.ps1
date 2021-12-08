$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$requiredfields = "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"

# parse input
$passports = New-Object -TypeName "System.Collections.ArrayList"

$passport = New-Object -TypeName Hashtable
$passport["Part1Valid"] = $true
$passport["Part2Valid"] = $true

foreach ($line in $in) {
    if ($line -eq "") {
        foreach ($field in $requiredfields) { $passport["Part1Valid"] = $passport["Part1Valid"] -and ($field -in $passport.Keys) }
        $passport["Part2Valid"] = $passport["Part2Valid"] -and $passport["Part1Valid"]
        $null = $passports.Add($passport)

        $passport = New-Object -TypeName hashtable
        $passport["Part1Valid"] = $true
        $passport["Part2Valid"] = $true
        continue
    }
    $keyvaluepairs = $line -split " "
    foreach ($keyvaluepair in $keyvaluepairs) {
        $key = ($keyvaluepair -split ":")[0]
        $value = ($keyvaluepair -split ":")[1]
        $passport[$key] = $value

        switch ($key) {
           "byr" {
                $passport["Part2Valid"] = $passport["Part2Valid"] -and ([int]$value -ge 1920 -and [int]$value -le 2002)
           }
           "iyr" {
                $passport["Part2Valid"] = $passport["Part2Valid"] -and ([int]$value -ge 2010 -and [int]$value -le 2020)
           }
           "eyr" {
                $passport["Part2Valid"] = $passport["Part2Valid"] -and ([int]$value -ge 2020 -and [int]$value -le 2030)
           }
           "hgt" {
                $passport["Part2Valid"] = $passport["Part2Valid"] -and ($value -match "^(\d{2,3})(cm|in)$")
                if ($passport["Part2Valid"]) {
                    switch ($Matches[2]) {
                        "cm" { $passport["Part2Valid"] = $passport["Part2Valid"] -and ([int]$Matches[1] -ge 150 -and [int]$Matches[1] -le 193) }
                        "in" { $passport["Part2Valid"] = $passport["Part2Valid"] -and ([int]$Matches[1] -ge 59 -and [int]$Matches[1] -le 76) }
                    }
                }
           }
           "hcl" {
                $passport["Part2Valid"] = $passport["Part2Valid"] -and ($value -match "^#[0-9A-F]{6}$")
           }
           "ecl" {
                $passport["Part2Valid"] = $passport["Part2Valid"] -and ($value -in @("amb", "blu", "brn", "gry", "grn", "hzl", "oth"))
           }
           "pid" {
                $passport["Part2Valid"] = $passport["Part2Valid"] -and ($value -match "^\d{9}$")
           }
           "cid" {}
        }
    }
}

Write-Output ("Part 1: " + ($passports | ? { $_["Part1Valid"] }).Count)
Write-Output ("Part 2: " + ($passports | ? { $_["Part2Valid"] }).Count)