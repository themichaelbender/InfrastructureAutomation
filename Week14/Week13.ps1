#Week 13
#Set PS Console to cd:\scripts\week13
cd c:\scripts\week13

#Chapter 8 in week12.ps1

#region 9.0 - Get-SystemInfo before help
function Get-SystemInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   HelpMessage="Computer name or IP address")]
        [ValidateCount(1,10)]
        [Alias('hostname')]
        [string[]]$ComputerName,

        [string]$ErrorLog = 'c:\retry.txt',

        [switch]$LogErrors
    )
    BEGIN {
        Write-Verbose "Error log will be $ErrorLog"
    }
    PROCESS {
        Write-Verbose "Beginning PROCESS block"
        foreach ($computer in $computername) {
            Write-Verbose "Querying $computer"
            $os = Get-WmiObject -class Win32_OperatingSystem `
                                -computerName $computer
            $comp = Get-WmiObject -class Win32_ComputerSystem `
                                  -computerName $computer
            $bios = Get-WmiObject -class Win32_BIOS `
                                  -computerName $computer
            $props = @{'ComputerName'=$computer;
                       'OSVersion'=$os.version;
                       'SPVersion'=$os.servicepackmajorversion;
                       'BIOSSerial'=$bios.serialnumber;
                       'Manufacturer'=$comp.manufacturer;
                       'Model'=$comp.model}
            Write-Verbose "WMI queries complete"
            $obj = New-Object -TypeName PSObject -Property $props
            Write-Output $obj
        }
    }
    END {}
}

help get-systeminfo
#endregion

#region 9.1 Comment-based help
#Adds Help
function Get-SystemInfo {
<#
.SYNOPSIS
Retrieves key system version and model information
from one to ten computers.

.DESCRIPTION
Get-SystemInfo uses Windows Management Instrumentation
(WMI) to retrieve information from one or more computers.
Specify computers by name or by IP address.

.PARAMETER ComputerName
One or more computer names or IP addresses, up to a maximum
of 10.

.PARAMETER LogErrors
Specify this switch to create a text log file of computers
that could not be queried.

.PARAMETER ErrorLog
When used with -LogErrors, specifies the file path and name
to which failed computer names will be written. Defaults to
C:\Retry.txt.

.EXAMPLE
 Get-Content names.txt | Get-SystemInfo

.EXAMPLE
 Get-SystemInfo -ComputerName SERVER1,SERVER2
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   HelpMessage="Computer name or IP address")]
        [ValidateCount(1,10)]
        [Alias('hostname')]
        [string[]]$ComputerName,

        [string]$ErrorLog = 'c:\retry.txt',

        [switch]$LogErrors
    )
    BEGIN {
        Write-Verbose "Error log will be $ErrorLog"
    }
    PROCESS {
        Write-Verbose "Beginning PROCESS block"
        foreach ($computer in $computername) {
            Write-Verbose "Querying $computer"
            $os = Get-WmiObject -class Win32_OperatingSystem `
                                -computerName $computer
            $comp = Get-WmiObject -class Win32_ComputerSystem `
                                  -computerName $computer
            $bios = Get-WmiObject -class Win32_BIOS `
                                  -computerName $computer
            $props = @{'ComputerName'=$computer;
                       'OSVersion'=$os.version;
                       'SPVersion'=$os.servicepackmajorversion;
                       'BIOSSerial'=$bios.serialnumber;
                       'Manufacturer'=$comp.manufacturer;
                       'Model'=$comp.model}
            Write-Verbose "WMI queries complete"
            $obj = New-Object -TypeName PSObject -Property $props
            Write-Output $obj
        }
    }
    END {}
}

help Get-SystemInfo -full
#endregion

Get-SystemInfo -ComputerName PS2,PS3,PS1

#region Error Action
$ErrorActionPreference

help about_common_parameters

$ErrorActionPreference = 'continue'
Get-WmiObject -Class Win32_BIOS -ComputerName NotOnline,localhost

$ErrorActionPreference = 'SilentlyContinue'
Get-WmiObject -Class Win32_BIOS -ComputerName NotOnline,localhost

