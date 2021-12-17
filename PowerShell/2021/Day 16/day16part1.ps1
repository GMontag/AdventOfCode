$in = Get-Content .\input.txt

$hexbinhash = @{'0' = @(0,0,0,0); '1' = @(0,0,0,1); '2' = @(0,0,1,0); '3' = @(0,0,1,1); '4' = @(0,1,0,0); '5' = @(0,1,0,1); '6' = @(0,1,1,0); '7' = @(0,1,1,1);
                '8' = @(1,0,0,0); '9' = @(1,0,0,1); 'A' = @(1,0,1,0); 'B' = @(1,0,1,1); 'C' = @(1,1,0,0); 'D' = @(1,1,0,1); 'E' = @(1,1,1,0); 'F' = @(1,1,1,1)}

$bitqueue = New-Object System.Collecions.Queue
$hexcounter = 0

function readBit() {
    if ($bitqueue.Count -eq 0) {
        $hexbinhash[$hexcounter] | % { $bitqueue.Enqueue($_) }
        $hexcounter++
    }
    return $bitqueue.Dequeue()
}

