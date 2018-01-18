[CmdletBinding()] #Required for advanced features
param()           #Required when using [CmdletBinding()]

#lines for getting data and setting variables
$data = import-csv C:\scripts\Week13\Ch11-Debug\listing11-2.csv
Write-Debug "Imported CSV data"

#Set Variables at zero
$totalqty = 0
$totalsold = 0
$totalbought = 0

#runs through each object in csv file
foreach ($line in $data) {
    
    #if transaction is buy, do this
    if ($line.transaction -eq 'buy') {
            
        $totalqty -= $line.qty
        $totalsold = $line.total
        Write-Debug "ENDED BUY transaction (we sold $totalsold)"  #Trace Code
    
    #If Transaction is sell do this
    } else {

        $totalqty += $line.qty
        $totalbought = $line.total
        Write-Debug "ENDED SELL transaction (we bought $totalbought)"  #TraceCode

    }
}
Write-Debug "Output: 
             TotalQty = $totalqty
             TotalBought = $totalbought
             TotalSold = $totalsold
             TotalAmt = $($totalbought-$totalsold)" #TraceCode