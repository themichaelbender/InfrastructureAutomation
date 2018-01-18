##Week 6
cd C:\scripts\Week6

((((get-ciminstance Win32_PhysicalMemory).capacity)|measure -Sum).sum)/1GB 
#region Chapter 16 - Working with Many Objects, One at a Time
    #Batch Cmdlets
    #Finding multiple items and making change in single action
        #Don't try this at home w/o -whatif
        Get-Service | Stop-Service -WhatIf -Verbose
    
        #Set multiple services to StartupType of Automatic
        get-service -name BITS,Spooler,W32Time | fl Name,Status
        
        help set-service -parameter StartupType

        Get-service -name BITS,Spooler,W32Time -ComputerName localhost |
             set-service -StartupType Automatic -WhatIf -Verbose

        #Using -PassThru for commands that do not produce output
        Get-service -name BITS,Spooler,W32Time -ComputerName localhost |
             Start-Service | out-file .\start-services.txt
        .\Start-Services.txt
        
        Get-service -name BITS,Spooler,W32Time -ComputerName localhost |
             Start-Service| gm

        #With -Passthru
        Get-service -name BITS,Spooler,W32Time -ComputerName localhost |
             Start-Service -PassThru | out-file .\start-services.txt
        .\start-services.txt

        Get-service -name BITS,Spooler,W32Time -ComputerName localhost |
             Start-Service -PassThru| gm

    #Bulk Enable users in AD
        Get-ADUser -SearchBase 'CN=Users,DC=company,DC=pri' -filter * |
            Set-ADUser -Enabled $true -WhatIf

    #Working With WMI/CIM
        #Enable DHCP on all Intel Network adapters
        gwmi -ClassName Win32_NetworkAdapterConfiguration | fl

        gwmi -ClassName Win32_NetworkAdapterConfiguration -Filter "description like '*intel*'"

        #Filtering WMI requires using % instead of * for wildcard
        gwmi -ClassName Win32_NetworkAdapterConfiguration -Filter "description like '%intel%'"

        #Review methods available with WMI objects
        gwmi -ClassName Win32_NetworkAdapterConfiguration -Filter "description like '%intel%'" | gm

        gwmi -ClassName Win32_NetworkAdapterConfiguration -Filter "description like '%intel%'" | EnableDHCP
            #Fails - You cannot pipe objects into a method
        
        #Getting Methods for CIM
        Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | gm #No Useable Methods
        
        #Need to access CIM class to access specific methods
        (get-cimclass -classname win32_networkadapterconfiguration).cimclassmethods
        
        #Use Invoke-WMIMethod to using methods attached to WMI objects
        gwmi -ClassName Win32_NetworkAdapterConfiguration -Filter "description like '%intel%'" |
            Invoke-WmiMethod -name EnableDHCP -WhatIf

        Get-CimInstance Win32_NetworkAdapterConfiguration -Filter "description like '%intel%'" |
            Invoke-CimMethod -MethodName EnableDHCP -WhatIf

    #same action - differenct methods
        get-service -Name *b* | stop-service -WhatIf #Batch Cmdlet

        get-service -Name *b* | ForEach-Object { $_.Stop() } -WhatIf #Use Stop Method of cmdlet

        Get-CimInstance Win32_Service -Filter "Name like '%B%'" | Invoke-CIMMethod -Name StopService -WhatIf

        GWMI Win32_Service -Filter "Name like '%B%'" | ForEach-Object { $_.StopService() } -WhatIf

        Stop-Service -Name *b* -WhatIf



    #Which to use
        #if using WMI/CIM, invoke their specific methods
        #If using other cmdlets, invoke their methods or use ForEach{}
        
#endregion

