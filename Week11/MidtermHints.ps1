#Name
#Class Period
#Description of Project
#This provides hints for each item in the Midterm Project

#region 1. Using a DNS hostname, determine IP Address configuration for a remote system including IP Address, Subnet Mask, Default Gateway, and whether system uses DHCP

 Get-CimInstance -ClassName Win32_networkadapterconfiguration 

#endregion

#region - 2. DNSClient Server Address
 Get-DnsClientServerAddress

#endregion

#region - #3 Memory
((Get-CimInstance -ClassName Win32_PhysicalMemory -ComputerName $comp).Capacity|Measure-Object -Sum)
#endregion

#region - 4 Operating System Information
Get-CimInstance Win32_OperatingSystem
#endregion

#region - 5Processor
Get-CIMInstance -ClassName Win32_Processor
#endregion

#region - 6. Freespace
#the approximation to the nearest two decimals in {0:N2} plus-f for the the value of the total physical memory in gigs
get-wmiobject -class win32_logicaldisk -filter "drivetype = '3'"
#endregion

#region - 7 LastReboot
Get-CimInstance Win32_OperatingSystem
#endregion

#region - 8 Last User Logon
Get-CimInstance Win32_NetworkLoginProfile 
#endregion

#region - 9 Retrieve User Accounts
get-wmiobject -class win32_useraccount
#endregion

#region - 10 Printers
Get-Printer
#endregion

#region - 11 Hotfixes & Updates
Get-HotFix
#endregion

#region - 12 Event Logs
Get-EventLog -LogName System
Get-eventlog -LogName Application
#endregion

#region - 13 Size of Pagefile.sys
Get-CimInstance Win32_PageFileUsage 
#endregion

#region - 14 Registered Applications
get-item HKLM:\Software\RegisteredApplications

#endregion

#region - 15 Stopped Services
get-service
#endregion
