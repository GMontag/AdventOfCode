$in = Get-Content .\input.json

"Part 1: " + ($in | Select-String "(-?\d+)" -AllMatches | % matches | % value | % {[int]($_)} | measure -Sum).Sum

$openbraces = New-Object System.Collections.Stack
$removing = $false
$lastopenbrace = 0

for ($i = 0; $i -lt $in.Length - 6; $i++) {
   if (-not $removing) {
      if ($in[$i] -eq '{') { $openbraces.Push($i) }
      if ($in[$i] -eq '}') { $null = $openbraces.Pop() }
      if ($in.Substring($i,6) -eq ':"red"') { $removing = $true; $lastopenbrace = $openbraces.Peek() }
   } else {
      if ($in[$i] -eq '{') { $openbraces.Push($i) }
      if ($in[$i] -eq '}') {
         if ($openbraces.Pop() -eq $lastopenbrace) {
            $in = $in.Remove($lastopenbrace, ($i - $lastopenbrace + 1))
            $i = $lastopenbrace - 1
            $removing = $false
         }
      }
   }

}

"Part 2: " + ($in | Select-String "(-?\d+)" -AllMatches | % matches | % value | % {[int]($_)} | measure -Sum).Sum