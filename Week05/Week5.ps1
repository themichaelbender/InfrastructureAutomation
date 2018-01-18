#Week 5 Lecture

cd C:\scripts\Week5

#region - Chapter 13 - Remote Control
    #Help
    Help about_Remote_Troubleshooting -ShowWindow
    
    #Enabling PS remoting
    #By Default, already on in Windows Server 2012 R2 and needs to be enabled on Clients
    #Enable on systems receiving connections (I.E Remote systems)
        Enable-PSRemoting -WhatIf -Verbose

    #Working with Workgroup Machines & setting up TrustedHosts
    #Run on System that commands are originating	    
        Test-WSMan
	    Get-Item WSMan:\Localhost\client\Trustedhosts
	    set-item WSMan:\localhost\client\TrustedHosts -Value *
	    Get-Item WSMan:\Localhost\client\Trustedhosts|fl
	    Get-NetAdapter
	    
        #If Network Adapter is Public, this will modify
            #Set-NetConnectionProfile -InterfaceIndex 12 -NetworkCategory Public
	        #Enable-PSRemoting –Force –SkipNetworkProfileCheck
            #Disable Firewall for Public

    #Remoting with PSSession
    # 1 to 1 remoting
        #Enter Remote Session
        Enter-PSSession -ComputerName Localhost

            cd c:\

            Dir

            Exit

        Get-PSSession -ComputerName Localhost

        #Create a New PSSession
        New-PSSession -ComputerName localhost -Name NewPS

        New-PSSession -ComputerName ServerB -Name NewPS-ServerB

        Get-PSSession -ComputerName Localhost

        Enter-PSSession -Name NewPS-ServerB

            cd c:\

            Dir
        
            exit

        Get-PSSession 

        Get-PSSession -ComputerName Localhost | Remove-PSSession

        Get-PSSession -ComputerName Localhost

        Enter-PSSession -ComputerName ServerB

    #Remoting with Invoke-Command - 1 to Many
        Invoke-Command -ComputerName sERVERb -ScriptBlock { Get-SERVICE } | GM
        #Get 
        $Comps = 'localhost','ServerA','ServerB'
        
        #Without Credentials
        $ip = Invoke-Command -ComputerName $comps -command {
                    Get-NetIPAddress | select PSComputerName,IPAddress
            } 
        $IP | GM
        
        #With Credentials
        $cred = Get-Credential
        Invoke-Command -ComputerName $comps -Credential $cred -command {
            Get-NetIPAddress | select PSComputerName,IPAddress
            } | ft -GroupBy PSComputerName
        
        #-ComputerName vs Invoke-command
        Get-service -ComputerName $comps | where Status -eq 'Running'| ft MachineName,Status,Name
            #Fails due to Firewall Issue and not using WS-Man
            #need to enable Remote Service Management group on target

        get-service -ComputerName ServerA,ServerB,Localhost
        
        Invoke-Command -ComputerName $comps -Credential $cred {
            get-service | where Status -eq 'Running'} | 
                ft -GroupBy PSComputerName |
                    out-file .\RunningServicesRemote.txt
        notepad .\RunningServicesRemote.txt

        #Remote vs Local Processing
            #Less Effiecient - Filtering on Host
            Invoke-Command -ComputerName $comps -Credential $cred -command  {
                get-process } | where Name -Like 's*' 

            #More Effiecient - Filtering on Remote Systems
            Invoke-Command -ComputerName $comps -Credential $cred -command {
                get-process  | where Name -Like 's*' }

        #Serialized Data
            get-service | gm

            Invoke-Command -Command { get-service } -ComputerName Localhost | gm
                #Lose Methods and Produces Read-Only copy of object

#endregion - CH 13

