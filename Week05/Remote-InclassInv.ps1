##In Class Project

#Gather Processor Information
cd C:\scripts\week5

$computer = "320-Instruct"
$credential = Get-Credential
#Create Report
Write-output "In Class Project - Remoting" | out-file .\RemoteInventory.txt 
Write-output "Michael Bender" | out-file .\RemoteInventory.txt -Append
Write-output "+++++++++++++++++++++++++++" | out-file .\RemoteInventory.txt -Append
Write-output "Inventory of $computer" | out-file .\RemoteInventory.txt -Append
Write-output "+++++++++++++++++++++++++++" | out-file .\RemoteInventory.txt -Append
Write-output " " | out-file .\RemoteInventory.txt -Append
Write-output " " | out-file .\RemoteInventory.txt -Append
#Gather Processor Information
Write-output "Processor Information on $computer" | out-file .\RemoteInventory.txt -Append

Invoke-Command -ComputerName $computer -Credential $credential -ScriptBlock {
    Get-CimInstance -ClassName Win32_Processor
    } | FL | out-file .\RemoteInventory.txt -Append

#Gather Memory Information
Get-WmiObject -list | where Name -like '*memory*'

Get-wmiobject -Class Win32_PhysicalMemory
$memory2 = Invoke-Command -ComputerName $computer -Credential $credential -ScriptBlock {
    Get-wmiobject -Class Win32_PhysicalMemory | select -ExpandProperty capacity 
    }
$TotalMem = $memory2.count
$Capacity = $memory2 | ForEach-Object {$_ /1gb -as [int]} | Measure-Object -Sum | select -ExpandProperty Sum
Write-output 'Memory information on $computer' | out-file .\RemoteInventory.txt -Append
Write-output "Total # of Memory DIMMs: $totalMem" | out-file .\RemoteInventory.txt -Append
Write-output "Total memory in GB: $Capacity" | out-file .\RemoteInventory.txt -Append
#DNS Server of Client


notepad .\RemoteInventory.txt