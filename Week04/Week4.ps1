#Week4
cd C:\scripts\Week5
#region Chapter 10 - Formatting



#Viewing Default formatting
        cd $PSHOME
        gci -Filter *.Format.ps1xml
        notepad .\DotNetTypes.format.ps1xml
         
#Find Formatting used by get-process in ps1xml file        
        get-process | gm
        #Copy TypeName to clipboard and paste into Find...
         

#Formatting Tables
    help Format-Table

    #Using Autosize
        Get-WmiObject Win32_OperatingSystem
        Get-WMIObject Win32_OperatingSystem | Format-Table -AutoSize
                
    # -Property
        Get-WmiObject Win32_OperatingSystem | gm
        (Get-WmiObject Win32_OperatingSystem | gm | where MemberType -eq 'Property').count #Shows Only Property members
        Get-WmiObject Win32_OperatingSystem | ft -Property * #Includes all Properities
        Get-WmiObject Win32_OperatingSystem | format-table -Property Name,InstallDate,PSComputerName -AutoSize
        get-ciminstance win32_operatingsystem | format-table -property name,installdate,pscomputername -autosize
            #Note Difference in Dates
        
        #Another Example
        get-process | Format-Table -Property * 
        get-process | Format-Table -Property ID,Name,Responding -AutoSize
        get-process | Format-Table -Property * -AutoSize

    # -groupby
        get-service | sort-object Status | FT -GroupBy Status
        get-process | sort processname | FT -GroupBy ProcessName

    # -wrap
        get-service | FT Name,Status,DisplayName -Wrap -AutoSize


#Formatting Lists - Display Vertically and additional technique for viewing properties
    get-service | Format-List 
    get-service | sort-object Status | FL -Property Name,Status -GroupBy Status

#Formatting Wide - Displays Wide List of a Single Property
    Get-Service | Format-Wide 
    get-service | FW -Property name -Column 4

#Custom columns
    #Create a Table with custom column headers
    get-service | FT Name,Status,Displayname
    get-service |                                       #Return after Pipe (|) allows continuation of command
        Format-Table @{n='Service Name';e={$_.Name}},   #Comma+Return allows continuation of command
        Status,Displayname

    #Create Table w/ Mathematical Expression
    help get-process -Full
    
    get-process | gm
    get-process | ft Name,VM #Default is Kilobits
    
    #Use a hash table to change display name and change value to be in MB
    Get-Process |
        Format-Table Name, 
        @{n='VM (MB)';e={$_.vm / 1MB -as [int]}} -AutoSize 

    #Create a Text based Report
        #Create Title
        Write-Output "Process Information" | out-file .\processor.txt
        notepad .\processor.txt
            
        #Get Processes and display
        Get-Process |
            Format-Table Name, 
            @{n='VM (MB)';e={$_.vm / 1MB -as [int]}} -AutoSize |
                Out-File .\Processor.txt -Append
            
        #get-Services and display
        Write-Output "Service Information" | out-file .\processor.txt -Append
            
        Get-Service |
            Format-Table @{n='ServiceName';e={$_.Name}},Status,Displayname|
                out-file .\processor.txt -Append
        
        notepad .\processor.txt


#Out to ...
    gcm -Verb Out
    
    Get-Service | Format-Wide
    
    Get-Service | Format-Wide | Out-Host

    #Out-Printer
    get-printer
    (get-printer).Name  #Type . to view Properties
    Get-Service | Format-Wide | Out-Printer -Name ((Get-Printer).Name)
        #use .Name to call Name Property of Printer object
    start .\Out-Printer.oxps
    
    #Install XPS Writer if not installed
    Get-WindowsFeature *xps* | Install-WindowsFeature
    
    #Gridviews - GUI
    get-Process | Out-GridView -Title 'this is a list of processes'

