##myfirstscript.ps1
##Purpose: Sends Services and IP infromation to Text File
##Created By: Michael Bender
##Created On: 02/23/2015
##
##How to Use: Simply run script from and it will create a file in c:\scripts. c:\scripts needs to exist to function

##Variables

##Functions

##Commands
Write-Output "In Class Scripting Project"|Out-file c:\scripts\Myfirstscript.txt #Adds Headers

#Creates section for Running Services and sends to file
Write-Output "List of Running Services"|Out-file c:\scripts\Myfirstscript.txt -Append
Get-Service -ComputerName localhost `
| Where-Object Status -EQ "Running" `
| Out-file c:\scripts\Myfirstscript.txt -Append
Write-output "" |Out-file c:\scripts\Myfirstscript.txt -Append

#Creates section for IP Configuration and sends to file
Write-Output "List of IP Configuration" |Out-file c:\scripts\Myfirstscript.txt -Append
Get-NetIPConfiguration -ComputerName LocalHost|Out-file c:\scripts\Myfirstscript.txt -Append
Write-Output "End of Script" |Out-file c:\scripts\Myfirstscript.txt -append
""
""
""
Write "nl"
""

#Opens text file in notepad
Notepad c:\scripts\Myfirstscript.txt