#region - Chapter 17 - security
    #In a Nutshell: PowerShell will let you do what you already have the ability to do

    #View Security
    Get-ExecutionPolicy

    help Set-ExecutionPolicy

    help Set-ExecutionPolicy -Parameter ExecutionPolicy

    Set-ExecutionPolicy Restricted

    .\View-Services.ps1

    Set-ExecutionPolicy AllSigned

    .\View-Services.ps1

    Set-ExecutionPolicy RemoteSigned

    .\View-Services.ps1

    Set-ExecutionPolicy Unrestricted

    .\View-Services.ps1

    #Discuss Digital Certificates
    
#endregion

#region - Chapter 18 - Variables

    #Variables - A place to store information in computers memory and access by name
        
        #Current and built-in variables
        Get-Variable 

        #View Environmental Variables
        set-location env:\ 
        dir
        $env:computername
        sl C:\scripts\Week6

        #Working with Variables
        $var = localhost #Fails
        
        $var = "localhost" #Quotes set value as string

        $var

        ${ My Var } = "localhost"

        ${ My Var }
        
        #Using variable in command
        Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName Localhost | fl

        Get-CimInstance -ClassName Win32_computerSystem -ComputerName $var | fl

        $var = 'localhost','PS1','localhost','PS1'

        Get-CimInstance -ClassName Win32_computerSystem -ComputerName $var | ft -GroupBy Name

    #Working with Quotes
        $comp = $env:computername

        #Double Quotes pass thru Variable value
        $doublequote = "computer name is $comp"

        $DoubleQuote

        #Single Quotes provide literal answer
        $SingleQuote = 'Computer name is $comp' 
        
        $SingleQuote 

        #Use Backtick to make variable name literal
        $Backtick = "`$comp is $comp"

        $Backtick

        #Use `n for newline
        $Backtick = "`$comp `nis `t$comp"

        $Backtick

        #Information on Escape Characters
        help about_escape 

    #Multiple Objects in a variable
        $Computers = 'Server-R2','Server1','localhost'
        $computers
        $computers[1] #Counts starting at 0
        $computers[-2]
    
    #UsingMethods on single object
        $Computername = 'Server-R2'
        $computername | gm
        $computername.count
        $computername.Length
        $Computername.toupper()
        $computername.replace('R2','2008') #Creates a new string; it does not modify existing variable
        $computername 
    
    #Multiple Object Method use
        $computers.tolower()
        #Modify value in variable
        $computers[0] = $computers[0].replace('R2','2012R2')
        $computers
    #More work with double Quotes
        #Trying to get first name in variable
        $services = get-service
        $firstName = "$services[0].name"
        $firstname #Fails
        $firstname = "The first name is $($services[0].name)" # $() is referred to as a subexpression
        $firstname #works

        #Last One - Pull out all of the names from object in a varable
        $services = get-service
        $services | gm
        $var = "The Service Names are: `n$services.names"

        $var

    #Declaring variable Type
        #Example: you need to read in a number that will be multiplied by 10
        $number = Read-Host "Enter a number"
        $number = $number * 10
        $number #Output is because PowerShell sees variable as string so it duplicates 10x

        #See What is up
        $number = Read-Host "Enter a number"
        $number | gm

        #Declare as integer
        [int]$number = Read-Host "Enter a number"
        $number | gm
        $number = $number * 10
        $number
            #Re-Run add Hello as input

        #Variable commands
        Get-Variable
        New-Variable -Name Var2 -Value hello
        $var2 
        Set-Variable -Name Var2 -Value goodbye
        $var2

    #Best Practices
        #1: Keep names meaningful and short
            $MyVar    #Short but no context to what it contains
            $Servers  #Just about right
        
        #2: No Spaces
            $My Var   #Won't Work

        #3: Declare variable type if you wish to allow only 1 specific object type
            [int]$var = Read-Host "Enter a number"
#endregion

#region - Chapter 19 I/O 
 
#Read-Host - Grabbing input from the command line 
    Read-host -Prompt "Enter the name of a computer" 
 
    #Save computer to variable 
    $Computer = Read-host -Prompt "Enter the name of a computer" 
 
    #Save password as secure string 
    $Password = Read-host -Prompt "Enter password:" -AsSecureString 
    $Password 
 