$ErrorActionPreference = 'Stop'
Get-WmiObject -Class Win32_BIOS -ComputerName NotOnline,localhost

$ErrorActionPreference = 'Inquire'
Get-WmiObject -Class Win32_BIOS -ComputerName NotOnline,localhost

#Using -ErrorAction in command
    Get-WmiObject -Class Win32_BIOS -ComputerName NotOnline,localhost -ErrorAction Stop

    Get-WmiObject -Class Win32_BIOS -ComputerName NotOnline,localhost -EA SilentlyContinue

#Using -ErrorVariable in command
    Get-WmiObject -Class Win32_BIOS -ComputerName NotOnline,localhost -ErrorVariable err -ea SilentlyContinue
    $err


#endregion

#region 10.1 Error Handling v2+ Try..Catch..Finally
function Get-SystemInfo {
<#
.SYNOPSIS
Retrieves key system version and model information
from one to ten computers.
.DESCRIPTION
Get-SystemInfo uses Windows Management Instrumentation
(WMI) to retrieve information from one or more computers.
Specify computers by name or by IP address.
.PARAMETER ComputerName
One or more computer names or IP addresses, up to a maximum
of 10.
.PARAMETER LogErrors
Specify this switch to create a text log file of computers
that could not be queried.
.PARAMETER ErrorLog
When used with -LogErrors, specifies the file path and name
to which failed computer names will be written. Defaults to
C:\Retry.txt.
.EXAMPLE
 Get-Content names.txt | Get-SystemInfo
.EXAMPLE
 Get-SystemInfo -ComputerName SERVER1,SERVER2
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   HelpMessage="Computer name or IP address")]
        [ValidateCount(1,10)]
        [Alias('hostname')]
        [string[]]$ComputerName,

        [string]$ErrorLog = 'c:\retry.txt',

        [switch]$LogErrors
    )
    BEGIN {
        Write-Verbose "Error log will be $ErrorLog"
    }
    PROCESS {
        Write-Verbose "Beginning PROCESS block"
        foreach ($computer in $computername) {
            Write-Verbose "Querying $computer"
            #Use Try..Catch for error handling
            #If try causes error it goes to catch 
            
            Try { 
                $os = Get-WmiObject -class Win32_OperatingSystem `
                                    -computerName $computer `
                                    -erroraction Stop #Added since error is expected
                #swith parameter $logerrors = $true, than perform catch
            } Catch {
                if ($LogErrors) {
                    $computer | Out-File $ErrorLog -Append
                }
            } #No Finally, which is performed always after try, error or not
            
            #This code will be run whether an error is produced or not
            $comp = Get-WmiObject -class Win32_ComputerSystem `
                                  -computerName $computer
            $bios = Get-WmiObject -class Win32_BIOS `
                                  -computerName $computer
            $props = @{'ComputerName'=$computer;
                       'OSVersion'=$os.version;
                       'SPVersion'=$os.servicepackmajorversion;
                       'BIOSSerial'=$bios.serialnumber;
                       'Manufacturer'=$comp.manufacturer;
                       'Model'=$comp.model}
            Write-Verbose "WMI queries complete"
            $obj = New-Object -TypeName PSObject -Property $props
            Write-Output $obj
        }
    }
    END {}
}

Get-SystemInfo –computername NOTONLINE #No error log created

Get-SystemInfo -ComputerName NOTONLINE -ErrorLog c:\scripts\week13\retry.txt -LogErrors #Error Log Produced
#endregion

