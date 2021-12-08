function Increment-String {
    param( [string]$string )

    $chars = [char[]]$string

    $carry = $true
    $curpos = $chars.Count - 1
    while ($carry) {
        if ($chars[$curpos] -eq 'z') {
            $chars[$curpos] = 'a'
        } else {
            $chars[$curpos] = [char]([int]$chars[$curpos] + 1)
            $carry = $false
        }

        if ($curpos -eq 0 -and $carry) {
            $chars = ,[char]('a') + $chars
            $carry = $false
        } else {
            $curpos--
        }
    }
    return $chars -join ''
}

function Check-Password {
    param( [string]$password )

    $passes = $true

    if ($password -match "(i|l|o)") { $passes = $false }
    if ($password -notmatch "(.)\1.*(.)\2") { $passes = $false }

    $ascendingmatch = (1..24 | % { ([char]($_+96), [char]($_+97), [char]($_+98)) -join '' }) -join '|'
    if ($password -notmatch $ascendingmatch) { $passes = $false }

    return $passes
}

$password = "cqjxjnds"

while (-not (Check-Password $password)) { $password = Increment-String $password }

"Part 1: " + $password

$password = Increment-String $password
while (-not (Check-Password $password)) { $password = Increment-String $password }

"Part 2: " + $password