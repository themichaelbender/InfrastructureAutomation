[CmdletBinding()]
param()
$data = import-csv c:\scripts\Week13\Ch11-Debug\listing11-6.csv
Write-Debug "Imported CSV data"

$totalqty = 0
$totalsold = 0
$totalbought = 0
foreach ($line in $data) {
    if ($line.transaction -eq 'buy') {
            
        $totalqty -= $line.qty
        $totalsold += $line.total
        Write-Debug "ENDED BUY transaction (we sold $totalsold)"

    } else {

        $totalqty += $line.qty
        $totalbought += $line.total
        Write-Debug "ENDED SELL transaction (we bought $totalbought)"

    }
}

Write-Debug "Output: 
             TotalQty = $totalqty
             TotalBought = $totalbought
             TotalSold = $totalsold
             TotalAmt = $($totalbought-$totalsold)"

"totalqty,totalbought,totalsold,totalamt" | out-file c:\summary.csv
"$totalqty,$totalbought,$totalsold,$($totalbought-$totalsold)" |
    out-file c:\summary.csv –append
