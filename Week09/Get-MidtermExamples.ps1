#Michael Bender
#Midterm Project
#Basic commands to produce a text file of information

#Create a folder for my text file
    mkdir c:\scripts\output -ErrorAction SilentlyContinue

#Set variable for computers
    $comp = "PS1"

#1. Get all the running services on a local system
    $service = get-service -ComputerName $comp | where status -eq running

#2. Get the amount of system memory in GB for remote System
    $Memory = ((((get-ciminstance Win32_PhysicalMemory -ComputerName $comp).capacity)|measure -Sum).sum)/1GB

#3. Get Printer Information - Name Only
    $printer = (get-printer -ComputerName $comp).Name #Does not like use of Localhost as computername
    #or
    $printer2 = (Get-CimInstance -ClassName Win32_Printer -ComputerName localhost).Name

#4. IP Address Information
    $NetIP = Invoke-Command -ComputerName $comp -Command {
                    Get-WmiObject Win32_NetworkAdapterConfiguration |
                            select -property IPAddress, IPsubnet, DefaultIpGateway, DHCPEnabled, DNSServerSearchOrder |
                                 Where -property IpAddress -NE $null | FL
                            }

#Write Output to text file
    $date = get-date -Format %M-%d-%y
    $Path = "c:\Scripts\Output\$comp-$date.txt"
    
    #Services
    Write-Output "List of Running Services" | out-file $Path -Append
    $service | out-file $path -Append

    #memory
    Write-Output "------------------------------------------------" | out-file $Path -Append
    Write-Output "Amount of Memory on Localhost: $Memory GB" | out-file $path -Append

    #Printers
    Write-Output "------------------------------------------------" | out-file $Path -Append
    Write-Output "Printers on $comp" | out-file $path -Append
    $printer | out-file $path -Append

    #Networking
    Write-Output "------------------------------------------------" | out-file $Path -Append
    Write-Output "Network Adapter Information on $comp" | out-file $path -Append
    $NetIP | out-file $path -Append

#Open File Explorer
    explorer.exe C:\scripts\output