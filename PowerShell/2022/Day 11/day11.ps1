$in = Get-Content "$PSScriptRoot\input.txt"

class Monkey {
    static [System.Collections.ArrayList]$monkeys
    [System.Collections.Queue]$items
    [string]$operation
    [int]$test
    [int]$iftrue
    [int]$iffalse
    [int]$totalinspections

    Monkey([string[]]$text) {
        #parse starting items
        $this.items = $text[0] | Select-String "(\d+)" -allmatches | % matches | % value | % { [int]$_ }
        #parse operation
        $this.operation = $text[1].Substring(13)
        #parse test
        $this.test = [int]$text[2].Substring(21)
        #parse test actions
        $this.iftrue = [int]$text[3].Substring(29)
        $this.iffalse = [int]$text[4].Substring(30)
        $this.totalinspections = 0
        [Monkey]::monkeys.Add($this)
    }

    [void]InspectItems() {
        while ($this.items.Count -gt 0) {
            
        }
    }

    [void]addItem([int]$item) {
        $this.items.Enqueue($item)
    }
}