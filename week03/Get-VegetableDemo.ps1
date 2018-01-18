#PowerShell Demo
#Windows Server 1/2

#Check Version of PowerShell on Computer
$PSVersionTable  

#ExtractDowload
Expand-Archive -Path C:\scripts\PSTeachingTools-master.zip -DestinationPath 'c:\program files\windowsPowerShell\Modules\'

#Allow scripts and modules to be run/imported w/o prompting
Unblock-file 'C:\Program Files\WindowsPowerShell\Modules\PSTeachingTools-Master\vegetables.ps1','c:\program files\WindowsPowerShell\Modules\PSTeachingTools-Master\PSteachingTools.psm1'
Import-Module 'c:\program files\WindowsPowerShell\Modules\PSTeachingTools-Master\PSteachingTools.psm1' -Force                                                                                                               


Get-Vegetable                                                                                                                         
help Get-Vegetable                                                                                                                    
Get-Vegetable | get-member                                                                                                                                                                                                       
Get-Vegetable | where IsPeeled -EQ $false                                                                                             
Get-Vegetable | where IsRoot -eq $true                                                                                                
get-vegetable | Format-List                                                                                                           
get-vegetable | where color -eq green                                                                                                 
get-vegetable | where count -ge 5                                                                                       
get-history|out-file veggiehistory   