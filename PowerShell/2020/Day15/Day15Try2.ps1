function memoryGame{
    param(
      [int[]]$numbers,
      [uint64]$totalTurns
    )
  
    $dict = @{}
    for($i=0;$i -lt $numbers.length-1; $i++){
      $dict.Set_Item($numbers[$i], $i+1)
    }
  
    $turn = $numbers.length
    $lookupNumber = $numbers[-1]
  
    while(1){
      $prevTurn = $dict.Get_Item($lookupNumber)
      if( $prevTurn -ge 1 ){
        $dict.Set_item($lookupNumber, $turn)
        $lookupNumber = $turn - $prevTurn
      }else{
        $dict.Set_item($lookupNumber, $turn)
        $lookupNumber = 0
      }
  
      $turn++
      if($turn -ge $totalTurns){
        break
      }
    }
    $lookupNumber
  }
  
  "Part 1: $(memoryGame @(2,20,0,4,1,17) 2020)"
  "Part 2: $(memoryGame @(2,20,0,4,1,17) 30000000)"