#region - Chapter 14 - WMI and CIM
    
    #A Better Way - WMI Explorer
        start C:\scripts\week5\WMIExplorer.exe
        #Explore Root/CIMv2 and look for processor
    
    #Searching and Viewing WMI Classes
        #WMI
        Get-WmiObject -List *
        (Get-WmiObject -List *).count
		Get-WmiObject -List *processor*
		Get-WmiObject -List *memory*
        Get-WmiObject -List *PhysicalMemory*

        #CIM
        Get-CimClass -ClassName *
        (Get-CimClass -ClassName *).count
        
        #Using NameSpace
        Get-WMIObject -Namespace Root/CIMv2 -List | Where name -like '*dis*'
        Get-CIMclass | sort CIMClassName | Where CIMClassName -like '*dis*'
        
        #WMI or CIM: Both access WMI 
        Get-WmiObject -Class Win32_DiskDrive #| gm
        Get-WMIObject -Class CIM_DiskDrive #| gm

    #View Properties of LOCALHOST > Security Tab
    #Can Drop -Namespace if necessary
        Get-WmiObject -Class Win32_Processor -ComputerName LocalHost | FL
        Get-WmiObject -Class Win32_Processor -ComputerName LocalHost | gm
        
        #Uses additional command to access Class
        Get-CimInstance -ClassName Win32_Processor -ComputerName LocalHost | FL #Browse Through
            #Note PSComputerName
        
        Get-CimInstance- ClassName Win32_Processor -ComputerName LocalHost | GM #Browse Through
        
        Get-CimInstance  -ClassName Win32_Processor -ComputerName LocalHost |
            Format-Table -Property SystemName,Name,NumberofLogicalProcessors
    
    #View Multiple Computers
        $Comps = 'localhost','ServerA','ServerB','localhost','ServerA','ServerB','localhost','ServerA','ServerB'
        
        #With WMI - Note Speed
        Get-WmiObject -ComputerName $comps
                
        Get-WmiObject -ComputerName $comps -Class Win32_Processor |
            Format-Table -Property SystemName,Name,NumberofLogicalProcessors -GroupBy PSComputerName

        #With CIM - Note Speed
        Get-CimInstance -ClassName Win32_Processor -ComputerName $comps
        
        Get-CimInstance -ClassName Win32_Processor -ComputerName $comps |
            Format-Table -Property SystemName,Name,NumberofLogicalProcessors -GroupBy PSComputerName
    
    #Doing Math with WMI/CIM
  
        Get-CimInstance -ClassName Win32_PhysicalMemory | gm
        Get-CimInstance -ClassName Win32_PhysicalMemory
        Get-CimInstance -ClassName Win32_PhysicalMemory | select -ExpandProperty Capacity 
        (Get-CimInstance -ClassName Win32_PhysicalMemory).capacity 
	    ((Get-CimInstance -ClassName Win32_PhysicalMemory).capacity)/1GB
	    ((Get-CimInstance -ClassName Win32_PhysicalMemory).capacity)/1MB


#endregion - CH 14

#region - Chapter 15 - Background Jobs

    #Run a local job
        start-job -Name dir -ScriptBlock { dir } 
        get-job
        get-job -Name dir | Fl

        Get-job -Name dir 

    #Using WMI and Remoting as a Job
        $comps = 'Localhost','ServerA','ServerB'
        Get-WmiObject -Class Win32_OperatingSystem -AsJob -ComputerName $comps
        
        #Remote Job since CIM doesn't support -asjob parameter
        Invoke-Command -ComputerName $comps `
            -Command { Get-CimInstance -Namespace root/CIMV2 -ClassName Win32_OperatingSystem } `
            -AsJob -JobName CIM_OS
        
        Get-Job
    
    #Receiving Results
        Get-Job
        Receive-job -id 14 #Fill in ID from WMIobject
        Receive-job -id 14 #Note Null
        get-job #Note HasMoreData column
        Receive-job CIM_OS -Keep

        #Store Job objects in variable
        $dir = Receive-Job -name CIM_OS -Keep
        $dir | gm
        $dir | ft -GroupBy PSComputername

    #ChildJobs - Doing the real work
        get-job -Name Cim_OS | fl
        get-job -Name Cim_OS | select -ExpandProperty childjobs | ft Name,Location,Command -AutoSize
    
    #Removing Jobs
        Remove-job -Name *
        Get-Job
     #Scheduling Jobs
        #Create a scheduled task that gathers processes running daily at 2am
        Register-ScheduledJob -Name DailyProcList `
            -scriptblock { get-process } `
            -Trigger (New-JobTrigger -Daily -At 2am) `
            -ScheduledJobOption (New-ScheduledJobOption -WakeToRun -RunElevated)
        Get-ScheduledJob | fl
        Get-ScheduledJob | select -ExpandProperty Options
        Unregister-ScheduledJob -Name DailyProcList
#endregion - CH 15

#Enter-PSSession -ComputerName 320-Instructor -Credential (get-credential)