#region 10.2 finishing off error handling
#prevent function from running commands against systems that error out
#$everything_OK is used to determine yes/no with query
function Get-SystemInfo {
<#
.SYNOPSIS
Retrieves key system version and model information
from one to ten computers.
.DESCRIPTION
Get-SystemInfo uses Windows Management Instrumentation
(WMI) to retrieve information from one or more computers.
Specify computers by name or by IP address.
.PARAMETER ComputerName
One or more computer names or IP addresses, up to a maximum
of 10.
.PARAMETER LogErrors
Specify this switch to create a text log file of computers
that could not be queried.
.PARAMETER ErrorLog
When used with -LogErrors, specifies the file path and name
to which failed computer names will be written. Defaults to
C:\Retry.txt.
.EXAMPLE
 Get-Content names.txt | Get-SystemInfo
.EXAMPLE
 Get-SystemInfo -ComputerName SERVER1,SERVER2
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   HelpMessage="Computer name or IP address")]
        [ValidateCount(1,10)]
        [Alias('hostname')]
        [string[]]$ComputerName,

        [string]$ErrorLog = 'c:\retry.txt',

        [switch]$LogErrors
    )
    BEGIN {
        Write-Verbose "Error log will be $ErrorLog"
    }
    PROCESS {
        Write-Verbose "Beginning PROCESS block"
        foreach ($computer in $computername) {
            Write-Verbose "Querying $computer"
            Try {
                $everything_ok = $true  #Error Handling variable
                $os = Get-WmiObject -class Win32_OperatingSystem `
                                    -computerName $computer `
                                    -erroraction Stop
            } Catch {
                $everything_ok = $false  #Error Handling variable
                if ($LogErrors) {
                    $computer | Out-File $ErrorLog -Append
                }
            }

            if ($everything_ok) {   #executes remaining code if error ok; skips if not
                $comp = Get-WmiObject -class Win32_ComputerSystem `
                                      -computerName $computer
                $bios = Get-WmiObject -class Win32_BIOS `
                                      -computerName $computer
                $props = @{'ComputerName'=$computer;
                           'OSVersion'=$os.version;
                           'SPVersion'=$os.servicepackmajorversion;
                           'BIOSSerial'=$bios.serialnumber;
                           'Manufacturer'=$comp.manufacturer;
                           'Model'=$comp.model}
                Write-Verbose "WMI queries complete"
                $obj = New-Object -TypeName PSObject -Property $props
                Write-Output $obj
            }
        }
    }
    END {}
}

Get-SystemInfo –computername NOTONLINE,PS1,NOTONLINE2,PS1,NOTONLINE3,PS1 -logerrors -verbose -ErrorLog C:\scripts\Week13\retry.txt

C:\retry.txt
#endregion

#region 10.3 Providing visuals
#Add warning messages for console
function Get-SystemInfo {
<#
.SYNOPSIS
Retrieves key system version and model information
from one to ten computers.
.DESCRIPTION
Get-SystemInfo uses Windows Management Instrumentation
(WMI) to retrieve information from one or more computers.
Specify computers by name or by IP address.
.PARAMETER ComputerName
One or more computer names or IP addresses, up to a maximum
of 10.
.PARAMETER LogErrors
Specify this switch to create a text log file of computers
that could not be queried.
.PARAMETER ErrorLog
When used with -LogErrors, specifies the file path and name
to which failed computer names will be written. Defaults to
C:\Retry.txt.
.EXAMPLE
 Get-Content names.txt | Get-SystemInfo
.EXAMPLE
 Get-SystemInfo -ComputerName SERVER1,SERVER2
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   HelpMessage="Computer name or IP address")]
        [ValidateCount(1,10)]
        [Alias('hostname')]
        [string[]]$ComputerName,

        [string]$ErrorLog = 'c:\retry.txt',

        [switch]$LogErrors
    )
    BEGIN {
        Write-Verbose "Error log will be $ErrorLog"
    }
    PROCESS {
        Write-Verbose "Beginning PROCESS block"
        foreach ($computer in $computername) {
            Write-Verbose "Querying $computer"
            Try {
                $everything_ok = $true    
                $os = Get-WmiObject -class Win32_OperatingSystem `
                                    -computerName $computer `
                                    -erroraction Stop
            } Catch {
                $everything_ok = $false
                Write-Warning "$computer failed"  #Warning Messages
                if ($LogErrors) {
                    $computer | Out-File $ErrorLog -Append
                    Write-Warning "Logged to $ErrorLog"  #Warning Messages
                }
            }

            if ($everything_ok) {
                $comp = Get-WmiObject -class Win32_ComputerSystem `
                                      -computerName $computer
                $bios = Get-WmiObject -class Win32_BIOS `
                                      -computerName $computer
                $props = @{'ComputerName'=$computer;
                           'OSVersion'=$os.version;
                           'SPVersion'=$os.servicepackmajorversion;
                           'BIOSSerial'=$bios.serialnumber;
                           'Manufacturer'=$comp.manufacturer;
                           'Model'=$comp.model}
                Write-Verbose "WMI queries complete on $computer...results below."
                $obj = New-Object -TypeName PSObject -Property $props
                Write-Output $obj
            }
        }
    }
    END {}
}

