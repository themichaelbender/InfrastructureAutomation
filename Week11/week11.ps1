#Week11.ps1
    cd C:\scripts\Week11

#Objects Members and Variables
    $Svc = Get-Service

    $svc | gm

    $svc[0].Name

    $svc.Name

    $name = $svc[1].name

    $name.Length

    $name.ToUpper()

#Logical Constructs
    
    #Accessing Smart Snippets
    #region - IF - Use when working with conditions
        if ($x -gt $y)
        {
            #Do something when condition is true
        } elseif ($t -lt $u) {
            #Do something if next condition is true
        } else {
            #Do something when both conditions are false
        }

        #Examples
        #using regex w/ if else
            $x = 2

            if ($x -gt 3) {

                "$x is greater than 3"

            }else {

                "$x is less than or equal to 3"
    
            }
    
    #Example
        $SrvName = "Print Spooler"
        $Service = Get-Service -display $SrvName -ErrorAction SilentlyContinue 
        if (-Not $Service) {$SrvName + " is not installed on this computer."} 
        ElseIf ($Service.Status -eq "Running") {$SrvName + " is working." }
        ElseIf ($Service.Status -eq "Stopped") {$SrvName + " is not working." }
        Else {"Guy is baffled "}

    #endregion

    #region - Using command that is boolean (true/false)
    $system = 'PS1'#$env:COMPUTERNAME
    
    if ((Test-NetConnection -ComputerName $System).PingSucceeded) {
        
        "$system is up"
    
    } else {
        
        "$System is down"
    
    }
    Test-NetConnection -ComputerName $System | gm
    #endregion
    
    #region - Switch - Compares 1 object against many values
        
        help about_switch

        Switch (<test-value>)
        {
            <condition> {<action>}
            <condition> {<action>}
       }

        Switch ($Status) {
    
            0 { $status_text = 'ok' }

            1 { $status_text = 'error' }

            2 { $status_text = 'stopped' }
         
            default { $status_text = 'unknown' }

        }

        #Example
        switch (1..3) # Try (4, 2) (1..3)
         {
            1 {"It is one." }
            2 {"It is two." }
            3 {"It is three." }
            4 {"It is four." }
            3 {"Three again."}
         } 

         # Case Study 1 - Solution with PowerShell 'Switch' Param
            Clear-Host
            $Disk = Get-WmiObject win32_logicaldisk 
             Foreach ($Drive in $Disk) {Switch ($Drive.DriveType) {
             1{ $Drive.DeviceID + " Unknown" } 
             2{ $Drive.DeviceID + " Floppy or Removable Drive" } 
             3{ $Drive.DeviceID + " Hard Drive" } 
             4{ $Drive.DeviceID + " Network Drive" } 
             5{ $Drive.DeviceID + " CD" } 
             6{ $Drive.DeviceID + " RAM Disk" } 
                 }
             }
    #endregion

#region - Looping Constructs

    #Do...While - Perform actions will a condition is true
    Do {
        # Do Something <commands>
    } While ($This -eq $That)

    #Example 1 - Always executes once
        $x = 10
        Do {
            "$x"
            $x++
        } while ($x -lt 10)

    #Example 2 - Must be true to execute
        $y = 10
        While ($y -lt 10) {
            "$y"
            $y++
        }
#endregion

    #region - Foreach
        foreach ($item in $collection) {
            <Do This>
        }
        
        
        $services = get-service
        Foreach ($bob in $Services) {
            $bob.name + " is " + $bob.Status
        }

    #For - Do something for x times
    For ($i = 0;$i -lt 10; $i++) {
        <Do Something>
    }

    For ($i = 0;$i -lt 10; $i++) {
        "$i is less than 10"
    }

    #Create x users
    $users = Read-host "Number of Users"
    For ($i=0;$i -lt $users;$i++) {
        "Creating AD User usr$i"
        "...."
        #New-ADUser...
        #AnyCommand you want to do X times
    }

    #exaqmple display disks
        $disk= Get-WmiObject Win32_LogicalDisk
        ForEach ( $drive in $disk ) { "Drive = " + $drive.Name}

        For ($disk;$disk.IsReadOnly -eq $false) { }
   # PowerShell ForEach loop piping into block statement
         Clear-Host
        $Path = "C:\Program Files\"
        Get-ChildItem  $Path -recurse -force | ForEach {
        If ($_.extension -eq ".txt") {
        Write-Host $_.fullname 
            }
        }
   #endregion

    #region - Using Break and Continue
    #Break
        $i = 1
        #$x=5 #Try 4 and 5
        do {
            if ($i -eq 5) { break }
            "$i is not 5"
            $i++
        } while ($i -lt 100)

    #continue
        $services = Get-Service
        foreach ($service in $services) {
            if ($service.name -ne 'BITS') { continue }
            $service.Name
            #$service.stop()

        }
#endregion

    #region - Building a function from a command
    $computerName = $env:COMPUTERNAME
    #Step 1: Command
    Get-CimInstance -ClassName Win32_OperatingSystem `
        -ComputerName $computerName
    
    #Step 2: Parametized Script

    .\listing4-1.ps1 -computerName PS1

    #Step 3: Function
    function Get-OSInfo {
        param(
            [string]$computerName = 'localhost'
        )
        
        Get-CimInstance -ClassName Win32_OperatingSystem `
        -ComputerName $computerName

    }
    Get-OSInfo

    #Dot-Sourcing
        #Run .\Get-OSInfo in console
        #Run . .\Get-OSInfo in consol
    
    #calling Function
    #Add Get-OSInfo -computername PS1 to script
#endregion

#scope Refresher
$var = 'hello!'

function My-Function {
    Write-Host "In the function; var contains '$var'"
    $var = 'goodbye!'
    Write-Host "In the function; var is now '$var'"
}

Write-Host "In the script; var is '$var'"
Write-Host "Running the function"
My-Function
Write-Host "Function is done"
Write-Host "In the script; var is now '$var'"

.\Listing5-1.ps1