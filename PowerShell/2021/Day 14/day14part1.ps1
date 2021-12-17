$in = Get-Content .\input.txt

$template = $in[0]

$rules = @{}

for ($i = 2; $i -lt $in.Count; $i++) {
    $null = $in[$i] -match "(\w\w) -> (\w)$"
    $rules[$Matches[1]] = $Matches[2]
}

$resultstring = $template
for ($i = 0; $i -lt 10; $i++) {
    $newresult = [System.Text.StringBuilder]::new()
    $null = $newresult.Append($resultstring[0])
    for ($j = 1; $j -lt $resultstring.Length; $j++) {
        $pair = $resultstring.Substring($j-1,2)
        $null = $newresult.Append($rules[$pair]).Append($pair[1])
    }
    $resultstring = $newresult.ToString()
}

$answer = ($resultstring.ToCharArray() | group | sort count)[-1].Count - ($resultstring.ToCharArray() | group | sort count)[0].Count

Write-Output ("Part 1: " + $answer)