Get-SystemInfo -ComputerName NOTONLINE1,PS1,NOTONLINE2,PS1,NOTONLINE3,PS1 -logerrors -ErrorLog C:\scripts\Week13\retry.txt


#region Chapter 11 - Debugging
    #Use TraceCode

    #region 11.1 - Sample code
        #Reformat for better viewing
        #Tab in all nested code
        $data = import-csv .\Ch11-Debug\listing11-2.csv
        $totalqty = 0
        $totalsold = 0
        $totalbought = 0
        foreach ($line in $data) {
        if ($line.transaction -eq 'buy') {
            # buy transaction (we sold)
            $totalqty -= $line.qty
            $totalsold = $line.total } else {
            # sell transaction (we bought)
            $totalqty += $line.qty
            $totalbought = $line.total }
        "totalqty,totalbought,totalsold,totalamt" | out-file c:\summary.csv
        "$totalqty,$totalbought,$totalsold,$($totalbought-$totalsold)" |
         out-file .\Ch11-Debug\summary.csv -append
    #endregion 
    #region 11.2 - CSV Data
        notepad .\Ch11-Debug\listing11-2.csv
    #endregion

     #region 11.3 - Reformatted Code
    #What's wrong with
    $data = import-csv .\Ch11-Debug\listing11-2.csv
    $totalqty = 0
    $totalsold = 0
    $totalbought = 0
    foreach ($line in $data) {
        if ($line.transaction -eq 'buy') {
            # buy transaction (we sold)
            $totalqty -= $line.qty
            $totalsold = $line.total
        } else {
            # sell transaction (we bought)
            $totalqty += $line.qty
            $totalbought = $line.total
        }
    
    "totalqty,totalbought,totalsold,totalamt" | out-file .\Ch11-Debug\summary.csv
    "$totalqty,$totalbought,$totalsold,$($totalbought-$totalsold)" |
    out-file c:\summary.csv –append
    #endregion

    #region 11.4 - Fixing Typos
    $data = import-csv .\Ch11-Debug\listing11-2.csv
    $totalqty = 0
    $totalsold = 0
    $totalbought = 0
    foreach ($line in $data) {
        if ($line.transaction -eq 'buy') {
            # buy transaction (we sold)
            $totalqty -= $line.qty
            $totalsold = $line.total
        } else {
            # sell transaction (we bought)
            $totalqty += $line.qty
            $totalbought = $line.total
        }
    } #Added closing bracket
    "totalqty,totalbought,totalsold,totalamt" | out-file c:\summary.csv
    "$totalqty,$totalbought,$totalsold,$($totalbought-$totalsold)" |
    out-file c:\summary.csv –append
    notepad c:\summary.csv
    #endregion

    #region 11.5 - Trace Code
    .\Ch11-Debug\listing11-5.ps1 

    .\Ch11-Debug\listing11-5.ps1 -Debug #Shows debug messages
    #Y
    #Suspend
    $data
    $data | gm
    #endregion

    #region 11.6
        #fix CSV
        notepad .\Ch11-Debug\listing11-2.csv

        #Fixed CSV
        Notepad .\ch11-debug\listing11-6.csv

        #Try Again
        .\Ch11-Debug\listing11-6.ps1 -Debug #Shows debug messages
        #Y
        #Suspend
        $Data
        Exit
    #endregion

        #region Breakpoints
        Set-PSBreakpoint -Script .\Ch11-Debug\listing11-6.ps1 -Variable totalbought,totalsold -Mode ReadWrite
        .\Ch11-Debug\listing11-6.ps1 -Debug #Shows debug messages
        #endbreakpoints
#Endregion