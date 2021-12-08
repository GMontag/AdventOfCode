$in = Get-Content -Path ($PSScriptRoot + "\input.txt")

$memory = @{}

foreach ($line in $in) {
    if ($line -match "mask = (.*)") {
        $mask = $Matches[1]
    } elseif ($line -match "mem\[(\d+)\] = (\d+)") {
        $rawaddress = [Convert]::ToString([uint64]$Matches[1],2).PadLeft(36,"0")
        $value = [uint64]$Matches[2]
        $maskedaddress = ""
        for ($i = 0; $i -lt 36; $i++) {
            switch ($mask[$i]) {
                "0" { $maskedaddress += $rawaddress[$i] }
                "1" { $maskedaddress += "1" }
                "X" { $maskedaddress += "X" }
            }
        }

        $xcount = ($maskedaddress.ToCharArray() | Where-Object { $_ -eq "X" }).Count
        $addressarray = @()
        for ($i = 0; $i -lt [Math]::Pow(2,$xcount); $i++) {
            $floatingaddress = $maskedaddress.Clone()
            $ibin = [Convert]::ToString($i,2).PadLeft($xcount,"0")
            for ($j = 0; $j -lt $xcount; $j++) {
                $floatingaddress = $floatingaddress.Split("X",2)[0] + $ibin[$j] + $floatingaddress.Split("X",2)[1]
            }
            $addressarray += $floatingaddress
        }
        foreach ($address in $addressarray) {
            $memory[[Convert]::ToUInt64($address,2)] = $value
        }
    }
}

$total = $memory.Values | Measure-Object -Sum | Select-Object -Property Sum -ExpandProperty Sum

Write-Output "Part 1: $total"