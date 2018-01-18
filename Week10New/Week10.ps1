#Week 10

#Starting Point command - Getting the disk freespace for a computer
cd C:\scripts\Week10
Get-WmiObject -Class Win32_LogicalDisk -Filter "Drivetype=3" -ComputerName LocalHost |
     select Name, @{n="Total Freespace";E={ "{0:N2}" -f ($_.freespace/1GB) }}


#regionMOl Examples - Ch21

    #region - repeatable commands - Get-DiskInventory.ps1
        #use Pipe '|' or command ',' to continue line of code
        Get-WmiObject -Class Win32_LogicalDisk `
            -ComputerName localhost `
            -Filter "drivetype=3" |
        Sort-Object -Property DeviceID |
        Format-Table -Property DeviceID,
                @{label='FreeSpace(MB)';expression={$_.Freespace / 1MB -as [int]}},
                @{label='Size(GB)';expression={$_.Size / 1GB -as [int]}},
                @{Label='%Free';expression={$_.FreeSpace /$_.Size * 100 -as [int]}}
            #Use a hash table to create custom property names (label) & specify value of property (expression)

    #endregion
    #region - Parameterizing Commands
    #Allowing parameter value input when runnig script

        #Using Variables
        #Using Variable for computername
        #Use Backtick for better readability
        $computername = localhost
            Get-WmiObject -Class Win32_LogicalDisk `
                -ComputerName $computername `
                -Filter "drivetype=3" |
            Sort-Object -Property DeviceID |
            Format-Table -Property DeviceID,
                @{label='FreeSpace(MB)';expression={$_.Freespace / 1MB -as [int]}},
                @{label='Size(GB)';expression={$_.Size / 1GB -as [int]}},
                @{Label='%Free';expression={$_.FreeSpace /$_.Size * 100 -as [int]}}
    #endregion
    #region - Creating a Parameterized Script
    #Allowing parameter value input when runnig script

#Create a parameter block for computername where localhost is default
    param (
            $computername = 'localhost'
    )
        Get-WmiObject -Class Win32_LogicalDisk `
            -ComputerName $computername `
            -Filter "drivetype=3" |
        Sort-Object -Property DeviceID |
        Format-Table -Property DeviceID,
            @{label='FreeSpace(MB)';expression={$_.Freespace / 1MB -as [int]}},
            @{label='Size(GB)';expression={$_.Size / 1GB -as [int]}},
            @{Label='%Free';expression={$_.FreeSpace /$_.Size * 100 -as [int]}}
    #endregion
    #region - Documenting your script
                <#
        .SYNOPSIS
        Get-DiskInventory retrieves logical disk information from one or
        more computers.

        .DESCRIPTION
        Get-DiskInventory uses WMI to retrieve the Win32_LogicalDisk
        instances from one or more computers. It displays each disk's
        drive letter, free space, total size, and percentage of free
        space.

        .PARAMETER computername
        The computer name, or names, to query. Default: Localhost.

        .PARAMETER drivetype
        The drive type to query. See Win32_LogicalDisk documentation
        for values. 3 is a fixed disk, and is the default.

        .EXAMPLE
        Get-DiskInventory -computername SERVER-R2 -drivetype 3
        #>
        param (
          $computername = 'localhost',
          $drivetype = 3
        )
        Get-WmiObject -class Win32_LogicalDisk `
            -computername $computername `
            -filter "drivetype=$drivetype" |
         Sort-Object -property DeviceID |
         Format-Table -property DeviceID,
             @{label='FreeSpace(MB)';expression={$_.FreeSpace / 1MB -as [int]}},
             @{label='Size(GB';expression={$_.Size / 1GB -as [int]}},
             @{label='%Free';expression={$_.FreeSpace / $_.Size * 100 -as [int]}}
    #endregion
    #region - Run Scripts
     
     #repeatable commands - Get-DiskInventory.ps1
     .\get-Diskinventory.ps1

     #Using Variable for computername
     .\get-Diskinventory-2.ps1

     #Create a Parametized Script
     .\get-diskinventory-3.ps1 -computername ServerA

     #Adding additional parameter for drive type
     .\get-diskinventory-4.ps1 
 
     .\get-diskinventory-4.ps1 ServerA 3

     help .\get-diskinventory-4.ps1

     help .\get-diskinventory-5.ps1

     help .\get-diskinventory-5.ps1 -Examples
    #endregion
    #region - One Script, One Pipeline

     #Run the following in Console
     #Copy and Paste 54-56
        Get-Process
        Get-Service
        
        .\test.ps1 #Note change in view because both items run through single pipeline
    #endregion
    #region - Working with Scope
    #shows isolation of variables and other information between processes in PS
        .\scope.ps1

        $x = 4

        .\scope.ps1

        #modify script by uncommenting variable

        .\scope.ps1

        $x
    #endregion

