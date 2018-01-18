#Week 2/3
#Objects & Pipeline
cd C:\scripts\Week2-3

#Walk Through install of AD into environment
#Optional
.\Install-AD.ps1

#Chapter 6
#The Pipeline
	#Basic usage of Pipe
		Get-Service | More
	    
    #Sends output of one command to input of another
        gsv | export-CSV services.csv
        gsv > servicesv1.csv
        gsv | out-file servicesv2.csv

		notepad services.csv
        notepad Servicesv1.csv #Shows display, not CSV formatted
        Notepad servicesv2.csv #Shows display, not CSV formatted
        
    #Point of Confusion
    #Difference between get-content and import-*
        Get-Content services.csv
		import-csv Services.csv
    
    #Adding Content to Variable  
         $w = get-content services.csv
         $w		 
         $x = import-csv services.csv
		 $x
		 $x| select-object Name,Status | Export-csv services2.csv
         notepad services2.csv

    #Comparing baseline processes to running processes
         
		 Get-Process | Export-CLiXML proc.xml
		 notepad proc.xml
		 
         help Compare-Object
		 help diff
		 diff -ReferenceObject (Import-CLiXML proc.xml) -DifferenceObject (Get-Process) -Property Name
        #open Notepad		 
        diff -ReferenceObject (Import-CLiXML proc.xml) -DifferenceObject (Get-Process) -Property Name

        #Modify System with Cmdlets
        Get-WindowsFeature -Name *RSAT* | Install-WindowsFeature
        Update-help

        #DO NOT RUN THIS without -whatif
        get-process | stop-process -WhatIf -verbose


           Get-Content services.csv
           import-csv Services.csv

#chapter 8

#Install Get-Vegetable module from PS Gallery
    Install-Module -Name PSTeachingTools

#Working with Vegetables as objects
    Get-Vegetable                                                                                                                         
    help Get-Vegetable                                                                                                                    
    Get-Vegetable | get-member                                                                                                                                                                                                       
    Get-Vegetable | where IsPeeled -EQ $false                                                                                             
    Get-Vegetable | where IsRoot -eq $true                                                                                                
    get-vegetable | Format-List                                                                                                           
    get-vegetable | where color -eq green                                                                                                 
    get-vegetable | where count -ge 5                                                                                       
    get-history|out-file veggiehistory   

#Viewing Objects in Internet Explorer
    Get-Process | ConvertTo-HTML | Out-File processes.html

    #Launch html page in browser
    start processes.html

#Working with Get-Member
	Get-Process 
	Get-Process | Get-Member 
	
#Accessing Kill method
    Notepad
      
	Get-process | where ProcessName -eq "notepad" | stop-process -whatif

    (Get-process -Name notepad).Kill()

#sorting
    Get-Process | Sort-Object -Property cpu
	Get-Process | Sort-Object cpu -descending
	
#Selecting Specific Properites 
    get-process | select-object -property Name,ID,VM,PM 
    
    get-process | select Name,ID,VM,PM | fl

    Get-Process | ConvertTo-HTML | Out-File test1.html
    start test1.html

    Get-Process | Select -property Name,ID,VM,PM | Convertto-HTML | Out-File test2.html
    Start test2.html
       
#Sorting and Selecting    
    get-process | Sort-Object ID,VM | select-object ID,Name,VM,PM | Convertto-HTML | out-file test3.html
	start test3.html


#Objects to the End
    Get-Process | 
    Sort-Object VM -Descending |
    Select-Object Name,VM,ID   
    
    Get-process | gm
    Get-Process | Sort-Object VM -Descending | gm 
    Get-Process | Sort-Object VM -Descending | Select-Object Name,VM,ID | gm  
    
    get-process | gm | gm 

    get-process -Name notepad | stop-process | gm


#Chapter 9

#How PS Passes data in pipeline via pipeline parameter binding

#A: pipeline input ByValue
    notepad .\computers.txt
    get-content .\computers.txt | Get-Service #Pipeline binds names in file to -Name parameter
    
    #Viewing Help for ByValue
    get-content .\computers.txt | GM
    help get-service -Full
        #Note TypeName is String
        #Note -Name is 1st Positional Parameter
        #Note Accepts pipeline input as ByValue (single)
    
    help get-service -Parameter Name
    
    #works
    get-process -name note* | Stop-Process -WhatIf
    get-process -name * | gm
    
    help get-process -detailed

    
#B: pipleine input ByPropertyName
    get-service -name s* | stop-process -WhatIf

    get-service -name s* | gm

    help Stop-Process -full
        #-Name is PropertyByName so multiple parameter could work

    get-service -name s* | stop-process -WhatIf
        #Basically get-service is providing stop-process the wrong info

#working Example
    #Create CSV w/ Name,Value to create Aliases
    notepad .\aliases.csv
    
    Import-csv .\aliases.csv | GM

    Help New-Alias

    #Run It
    Import-csv .\aliases.csv | New-Alias -Verbose
    
    get-alias d,sel,go

#Custom Properties
    #Import CSV of new users to created AD Users
    help New-ADUser

    notepad .\newusers.csv

    Import-CSV .\newusers.csv | New-ADUser -WhatIf -Verbose

    #The Fix - Create a Hashtable
    help about_Hash_Tables
    
    Import-csv .\Newusers.csv | Select-object -Property * | FL
        #Wrong format for new-aduser

    #Use inline objects to create new object properties for SamAccountName,Name,Department
    Import-CSV .\newusers.csv |
        select-object -Property * `
        ,@{Name='SamAccountName';expression={$_.Login}} `
        ,@{Label='Name';expression={$_.Login}} `
        ,@{n='Department';e={$_.dept}} |
            New-ADUser -WhatIf -Verbose                    

#Parenthetical Expressions
    get-content .\computers2.txt | get-wmiobject -class win32_bios
        #Name in compters.txt won't bind to parameter

    Get-WmiObject -class Win32_BIOS -ComputerName (Get-Content .\computers2.txt)

    Stop-process -Name (get-service) -WhatIf

    Stop-process -Name (get-service) -WhatIf

    #Get a Value from a single property
    #Get-Service on computer in Domain, specifically a domain controller
    get-adcomputer -filter * -SearchBase "OU=Domain Controllers,dc=company,dc=pri"

    Get-Service -computerName (Get-ADComputer -filter * -searchBase "OU=Domain Controllers,dc=company,dc=pri")

    help Get-Service

    Help Get-ADComputer

    get-adcomputer -filter * -SearchBase "OU=Domain Controllers,dc=company,dc=pri" |
        Select-Object -ExpandProperty Name

    get-service -ComputerName (get-adcomputer -filter * -SearchBase "OU=Domain Controllers,dc=company,dc=pri" |
        Select-Object -ExpandProperty Name) 

    #Another round
    help get-process -full

    Get-Process -ComputerName (import-csv .\computers.csv)

    import-csv .\computers.csv

    import-csv .\computers.csv | gm

    #Select Out Hostname
    import-csv .\computers.csv | Select -Property Hostname

    import-csv .\computers.csv | Select -Property Hostname | gm
    
    Get-Process -ComputerName (import-csv .\computers.csv | Select -Property Hostname)

    #Expand Property
    #Use -ExpandProperty to extract value from input and send to output
    import-csv .\computers.csv | Select -expand Hostname
    
    import-csv .\computers.csv | Select -expand Hostname | gm

    Get-Process -ComputerName (import-csv .\computers.csv | Select -expand Hostname)
        