#Format Right
        get-service | Format-Table | GM 
            #Not this produces formatting instructions, not object information

        #Wonky - Because formatting instructions, from FT, are passed, not objects        
        get-Service | Select Name,DisplayName,Status | FT | ConvertTo-Html |
            Out-File services.html
        Start .\services.html

        get-service | select Name,Displayname,Status | FT | gm

        #Correct with Format-Right
        get-Service | Select Name,DisplayName,Status| ConvertTo-Html | FT |
            Out-File services2.html
        Start .\services2.html

        #Out-Gridview accepts no formatting
        get-Process | Out-GridView
        get-Process | FT | Out-GridView

        #Only one type of object per pipeline input
        get-process ; get-service
            #Note Services display as list vs. table
#endregion

#region Chapter 11 - filtering and Comparisons

    #General Rule: Filter left whenever possible

    #region - Early Filtering
        get-service -Name e*,s*
            #Can only filter by -Name
            #Filtering left dependent on available parameters & use of wildcards
            #if you want to filter by status it requires where-object

        #Get-AD... cmdlets Allow filtering by multiple properties
        #Filtering AD objects using -filter
            Get-ADComputer -Filter * -Properties * | gm
            Get-ADComputer -Filter "Name -like 'ps*'" | ft
            get-aduser -Filter * -Properties * | gm
        
        #Filter AD Users
            get-ADuser -Filter * -Properties * | Where-object City -like 'la*' | ft Name  #Iterative Filtering
            get-aduser -Filter "City -like 'La*'" | ft Name                               #Filter Left
                #Result is that processing of Get-ADUser occur on remote system &
                #And decreases size of information passed along
        
        #Filter AD Groups
            Get-ADgroup -Filter "GroupScope -eq 'Global'" | ft
    
    #endregion - Early Filtering

    #Comparison Operators
        #cmd> "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -command 'help about_comparison_operators' 
        help about_comparison_operators
        
        5 -eq 5

        5 -notlike 5

        (5 -gt 10) -and (10 -lt 100)

        (5 -gt 10) -or (10 -lt 100)
        
    #Using Where-Object
        get-service | Where-object -filter { $_.Status -eq 'stopped' }
            #Remeber: $_. means you are looking for specific property
                    #  of the current object in pipeline
            
        get-service | Where-object Status -eq stopped 
            #Simplfied method; just don't forget about the old syntax

        get-service | Where-object -filter { ($_.Status -eq 'stopped') -and ($_.Name -like 's*') }

        get-service | Where-object -filter { ($_.Status -eq 'stopped') -or ($_.Name -like 's*') }
        
        get-service | Where-object -Filter { $_.Status -like 'st*' }

        #Where vs Select

        get-service | select-object -Property Name,status #Pulls properties out of object and discards rest

        get-service | select-object -Property Name,Status | gm

        get-service | Where-object -filter { $_.Status -eq 'stopped' } | select-object -Property Name,status

    #region - Iterative Command Line
        #Measure amount of VM used by 10 highest usage processes w/
        #Exclusion of PowerShell

            #Step 1 Get processes

            #step 2 Remove PowerShell

            #Step 3 Sort by VM

            #Step 4 Only keep top 10
                Select-Object

            #step 5 Add up VM

        #Step 1 - 3
            
            Get-process |
                Where-object -filter { $_.Name -notlike 'powershell*' } |
                    Sort-object VM -Descending

            #Step 4 Only keep top 10
            Get-process |
                Where-object -filter { $_.Name -notlike 'powershell*' } |
                    Sort-object VM -Descending |
                        Select-Object -First 10

            #step 5 Add up VM
            Get-process |
                Where-object -filter { $_.Name -notlike 'powershell*' } |
                    Sort-object VM -Descending |
                        Select-Object -First 10 |
                            Measure-Object -Sum -Property VM

            $Proc = Get-process |
                Where-object -filter { $_.Name -notlike 'powershell*' } |
                    Sort-object VM -Descending |
                        Select-Object -First 10 |
                            Measure-Object -Sum -Property VM
            
            $proc.Count
        #endregion - Iterative Command Line
    #Points of Confusion
        #Using $_.
            #Note how -filter is nested in Parenthetical expression - do first!
        Get-Service -ComputerName (get-content .\Names.txt | Where-object -Filter { $_ -notlike '*dc'}) |
            Where-Object -Filter { $_.Status -eq 'Running' }
#endregion

    