#endregion Examples - Ch21

#region - MOL Examples - Ch22
    #StartingPoint - Base Script from Ch21
    .\get-diskinventory-6.ps1 | Format-Table
    .\get-diskinventory-5.ps1 | Format-list #Uses table format because old version used Format-Table in script
    .\get-diskinventory-6.ps1 | format-list #Allows use of formatting with Select-Object
    .\get-diskinventory-6.ps1 | Export-csv disks.csv
    notepad .\disks.csv

    ##Replace Format-Table w/ Select-Object
    .\get-diskinventory-6.ps1 #- tab complete
    .\get-diskinventory-7.ps1 #- tab complete

    #Mandatory Parameters
    .\get-diskinventory-8.ps1

    #Adding parameter aliases
    .\get-diskinventory-9.ps1 -host ps1

    #Validating Parameter Input
    .\get-diskinventory-10.ps1 -host ps1 -drivetype #tab-complete

    #Using Verbose commands
    .\get-diskinventory-11.ps1 -host PS1 
    
    .\get-diskinventory-11.ps1 -host PS1 -Verbose

#endregion- MOL Examples - Ch22

#region
    #Regular Expressions
    help about_regular_expressions
    
    #Using -Match
    "don" -match "d[aeiou]n"         #Match single vowel
    "dooon" -match "d[aeiou]n"       #Match single vowel
    "dooon" -match "d[aeiou]+n"      #Match multiple vowels (preceding characters)
    "djinn" -match "d[aeiou]+n"      #Match multiple vowels (preceding characters)
    "dean" -match "d[aeiou]n"        #Match single vowel
    "dean" -match "d[aeiou]+n"       #Match multiple vowels (preceding characters)
        
    #Get all files in your Windows directory that have a 2 digit number as part of the name. 
        dir c:\windows | where {$_.name -match “\d{2}”}

    #Find all processes running on your computer that are from Microsoft and display the process ID, name and company name.
    # ^ matches 1 or more characters
        get-process | where {$_.company -match “^Microsoft”} | Select Name,ID,Company 
        get-process | gm
    
    #Using Select-String
        Help Select-String 
    
    #Viewing IIS Logs
        #Connections by Windows NT 6.2 clients for Gecko-Based Browsers
        # Use 6\.2; to get literal 6.2 in search
        # use [\w\W]+ to match everything, word and non-word
        # use \+Gecko to match Gecko literally
            
        Get-ChildItem -Filter *.log -Path C:\Logfiles -Recurse|
            select-string -Pattern "6\.2;[\w\W]+\+Gecko"

    #Review Event Logs
        get-eventlog -LogName Security -Newest 5 |
            Where { $_.EventID -eq 4624 } |
                select -ExpandProperty Message |
                    select-string -Pattern "P[\w]+[0-9]\$"
            
        get-eventlog -LogName Security -Newest 5 |
            Where { $_.EventID -eq 4624 -and $_.Message -match "P[\w]+[0-9]\$"} 

#endregion

#region - Tips and Tricks
    #Profiles
    help about_profiles

    $profile
    
    if (!(test-path $profile)) 
        {new-item -type file -path $profile -force}

    notepad $profile

    #Open Profile in ISE c:\Users\Administrator\documents\WindowsPowerShell

    #Open New Window and run some commands and Output-History
    
       
    #Change Color of Error
    get-server 
    get-host 
    (get-host).PrivateData.ErrorForegroundColor = 'yellow'
    (get-host).Privatedata.Error
    
    #replace
    "192.168.95.2" -replace "95","2"

    #split
    notepad .\File2.tdf
    $array = (gc .\File2.tdf) -split "`t"
    
    #Dates
    get-date | gm

    (get-date).DayOfWeek #add decimal

    #Use methods to modify date
    $today = Get-Date
    $90DaysAgo = $today.AddDays(-90)  #Subtract 90 days from current date
    $90Daysago
    $90DaysAgo.ToLongDateString() #explore methods

    #WMI Dates
    Get-WmiObject Win32_OperatingSystem | select LastBootUpTime

    Get-WmiObject Win32_OperatingSystem | gm

    $os = Get-WmiObject Win32_OperatingSystem
    $os.ConvertToDateTime($os.LastBootUpTime)


#endregion

#region
    Install-WindowsFeature Web-Server

#endregion

#region

#endregion