#GUI 
    [void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.visualBasic') 
    $computername = [Microsoft.VisualBasic.Interaction]::InputBox('Enter a computer name','localhost') 
    $computername 
 
#Write Host - Writes directly to output with no Pipeline 
    Write-Host "This is Colorful!" -ForegroundColor Yellow -BackgroundColor Magenta 
    Write-Host "This is Colorful!" -ForegroundColor Yellow -BackgroundColor Magenta | gm 
        #error shows no objects are sent to pipeline 
 
#Write-Verbose
    $VerbosePreference 
    $VerbosePreference = 'continue' 
    help Write-Verbose 
    Write-verbose -Message "This is an error" 
 
#Write-Output -  - Better Way 
    Write-Output -InputObject "This is writing an object-based message" 
    Write-Output -InputObject "This is writing an object-based message" | gm 
    (Write-Output -InputObject "This is writing an object-based message").length 
 
#The Difference 
    Write-Output "hello" | where Length -gt 10 
    Write-Host "hello" | where Length -gt 10 
 
#Other Write Methods 
    help Write-Progress -Examples 
 
    for($I = 1; $I -lt 101; $I++ ) 
    {Write-Progress -Activity Updating -Status 'Progress->' -PercentComplete $I -CurrentOperation OuterLoop; 
    for($j = 1; $j -lt 101; $j++ ) 
    {Write-Progress -Id 1 -Activity Updating -Status 'Progress' -PercentComplete $j -CurrentOperation InnerLoop} } 

#endregion 
 
#region - Chapter 20 - More Remoting 

    #Creating reuseable sessions 
        New-PSSession -ComputerName Localhost,PS1 
 
    #View Sessions 
        Get-PSSession 
 
    #In Variable 
        $Servers = New-PSSession -ComputerName Localhost,PS1 
        Get-PSSession 
     
    #Remove Specific sessions by variable 
        $servers | Remove-PSSession 
        Get-PSSession 
     
    #Remove all open 
        Get-PSSession | Remove-PSSession 
        Get-PSSession 
 
    #Entering Session 
        $sessions = New-PSSession -ComputerName Localhost,PS1 
        $sessions 
         
        Enter-PSSession -Session $sessions[1] #By object index 
            exit 
        $sessions | gm
        Enter-PSSession -Session (Get-PSSession | where ComputerName -eq PS1) #By Filter 
            exit 
 
        Enter-PSSession -Id 9 #By ID 
            exit 
    #Creating new sessions from Text file
        $servers = Get-content -Path .\Servers.txt
        $sessions = New-PSSession -ComputerName $servers
        or
        $sessions = New-PSSession -ComputerName (Get-content -Path .\Servers.txt)

    #Invoke-Command 
        Invoke-Command -Command { Get-CimInstance -Class Win32_OperatingSystem } -Session $sessions | 
            ft -GroupBy PSComputerName 
 
    #Implicit Remoting - Allow you to import & run cmdlets from other systems 
        #1: Create Session 
        $Session = New-PSSession -ComputerName PS1 
         
        #2: Import AD module on remote system into session 
        Invoke-Command -ScriptBlock { Import-Module ActiveDirectory } -Session $session 
         
        #3: Import module to local system using REM prefix 
        Import-PSSession -Session $Session -Module ActiveDirectory -Prefix REM 
 
        #4: Running commands import 
        Get-REMAdUser -Filter { Name -eq 'Administrator' }

    #Using disconnected Sessions
        #View Open Sessions
        Get-PSSession

        #Disconnect Sessions
        Disconnect-PSSession
            #This session would be available if you connect from another computer
        
        #Reconnect Session
        Get-PSSession -ComputerName PS1 | Connect-PSSession

        #View Session info
        Get-PSSession | FL
    
        #View Default settings in WSMan
        get-psdrive

        cd WSMan:\localhost\Shell ; dir

        cd WSMan:\localhost\Service ; dir
 
#endregion 
 
 