##Windows PowerShell script for AD DS Deployment
##This script is used to build a custom domain called company.pri on a standalone windows server
##Run this script on the server you wish to promote

#Install ADDS Role and Mgt Tools
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools


# Replace all references to XX with your monitor number on Lines 20 and 21

##Import ADDSDeployment Module
Import-Module ADDSDeployment

##Install a new AD Forest
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "Win2012r2" `
-DomainName "company.pri" `
-DomainNetbiosName "company" `
-ForestMode "Win2012r2" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
