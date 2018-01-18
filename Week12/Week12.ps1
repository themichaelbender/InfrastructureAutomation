#Advanced Functions

#region - 7.1 Create Function block of code
function Get-SystemInfo {     #<Function Declaration
    
    [CmdletBinding()] #<Signifies Advanced Function
    
    param(            
                      #<Input Parameters go here
    )
    
    BEGIN {}          #<Defined Script Blocks
    PROCESS {}        
    END {}
}#endregion

#region - 7.2 Design function
get-Systeminfo -ComputerName PS1,PS2 -ErrorLog c:\errors.txt

get-content -Path computers.txt | get-systeminfo -ErrorLog c:\errors.txt
#endregion

#region - 7.3 Declare Parameters
function Get-SystemInfo {
    [CmdletBinding()]
    
    param(
        [string[]]$ComputerName,

        [string]$ErrorLog
    )
    BEGIN {}
    PROCESS {}
    END {}
} #endregion

#region - 7.4 Testing the Parameters
function Get-SystemInfo {
    [CmdletBinding()]
    param(
        [string[]]$ComputerName,

        [string]$ErrorLog
    )
    BEGIN {}
    PROCESS {
        Write-Output $ComputerName   #Throwaway code
        Write-Output $ErrorLog       #Throwaway code
    }
    END {}
}
get-systeminfo -ComputerName one,two,three -ErrorLog c:\error.txt

#Remove throwaway code after testing is complete
#endregion

#region - 7.5 Writing Main Code
function Get-SystemInfo {
    [CmdletBinding()]
    param(
        [string[]]$ComputerName,

        [string]$ErrorLog
    )
    BEGIN {
        Write-Output "Log name is $errorlog"
    }
    PROCESS {
        foreach ($computer in $computername) {   #Loop through all computernames
            #add WMI code for gathering info
            $os = Get-WmiObject -class Win32_OperatingSystem `
                                -computerName $computer
            $comp = Get-WmiObject -class Win32_ComputerSystem `
                                  -computerName $computer
            $bios = Get-WmiObject -class Win32_BIOS `
                                  -computerName $computer
            
            #Call variables to see output objects and remove when done
            $os
            $comp
            $bios
        }
    }
    END {}
}
Get-SystemInfo -ComputerName "$env:COMPUTERNAME" -ErrorLog c:\errors.log
#endregion

#region - 7.6 Outputting custom objects
#We need tool to output specific objects from data gathered
function Get-SystemInfo {
    [CmdletBinding()]
    param(
        [string[]]$ComputerName,

        [string]$ErrorLog
    )
    BEGIN {
    }
    PROCESS {
        foreach ($computer in $computername) {
            $os = Get-WmiObject -class Win32_OperatingSystem `
                                -computerName $computer
            $comp = Get-WmiObject -class Win32_ComputerSystem `
                                  -computerName $computer
            $bios = Get-WmiObject -class Win32_BIOS `
                                  -computerName $computer
            #Add hashtable to pick objects
            $props = @{'ComputerName'=$computer;
                       'OSVersion'=$os.version;
                       'SPVersion'=$os.servicepackmajorversion}
                       #'BIOSSerial'=$bios.serialnumber}
                       #'Manufacturer'=$comp.manufacturer;
                       #'Model'=$comp.model}
            #create new PowerShell Object using hashtable info & write objects out
            $obj = New-Object -TypeName PSObject -Property $props
            $obj | gm
            Write-Output $obj
        }
    }
    END {}
}
Get-SystemInfo -ErrorLog x.txt -ComputerName localhost
#endregion

#Make it better
#1: Make parameters mandatory
#2: Better error Handling

#region - 8.1 Making parameters mandatory
function Get-SystemInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)] #Makes ComputerName mandatory 
        [string[]]$ComputerName,     #Defines as String

        [string]$ErrorLog = 'c:\retry.txt'  #Makes ErrorLog have default value
    )
    BEGIN {
    }
    PROCESS {
        foreach ($computer in $computername) {
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
            $obj = New-Object -TypeName PSObject -Property $props
            Write-Output $obj
        }
    }
    END {}
}

Get-SystemInfo 


#endregion

#region - 8.2 Verbose Output
function Get-SystemInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        [string[]]$ComputerName,

        [string]$ErrorLog = 'c:\retry.txt'
    )
    BEGIN {
        Write-Verbose "Error log will be $ErrorLog"   #Verbose messages
    }
    PROCESS {
        foreach ($computer in $computername) {
            Write-Verbose "Querying $computer"        #Verbose messages
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
            Write-Verbose "WMI queries complete"      #Verbose messages
            $obj = New-Object -TypeName PSObject -Property $props
            Write-Output $obj
        }
    }
    END {}
}

Get-SystemInfo -ComputerName localhost -Verbose

#endregion

#region - 8.3 Parameter Aliases
function Get-SystemInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        [Alias('hostname')]     #Alias
        [string[]]$ComputerName,

        [string]$ErrorLog = 'c:\retry.txt'
    )
    BEGIN {
        Write-Verbose "Error log will be $ErrorLog"
    }
    PROCESS {
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

Get-SystemInfo -Host localhost –verbose

#endregion

#region - 8.4 Accepting Pipeline Input
#Allows input from pipeline
function Get-SystemInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]  #Adds acceptance of pipeline input
        [Alias('hostname')]
        [string[]]$ComputerName,

        [string]$ErrorLog = 'c:\retry.txt'
    )
    BEGIN {
        Write-Verbose "Error log will be $ErrorLog"
    }
    PROCESS {
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

'localhost','localhost' | Get-SystemInfo
#endregion

#region - 8.5 Parameter Validation
#In this case, a limitation to the number of system that can be input to 10
function Get-SystemInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [ValidateCount(1,10)]   #Limit input to 10
        [Alias('hostname')]
        [string[]]$ComputerName,

        [string]$ErrorLog = 'c:\retry.txt',

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

Get-SystemInfo -ComputerName localhost -LogErrors 
#endregion

#region - 8.6 Adding a switch parameter
#Need a way to turn error logs on/off
function Get-SystemInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [ValidateCount(1,10)]
        [Alias('hostname')]
        [string[]]$ComputerName,

        [string]$ErrorLog = 'c:\retry.txt',

        [switch]$LogErrors    #Populates $logerrors variable; $true if parameter called
    )
    BEGIN {
        Write-Verbose "Error log will be $ErrorLog. error log capture set to $LogErrors"
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

Get-SystemInfo -ComputerName localhost -Verbose -LogErrors

#endregion

#region - 8.7 Parameter Help
function Get-SystemInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   HelpMessage="Computer name or IP address")]  #Help Message Added
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

Get-SystemInfo 
#endregion